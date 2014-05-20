# Automa che supporta le azioni
class ActionAutomata extends Automata
	_execute = (fnList) ->
		for fn in fnList
			fn()
		return

	_bindActions = (n, target, actionsList, fnProvider) ->
		actions = []
		for a in actionsList
			actions.push -> fnProvider[a.exec](a.on, a.args)
		n[target] = -> _execute(actions); return
		return

	constructor: (model, fnProvider) ->
		for n in model.nodes
			if n.enter?
				_bindActions n, 'enter', n.enter, fnProvider
			if n.run?
				_bindActions n, 'run', n.run, fnProvider
			if n.exit?
				_bindActions n, 'exit', n.exit, fnProvider

		super model
		
		return
