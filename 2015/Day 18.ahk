#NoEnv

Process, Priority, , High
SetBatchLines, -1

; --- Day 18: Like a GIF For Your Yard ---
; https://adventofcode.com/2015/day/18

; path to the input file
filePath := "input18.txt"

; Reading the map is straightforward
map := []
loop, read, %filePath%
{
	line := A_LoopReadLine
	if (line == "")
		continue

	map.push(StrSplit(line))
}

; Now we pregenerate the neighbourhood for each cell,
; so we can speed up the neighbour count
neighbourLocations := [[-1, -1], [0, -1], [1, -1], [-1, 0], [1, 0], [-1, 1], [0, 1], [1, 1]]
neighbourMap := []
for y, row in map {
	neighbourMap.push([])
	for x, _ in row {
		neighbourMap[y].push([])
		for _, delta in neighbourLocations {
			x2 := x + delta[1]
			if ((x2 < 1) || (x2 > map[y].count()))
				continue
			y2 := y + delta[2]
			if ((y2 < 1) || (y2 > map.count()))
				continue
			neighbourMap[y][x].push([x2, y2])
		}
	}
}

; Note we are using the pregenerated neighbourhood,
; thus saving having to recheck it each time
CountLights(map, neighbourMap, x, y) {
	acc := 0
	for _, loc in neighbourMap[y][x] {
		if (map[loc[2]][loc[1]] == "#")
			acc++
	}
	return acc
}

Iteration(map, neighbourMap, times) {
	loop, % times {
		newMap := []
		for y, row in map {
			newMap.push([])
			for x, v in row {
				c := CountLights(map, neighbourMap, x, y)
				; count of 3 overrides with on state
				if (c == 3) {
					newMap[y][x] := "#"
				} else if (v == "#") && (c == 2) { ; only other case of on
					newMap[y][x] := "#"
				} else { ; turn off
					newMap[y][x] := "."
				}
			}
		}
		map := newMap
	}
	return map
}

CountAllLights(map) {
	acc := 0
	for _, row in map {
		for _, v in row {
			acc += (v == "#")
		}
	}
	return acc
}

msgbox, % "The amount of on lights is: " CountAllLights(Iteration(map, neighbourMap, 100))

; We set the 4 corners on
map[1][1] := "#"
map[1][map[1].count()] := "#"
map[map.count()][1] := "#"
map[map.count()][map[map.count()].count()] := "#"

; Be noted, it might return true if
; 'x' or 'y' are out of bounds
IsCorner(map, x, y) {
	if (y > 1) && (y < map.count())
		return false
	if (x > 1) && (x < map[y].count())
		return false
	return true
}

Iteration2(map, neighbourMap, times) {
	loop, % times {
		newMap := []
		for y, row in map {
			newMap.push([])
			for x, v in row {
				if (IsCorner(map, x, y)) { ; override on corner
					newMap[y][x] := "#"
					continue
				}
				c := CountLights(map, neighbourMap, x, y)
				; count of 3 overrides with on state
				if (c == 3) {
					newMap[y][x] := "#"
				} else if (v == "#") && (c == 2) { ; only other case of on
					newMap[y][x] := "#"
				} else { ; turn off
					newMap[y][x] := "."
				}
			}
		}
		map := newMap
	}
	return map
}

msgbox, % "The amount of on lights is: " CountAllLights(Iteration2(map, neighbourMap, 100))
