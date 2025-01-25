#NoEnv

; --- Day 15: Timing is Everything ---
; https://adventofcode.com/2016/day/15

; path to the input file
filePath := "input15.txt"

disks := []
loop, read, %filePath%
{
	line := A_LoopReadLine
	if (line == "")
		continue

	if (RegExMatch(line, "(\d+) positions.*position (\d+)", m))
		disks.push([m1, m2])
}

; This is a very simple one.
; People would mention the Chinese Remainder Theorem,
; but it's never explained how to apply it to this particular problem.
; In here, we simply iterate in steps, find when disk n syncronizes,
; multiply the step by it's modulous, go to the next disk,
; rinse and repeat.

CalculateIdealTime(disk, offset, time, step) {
	; At time + k, the disk k is at position 0
	while (mod(disk[2] + offset + time, disk[1])) {
		time += step
	}
	return time
}

time := 0
step := 1
for k, disk in disks {
	time := CalculateIdealTime(disk, k, time, step)
	; By multiplying the modulous (the disk size),
	; we can ensure we are always syncronized to the disks above.
	step *= disk[1]
}
msgbox, % "The perfect time is at: " time

; We simply add a new disk to the end.
; But it also means we don't need to redo the work.
; Just calculate for the new disk.

; [modulous, position at time 0]
newDisk := [11, 0]
time := CalculateIdealTime(newDisk, disks.count() + 1, time, step)
msgbox, % "The perfect time with the new disk is now: " time
