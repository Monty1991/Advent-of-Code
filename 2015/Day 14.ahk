#NoEnv

; --- Day 14: Reindeer Olympics ---
; https://adventofcode.com/2015/day/14

; path to the input file
filePath := "input14.txt"

data := []
loop, read, %filePath%
{
	line := A_LoopReadLine
	if (line == "")
		return

	if (RegexMatch(line, "\D*(\d+)\D*(\d+)\D*(\d+)", m))
		data.push([m1, m2, m3])
}

; This is very simple
; We use a state machine (running/resting)
; and calculate the biggest block of time for that state
Race(stats, time) {
	distance := 0
	running := true
	while (time > 0) {
		deltaTime := min(time, running? stats[2]: stats[3])
		time -= deltaTime
		if (running)
			distance += stats[1] * deltaTime
		running := !running
	}
	return distance
}

maxDistance := 0
for _, stats in data {
	maxDistance := max(Race(stats, 2503), maxDistance)
}

msgbox, % "The max distance travelled by the winning reindeer is: " maxDistance
