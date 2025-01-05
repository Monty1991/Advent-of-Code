#NoEnv

; --- Day 10: Elves Look, Elves Say ---
; https://adventofcode.com/2015/day/10

; Since we are using brute force...
Process, Priority, , High
SetBatchLines, -1

; replace with the seed given
seed := "3113322113"

; this problem is pretty straighforward
Iterate(string) {
	output := ""
	pos := 1
	; This regex will catch a digit and it's repetions
	; Note we are updating the starting position on the string
	; on each iteration
	while (RegExMatch(string, "(\d)(\1*)", m, pos)) {
		; the total lenght is 1 (the starting digit) plus the repetition
		l := strlen(m2) + 1
		output .= l m1
		pos += l
	}
	return output
}

string := seed
loop, % 40 {
	string := Iterate(string)
}

msgbox, % "The lenght after 40 iterations is: " strlen(string)

; this takes a while longer, since we are starting with a bigger string
loop, % 10 {
	string := Iterate(string)
}

msgbox, % "The lenght after 50 iterations is: " strlen(string)
