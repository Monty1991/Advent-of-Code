#NoEnv

; --- Day 9: Explosives in Cyberspace ---
; https://adventofcode.com/2016/day/9

; path to the input file
filePath := "input09.txt"

compressedFile := ""
loop, read, %filePath%
{
	line := A_LoopReadLine
	if (line == "")
		continue

	compressedFile := line
}

; We assume the file is better formed
GetLength(compressedFile, recursive := false) {
	size := StrLen(compressedFile)
	acc := 0
	pos := 1
	while (pos <= size) {
		x := RegExMatch(compressedFile, "\((\d+)x(\d+)\)", m, pos)
		if (x == 0)
			break
		acc += x - pos
		pos := x + strlen(m)
		if (recursive) {
			len := GetLength(SubStr(compressedFile, pos, m1), recursive)
		} else {
			len := m1
		}
		acc += len * m2
		pos += m1

	}

	if (pos <= size) {
		acc += size - pos + 1
	}

	return acc
}
msgbox, % "The decompressed length is: " GetLength(compressedFile)
msgbox, % "The decompressed length is now: " GetLength(compressedFile, true)
