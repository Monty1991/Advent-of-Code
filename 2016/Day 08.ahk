#NoEnv

; --- Day 8: Two-Factor Authentication ---
; https://adventofcode.com/2016/day/8

; path to the input file
filePath := "input08.txt"

instructions := []
loop, read, %filePath%
{
	line := A_LoopReadLine
	if (line == "")
		continue

	; We note here, that all instructions have keywords rect, row and column
	; And there are always 2 numbers
	if (RegExMatch(line, "(rect|row|column)\D+(\d+)\D+(\d+)", m)) {
		instructions.push([m1, m2, m3])
	}
}

; We'll use this to ease rotation of lines
class Buffer {
	__new(size) {
		this.store := []
		this.size := size
		loop, % this.size {
			this.store.push(false)
		}
		this.index := 1
	}

	getIndex(i) {
		return mod(this.index + i - 1, this.size) + 1
	}

	__get(i) {
		if (i ~= "\d+") {
			return this.store[this.getIndex(i)]
		}
	}

	__set(i, v) {
		if (i ~= "\d+") {
			this.store[this.getIndex(i)] := v
			return v
		}
	}

	rotate(n) {
		this.index := this.getIndex(this.size - n)
	}

	countLit() {
		acc := 0
		for _, v in this.store {
			acc += v
		}
		return acc
	}

	toString() {
		output := ""
		loop, % this.size {
			output .= this[A_Index - 1]? "#": "."
		}
		return output
	}
}

display := []
loop, % 6 {
	display.push(new Buffer(50))
}

for _, instruction in instructions {
	switch (instruction[1]) {
		case "rect":
			loop, % min(instruction[3], display.count()) {
				y := A_Index
				loop, % min(instruction[2], display[y].size) {
					x := A_Index - 1
					display[y][x] := true
				}
			}
		case "row":
			display[instruction[2] + 1].rotate(instruction[3])
		case "column":
			; We store the column in a buffer, rotate
			; and then return it to the lines
			temp := new Buffer(display.count())
			loop, % display.count() {
				temp[A_Index] := display[A_Index][instruction[2]]
			}
			temp.rotate(instruction[3])
			loop, % display.count() {
				display[A_Index][instruction[2]] := temp[A_Index]
			}
	}
}

acc := 0
for _, b in display {
	acc += b.countLit()
}

msgbox, % "The amount of lit pixels is: " acc

; We could display as text and try to read it...
/*
output := ""
for _, b in display {
	output .= b.toString() "`n"
}

msgbox, % output
*/

; But's let's try to make a simple OCR
; We start by storing each letter as an array of monocrome bitmap
; Note: some letters might be missing from your solution
global gLetters := {}
gLetters["F"] := ["11110", "10000", "11100", "10000", "10000", "10000"]
gLetters["G"] := ["01100", "10010", "10000", "10110", "10010", "01110"]
gLetters["H"] := ["10010", "10010", "11110", "10010", "10010", "10010"]
gLetters["O"] := ["01100", "10010", "10010", "10010", "10010", "01100"]
gLetters["P"] := ["11100", "10010", "10010", "11100", "10000", "10000"]
gLetters["S"] := ["01110", "10000", "10000", "01100", "00010", "11100"]
gLetters["Z"] := ["11110", "00010", "00100", "01000", "10000", "11110"]

; In here we compare a letter with the display, pixel by pixel, by columns
OCRLetter(display, column, letterData) {
	loop, % StrLen(letterData[1]) {
		colIndex := A_Index
		loop, % letterData.count() {
			if (SubStr(letterData[A_Index], colIndex, 1) != display[A_Index][column])
				return false
		}
		column++
	}
	return true
}

; This poor man's ocr tries to read any letter for every 5 pixels
OCR(display) {
	code := ""
	column := 0
	while (column < display[1].size) {
		for letter, data in gLetters {
			if (!OCRLetter(display, column, data))
				continue
			code .= letter
			break
		}
		column += 5
	}
	return code
}

msgbox, % "The code displayed is: " OCR(display)
