#NoEnv

; Another brute force
Process, Priority, , High
SetBatchLines, -1

; --- Day 11: Corporate Policy ---
; https://adventofcode.com/2015/day/11

; replace with your given password
password := "cqjxjnds"

; returns the next letter in the alphabet
; wraps around
nextLetter(x) {
	if (x == "z")
		return "a"
	return chr(asc(x) + 1)
}

; Generates a string of 3 consecutives letters
GenerateStair(x) {
	y := nextLetter(x)
	z := nextLetter(y)
	return x y z
}

; We generate all valid stairs
; They go from 'abc' to 'xyz'
; We skip those containing i|o|l, since they
; are discarded by another rule
global validStairs := {}
x := "a"
validStairs[GenerateStair(x)] := x
while(x != "x") {
	x := nextLetter(x)
	stair := GenerateStair(x)
	if (stair ~= "i|o|l")
		continue
	validStairs[stair] := 1
}

Check(string) {
	if (string ~= "i|o|l")
		return false

	; This matches a pair, and then
	; another, distint from the first
	if (!(string ~= "(.)\1.*((?!\1).)\2"))
		return false

	index := 1
	while (index < (StrLen(string) - 1)) {
		if (validStairs.hasKey(SubStr(string, index, 3)))
			return true
		index++
	}

	return false
}

Increment(string) {
	string := StrSplit(string)
	index := string.count()
	while (index > 0) {
		x := string[index]
		x := nextLetter(x)
		; we skip the bad letters
		; it's safe, since we won't trigger
		; a wrap around on a skip
		while (x ~= "i|o|l") {
			x := nextLetter(x)
		}
		string[index] := x
		; If not wrapped around, break loop
		if (x != "a")
			break
		index--
	}
	output := ""
	for _, ch in string {
		output .= ch
	}
	return output
}

GetNext(string) {
	string := Increment(string)
	while (!Check(string)) {
		string := Increment(string)
	}
	return string
}

next := GetNext(password)
next2 := GetNext(next)

msgbox, % "The new password is: " next
msgbox, % "The second new password is: " next2
