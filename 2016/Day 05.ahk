#NoEnv

Process, Priority, , High
SetBatchLines, -1

; --- Day 5: How About a Nice Game of Chess? ---
; https://adventofcode.com/2016/day/5

; Replace with your own
secret := "cxdnnyjw"

#include MD5.ahk

; We'll use this class to hide hash generation
; And since it'll save the hashes, we can skip
; regenerating the first 8 hashes
class HashTable {
	__new(seed, leadingZeroes) {
		this.seed := seed
		this.store := []
		this.index := 0
		this.acceptString := "^0{" leadingZeroes "}"
	}

	; this meta method gets triggered on expressions of the form x[i]
	__get(i) {
		if (i ~= "\d+") {
			while (this.store.count() < i) {
				hash := MD5(this.seed . this.index++)
				while (!(hash ~= this.acceptString)) {
					hash := MD5(this.seed . this.index++)
				}
				this.store.push(hash)
			}
			return this.store[i]
		}
	}

	count() {
		return this.store.count()
	}
}

ht := new HashTable(secret, 5)

password := ""
loop, % 8 {
	password .= SubStr(ht[A_index], 6, 1)
}
msgbox, % "The password is: " password

password := "........"
lettersPlaced := 0
index := 1
while (lettersPlaced < 8) {
	hash := ht[index++]
	pos := SubStr(hash, 6, 1)
	if (pos < 8) {
		pos++
		if (SubStr(password, pos, 1) != ".")
			continue
		password := SubStr(password, 1, pos - 1) SubStr(hash, 7, 1) SubStr(password, pos + 1)
		lettersPlaced++
	}
}

msgbox, % "The second password is: " password
