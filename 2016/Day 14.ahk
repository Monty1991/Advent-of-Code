#NoEnv

Process, Priority, , High
SetBatchLines, -1

; --- Day 14: One-Time Pad ---
; https://adventofcode.com/2016/day/14

global salt := "ihaygndm"

#include MD5.ahk

class HashTable {
	__new(seed) {
		this.seed := seed
		this.store := []
	}

	getHash(index) {
		if (this.store[index] == "") {
			hash := MD5(this.seed . index)
			this.store[index] := hash
		}
		return this.store[index]
	}

	; this meta method gets triggered on expressions of the form x[i]
	__get(i) {
		if (i ~= "\d+") {
			return this.getHash(i)
		}
	}

	count() {
		return this.store.count()
	}
}

class StretchedHashTable extends HashTable {
	__new(internalHashTable, stretching) {
		this.base.__new("")
		this.internal := internalHashTable
		this.stretching := stretching
	}

	getHash(index) {
		if (this.store[index] == "") {
			hash := this.internal[index]
			loop, % this.stretching {
				hash := MD5(hash)
			}
			this.store[index] := hash
		}
		return this.store[index]
	}
}

CheckHash(ht, index) {
	hash := ht[index]
	if (!RegExMatch(hash, "(\w)\1\1", m))
		return false

	loop, % 1000 {
		if (ht[++index] ~= (m1 "{5}"))
			return true
	}
	return false
}

GenerateKeys(ht, keysToGenerate) {
	keys := []
	index := 0
	while (keys.count() < keysToGenerate) {
		if (CheckHash(ht, index))
			keys.push(index)
		index++
	}
	return keys
}

ht := new HashTable(salt)
ht2 := new StretchedHashTable(ht, 2016)

msgbox, % "The index of 64th key is: " GenerateKeys(ht, 64)[64]
; Takes it's time: 1001 * 2016 hashes to get started
msgbox, % "The index of 64th key with stretching is: " GenerateKeys(ht2, 64)[64]
