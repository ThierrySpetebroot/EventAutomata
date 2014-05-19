// Generated by CoffeeScript 1.7.1
var EventMapper;

Function.prototype.property = function(prop, desc) {
  return Object.defineProperty(this.prototype, prop, desc);
};

EventMapper = (function() {
  var _arrayTrigger, _defaultTrigger;

  _defaultTrigger = function(callback, args, target, evtContext) {
    return callback.apply(target, args);
  };

  _arrayTrigger = function(callback, args, target, evtContext) {
    var i;
    for (i in evtContext.array) {
      callback.apply(target, args.splice(args.length, 0, [evtContext.array[i], i]));
    }
  };

  EventMapper.property('defaultTrigger', {
    get: function() {
      return _defaultTrigger;
    },
    set: function(value) {
      _defaultTrigger = value;
    }
  });

  EventMapper.property('arrayTrigger', {
    get: function() {
      return _arrayTrigger;
    },
    set: function(value) {
      _arrayTrigger = value;
    }
  });

  function EventMapper() {
    var _evtMap;
    _evtMap = {};
    this.on = (function(_this) {
      return function(e, fn, target) {
        if (_evtMap[e] == null) {
          _this.trigger.setEvent(e);
        }
        _evtMap[e].push({
          target: target,
          callback: fn
        });
      };
    })(this);
    this.trigger = function() {
      var args, e, evt, h, _i, _len;
      e = arguments[0];
      if (_evtMap[e] == null) {
        return;
      }
      evt = _evtMap[e];
      args = Array.prototype.slice.call(arguments, 1);
      for (_i = 0, _len = evt.length; _i < _len; _i++) {
        h = evt[_i];
        evt.options.trigger(h.callback, args, h.target, evt.options);
      }
    };
    this.trigger.setEvent = function(e, p1, p2) {
      var evt, options, trigger;
      if (arguments.length === 2) {
        switch (typeof p1) {
          case 'function':
            trigger = p1;
            break;
          case 'object':
            options = p1;
        }
      } else if (arguments.length > 2) {
        options = p1;
        trigger = p2;
      }
      if (options == null) {
        options = {};
      }
      if (typeof e === 'string') {
        _evtMap[e] = [];
        evt = _evtMap[e];
      } else {
        _evtMap[e.name] = [];
        evt = _evtMap[e.name];
      }
      if (e.array != null) {
        options._array = e.array;
        options.trigger = trigger != null ? trigger : _arrayTrigger;
      } else {
        options.trigger = trigger != null ? trigger : _defaultTrigger;
      }
      evt.options = options;
    };
    return;
  }

  return EventMapper;

})();