#NoEnv

; --- Day 2: Bathroom Security ---
; https://adventofcode.com/2016/day/2

; path to the input file
filePath := "input02.txt"

; as simple as it gets
instructions := []
loop, read, %filePath%
{
	line := A_LoopReadLine
	if (line == "")
		continue

	instructions.push(line)
}

; Register valid moves
GetAdyacencies(arrMap, x, y) {
	adyacencies := {}

	if (x > 1) {
		v := arrMap[y][x - 1]
		if ((v != "") && (v != " "))
			adyacencies["L"] := [x - 1, y]
	}

	if (x < arrMap[y].count()) {
		v := arrMap[y][x + 1]
		if ((v != "") && (v != " "))
			adyacencies["R"] := [x + 1, y]
	}

	if (y > 1) {
		v := arrMap[y - 1][x]
		if ((v != "") && (v != " "))
			adyacencies["U"] := [x, y - 1]
	}

	if (y < arrMap.count()) {
		v := arrMap[y + 1][x]
		if ((v != "") && (v != " "))
			adyacencies["D"] := [x, y + 1]
	}

	return adyacencies
}

; Generates an adjacency map, storing the value and
; computing the location of the button "5"
GenerateMap(stringData) {
	tempMap := []
	for _, row in StrSplit(stringData, "`n") {
		if (row == "")
			continue
		tempMap.push(mapRow := [])
		x := 1
		while(x <= StrLen(row)) {
			v := SubStr(row, x, 1)
			mapRow.push(v)
			x += 2
		}
	}

	startingLocation := [1, 1]
	map := []
	for y, row in tempMap {
		for x, v in row {
			if (v != " ") {
				map[x ";" y] := {"value": v, "adjacencies": GetAdyacencies(tempMap, x, y)}
				if (v == 5)
					startingLocation := [x, y]
			}
		}
	}
	return [map, startingLocation]
}

; Traverses the instructions, generating the code
GetCode(instructions, map, startingLocation) {
	code := ""
	x := startingLocation[1]
	y := startingLocation[2]
	cell := map[x ";" y]
	for _, instruction in instructions {
		for _, m in StrSplit(instruction) {
			; invalid move, ignore
			if (!cell.adjacencies.hasKey(m))
				continue
			nextLocation := cell.adjacencies[m]
			key := nextLocation[1] ";" nextLocation[2]
			cell := map[key]
		}
		code .= cell.value
	}
	return code
}

dataA := "
(
1 2 3
4 5 6
7 8 9
)"

temp := GenerateMap(dataA)
code := GetCode(instructions, temp*)

msgbox, % "The bathroom code is: " code

dataB := "
(
    1
  2 3 4
5 6 7 8 9
  A B C
    D
)"

temp := GenerateMap(dataB)
code := GetCode(instructions, temp*)

msgbox, % "The real bathroom code is: " code
