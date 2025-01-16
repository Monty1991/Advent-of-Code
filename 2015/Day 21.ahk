#NoEnv

; --- Day 21: RPG Simulator 20XX ---
; https://adventofcode.com/2015/day/21

; path to the input file
filePath := "input21.txt"

shopDescription := "
(
Weapons:    Cost  Damage  Armor
Dagger        8     4       0
Shortsword   10     5       0
Warhammer    25     6       0
Longsword    40     7       0
Greataxe     74     8       0

Armor:      Cost  Damage  Armor
Leather      13     0       1
Chainmail    31     0       2
Splintmail   53     0       3
Bandedmail   75     0       4
Platemail   102     0       5

Rings:      Cost  Damage  Armor
Damage +1    25     1       0
Damage +2    50     2       0
Damage +3   100     3       0
Defense +1   20     0       1
Defense +2   40     0       2
Defense +3   80     0       3
)"

; a dummy class to store equipment stats
class Equipment {
	__new(name, cost, damage, armor) {
		this.name := name
		this.cost := cost
		this.damage := damage
		this.armor := armor
	}

	getCost() {
		return this.cost
	}

	getDamage() {
		return this.damage
	}

	getArmor() {
		return this.armor
	}
}

EnsureInitialization(dict, key, defaultValue) {
	if (dict.hasKey(key))
		return
	dict[key] := defaultValue
}

shop := {}
category := ""
for _, line in StrSplit(shopDescription, "`n") {
	if (RegExMatch(line, "^(\w+):", m)) {
		category := m1
		EnsureInitialization(shop, category, [])
	} else if (RegExMatch(line, "(\w+(?: \+\d)?)\D+(\d+)\D+(\d+)\D+(\d+)", m)) {
		shop[category].push(new Equipment(m1, m2, m3, m4))
	}
}

; A little trick to make up for unused slots
shop["Armor"].push(new Equipment("No Armor", 0, 0, 0))
shop["Rings"].push(new Equipment("No Ring", 0, 0, 0))
shop["Rings"].push(new Equipment("No Ring 2", 0, 0, 0))

bossStats := {}
loop, read, %filePath%
{
	line := A_LoopReadLine
	if (line == "")
		continue

	x := StrSplit(line, ": ")
	bossStats[x[1]] := x[2]
}

; We'll pregenerate all equipment combinations
GetAllCombinations(shop) {
	combinations := []
	weapons := shop["Weapons"]
	armor := shop["Armor"]
	rings := shop["Rings"]

	for _, w in weapons {
		for _, a in armor {
			index := 1
			while (index < rings.count()) {
				index2 := index + 1
				while(index2 <= rings.count()) {
					combinations.push([w, a, rings[index], rings[index2]])
					index2++
				}
				index++
			}
		}
	}

	return combinations
}

; A convenient way to abstract the combat
class Entity {
	__new(hp, damage, armor) {
		this.hp := hp
		this.damage := damage
		this.armor := armor
	}

	getDamage() {
		return this.damage
	}

	hit(intendedDamage) {
		this.hp -= max(intendedDamage - this.armor, 1)
	}

	isAlive() {
		return this.hp > 0
	}
}

; we calculate the stats for the full set
CalculateStats(equipmentSet) {
	stats := {"cost": 0, "armor": 0, "damage": 0}
	for _, equip in equipmentSet {
		stats.cost += equip.getCost()
		stats.armor += equip.getArmor()
		stats.damage += equip.getDamage()
	}
	return stats
}

; returns cost for the wining side (player - boss)
Combat(bossStats, equipmentSet) {
	boss := new Entity(bossStats["Hit Points"], bossStats["Damage"], bossStats["Armor"])
	stats := CalculateStats(equipmentSet)
	player := new Entity(100, stats.damage, stats.armor)

	while (true) {
		boss.hit(player.getDamage())
		if (!boss.isAlive())
			return [stats.cost, 0]
		player.hit(boss.getDamage())
		if (!player.isAlive())
			break
	}
	return [1.0e+6, stats.cost]
}

allSets := GetAllCombinations(shop)
minCost := 1.0e+6
maxCost := 0
for _, set in allSets {
	result := Combat(bossStats, set)
	minCost := min(minCost, result[1])
	maxCost := max(maxCost, result[2])
}

msgbox, % "The minimum cost for a set to defeat the boss is: " minCost
msgbox, % "The maximum cost for a set and still loose to the boss is: " maxCost
