class AutomataUtils
	@buildGraphModel = (model) ->
		graph = { nodes: [], links: {} }
		for v in model.nodes
			nodes.push v
		#TODO 	nodes.push new State v.id, v.name # solo v? così copio i valori senza perderli
		for k, ls of model.links
			if not getNodeById graph.nodes, k?
				console.log "Undefined State #{k}"
				continue

			for l in ls
				if not links[k]?
					links[k] = []

				t = getNodeById graph.nodes, l.target
				if not t?
					console.log "Undefined State #{t}"
					continue

				links[k].push { trigger: l.trigger, target: t }
		#TODO copiare anche il resto
		return

	@getNodeById = (nodes, id) ->
		for n in nodes
			return n if n.id is id
		return undefined

		
#TODO define Node
# class State
# 	@::toString = () ->
# 		return @id

# 	constructor: (id, name) ->
# 		@id = id
# 		@name = name
# 		return
#TODO 
# class Transition
