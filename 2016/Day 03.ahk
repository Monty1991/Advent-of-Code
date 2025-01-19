#NoEnv

; --- Day 3: Squares With Three Sides ---
; https://adventofcode.com/2016/day/3

; path to the input file
filePath := "input03.txt"

tupples := []
loop, read, %filePath%
{
	line := A_LoopReadLine
	if (line == "")
		continue

	if (RegExMatch(line, "(\d+) +(\d+) +(\d+)", m))
		tupples.push([m1, m2, m3])
}

IsValid(tupple) {
	if ((tupple[1] + tupple[2]) <= tupple[3])
		return false
	if ((tupple[1] + tupple[3]) <= tupple[2])
		return false
	if ((tupple[2] + tupple[3]) <= tupple[1])
		return false
	return true
}

acc := 0
for _, tupple in tupples {
	acc += IsValid(tupple)
}

msgbox, % "The amount of valid triangles is: " acc

acc := 0
index := 1
while (index <= tupples.count()) {
	t1 := tupples[index++]
	t2 := tupples[index++]
	t3 := tupples[index++]
	loop, % 3 {
		acc += IsValid([t1[A_Index], t2[A_Index], t3[A_Index]])
	}
}

msgbox, % "The amount of valid triangles is now: " acc
