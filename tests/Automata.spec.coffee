#TODO update tests

# EventMapper 	= require './../src/EventMapper'
# EventDispatcher = require './../src/EventDispatcher'
# Automata 		= require './../src/Automata'

Module = require './../dist/all'
EventMapper 	= Module.EventMapper
EventDispatcher = Module.EventDispatcher
Automata 		= Module.Automata

describe "Automata", () ->
	log = console.log
	automata = null
	model = null
	env = null

	# simple eventDispatcher (only one handler can subscribe)
	ed = null
		# on: (fn) -> 
		# 	@fn = fn
		# 	return
		# trigger: (name) -> 
		# 	@fn name
		# 	log "Triggered '#{name}' event"
		# 	return

	beforeEach ->
		ed = new EventDispatcher()
		automata = new Automata(model, ed, env)
		log('\n')


	model = {}
	model.nodes = [{
		name: "S0",
		id: 0
	}, {
		name: "S1",
		id: 1,
		run: -> console.log "STATE 1!"
	}]
	model.links = {
		'0': [
			{ trigger: "changeStatus", target: model.nodes[1] }
		]
	}

	env = {}
	env.currentStatus = model.nodes[0]
	it "should change state on 'changeStatus' trigger if the automata is active", () ->
		# check current status
		expect(automata.currentStatus).toEqual(model.nodes[0])

		# init automata
		automata.active = true
		
		# trigger unhandled event
		ed.trigger 'null'
		expect(automata.currentStatus).toEqual(model.nodes[0]) # nothing happens

		# trigger handled event
		ed.trigger 'changeStatus'
		expect(automata.currentStatus).toEqual(model.nodes[1]) # state changed

		log("\nStatus changed: #{model.nodes[0].name} -> #{model.nodes[1].name}")
		return
	it "shouldn't change state on 'changeStatus' trigger if the automata is not active", () ->
		# check current status
		expect(automata.currentStatus).toEqual(model.nodes[0])

		# init automata
		automata.active = false
		
		# trigger unhandled event
		ed.trigger 'null'
		expect(automata.currentStatus).toEqual(model.nodes[0]) # nothing happens

		# trigger handled event
		ed.trigger 'changeStatus'
		expect(automata.currentStatus).toEqual(model.nodes[0]) # nothing happens
		return
	return
