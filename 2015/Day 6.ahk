#NoENv

; The following two lines allows to run the script to full power
; Use it sparingly.
Process, Priority, , High
SetBatchLines, -1

; --- Day 6: Probably a Fire Hazard ---
; https://adventofcode.com/2015/day/6

; path to the input file
filePath := "input6.txt"

data := []
loop, read, %filePath%
{
	line := A_LoopReadLine
	
	if (line == "")
		continue

	; we capture all in one regex: action, start and end points
	if (RegexMatch(line, "(on|off|toggle)\D+(\d+)\D+(\d+)\D+(\d+)\D+(\d+)", m)) {
		data.push([m1, [m2, m3], [m4, m5]])
	}
}

MakeGrid(sizeX, sizeY) {
	grid := []
	; this method allows to the pre allocation of space
	; as long as you don't exceed, it speedups pushing
	grid.setCapacity(1000)
	loop, % 1000 {
		row := []
		row.setCapacity(1000)
		loop, % 1000 {
			row.push(0)
		}
		grid.push(row)
	}
	return grid
}

Perform(grid, instruction) {
	action := instruction[1]
	start := instruction[2]
	end := instruction[3]

	y := start[2]
	while (y <= end[2]) {
		x := start[1]
		while(x <= end[1]) {
			switch (action) {
				case "on":
					grid[y + 1][x + 1] := 1
				case "off":
					grid[y + 1][x + 1] := 0
				case "toggle":
					; Reminder that XOR 1 will toggle a boolean
					grid[y + 1][x + 1] ^= 1
			}
			x++
		}
		y++
	}
}

Perform2(grid, instruction) {
	action := instruction[1]
	start := instruction[2]
	end := instruction[3]

	y := start[2]
	while (y <= end[2]) {
		x := start[1]
		while(x <= end[1]) {
			switch (action) {
				case "on":
					grid[y + 1][x + 1]++
				case "off":
					; This ensures the minimum value is 0
					grid[y + 1][x + 1] := max(0, grid[y + 1][x + 1] - 1)
				case "toggle":
					grid[y + 1][x + 1] += 2
			}
			x++
		}
		y++
	}
}

; Since the required memory is small,
; we'll simply apply brute force

grid := MakeGrid(1000, 1000)
grid2 := MakeGrid(1000, 1000)

for _, instruction in data {
	Perform(grid, instruction)
	Perform2(grid2, instruction)
}

acc := 0
acc2 := 0
loop, % 1000 {
	y := A_Index
	loop, % 1000 {
		x := A_Index
		acc += grid[y][x]
		acc2 += grid2[y][x]
	}
}

msgbox, % "The amount of on lights is: " acc
msgbox, % "The total brighness is: " acc2
