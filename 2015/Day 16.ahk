#NoEnv

; --- Day 16: Aunt Sue ---
; https://adventofcode.com/2015/day/16

; path to the input file
filePath := "input16.txt"

; This problem has 2 types of input.
; Let's first convert the tape to a dict

tickerTape := "
(
children: 3
cats: 7
samoyeds: 2
pomeranians: 3
akitas: 0
vizslas: 0
goldfish: 5
trees: 3
cars: 2
perfumes: 1
)"

clues := {}
for _, v in StrSplit(tickerTape, "`n") {
	x := StrSplit(v, ": ")
	clues[x[1]] := x[2]
}

; We now do something similar for the aunts
; In this case, we use a list, preserving the order
listOfAunts := []
loop, read, %filePath%
{
	line := A_LoopReadLine
	if (line == "")
		return

	data := {}
	pos := 1
	while (pos := RegExMatch(line, "(\w+): (\d+)", m, pos)) {
		data[m1] := m2
		pos += strlen(m)
	}
	listOfAunts.push(data)
}

; Now, we just have to play a "guess who?"
listOfCandidates := []
loop, % listOfAunts.count() {
	listOfCandidates.push(A_Index)
}

; We simply iterate over each clue
; And we eliminate those who contradict the clue
; Note we preserve those with unknown value
GuessWho(listOfSuspects, clues) {
	listOfCandidates := []
	loop, % listOfSuspects.count() {
		listOfCandidates.push(A_Index)
	}

	for clueName, value in clues {
		newListOfCandidates := []
		for _, index in listOfCandidates {
			suspect := listOfSuspects[index]
			if (suspect.hasKey(clueName)) {
				if (suspect[clueName] != value)
					continue
			}
			newListOfCandidates.push(index)
		}
		listOfCandidates := newListOfCandidates
	}
	return listOfCandidates
}

msgbox, % "The aunt number is: " GuessWho(listOfAunts, clues)[1]

; For this one, we just need to include the evaluation for specific clues:
; cats and trees -> greater than
; pomeranians and goldfish -> less than
GuessWho2(listOfSuspects, clues) {
	listOfCandidates := []
	loop, % listOfSuspects.count() {
		listOfCandidates.push(A_Index)
	}

	for clueName, value in clues {
		newListOfCandidates := []
		for _, index in listOfCandidates {
			suspect := listOfSuspects[index]
			if (suspect.hasKey(clueName)) {
				suspectValue := suspect[clueName]
				; Note here, that since Autohotkey does not allow to fall
				; through in switches, we instead use a list of cases
				switch (clueName) {
					case "cats", "trees":
						if (suspectValue <= value)
							continue
					case "pomeranians", "goldfish":
						if (suspectValue >= value)
							continue
					default:
						if (suspectValue != value)
							continue
				}
			}
			newListOfCandidates.push(index)
		}
		listOfCandidates := newListOfCandidates
	}
	return listOfCandidates
}

msgbox, % "The correct aunt is: " GuessWho2(listOfAunts, clues)[1]
