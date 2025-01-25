#NoEnv

; The code is slow on part 2
Process, Priority, , High
SetBatchLines, -1

; --- Day 12: Leonardo's Monorail ---
; https://adventofcode.com/2016/day/12

; path to the input file
filePath := "input12.txt"

instructions := []
loop, read, %filePath%
{
	line := A_LoopReadLine
	if (line == "")
		continue

	if (RegExMatch(line, "(\w+) (\w+) ?(-?\w+)?", m))
		instructions.push([m1, m2, m3])
}

class Computer {
	__new(program) {
		this.program := program
		this.pc := 1 ; program counter, keep track of the current instruction
		this.registers := {"a": 0, "b": 0, "c": 0, "d": 0}
	}

	; Makes transparent the handling of inmediate value or register address
	getValue(x) {
		if (x ~= "\d+")
			return x
		return this.registers[x]
	}

	; Runs the program. It's as simple as it gets
	run(c := 0) {
		this.pc := 1
		this.registers.a := 0
		this.registers.b := 0
		this.registers.c := c
		this.registers.d := 0

		; Condition for halting
		while (this.pc <= this.program.count()) {
			instruction := this.program[this.pc]
			switch (instruction[1]) {
				case "inc":
					this.registers[instruction[2]]++
				case "dec":
					this.registers[instruction[2]]--
				case "jnz":
					if (this.getValue(instruction[2]) != 0) {
						this.pc += instruction[3]
						; Important! We already have computed the next pc value
						; So skip the increment
						continue
					}
				case "cpy":
					this.registers[instruction[3]] := this.getValue(instruction[2])
				default:
					; Something bad really happened
					throw Format("Invalid instruction at {}: {} {} {}", this.pc, instruction*)
			}
			; Normal flow, increment pc in 1
			this.pc++
		}
		return this.registers["a"]
	}
}

c := new Computer(instructions)
msgbox, % "The value on register A is: " c.run(0)
msgbox, % "With register c on 1, register A is now: " c.run(1)
