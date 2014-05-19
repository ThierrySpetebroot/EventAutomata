## property definition shortcut 
Function::property = (prop, desc) ->
	Object.defineProperty this.prototype, prop, desc

class EventMapper

	_defaultTrigger = (callback, args, target, evtContext) -> callback.apply target, args
	_arrayTrigger = (callback, args, target, evtContext) ->
		for i of evtContext.array
			callback.apply target, (args.splice args.length, 0, [evtContext.array[i], i])
		return

	# shared properties
	@property 'defaultTrigger', 
		get: -> _defaultTrigger
		set: (value) -> _defaultTrigger = value; return

	@property 'arrayTrigger', 
		get: -> _arrayTrigger
		set: (value) -> _arrayTrigger = value; return

	constructor: ->
		_evtMap = {}

		@on = (e, fn, target) =>
			@trigger.setEvent(e) if not _evtMap[e]?

			# TODO: valutare il caso in cui target non sia definito
			#target = @ if not target?

			_evtMap[e].push target: target, callback: fn
			return
		@trigger = -> #(event_name, comma_separated_arguments) ->
			e = arguments[0]
			return if not _evtMap[e]?

			evt = _evtMap[e]
			args = Array.prototype.slice.call(arguments, 1) # arguments[1..] - arguments is NOT an Array (only a pseudo-Array and lacks of the prototype of Array)

			for h in evt
				evt.options.trigger h.callback, args, h.target, evt.options
			return

		@trigger.setEvent = (e, p1, p2) ->
			if arguments.length == 2 # overloading with 2 parameters
				switch (typeof p1)
					when 'function'then trigger = p1
					when 'object' then options = p1
			else if arguments.length > 2 # solo un ordine dei parametri consentito
				options = p1
				trigger = p2
			options ?= {} # options (event context) always defined

			if typeof e == 'string'
				_evtMap[e] = []
				evt = _evtMap[e]
			else
				_evtMap[e.name] = []
				evt = _evtMap[e.name]
			
			# bind trigger function
			if e.array?
				options._array = e.array
				options.trigger = trigger ? _arrayTrigger # if not options.trigger? (caso options.trigger sia già definito)
			else
				options.trigger = trigger ? _defaultTrigger # if not options.trigger? (caso options.trigger sia già definito)

			evt.options = options
			return
		return

# module.exports = EventMapper
