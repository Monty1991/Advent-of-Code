#NoEnv

; --- Day 13: A Maze of Twisty Little Cubicles ---
; https://adventofcode.com/2016/day/13

; The number given
global favoriteNumber := 1352

CountOnes(num) {
	acc := 0
	while (num > 0) {
		acc += (num & 1)
		num >>= 1
	}
	return acc
}

; return 1 for open space
CheckCoords(x, y) {
	f := x*x + 3*x + 2*x*y + y + y*y + favoriteNumber
	return !mod(CountOnes(f), 2)
}

GetAdjacencies(x, y) {
	adjacencies := []
	if (x > 0) {
		if (CheckCoords(x - 1, y))
			adjacencies.push([x - 1, y])
	}
	if (y > 0) {
		if (CheckCoords(x, y - 1))
			adjacencies.push([x, y - 1])
	}

	if (CheckCoords(x + 1, y))
		adjacencies.push([x + 1, y])
	if (CheckCoords(x, y + 1))
		adjacencies.push([x, y + 1])

	return adjacencies
}

; Returns the minimal distance from 0,0 to destination
; Returns -1 if it can't reach it
; May end in an infinite loop if it's on an island
Navigate(startingLocation, destination) {
	; sanity check
	if (!CheckCoords(destination*))
		return -1

	map := {}
	visited := {}
	pointsToVisit := [[startingLocation, 0]]
	index := 1
	while (index <= pointsToVisit.count()) {
		data := pointsToVisit[index++]
		point := data[1]
		distance := data[2]
		key := Format("{};{}", point*)
		if (visited.hasKey(key))
			continue
		visited[key] := distance
		if ((point[1] == destination[1]) && (point[2] == destination[2]))
			return distance
		distance++
		for _, p in GetAdjacencies(point*) {
			pointsToVisit.push([p, distance])
		}
	}
	return -1
}

; Same structure as Navigate, but won't go further than maxDistance
; nor does it stop halfway. Guaranteed to always stop
GetAllReacheableCoords(startingLocation, maxDistance) {
	map := {}
	visited := {}
	pointsToVisit := [[startingLocation, 0]]
	index := 1
	while (index <= pointsToVisit.count()) {
		data := pointsToVisit[index++]
		point := data[1]
		distance := data[2]
		if (distance > maxDistance)
			continue
		key := Format("{};{}", point*)
		if (visited.hasKey(key))
			continue
		visited[key] := distance
		distance++
		for _, p in GetAdjacencies(point*) {
			pointsToVisit.push([p, distance])
		}
	}
	return visited
}

msgbox, % "The distance from (1,1) to (31,39) is: " Navigate([1, 1], [31, 39])
msgbox, % "The amount of locations accessible in at most 50 steps away is: " GetAllReacheableCoords([1, 1], 50).count()
