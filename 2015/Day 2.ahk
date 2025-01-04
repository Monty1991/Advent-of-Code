#NoEnv

; --- Day 2: I Was Told There Would Be No Math ---
; https://adventofcode.com/2015/day/2

; path to the input file
filePath := "input2.txt"

; we are given the total surface formula
; 2*l*w + 2*w*h + 2*h*l

; we prepare a simple array to store the values
data := []
; Since we have multiple lines, is good practice
; to read one line at a time
loop, read, %filePath%
{
	; We store the automatic variable that stores the line read
	; I personally recomend it as good practice
	line := A_LoopReadLine

	; we skip the empty lines
	; in this case, again, a personal choice
	if (line == "")
		continue

	; we use RegExMatch. It returns the first character position
	; were a match is found (a non zero value). Zero if none.
	; the match is against 3 numbers, separated by character 'x'
	; the capture groups are stored in order into the variable provided 'm'
	; To access each group, we append the index (starting from 1)
	if (RegExMatch(line, "(\d+)x(\d+)x(\d+)", m))
		data.push([m1, m2, m3])
}

; Now we have the variable data populated with 3 numbers arrays.
; All we need to do now is calculate the sum of the required surfaces for each box

; We'll use these variables as accumulators
total_surface := 0
total_ribbon := 0

; '_' is used as a varible placeholder in style "don't care".
; On AutoHotkey iterations, the first variable is always the index
for _, v in data {
	; for clarity, we'll assign a variable for each value
	l := v[1]
	w := v[2]
	h := v[3]

	; we'll construct the 3 diferent sized areas
	front_back := w*h
	side := l*h
	base_top := l*w

	; and the 3 perimeters
	perimeter_front := (w + h) * 2
	perimeter_side := (w + l) * 2
	perimeter_base := (h + l) * 2

	; we store the minimal area of the 3
	minArea := min(front_back, side, base_top)
	; and the minimal perimeter
	minPerimeter := min(perimeter_front, perimeter_side, perimeter_base)

	; we calculate the total area required
	; in this case, the box surface plus the minimal area
	area := (front_back + side + base_top) * 2 + minArea

	; we calculate the ribbon required
	; volume plus minimal perimeter
	volume := l*w*h
	ribbon := minPerimeter + volume

	; Lastly, we add to the accumulators
	total_surface += area
	total_ribbon += ribbon
}

Msgbox, % "The total area is: " total_surface
Msgbox, % "The total lenght of ribbon is: " total_ribbon
