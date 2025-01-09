#NoEnv

; --- Day 17: No Such Thing as Too Much ---
; https://adventofcode.com/2015/day/17


; path to the input file
filePath := "input17.txt"

containers := []
loop, read, %filePath%
{
	line := A_LoopReadLine
	if (line == "")
		continue

	containers.push(line)
}

; This is a combinatory case, with no reposition nor permutation
GetAllCombinations(containers, index, amountLeft, currentCombination, solutions) {
	if (amountLeft < 0) ; in this case, we abort
		return

	if (amountLeft == 0) { ; we found a combination
		solutions.push(currentCombination.clone())
		return
	}

	while (index <= containers.count()) {
		currentCombination.push(index)
		GetAllCombinations(containers, index + 1, amountLeft - containers[index], currentCombination, solutions)
		currentCombination.pop()
		index++
	}
}

combinationBuffer := []
solutions := []
GetAllCombinations(containers, 1, 150, combinationBuffer, solutions)

msgbox, % solutions.count()

EnsureInitialization(dict, key, defaultValue) {
	if (dict.hasKey(key))
		return
	dict[key] := defaultValue
}

; For this part, we'll need to count the solutions per the amount of containers
; It's sort of a bucket sort. We can do this with the dictionary, where the key
; will be the amount.

solutionsInBuckets := {}
for _, solution in solutions {
	c := solution.count()
	EnsureInitialization(solutionsInBuckets, c, 0)
	solutionsInBuckets[c]++
}

; In Autohotkey, iteration over dictionaries are always in ascending order
; Since the answer is the smaller one, we only need the first element
solution2 := 0
for c, solutionCount in solutionsInBuckets {
	solution2 := solutionCount
	break
}

msgbox, % "The many ways to store with the minimal amount of containers is: " solution2
