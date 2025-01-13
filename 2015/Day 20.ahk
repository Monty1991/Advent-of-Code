#NoEnv

; For the kind of work we are doing, we need full power
Process, Priority, , High
SetBatchLines, -1

; --- Day 20: Infinite Elves and Infinite Houses ---
; https://adventofcode.com/2015/day/20

; The target number of presents they give you
target := 34000000

; For this problem we observe that for each house, only the Elves
; with that number, one or any divisor, are the only ones to reach the house
; IE: for house 36, only elves 1, 2, 3, 4, 6, 9, 12, 18 and 36 reach it
; Therefore, we need to find a number n, such that
; target (divided by 10) = n + 1 + all divisors of n
; Note also, that all divisors are made from the combination of the prime divisors.
; So the next logical step is to do factorization (and prime number generation)

; The prime numbers are generated through a somewhat Sieve of Eratosthenes
; https://en.wikipedia.org/wiki/Sieve_of_Eratosthenes
; We only search for primes as required
class PrimeTable {
	__new() {
		this.arrPrimes := [2, 3] ; for iterations
		this.primes := {"2": 1, "3": 1} ; for quick checks
		this.lastPrime := 3 ; the lastest prime found
		this.index := 5 ; the next candidate for a prime
	}

	isPrime(n) {
		if (this.primes.hasKey(n))
			return true

		; since we'll always find a divisor less or equal to the square root
		; and if we don't find it, it's a guaranteed prime
		maxP := sqrt(n)
		if (maxP > this.lastPrime)
			this.getNext(maxP)
		for _, p in this.arrPrimes {
			if (p > maxP)
				break
			if (mod(n, p) == 0)
				return false
		}
		return true
	}

	getNext(n) {
		while (this.lastPrime < n) {
			if (this.isPrime(this.index)) {
				this.arrPrimes.push(this.index)
				this.primes[this.index] := 1
				this.lastPrime := this.index
			}
			this.index += 2 ; since the only even prime is 2
		}
	}

	factorize(n) {
		factors := {}
		this.getNext(sqrt(n) + 1)

		for _, p in this.arrPrimes {
			if (mod(n, p) != 0)
				continue
			factors[p] := 0
			while (mod(n, p) == 0) {
				factors[p]++
				n //= p
			}
		}
		if (n > 1) {
			factors[n] := 1
		}

		return factors
	}
}

; We store it as a global variable
; This is an alternative for Singleton objects,
; provided no one else sets the variable
global gPrimeTable := new PrimeTable()

GetAllProductCombinations(acc, factors, combinationTable) {
	if (combinationTable.hasKey(acc)) ; already visited
		return

	combinationTable[acc] := 1
	for k, m in factors {
		if (m > 0) {
			factors[k]--
			GetAllProductCombinations(acc * k, factors, combinationTable)
			factors[k]++
		}
	}
}

CalculateSum(n, maxVisits) {
	factors := gPrimeTable.factorize(n)
	combinationTable := {}
	GetAllProductCombinations(1, factors, combinationTable)

	sum := 0
	for k, _ in combinationTable {
		if ((n // k) <= maxVisits)
			sum += k
	}
	return sum
}

GetHouseNumber(target, factor, maxVisits) {
	loop, % (target / factor) {
		x := CalculateSum(A_Index, maxVisits)
		if (x < (target / factor))
			continue
		return A_Index
	}
	return -1 ; failure
}

msgbox, % "The lowest house number to have at least target presents is: " GetHouseNumber(target, 10, target)

msgbox, % "The newest lowest house number to have at least target presents is: " GetHouseNumber(target, 11, 50)
