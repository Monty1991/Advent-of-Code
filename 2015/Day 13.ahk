#NoEnv

; --- Day 13: Knights of the Dinner Table ---
; https://adventofcode.com/2015/day/13

; path to the input file
filePath := "input13.txt"

data := []
loop, read, %filePath%
{
	line := A_LoopReadLine
	if (line == "")
		return

	if (RegexMatch(line, "^(\w+).*(lose|gain)\D*(\d+).*([[:upper:]]\w+).$", m))
		data.push([m1, m4, (m2 == "lose"? "-" : "") m3])
}

; This is a similar problem to the travelling salesman
; In order to convert it, we observe:
; Since we account for both conections, we can transform the
; directed graph into a non-directed, by acruing the sum of both weights
; 	ie: Alice with David is -2, David with alice is 46, the total is 44
; Since we end at the starting point (circular table), it doesn't matter
; on which node we start. We only need to remember the first node (so we can connect with the last)

EnsureInitialization(dict, key, defaultValue) {
	if (dict.hasKey(key))
		return
	dict[key] := defaultValue
}

graph := {}
for _, connection in data {
	person := connection[1]
	person2 := connection[2]
	value := connection[3]

	EnsureInitialization(graph, person, {})
	EnsureInitialization(graph, person2, {})
	EnsureInitialization(graph[person], person2, 0)
	EnsureInitialization(graph[person2], person, 0)

	graph[person][person2] += value
	graph[person2][person] += value
}

; We'll use a similar aproach to problem 9, part b.
; The difference is we store the first node as "start" on visited
GetBiggest(graph, node, acc, visited) {
	if (visited.count() == graph.count())
		return acc + graph[node][visited["start"]]

	visited[node] := true
	biggest := 0
	for nextNode, value in graph[node] {
		if (visited.hasKey(nextNode))
			continue
		biggest := max(GetBiggest(graph, nextNode, acc + graph[node][nextNode], visited), biggest)
	}
	visited.delete(node)
	return biggest
}

; In Autohotkey, there isn't a simple way to get an arbitrary key.
; What we do is iterate once and break
biggest := 0
for node, _ in graph {
	visited := {}
	visited["start"] := node
	biggest := GetBiggest(graph, node, 0, visited)
	break
}

msgbox, % "The max happiness is: " biggest

; on this one, we add a new member "you" with value 0 for both ways
EnsureInitialization(graph, "you", {})
for node, _ in graph {
	graph["you"][node] := 0
	graph[node]["you"] := 0
}

; Since we now know a key that always exists ("you"), we can use it as
; the starting point, and simplify the problem
visited := {}
visited["start"] := "you"
biggest := GetBiggest(graph, "you", 0, visited)

msgbox, % "The max happiness, you included, is: " biggest
