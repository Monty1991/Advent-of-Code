#NoEnv

; This is for the first part
Process, Priority, , High
SetBatchLines, -1

; --- Day 24: It Hangs in the Balance ---
; https://adventofcode.com/2015/day/24

; path to the input file
filePath := "input24.txt"

packages := []
loop, read, %filePath%
{
	line := A_LoopReadLine
	if (line == "")
		continue

	packages.push(line)
}

CalculateQE(list) {
	acc := 1
	for _, w in list {
		acc *= w
	}
	return acc
}

; We make use of the ascending order of keys while traversing a dictionary
SortDescending(list) {
	temp := {}
	for _, w in list {
		temp[w] := 1
	}

	; With the order set, we now put them backwards
	order := []
	for w, _ in temp {
		order[list.count() - A_Index + 1] := w
	}
	return order
}

; We now sort the packages in descending order
; This makes arriving to the solution faster
; The logic being, bigger packages makes for a lower count
packages := SortDescending(packages)

Calculate(listOfPackages, target, byRef bestSize, byRef QE, acc := 0, used := "", currentCombination := "") {
	if (used == "")
		used := {}
	if (currentCombination == "")
		currentCombination := []

	if (acc > target)
		return

	size := currentCombination.count()
	; No point in exploring further
	if ((size > bestSize) || ((size == bestSize) && (acc < target)))
		return
	if (acc > 0) {
		; This means we'll never reach a beter size
		if ((acc / size) <= (target / bestSize))
			return
	}

	if (acc == target) {
		if (size < bestSize) { ; best size overrides QE
			QE := CalculateQE(currentCombination)
			bestSize := size
		} else {
			QE := min(QE, CalculateQE(currentCombination))
		}
		return
	}

	for k, w in listOfPackages {
		if (used.hasKey(k))
			continue
		used[k] := 1
		currentCombination.push(w)
		Calculate(listOfPackages, target, bestSize, QE, acc + w, used, currentCombination)
		currentCombination.pop()
		used.delete(k)
	}
}

; We now calculate the total weight
total := 0
for _, weight in packages {
	total += weight
}
bestSize := packages.count()
QE := 1

Calculate(packages, total // 3, bestSize, QE)
msgbox, % "The lowest quantum entanglement value for the ideal first group is: " QE

bestSize := packages.count()
Calculate(packages, total // 4, bestSize, QE)
msgbox, % "The lowest quantum entanglement value for the ideal first group is: " QE
