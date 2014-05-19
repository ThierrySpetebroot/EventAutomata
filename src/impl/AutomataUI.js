// Generated by CoffeeScript 1.7.1
var AutomataUI, Drawer, LinkDrawer, NodeDrawer, SvgUtils, _AutomataUI;

SvgUtils = (function() {
  function SvgUtils() {}

  SvgUtils.linkArc = function(d) {
    var dr, dx, dy;
    dx = d.target.x - d.source.x;
    dy = d.target.y - d.source.y;
    dr = Math.sqrt(dx * dx + dy * dy);
    return "M" + d.source.x + ", " + d.source.y + "A" + dr + "," + dr + " 0 0,1 " + d.target.x + "," + d.target.y;
  };

  SvgUtils.transform = function(d) {
    return "translate(" + d.x + "," + d.y + ")";
  };

  SvgUtils.defineArrow = function(svg) {
    if (this.arrowDefined) {
      return;
    }
    svg.append("defs").append("marker").attr("id", "arrow").attr("viewBox", "0 -5 10 10").attr("refX", 20).attr("refY", -1.5).attr("markerWidth", 6).attr("markerHeight", 6).attr("orient", "auto").append("path").attr("d", "M0,-5L10,0L0,5");
    this.arrowDefined = true;
  };

  return SvgUtils;

})();

Drawer = (function() {
  var _doNothing, _injectInto, _update;

  _doNothing = function() {};

  _injectInto = function(domTarget, injectFn) {
    var selection;
    selection = domTarget.append('g').selectAll(this.wrapper).data(this.data).enter().append(this.wrapper);
    injectFn.call(this, selection);
    this.selections.push(selection);
  };

  _update = function(updateFn) {
    var selection, _i, _len, _ref;
    _ref = this.selections;
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      selection = _ref[_i];
      updateFn.call(this);
    }
  };


  /*
  	Creates a Drawer
  
  	pseudo typescript definition:
  	interface IDrawerConfig
  		data?: 		any
  		wrapper: 	string
  		injectFn?:	(selection:D3selection) => void
  		updateFn?:	(d:any) => void
  
  	constructor: (, wrapper:string, injectFn?:(selection:D3selection)=>void, updateFn?:(d:any)=>void, data?:any) => Drawer
  	constructor: (data:IDrawerConfig) => Drawer
   */

  function Drawer(wrapper, injectFn, updateFn, data) {
    if (injectFn == null) {
      injectFn = _doNothing;
    }
    if (updateFn == null) {
      updateFn = _doNothing;
    }
    if (typeof wrapper === 'string') {
      wrapper = {
        data: data,
        wrapper: wrapper,
        injectFn: injectFn,
        updateFn: updateFn
      };
    }
    this.data = wrapper.data;
    this.wrapper = wrapper.wrapper;
    this.selections = [];
    this.injectInto = (function(_this) {
      return function(el) {
        _injectInto.call(_this, el, wrapper.injectFn);
      };
    })(this);
    this.update = (function(_this) {
      return function() {
        _update.call(_this, wrapper.updateFn);
      };
    })(this);
    return this;
  }

  return Drawer;

})();

NodeDrawer = new Drawer({
  wrapper: 'g',
  injectFn: function(wrapper) {
    if (this.nodesSelections == null) {
      this.nodesSelections = [];
    }
    this.nodesSelections.push(wrapper.append('circle').attr('r', 8).attr('class', 'node').call(this.force.drag));
    if (this.labelsSelections == null) {
      this.labelsSelections = [];
    }
    this.labelsSelections.push(wrapper.append('text').attr('x', 15).attr('y', '.30em').text(function(d) {
      return d.name;
    }).attr('class', 'node-label'));
  },
  updateFn: function() {
    var labelsSelection, nodesSelection, _i, _j, _len, _len1, _ref, _ref1;
    _ref = this.nodesSelections;
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      nodesSelection = _ref[_i];
      nodesSelection.attr('transform', SvgUtils.transform);
    }
    _ref1 = this.labelsSelections;
    for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
      labelsSelection = _ref1[_j];
      labelsSelection.attr('transform', SvgUtils.transform);
    }
  }
});

