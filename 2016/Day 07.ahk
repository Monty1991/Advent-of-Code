#NoEnv

; --- Day 7: Internet Protocol Version 7 ---
; https://adventofcode.com/2016/day/7

; path to the input file
filePath := "input07.txt"

ipList := []
loop, read, %filePath%
{
	line := A_LoopReadLine
	if (line == "")
		continue

	ipList.push(line)
}

CheckABBA(ip) {
	if (ip ~= "\[\w*(\w)((?!\1)\w)\2\1\w*]")
		return false

	if (ip ~= "(\w)((?!\1)\w)\2\1")
		return true

	return false
}

acc := 0
for _, ip in ipList {
	acc += CheckABBA(ip)
}

msgbox, % "The number of IPs that suport TLS is: " acc

; The strategy here is to separate into hyper and super blocks
; Then we check for the BAB in the hyper blocks and search
; for a corresponding ABA in the super blocks
CheckSSL(ip) {
	hyperBlocks := []
	superBlocks := []
	pos := 1
	lastPos := 1
	while ((pos := RegExMatch(ip, "\[(\w*)]", m, pos)) != 0) {
		hyperBlocks.push(m1)
		if (pos > lastPos) {
			superBlocks.push(SubStr(ip, lastPos, pos - lastPos))
			lastPos := pos + StrLen(m)
		}
		pos += StrLen(m)
	}
	if (lastPos < StrLen(ip))
		superBlocks.push(SubStr(ip, lastPos))

	for _, hyper in hyperBlocks {
		pos := 1
		while (pos := RegExMatch(hyper, "(\w)((?!\1)\w)\1", m, pos)) {
			for _, super in superBlocks {
				if (super ~= (m2 m1 m2))
					return true
			}
			; by doing this we take into account overlapping
			pos += 1
		}
	}
	return false
}

acc := 0
for _, ip in ipList {
	acc += CheckSSL(ip)
}

msgbox, % "The number of IPs that suport SSL is: " acc
