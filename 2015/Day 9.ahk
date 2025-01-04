#NoEnv

; --- Day 9: All in a Single Night ---
; https://adventofcode.com/2015/day/9

; path to the input file
filePath := "input9.txt"

data := []
loop, read, %filePath%
{
	line := A_LoopReadLine
	if (line == "")
		return

	; a simple regex, we store as a tuple
	if (RegExMatch(line, "(\w+) to (\w+) = (\d+)", m)) {
		data.push([m1, m2, m3])
	}
}

; This initializes a key with a default value
EnsureInitialization(dict, key, defaultValue) {
	if (dict.hasKey(key))
		return
	dict[key] := defaultValue
}

; Since it's about distances between points,
; we procede to build a non-directed graph of incidences.
; We use a dictionary and do "double bookkeeping",
; meaning that we store on both locations the distance to the other
graph := {}
for _, edge in data {
	location := edge[1]
	location2 := edge[2]
	distance := edge[3]

	EnsureInitialization(graph, location, {})
	EnsureInitialization(graph, location2, {})

	graph[location][location2] := distance
	graph[location2][location] := distance
}

; We are asked to visit all locations
; and to register the minimum distance.
; This problem is known as the Traveller's problem.
; There is no algorithm known to solve the problem in polynomial time.
; But since the set is small, we are allowed to brute force it.
FindShortest(graph, location, acc, visited) {
	; we arrived at the last location
	if ((graph.count() - 1) == visited.count())
		return acc

	; we mark the location as visited
	visited[location] := true
	; we start with a ridiculous max distance
	shortest := 1.0e+6

	for nextLocation, distance in graph[location] {
		; skip already visited locations
		if (visited.hasKey(nextLocation))
			continue
		; we mark a visited location before going to the next
		distance := FindShortest(graph, nextLocation, acc + distance, visited)
		shortest := min(distance, shortest)
	}
	; we clear the location for a future iteration
	visited.delete(location)

	; note that if we arrive on a dead-end, the shortest will be the default big number
	; this ensures we always compute a valid path
	return shortest
}

; This is same to FindShortest, except we change the default to 0, and min to max
FindLongest(graph, location, acc, visited) {
	if ((graph.count() - 1) == visited.count())
		return acc

	visited[location] := true
	longest := 0
	for nextLocation, distance in graph[location] {
		if (visited.hasKey(nextLocation))
			continue
		distance := FindLongest(graph, nextLocation, acc + distance, visited)
		longest := max(distance, longest)
	}
	visited.delete(location)

	return longest
}

; We simply iterate over all locations as the initial starting point
shortestDistance := 1.0e+6
longestDistance := 0
for location, _ in graph {
	shortestDistance := min(FindShortest(graph, location, 0, {}), shortestDistance)
	longestDistance := max(FindLongest(graph, location, 0, {}), longestDistance)
}

msgbox, % "The shortest travel distance is : " shortestDistance
msgbox, % "The longest travel distance is : " longestDistance