LinkDrawer = new Drawer({
  wrapper: 'g',
  injectFn: function(wrapper) {
    if (this.linksSelections == null) {
      this.linksSelections = [];
    }
    this.linksSelections.push(wrapper.append('path').attr('marker-end', 'url(#arrow)').attr('class', 'link'));
  },
  updateFn: function() {
    var linksSelection, _i, _len, _ref;
    _ref = this.linksSelections;
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      linksSelection = _ref[_i];
      linksSelection.attr('d', SvgUtils.linkArc);
    }
  }
});

_AutomataUI = (function() {
  var _getLinks, _getNodes, _tick;

  _AutomataUI.defaults = {
    width: 960,
    height: 500,
    linkDistance: 60,
    charge: -300
  };

  _getLinks = function(model) {
    var k, l, res, v, _i, _len, _ref;
    res = [];
    _ref = model.links;
    for (k in _ref) {
      v = _ref[k];
      for (_i = 0, _len = v.length; _i < _len; _i++) {
        l = v[_i];
        res.push({
          source: model.nodes[k],
          target: l.target,
          trigger: l.trigger
        });
      }
    }
    return res;
  };

  _getNodes = function(model) {
    return model.nodes;
  };

  _tick = function(evt) {
    this.linkDrawer.update();
    this.nodeDrawer.update();
  };

  function _AutomataUI(domTarget, automata, nodeDrawer, linkDrawer, opt) {
    var svg, _charge, _guiModel, _height, _layout, _linkDistance, _ref, _ref1, _ref2, _ref3, _this, _width;
    if (opt == null) {
      opt = {};
    }
    _this = this;
    _width = (_ref = opt.width) != null ? _ref : _AutomataUI.defaults.width;
    _height = (_ref1 = opt.height) != null ? _ref1 : _AutomataUI.defaults.height;
    _linkDistance = (_ref2 = opt.linkDistance) != null ? _ref2 : _AutomataUI.defaults.linkDistance;
    _charge = (_ref3 = opt.charge) != null ? _ref3 : _AutomataUI.defaults.charge;
    _guiModel = {
      nodes: _getNodes(automata.model),
      links: _getLinks(automata.model)
    };
    this.getNode = function(id) {
      return nodeDrawer.nodesSelections[0].filter(function(d) {
        return d.id === id;
      });
    };
    this.nodeDrawer = nodeDrawer;
    this.linkDrawer = linkDrawer;
    _layout = d3.layout.force().nodes(_guiModel.nodes).links(_guiModel.links).size([_width, _height]).linkDistance(_linkDistance).charge(_charge).on('tick', function() {
      return _tick.call(_this, this);
    });
    if (opt.linkStrength != null) {
      _layout.linkStrength(opt.linkStrength);
    }
    if (opt.friction != null) {
      _layout.friction(opt.friction);
    }
    if (opt.chargeDistance != null) {
      _layout.chargeDistance(opt.chargeDistance);
    }
    if (opt.gravity != null) {
      _layout.gravity(opt.gravity);
    }
    _layout.start();
    svg = domTarget.append('svg').attr('width', _width).attr('height', _height);
    SvgUtils.defineArrow(svg);
    linkDrawer.data = _guiModel.links;
    linkDrawer.injectInto(svg);
    nodeDrawer.data = _guiModel.nodes;
    nodeDrawer.force = _layout;
    nodeDrawer.injectInto(svg);
    return;
  }

  return _AutomataUI;

})();

AutomataUI = (function() {
  function AutomataUI(domTarget, automata, opt) {
    return new _AutomataUI(domTarget, automata, NodeDrawer, LinkDrawer, opt);
  }

  return AutomataUI;

})();