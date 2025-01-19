#NoEnv

; --- Day 4: Security Through Obscurity ---
; https://adventofcode.com/2016/day/4

; path to the input file
filePath := "input04.txt"

rooms := []
loop, read, %filePath%
{
	line := A_LoopReadLine
	if (line == "")
		continue

	rooms.push(line)
}

EnsureInitialization(dict, key, defaultValue) {
	if (dict.hasKey(key))
		return
	dict[key] := defaultValue
}

; Basically counts characters and sort them in buckets
; Then gets the first 5 biggest chars in alphabetical order
GetCheckSum(code) {
	charCount := {}
	for _, c in StrSplit(code) {
		EnsureInitialization(charCount, c, 0)
		charCount[c]++
	}

	bucketList := {}
	for c, count in charCount {
		EnsureInitialization(bucketList, count, {})
		bucketList[count][c] := 1
	}

	ordered := []
	for count, collection in bucketList {
		ordered.push(collection)
	}

	checkSum := ""	
	times := 5
	index := ordered.count()
	while (times) {
		collection := ordered[index--]
		for c, _ in collection {
			checkSum .= c
			times--
			if (times < 1)
				break
		}
	}
	return checkSum
}

; Decrypts a code in shift cipher
Decrypt(code, id) {
	static modulous := asc("z") - asc("a") + 1
	msg := ""
	for _, c in StrSplit(code) {
		msg .= chr(asc("a") + mod(asc(c) - asc("a") + id, modulous))
	}
	return msg
}

acc := 0
northPoleId := 0
for _, room in rooms {
	pos := (room ~= "\d")
	code := RegExReplace(SubStr(room, 1, pos - 1), "-", "")
	rest := SubStr(room, pos, -1)
	x := StrSplit(rest, "[")
	id := x[1]
	checkSum := x[2]

	if (GetCheckSum(code) == checkSum) {
		; we eliminated the dashes, so it's all together
		if (Decrypt(code, id) ~= "northpole")
			northPoleId := id
		acc += id
	}
}

msgbox, % "The sum of valid room ids is: " acc
msgbox, % "The north pole office id is: " northPoleId
