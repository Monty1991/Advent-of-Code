#NoEnv

; --- Day 23: Opening the Turing Lock ---
; https://adventofcode.com/2015/day/23

; path to the input file
filePath := "input23.txt"

program := []
loop, read, %filePath%
{
	line := A_LoopReadLine
	if (line == "")
		continue

	; Sometimes, regex isn't your best friend
	RegExMatch(line, "(\w+) ([^,]+)[, ]*(.*)?", m)

	instruction := [m1, m2]
	if (m3 != "")
		instruction.push(m3)
	program.push(instruction)
}

Run(program, a) {
	pc := 1 ; since arrays start at index 1
	registers := {"a": a, "b": 0}
	while (pc <= program.count()) {
		instruction := program[pc]
		operand := instruction[2]
		switch (instruction[1]) {
			case "hlf":
				registers[operand] //= 2
			case "tpl":
				registers[operand] *= 3
			case "inc":
				registers[operand]++
			; It's all relative offsets, but we substract 1,
			; since at the end of the switch is the
			; pc increment
			case "jmp":
				pc += operand - 1
			case "jie":
				if (mod(registers[operand], 2) == 0)
					pc += instruction[3] - 1
			case "jio":
				if (registers[operand] == 1)
					pc += instruction[3] - 1
		}
		pc++
	}
	return registers["b"]
}

msgbox, % "The final value on register b is: " Run(program, 0)

msgbox, % "The final value on register b, starting with 1 on register a, is: " Run(program, 1)
