model = {}
model.nodes = [{
	name: "S0",
	id: 0
}, {
	name: "S1",
	id: 1
}, {
	name: "S2",
	id: 2
}, {
	name: "S3",
	id: 3
}]
model.links = {
	'0': [
		{ trigger: "changeStatus", target: model.nodes[1] }
	], 
	'1': [
		{ trigger: "toBegin", target: model.nodes[0] }
		{ trigger: "changeStatus", target: model.nodes[2] }
	], 
	'2': [
		{ trigger: "changeStatus", target: model.nodes[3] }
	], 
	'3': [
		{ trigger: "changeStatus", target: model.nodes[1] }
	]
}
