#TODO bind eventi automa 				(start, stop, transition)
#TODO evidenziare stato attivo 			(class: .state-current)
#TODO evidenziare stato di accettazione (class: .state-final)
#TODO evidenziare stato iniziale 		(class: .state-initial)

class SvgUtils
	@linkArc = (d) ->
		dx = d.target.x - d.source.x
		dy = d.target.y - d.source.y
		dr = Math.sqrt(dx * dx + dy * dy)
		return "M#{d.source.x}, #{d.source.y}A#{dr},#{dr} 0 0,1 #{d.target.x},#{d.target.y}"

	@transform = (d) -> "translate(#{d.x},#{d.y})"

	@defineArrow = (svg) ->
		return if @arrowDefined
		#TODO generalizzare
		svg.append("defs").append "marker"
		    .attr "id", "arrow"
		    .attr "viewBox", "0 -5 10 10"
		    .attr "refX", 20
		    .attr "refY", -1.5
		    .attr "markerWidth", 6
		    .attr "markerHeight", 6
		    .attr "orient", "auto"
		  .append "path"
		    .attr("d", "M0,-5L10,0L0,5");
		@arrowDefined = true
		return

#TODO in caso i dati cambino occorre richiamare la injectFn
#TODO modificare facendo bind su elemento
#TODO definire factory e passare quella a AutomataUI
# così da fare bind sul singolo elemento (una sola injection possibile, una sola selection possibile ed una sola serie di dati possibile)
class Drawer
	_doNothing = -> 

	_injectInto = (domTarget, injectFn) ->
		selection = domTarget.append 'g'
		  .selectAll @wrapper
		  .data @data
		  .enter()
		  .append @wrapper
		injectFn.call(@, selection)
		@selections.push selection
		return

	_update = (updateFn) ->
		for selection in @selections
			updateFn.call(@)
		return
		
	###
	Creates a Drawer

	pseudo typescript definition:
	interface IDrawerConfig
		data?: 		any
		wrapper: 	string
		injectFn?:	(selection:D3selection) => void
		updateFn?:	(d:any) => void

	constructor: (, wrapper:string, injectFn?:(selection:D3selection)=>void, updateFn?:(d:any)=>void, data?:any) => Drawer
	constructor: (data:IDrawerConfig) => Drawer
	###
	constructor: (wrapper, injectFn = _doNothing, updateFn = _doNothing, data) ->
		if typeof wrapper is 'string'
			# setup single param overload
			wrapper = 
				data: 		data,
				wrapper: 	wrapper,
				injectFn: 	injectFn,
				updateFn: 	updateFn

		@data 		= wrapper.data
		@wrapper 	= wrapper.wrapper
		@selections = []

		@injectInto = (el) => 
			_injectInto.call @, el, wrapper.injectFn
			return
		@update = () =>
			_update.call @, wrapper.updateFn
			return
		return @


NodeDrawer = new Drawer(
	wrapper: 'g'
	injectFn: (wrapper) ->
		#node
		@nodesSelections ?= []
		@nodesSelections.push(wrapper.append 'circle'
		  .attr 'r', 8
		  .attr 'class', 'node'
		  .call @force.drag #TODO draggable
		)
		#label
		@labelsSelections ?= []
		@labelsSelections.push(wrapper.append 'text'
		   .attr 'x', 15
		   .attr 'y', '.30em'
		   .text (d) -> d.name
		   .attr 'class', 'node-label'
		)
		return
	updateFn: () ->
		for nodesSelection in @nodesSelections
			nodesSelection.attr 'transform', SvgUtils.transform
		for labelsSelection in @labelsSelections
			labelsSelection.attr 'transform', SvgUtils.transform
		return
)

LinkDrawer = new Drawer(
	wrapper: 'g'
	injectFn: (wrapper) ->
		#link
		@linksSelections ?= []
		@linksSelections.push(wrapper.append 'path'
		  .attr 'marker-end', 'url(#arrow)'
		  .attr 'class', 'link'
		)
		return
	updateFn: () ->
		for linksSelection in @linksSelections
			linksSelection.attr 'd', SvgUtils.linkArc
		return
)

class _AutomataUI
	@defaults = 
		width:			 960,
		height:			 500,
		linkDistance:	 60,
		charge:			-300

	_getLinks = (model) ->
		# to d3js link model conversion
		res = []
		for k, v of model.links
			for l in v
				res.push source: model.nodes[k], target: l.target, trigger: l.trigger
		return res
	_getNodes = (model) -> model.nodes

	_tick = (evt) ->
		@linkDrawer.update()
		@nodeDrawer.update()
		return

	constructor: (domTarget, automata, nodeDrawer, linkDrawer, opt = {}) ->
		_this = @

		_width			 = opt.width 		? _AutomataUI.defaults.width
		_height			 = opt.height 		? _AutomataUI.defaults.height
		_linkDistance	 = opt.linkDistance ? _AutomataUI.defaults.linkDistance
		_charge			 = opt.charge 		? _AutomataUI.defaults.charge

		_guiModel = 
			nodes: _getNodes(automata.model),
			links: _getLinks(automata.model)

		#TODO rivedere
		@getNode = (id) -> nodeDrawer.nodesSelections[0].filter((d) -> return d.id is id) # per definizione può essere solo 1

		@nodeDrawer = nodeDrawer
		@linkDrawer = linkDrawer

		_layout = d3.layout.force()
		  .nodes(_guiModel.nodes)
		  .links(_guiModel.links)
		  .size([_width, _height])
		  .linkDistance(_linkDistance)
		  .charge(_charge)
		  .on('tick', -> _tick.call _this, @)

		_layout.linkStrength(opt.linkStrength) if opt.linkStrength?
		_layout.friction(opt.friction) if opt.friction?
		_layout.chargeDistance(opt.chargeDistance) if opt.chargeDistance?
		_layout.gravity(opt.gravity) if opt.gravity?

		_layout.start()

		svg = domTarget.append('svg')
		  .attr 'width',  _width
		  .attr 'height', _height

		SvgUtils.defineArrow(svg)
		linkDrawer.data = _guiModel.links
		linkDrawer.injectInto(svg) #TODO svg.append 'g'

		nodeDrawer.data = _guiModel.nodes
		nodeDrawer.force = _layout
		nodeDrawer.injectInto(svg) #TODO svg.append 'g'
		return

class AutomataUI
	constructor: (domTarget, automata, opt) ->
		return new _AutomataUI(domTarget, automata, NodeDrawer, LinkDrawer, opt)

# module.exports = AutomataUI
