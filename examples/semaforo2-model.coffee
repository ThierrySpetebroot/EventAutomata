model = {}
model.nodes = [{
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
}]
model.links = {
	# CarFlow-Green-TEXP
	'0': [
		{ trigger: "buttonPressed", target: model.nodes[1] }
	], 
	# CarFlow-Yellow
	'1': [
		{ trigger: "timeout", target: model.nodes[2] }
	], 
	# PedFlow-Green
	'2': [
		{ trigger: "timeout", target: model.nodes[3] }
	], 
	# PedFlow-Yellow
	'3': [
		{ trigger: "buttonPressed", target: model.nodes[4] }
		{ trigger: "timeout", target: model.nodes[5] }
	], 
	# PedFlow-Yellow-Btn
	'4': [
		{ trigger: "timeout", target: model.nodes[6] }
	],
	# CarFlow-Green
	'5': [
		{ trigger: "timeout", target: model.nodes[0] },
		{ trigger: "buttonPressed", target: model.nodes[6] }
	],
	# CarFlow-Green-TWAIT
	'6': [
		{ trigger: "timeout", target: model.nodes[1] }
	]
}
