#NoEnv

; What we have to do here is basically mine crypto
; And mining requires full power
Process, Priority, , High
SetBatchLines, -1

; --- Day 4: The Ideal Stocking Stuffer ---
; https://adventofcode.com/2015/day/4

; In this case, the value is provided on the same page
; Replace with your own
secret := "ckczppom"

global K := []
loop, % 64 {
	K.push(floor(abs(sin(A_Index)) * 2**32))
}

; The rotation values
global S := [ 7, 12, 17, 22, 7, 12, 17, 22, 7, 12, 17, 22, 7, 12, 17, 22
			, 5, 9, 14, 20, 5, 9, 14, 20, 5, 9, 14, 20, 5, 9, 14, 20
			, 4, 11, 16, 23, 4, 11, 16, 23, 4, 11, 16, 23, 4, 11, 16, 23
			, 6, 10, 15, 21, 6, 10, 15, 21, 6, 10, 15, 21, 6, 10, 15, 21 ]

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
		step := A_Index - 1
		if (step < 16) {
			F := (B & C) | (~B & D)
			g := step
		} else if (step < 32) {
			F := (D & B) | (~D & C)
			g := mod(5 * step + 1, 16)
		} else if (step < 48) {
			F := B ^ C ^ D
			g := mod(3 * step + 5, 16)
		} else {
			F := C ^ (B | ~D)
			g := mod(7 * step, 16)
		}
		; And again, array index start at 1
		F += A + K[step + 1] + M[g + 1]
		A := D
		D := C
		C := B
		B += LeftRotate(F, S[step + 1])
	}

	A := LittleEndian((A + a0) & 0xFFFFFFFF)
	B := LittleEndian((B + b0) & 0xFFFFFFFF)
	C := LittleEndian((C + c0) & 0xFFFFFFFF)
	D := LittleEndian((D + d0) & 0xFFFFFFFF)

	return Format("{:08x}{:08x}{:08x}{:08x}", A, B, C, D)
}

MineBlock(secret, leadingZeroes) {
	index := 0
	while (true) {
		x := MD5(secret . index)
		if (SubStr(x, 1, leadingZeroes) == 0)
			break
		index++
	}
	return index
}

Msgbox, % "The number is: " MineBlock(secret, 5)

; Will take a while.
; If I ever found something better, I'll update
Msgbox, % "The number is: " MineBlock(secret, 6)
