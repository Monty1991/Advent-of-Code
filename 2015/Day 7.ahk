#NoEnv

; --- Day 7: Some Assembly Required ---
; https://adventofcode.com/2015/day/7

; path to the input file
filePath := "input7.txt"

instructions := []
loop, read, %filePath%
{
	line := A_LoopReadLine
	if (line == "")
		continue

	; the order is important
	if (RegexMatch(line, "NOT (\w+)\W+(\w+)", m))
		instructions.push(["NOT", m1, m2])
	else if (RegexMatch(line, "(\w+) (\w+) (\w+)\W+(\w+)", m))
		instructions.push([m2, m1, m3, m4])
	else if (RegexMatch(line, "(\w+)\W+(\w+)", m))
		instructions.push(["MOVE", m1, m2])
}

; this will compute an instruction or abort
; in case one of the inputs is a non-set wire.
; Will return a flag indicating success (true)
; or failure (false)
Operate(wires, gate) {
	op := gate[1]
	in1 := gate[2]
	if (!wires.hasKey(in1)) {
		; if not a number
		if (in1 ~= "\D+")
			return false
	} else {
		in1 := wires[in1]
	}

	; this is required for part 2
	; what it does is silently abort
	; when it's about to override a wire
	if (wires.hasKey(gate[gate.count()])) {
		return true
	}

	switch (op) {
		case "MOVE":
			wires[gate[3]] := mod(in1, 65536)
			return true

		case "NOT":
			wires[gate[3]] := mod(~in1, 65536)
			return true
	}

	in2 := gate[3]
	if (!wires.hasKey(in2)) {
		; if not a number, it's a non-set wire
		if (in2 ~= "\D+")
			return false
	} else {
		in2 := wires[in2]
	}

	value := ""
	switch (op) {
		case "AND":
			value := mod(in1 & in2, 65536)
		case "OR":
			value := mod(in1 | in2, 65536)
		case "LSHIFT":
			value := mod(in1 << in2, 65536)		
		case "RSHIFT":
			value := mod(in1 >> in2, 65536)

		default: ; unknown instruction
			; alternatively could throw an exception
			return false
	}
	wires[gate[4]] := value
	return true
}

; This loops till the wire 'a' is set
; In here, the iteration is over the collection
; of aborted gates of the previous iteration
DoLoop(wires, instructionList) {
	while (!wires.hasKey("a")) {
		newInstructionList := []
		for _, gate in instructionList {
			if (!Operate(wires, gate))
				newInstructionList.push(gate)
		}
		instructionList := newInstructionList
	}
}

wires := {}
DoLoop(wires, instructions)

msgbox, % "The value on wire <a> is: " wires["a"]

; In this case, we repeat the loop with a new wireset
wires2 := {}
wires2["b"] := wires["a"]
DoLoop(wires2, instructions)

msgbox, % "The new value on wire <a> is: " wires2["a"]
