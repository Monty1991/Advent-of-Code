#NoEnv

; --- Day 5: Doesn't He Have Intern-Elves For This? ---
; https://adventofcode.com/2015/day/5

; path to the input file
filePath := "input5.txt"

; I like to separate reading from processing
data := []
loop, read, %filePath%
{
	line := A_LoopReadLine
	if (line == "")
		continue
	data.push(line)
}

; we'll use this function to verify the naughtyness
IsNice(string) {
	; we'll use regex for checking out bad words
	static badWord := "ab|cd|pq|xy"
	if (string ~= badWord)
		return false

	; Check at least 3 vocals present
	; Note here we check for the pattern (a vocal), and not
	; a repeat of the first vocal
	if (RegExMatch(string, "([aeiou]).*(?1).*(?1)") == 0)
		return false

	; We simply check for a repeating character
	return (RegExMatch(string, "(.)\1") != 0)

}

IsNice2(string) {
	if (!(string ~= "(\w{2}).*\1"))
		return false
	if (string ~= "(\w).\1")
		return true
	return false
}

acc1 := 0
acc2 := 0
for _, string in data {
	acc1 += IsNice(string)
	acc2 += IsNice2(string)
}

msgbox, % "The amount of nice strings are: " acc1
msgbox, % "The amount of nice strings are: " acc2
