#NoEnv

; --- Day 8: Matchsticks ---
; https://adventofcode.com/2015/day/8

; path to the input file
filePath := "input8.txt"

stringsCodes := []
loop, read, %filePath%
{
	line := A_LoopReadLine
	if (line == "")
		return

	stringsCodes.push(line)
}

InterpretString(string) {
	; We eliminate the starting and ending double quotes
	string := SubStr(string, 2, -1)

	output := ""
	escape := false ; flag to keep in check if we are in an escape sequence
	string := StrSplit(string)
	index := 1
	while(index <= string.count()) {
		ch := string[index++]
		if (!escape) {
			if (ch != "\")
				output .= ch
			else
				escape := true
		} else {
			; we are in an escape sequence
			escape := false
			if (ch != "x") {
				; if not the code sequence, just output the char
				output .= ch
			} else {
				; we need to read 2 chars more, for the code
				code := string[index++]
				code .= string[index++]
				output .= chr("0x" code)
			}
		}
	}

	return output
}

; This one is even easier
EscapeString(string) {
	output := ""
	for _, ch in StrSplit(string) {
		; The weird thing about autohotkey is the way to escape double quotes
		if ((ch == "\") || (ch == """"))
			output .= "\" ch
		else
			output .= ch
	}

	; finally, we enclose into double quotes
	return """" output """"
}

acc := 0
acc2 := 0
for _, stringCode in stringsCodes {
	stringLiteral := InterpretString(stringCode)
	escapedString := EscapeString(stringCode)
	acc += StrLen(stringCode) - StrLen(stringLiteral)
	acc2 += StrLen(escapedString) - StrLen(stringCode)
}

msgbox, % "The total difference is: " acc
msgbox, % "The total difference is: " acc2
