#NoEnv

; --- Day 12: JSAbacusFramework.io ---
; https://adventofcode.com/2015/day/12

; path to the input file
filePath := "input12.txt"

; it's only 1 line
data := ""
loop, read, %filePath%
{
	line := A_LoopReadLine
	if (line == "")
		return

	data := line
	break
}

; Let's build a primitive json parser

; ByRef allows to modify the argument from the caller
ReadString(string, ByRef pos) {
	output := ""
	x := substr(string, ++pos, 1)
	while (x != """") {
		output .= x
		x := substr(string, ++pos, 1)
	}
	pos++
	return output
}

ReadNumber(string, ByRef pos) {
	output := ""
	x := substr(string, pos, 1)
	while (x ~= "-|\d") {
		output .= x
		x := substr(string, ++pos, 1)
	}
	return output
}

ReadValue(string, ByRef pos) {
	x := substr(string, pos, 1)
	switch (x) {
		case "{":
			return ReadDictionary(string, pos)
		case "[":
			return ReadArray(string, pos)
		case """":
			return ReadString(string, pos)
		default:
			return ReadNumber(string, pos)
	}
}

ReadArray(string, ByRef pos) {
	output := []
	x := substr(string, ++pos, 1)
	while (x != "]") {
		output.push(ReadValue(string, pos))
		if ((x := substr(string, pos, 1)) == ",")
			pos++
	}
	pos++
	return output
}

ReadDictionary(string, ByRef pos) {
	output := {}
	value1 := ""
	value2 := ""
	x := substr(string, ++pos, 1)
	while (x != "}") {
		key := ReadValue(string, pos)
		pos++
		output[key] := ReadValue(string, pos)
		if ((x := substr(string, pos, 1)) == ",")
			pos++
	}
	pos++
	return output
}

ReadJson(data) {
	i := 1
	return ReadValue(data, i)
}

Count(x) {
	if (!isObject(x)) {
		if (x ~= "-?\d+")
			return x
		return 0
	}

	acc := 0
	for _, v in x {
		acc += Count(v)
	}
	return acc
}

Count2(x) {
	if (!isObject(x)) {
		if (x ~= "-?\d+")
			return x
		return 0
	}

	; in AutoHotkey, the usual way to diferentiate
	; an array from a dict is to find a non numeric key
	foundRed := false
	isDict := false
	acc := 0
	for k, v in x {
		if (k ~= "\D")
			isDict := true

		if (v == "red") {
			foundRed := true
			; suposedly, all keys in the object are strictly non-numeric
			; so we add this shortcut
			if (isDict)
				return 0
		}
		acc += Count2(v)
	}
	; note we need to make sure is a dict
	; in order to abort when red is found
	if (isDict && foundRed)
		return 0
	return acc
}

json := ReadJson(data)

msgbox, % "The total count is: " Count(json)
msgbox, % "The total count (without red) is: " Count2(json)
