#NoEnv

; --- Day 1: No Time for a Taxicab ---
; https://adventofcode.com/2016/day/1

; path to the input file
filePath := "input01.txt"

instructions := []
loop, read, %filePath%
{
	line := A_LoopReadLine
	if (line == "")
		continue

	pos := 1
	while ((pos := RegExMatch(line, "(\w)(\d+)", m, pos)) != 0) {
		pos += StrLen(m)
		instructions.push([m1, m2])
	}
}

EnsureInitialization(dict, key, defaultValue) {
	if (dict.hasKey(key))
		return
	dict[key] := defaultValue
}

; This stores the delta movement per orientation
global gDeltas := {"N": [0, -1], "E": [1, 0], "S": [0, 1], "W": [-1, 0]}
; And this one the rotations
global gRotations := {"N": {"L": "W", "R": "E"}
					, "E": {"L": "N", "R": "S"}
					, "S": {"L": "E", "R": "W"}
					, "W": {"L": "S", "R": "N"}}

; starting conditions
orientation := "N"
x := 0
y := 0

; Since we need to check for passing over the same point,
; We need to store the locations over all points
visitedLocations := {"0;0": 1}
realLocation := ""

for k, instruction in instructions {
	orientation := gRotations[orientation][instruction[1]]
	delta := gDeltas[orientation]
	loop, % instruction[2] {
		x += delta[1]
		y += delta[2]

		; we do this till we find our first overlapping
		if (realLocation != "")
			continue
		key := x ";" y
		if (!visitedLocations.hasKey(key))
			visitedLocations[key] := 1
		else
			realLocation := [x, y]
	}
}

distance := abs(x) + abs(y)
realDistance := abs(realLocation[1]) + abs(realLocation[2])
msgbox, % Format("Easter Bunny HQ is {} blocks away", distance)
msgbox, % Format("The real location of Easter Bunny HQ is {} blocks away", realDistance)
