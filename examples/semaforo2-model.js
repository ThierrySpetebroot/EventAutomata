// Generated by CoffeeScript 1.7.1
var model;

model = {};

model.nodes = [
  {
    name: "CAR_G_TEXP",
    id: 0,
    init: true
  }, {
    name: "CAR_Y",
    id: 1
  }, {
    name: "PED_G",
    id: 2
  }, {
    name: "PED_Y",
    id: 3
  }, {
    name: "PED_Y_BTN",
    id: 4
  }, {
    name: "CAR_G",
    id: 5
  }, {
    name: "CAR_G_TWAIT",
    id: 6
  }
];

model.links = {
  '0': [
    {
      trigger: "buttonPressed",
      target: model.nodes[1]
    }
  ],
  '1': [
    {
      trigger: "timeout",
      target: model.nodes[2]
    }
  ],
  '2': [
    {
      trigger: "timeout",
      target: model.nodes[3]
    }
  ],
  '3': [
    {
      trigger: "buttonPressed",
      target: model.nodes[4]
    }, {
      trigger: "timeout",
      target: model.nodes[5]
    }
  ],
  '4': [
    {
      trigger: "timeout",
      target: model.nodes[6]
    }
  ],
  '5': [
    {
      trigger: "timeout",
      target: model.nodes[0]
    }, {
      trigger: "buttonPressed",
      target: model.nodes[6]
    }
  ],
  '6': [
    {
      trigger: "timeout",
      target: model.nodes[1]
    }
  ]
};
