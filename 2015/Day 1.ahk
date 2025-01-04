#NoEnv

; --- Day 1: Not Quite Lisp ---
; https://adventofcode.com/2015/day/1

; path to the input file
filePath := "input1.txt"

; this sets variable data with the contents
; of the file specified above
FileRead, data, % filePath

; Will store the floor where santa ends
dest_floor := 0

; We'll store the character position upon which santa enters
; the basement for the first time. By using an invalid value
; we can later check if it was setted or not.
basement := 0

; We'll do a basic iteration for every character
; (StrSplit with no extra parameters,
;	splits the string into individual characters)
; Note that in AutoHotkey, index starts at 1
for index, char in StrSplit(data) {
	if (char == "(")
		dest_floor++
	else if (char == ")")
		dest_floor--

	; we set the variable basement only once
	; note we check upon the initialization value
	if ((dest_floor == -1) && (basement == 0))
		basement := index
}

; We only need the numeric answer, but it's nice to give a context to the user
msgbox, % "Santa ends on floor: " dest_floor
msgbox, % "Santa enters the basement at character position: " basement
