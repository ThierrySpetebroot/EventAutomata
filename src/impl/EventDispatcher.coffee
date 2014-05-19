EventDispatcher = () ->
	_fnMap = []

	@on = (fn) -> 
		_fnMap.push fn # add handler
		return

	@remove = (fn) ->
		_fnMap.pop fn if _fnMap.contains fn

	@trigger = (evt) ->
		for fn in _fnMap
			fn(evt) # triggers evt transition
		return
	return

# module.exports = EventDispatcher
