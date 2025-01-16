#NoEnv

; we are basically doing backtracking here
Process, Priority, , High
SetBatchLines, -1

; --- Day 22: Wizard Simulator 20XX ---
; https://adventofcode.com/2015/day/22

; path to the input file
filePath := "input22.txt"

; same file format as day 21
bossStats := {}
loop, read, %filePath%
{
	line := A_LoopReadLine
	if (line == "")
		continue

	x := StrSplit(line, ": ")
	bossStats[x[1]] := x[2]
}

class Entity {
	__new(hp, damage, armor) {
		this.hp := hp
		this.damage := damage
		this.armor := armor
		this.poisonCounter := 0
	}

	getDamage() {
		return this.damage
	}

	getArmor() {
		return this.armor
	}

	bleed() {
		this.hp--
	}

	poison() {
		this.poisonCounter := 6
	}

	applyEffects() {
		if (this.poisonCounter > 0) {
			this.hit(3, true)
			this.poisonCounter--
		}
	}

	hit(intendedDamage, isMagical) {
		if (isMagical) {
			this.hp -= intendedDamage
		} else {
			this.hp -= max(intendedDamage - this.getArmor(), 1)
		}
	}

	isAlive() {
		return this.hp > 0
	}
}

class Wizard extends Entity {
	__new(hp, mana) {
		base.__new(hp, 0, 0)
		this.mana := mana
		this.manaSpent := 0
		this.poisonCooldown := 0
		this.rechargeCooldown := 0
		this.shieldCooldown := 0
	}

	getArmor() {
		return base.getArmor() + (this.shieldCooldown > 0? 7 : 0)
	}

	applyEffects() {
		base.applyEffects()

		if (this.poisonCooldown > 0) {
			this.poisonCooldown--
		}

		if (this.shieldCooldown > 0) {
			this.shieldCooldown--
		}

		if (this.rechargeCooldown > 0) {
			this.mana += 101
			this.rechargeCooldown--
		}
	}

	castSpell(spellName, target) {
		switch (spellName) {
			case "Magic Missile":
				this.spendMana(53)
				target.hit(4, true)

			case "Drain":
				this.spendMana(73)
				target.hit(2, true)
				this.hp += 2

			case "Shield":
				this.spendMana(113)
				this.shieldCooldown := 6

			case "Poison":
				this.spendMana(173)
				this.poisonCooldown := 6
				target.poison()

			case "Recharge":
				this.spendMana(229)
				this.rechargeCooldown := 5
		}
	}

	canCast(spellName) {
		switch (spellName) {
			case "Magic Missile":
				return (this.mana > 53)

			case "Drain":
				return (this.mana > 73)

			case "Shield":
				return (this.shieldCooldown == 0) && (this.mana > 113)

			case "Poison":
				return (this.poisonCooldown == 0) && (this.mana > 173)

			case "Recharge":
				return (this.rechargeCooldown == 0) && (this.mana > 229)
		}
	}

	spendMana(amount) {
		this.mana -= amount
		if (this.mana < 0) {
			; we attempted to use more mana than available
			; kill the caster
			this.hp := 0
			return
		}
		this.manaSpent += amount
	}
}

global allSpells := ["Magic Missile", "Drain", "Shield", "Poison", "Recharge"]
GetAvailableSpells(e) {
	available := []
	for _, spellName in allSpells {
		if (e.canCast(spellName))
			available.push(spellName)
	}
	return available
}

Combat(player, boss, byRef minimumManaSpent, hardMode) {
	if (player.manaSpent > minimumManaSpent)
		return

	; wizard turn
	if (hardMode) {
		player.bleed()
		if (!player.isAlive())
			return
	}

	player.applyEffects()
	boss.applyEffects()
	if (!boss.isAlive()) {
		minimumManaSpent := min(minimumManaSpent, player.manaSpent)
		return
	}

	availableSpells := GetAvailableSpells(player)
	; out of spells to cast, wizard looses
	if (availableSpells.count() == 0)
		return

	for _, spellName in availableSpells {
		player2 := player.clone()
		boss2 := boss.clone()
		player2.castSpell(spellName, boss2)
		if (player2.manaSpent > minimumManaSpent)
			continue
		if (!boss2.isAlive()) {
			minimumManaSpent := min(minimumManaSpent, player2.manaSpent)
			continue
		}

		; boss turn
		player2.applyEffects()
		boss2.applyEffects()
		if (!boss2.isAlive()) {
			minimumManaSpent := min(minimumManaSpent, player2.manaSpent)
			continue
		}
		player2.hit(boss.getDamage(), false)
		if (player2.isAlive())
			Combat(player2, boss2, minimumManaSpent, hardMode)
	}
}

minimumManaSpent := 1.0e+6

Combat(new Wizard(50, 500), new Entity(bossStats["Hit Points"], bossStats["Damage"], 0), minimumManaSpent, false)

Msgbox, % "The least amount of mana spent to defeat the boss is: " minimumManaSpent

minimumManaSpent := 1.0e+6

Combat(new Wizard(50, 500), new Entity(bossStats["Hit Points"], bossStats["Damage"], 0), minimumManaSpent, true)

Msgbox, % "The least amount of mana spent to defeat the boss in hard mode is: " minimumManaSpent
