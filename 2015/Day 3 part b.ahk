#NoEnv

; path to the input file
filePath := "input3.txt"

; Since it's a single line we read in one fell swoop
FileRead, data, % filePath

; In this part, we now have 2 santas delivering presents,
; taking turns in moving, per the same instructions.
; managing 2 sets of coordinates is a hassle, so we'll resort
; to construct a simple object.

class Present_Deliverer {
	; this is the constructor equivalent for AutoHotkey
	__new() {
		this.x := 0
		this.y := 0
	}

	; Now it's a method on it's own
	move(direction) {
		; In this case, the default case is not needed,
		; since it wouldn't do anything
		switch (direction) {
			case "<":
				this.x--
			case ">":
				this.x++
			case "^":
				this.y--
			case "v":
				this.y++
		}
	}

	; Same as with CoordToKey
	toString() {
		return this.x ";" this.y
	}
}

; No changes to the strategy
visited_houses := {}

; This is something I'll do a lot
; We'll store a collection objects of the same type
deliverers := []

; this way of doing things allows to, for example, add more santas
; Some purists don't like the '%' when the loop is a literal number
loop, % 2 {
	deliverers.push(new Present_Deliverer())
}

; We store the origin as always
; Remember that both start at the same location
visited_houses[deliverers[1].toString()] := 1

for index, char in StrSplit(data) {
	; In here we pick a santa in round robin fashion
	; You'll see this formula quite a lot
	; Since the index at the loop and the array start at 1
	; we need to substract 1 before applying modulo and then
	; add it back
	i := mod(index - 1, deliverers.count()) + 1
	deliverer := deliverers[i]
	deliverer.move(char)
	visited_houses[deliverer.toString()] := 1
}

; No changes in the way to get the answer
msgbox, % "The number of unique houses visited are: " visited_houses.count()
