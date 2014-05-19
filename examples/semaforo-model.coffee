model = {}
model.nodes = [{
	name: "VERDE_TEXP",
	id: 0,
	init: true
}, {
	name: "GIALLO",
	id: 1
}, {
	name: "GIALLO_BPRES",
	id: 2
}, {
	name: "ROSSO_BPRES",
	id: 3
}, {
	name: "VERDE_BPRES",
	id: 4
}, {
	name: "ROSSO",
	id: 5
}, {
	name: "VERDE",
	id: 6
}]
model.links = {
	'0': [
		{ trigger: "buttonPressed", target: model.nodes[1] }
	], 
	'1': [
		{ trigger: "timeout", target: model.nodes[5] }
		{ trigger: "buttonPressed", target: model.nodes[2] }
	], 
	'2': [
		{ trigger: "timeout", target: model.nodes[3] }
	], 
	'3': [
		{ trigger: "timeout", target: model.nodes[4] }
	],
	'4': [
		{ trigger: "timeout", target: model.nodes[1] }
	],
	'5': [
		{ trigger: "timeout", target: model.nodes[6] },
		{ trigger: "buttonPressed", target: model.nodes[4] }
	],
	'6': [
		{ trigger: "timeout", target: model.nodes[0] }
	]
}
