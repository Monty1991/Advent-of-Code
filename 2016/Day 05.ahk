﻿#NoEnv

Process, Priority, , High
SetBatchLines, -1

; --- Day 5: How About a Nice Game of Chess? ---
; https://adventofcode.com/2016/day/5

; Replace with your own
secret := "cxdnnyjw"

; This is very similar to day 4 of 2015
; So we start with a copy of the code
global K := []
loop, % 64 {
	K.push(floor(abs(sin(A_Index)) * 2**32))
}

; The rotation values
global S := [ 7, 12, 17, 22, 7, 12, 17, 22, 7, 12, 17, 22, 7, 12, 17, 22
			, 5, 9, 14, 20, 5, 9, 14, 20, 5, 9, 14, 20, 5, 9, 14, 20
			, 4, 11, 16, 23, 4, 11, 16, 23, 4, 11, 16, 23, 4, 11, 16, 23
			, 6, 10, 15, 21, 6, 10, 15, 21, 6, 10, 15, 21, 6, 10, 15, 21 ]

; We observe that index g cycles over the same sequence
; So let's precompute the values
global G := []
loop, 16 {
	G.push(A_Index - 1)
}
loop, 16 {
	G.push(mod(5 * (A_Index + 15) + 1, 16))
}
loop, 16 {
	G.push(mod(3 * (A_Index + 31) + 5, 16))
}
loop, 16 {
	G.push(mod(7 * (A_Index + 47), 16))
}

; We have to use little endian here
StringToWord(n) {
	acc := 0
	loop, % 4 {
		acc := acc << 8
		acc |= asc(SubStr(n, 5 - A_index, 1))
	}
	return acc
}

LeftRotate(value, amount) {
	part := (value & 0xFFFFFFFF) >> (32 - amount)
	value := value << amount
	value |= part
	return value
}

LittleEndian(word) {
	output := 0
	loop, % 4 {
		output := output << 8
		output |= word & 0xFF
		word := word >> 8
	}
	return output
}

; This is a 1 chunk hash implementation, bassed on wiki
; https://en.wikipedia.org/wiki/MD5
MD5(message) {
	static a0 := 0x67452301, b0 := 0xefcdab89, c0 := 0x98badcfe, d0 := 0x10325476
	len := StrLen(message)

	M := []
	index := 1
	while (index <= len) {
		word := SubStr(message, index, 4)
		wl := StrLen(word)
		word := StringToWord(word)

		if (wl < 4) {
			; Requires padding
			; Reminder that we are using little endian here
			word |= 0x80 << (wl * 8)
		}

		M.push(word)

		index += 4
	}

	if (mod(len, 4) == 0) {
		M.push(0x00000080)
	}

	while (M.count() < 14) {
		M.push(0)
	}

	; Important!! Convert the lenght from bytes to bits
	len *= 8
	; probably wrong above 255 bits, but we'll never arrive here
	M.push(len & 0xFFFFFFFF)
	M.push(len >> 32)

	A := a0
	B := b0
	C := c0
	D := d0
	; Reminder that in AutoHotKey, loop indices start at 1
	loop, % 64 {
		if (A_Index <= 16) {
			F := (B & C) | (~B & D)
		} else if (A_Index <= 32) {
			F := (D & B) | (~D & C)
		} else if (A_Index <= 48) {
			F := B ^ C ^ D
		} else {
			F := C ^ (B | ~D)
		}
		; And again, array index start at 1
		F += A + K[A_Index] + M[G[A_Index] + 1]
		A := D
		D := C
		C := B
		B += LeftRotate(F, S[A_Index])
	}

	A := LittleEndian((A + a0) & 0xFFFFFFFF)
	B := LittleEndian((B + b0) & 0xFFFFFFFF)
	C := LittleEndian((C + c0) & 0xFFFFFFFF)
	D := LittleEndian((D + d0) & 0xFFFFFFFF)

	return Format("{:08x}{:08x}{:08x}{:08x}", A, B, C, D)
}

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
