#TODO stati di accettazione
#TODO eventi
# transition - transizioni di stato
# enter - ingresso stato
# exit - uscita stato
# start - inizio automa (chamata metodo start)
# stop - termine automa (stop esplicito o raggiunto stato di accettazione) 
#TODO eliminare active / mettere readonly

class Automata
	# private shared
	_gotoState = (target, evt, _evtMapper) ->
#		console.log "TRANSITION " + evt + " TRIGGERED"
		source = @currentStatus
		@currentStatus.exit() if @currentStatus && @currentStatus.exit?
		@currentStatus = target
		_evtMapper.trigger 'transition', @, from: source, to: target, trigger: evt
		@currentStatus.enter() if @currentStatus.enter?
		@currentStatus.run() if @currentStatus.run?

		if @currentStatus.final is true
			@stop(@currentStatus) # stato di accettazione, termine computazione
		return

	_evtHandler = (evt, _evtMapper) -> 
#		console.log "EVENT: " + evt
#		console.log "Automata: " + @active
		return if not @active

#		console.log "Transitions for " + @currentStatus.id + ": " + @model.links[@currentStatus.id]
		transitions = @model.links[@currentStatus.id]
		for transition in transitions
#			console.log transition.trigger + " == " + evt
			if transition.trigger is evt
				_gotoState.call @, transition.target, evt, _evtMapper
				break
		return

	_getInitState = (model) ->
		for s in model.nodes
			if s.init is true
				return s
		return undefined

	constructor: (model, ed, env = {}) ->
		@model = model
		@ed = ed
		@env = env

		# _initStatuses(model.nodes, envt) # aggiunge un proprio env e l'env condiviso dell'automa ad ogni stato se non definito

		@currentStatus = null # begin state is null
		_initialState   = _getInitState(model)
		_initialState ?= env.currentStatus

		_evtMapper = new EventMapper()
		@on = _evtMapper.on

		if not @currentStatus?
			_initialState = @model.nodes[0]
			console.log "Initial Status not defined"
			console.log "inferred initial state #{_initialState.id} - #{_initialState.name}"
 
 		@active = false
		@start = () =>
			@active = true
			_gotoState.call @, _initialState, 'START', _evtMapper
			_evtMapper.trigger 'START', @, {}
			return
		@stop = (state) =>
			@active = false
			_evtMapper 'STOP', @, state
			return

		ed.on (evt) => _evtHandler.call @, evt, _evtMapper; return
		return @

# module.exports = Automata
