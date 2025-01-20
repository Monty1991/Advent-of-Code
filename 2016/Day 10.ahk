#NoEnv

; --- Day 10: Balance Bots ---
; https://adventofcode.com/2016/day/10

; path to the input file
filePath := "input10.txt"

instructions := []
loop, read, %filePath%
{
	line := A_LoopReadLine
	if (line == "")
		continue

	if (RegExMatch(line, "(value) (\d+)\D+(\d+)", m)) {
		instructions.push([m1, m2, m3])
	} else if (RegExMatch(line, "(bot)\D+(\d+)\D+(bot|output) (\d+)\D+(bot|output) (\d+)", m)) {
		instructions.push([m1, m2, [m3, m4], [m5, m6]])
	}
}

; A simple class to represent the bots
class cBot {
	__new() {
		this.values := []
		this.lowDest := -1
		this.highDest := -1
	}

	give(value) {
		this.values.push(value)
	}

	canOperate() {
		return (this.values.count() == 2)
	}

	setLow(lowDest) {
		this.lowDest := lowDest
	}

	setHigh(highDest) {
		this.highDest := highDest
	}

	getLow() {
		return [this.lowDest, min(this.values*)]
	}

	getHigh() {
		return [this.highDest, max(this.values*)]
	}

	hasValue(value) {
		for _, v in this.values {
			if (v == value)
				return true
		}
		return false
	}
}

; We now initialize the bots
bots := {}
output := {}
for _, instruction in instructions {
	if (instruction[1] == "value") {
		if (!bots.hasKey(instruction[3]))
			bots[instruction[3]] := new cBot()
		bots[instruction[3]].give(instruction[2])
	} else if (instruction[1] == "bot") {
		if (!bots.hasKey(instruction[2])) {
			bot := new cBot()
			bots[instruction[2]] := bot
		} else {
			bot := bots[instruction[2]]
		}

		lowDest := instruction[3]
		bot.setLow(lowDest)
		if (lowDest[1] == "output")
			output[lowDest[2]] := -1

		highDest := instruction[4]
		bot.setHigh(highDest)
		if (highDest[1] == "output")
			output[highDest[2]] := -1
	}
}

; We now iterate over the bots
; If a bot is not ready (missing a chip), it's saved
; for the next iteration
listOfBots := bots
while (listOfBots.count() > 0) {
	newListOfBots := {}
	for id, bot in listOfBots {
		if (!bot.canOperate()) {
			newListOfBots[id] := bot
			continue
		}
		low := bot.getLow()
		if (low[1][1] == "output")
			output[low[1][2]] := low[2]
		else
			bots[low[1][2]].give(low[2])
		high := bot.getHigh()
		if (high[1][1] == "output")
			output[high[1][2]] := high[2]
		else
			bots[high[1][2]].give(high[2])
	}
	; This prevents softlocks, the system won't evolve any further
	if (listOfBots.count() == newListOfBots.count())
		break
	listOfBots := newListOfBots
}

; A simple check
botNumber := 0
for id, bot in bots {
	if (bot.hasValue(61) && bot.hasValue(17)) {
		botNumber := id
		break
	}
}

Msgbox, % "The number of the bot that handles chips 61 and 17 is: " botNumber

; A no-brainer
acc := 1
loop, % 3 {
	acc *= output[A_Index - 1]
}

Msgbox, % "The product between outputs 0, 1 and 2 is: " acc
