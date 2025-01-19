#NoEnv

; --- Day 6: Signals and Noise ---
; https://adventofcode.com/2016/day/6

; path to the input file
filePath := "input06.txt"

messages := []
loop, read, %filePath%
{
	line := A_LoopReadLine
	if (line == "")
		continue

	messages.push(line)
}

EnsureInitialization(dict, key, defaultValue) {
	if (dict.hasKey(key))
		return
	dict[key] := defaultValue
}

frequencies := []
loop, % StrLen(messages[1]) {
	frequencies.push({})
}

for _, msg in messages {
	for k, c in StrSplit(msg) {
		freqDict := frequencies[k]
		EnsureInitialization(freqDict, c, 0)
		freqDict[c]++
	}
}

message := ""
for _, freqDict in frequencies {
	mostFreqChar := ""
	biggestFreq := 0
	for ch, freq in freqDict {
		if (freq < biggestFreq)
			continue
		mostFreqChar := ch
		biggestFreq := freq
	}
	message .= mostFreqChar
}

msgbox, % "The message is: " message

message := ""
for _, freqDict in frequencies {
	leastFreqChar := ""
	lowestFreq := 1.0e6
	for ch, freq in freqDict {
		if (freq > lowestFreq)
			continue
		leastFreqChar := ch
		lowestFreq := freq
	}
	message .= leastFreqChar
}

msgbox, % "The message is now: " message
