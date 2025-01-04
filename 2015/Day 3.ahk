#NoEnv

; --- Day 3: Perfectly Spherical Houses in a Vacuum ---
; https://adventofcode.com/2015/day/3

; path to the input file
filePath := "input3.txt"

; Since it's a single line we read in one fell swoop
FileRead, data, % filePath

; We'll use coordinates relative to the starting position
x := 0
y := 0

; Since the map is theorically infinite, we can't use a matrix
; But, since the number of locations visited is finite, we can record
; them instead. For that we'll make use of a set.
; A set can be constructed from a dictionary, by using the keys as a set.
visited_houses := {}

; this function converts a coordinate pair into a string
; which we'll use as the keys for the set.
; Note that Autohotkey only natively supports strings and numbers as
; dictionary keys.
CoordToKey(x, y) {
	; We use a separator that is not a valid character in a number
	; representation.
	; In Autohotkey, concatenation does not require an explicit operator
	; Numbers are implicitly converted to / from strings as required
	return x ";" y
}

; The origin is counted, so we have to store it. There's no guarantee
; we'll ever pass through.
visited_houses[CoordToKey(0, 0)] := 1

for _, char in StrSplit(data) {
	; Switches in AutoHotkey don't fall through.
	; The space between the keyword and the parentesis
	; is mandatory, else a syntax error is issued
	switch (char) {
		case "<":
			x--
		case ">":
			x++
		case "v":
			y++
		case "^":
			y--
		default: ; in case it's not a valid character
			continue
	}
	key := CoordToKey(x, y)
	; Since we are only using the keys, we don't care as for the value
	visited_houses[key] := 1
}

; count() is a usefull method in AutoHotkey. It counts the total entries
; in an array or dictionary.
msgbox, % "The number of unique houses visited are: " visited_houses.count()
