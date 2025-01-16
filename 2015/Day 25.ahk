#NoEnv

; --- Day 25: Let It Snow ---
; https://adventofcode.com/2015/day/25

; path to the input file
filePath := "input25.txt"

coords := {}
loop, read, %filePath%
{
	line := A_LoopReadLine
	if (line == "")
		continue

	; this captures row and column words, to make it order independent
	if (RegExMatch(line, "(\w+) (\d+)\W+(\w+) (\d+)", m))
		coords[m1] := m2
		coords[m3] := m4
}

; We'll get the index in the sequence.
; For that we calculate the value of row 1 on the same diagonal,
; using euler's sum.
; Then we calculate the index by substracting the distance in the diagonal
CoordsToIndex(coords) {
	distanceToFirstRow := coords.row - 1
	index := coords.column + distanceToFirstRow
	index := ((index + 1) * index) // 2
	return index - distanceToFirstRow
}

; This calculates mod(base**exponent, modulous)
ModularExponentiate(base, exponent, modulous) {
	if (exponent == 0)
		return 1
	if (exponent == 1)
		return mod(base, modulous)

	; In here we use binary exponentiation O(log(exponent))
	if (mod(exponent, 2) == 1)
		return mod(base * ModularExponentiate(base, exponent - 1, modulous), modulous)
	return ModularExponentiate(mod(base * base, modulous), exponent // 2, modulous)
}

code := 20151125
base := 252533
modulous := 33554393
; We substract 1 from the exponent since we are calculating relative to index 1
temp := ModularExponentiate(base, CoordsToIndex(coords) - 1, modulous)
; Finally we add the code for index 1
code := mod(code * temp, modulous)
Msgbox, % "The code you are looking for is: " code
