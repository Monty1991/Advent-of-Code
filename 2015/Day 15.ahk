#NoEnv

; --- Day 15: Science for Hungry People ---
; https://adventofcode.com/2015/day/15

; path to the input file
filePath := "input15.txt"

ingredientList := {}
loop, read, %filePath%
{
	line := A_LoopReadLine
	if (line == "")
		return

	pos := RegExMatch(line, "^(\w+)", m)
	ingredientName := m1
	pos += StrLen(m1)
	properties := {}
	while (pos := RegExMatch(line, "(\w+) (-?\d+)", m, pos)) {
		properties[m1] := m2
		pos += StrLen(m)
	}
	ingredientList[ingredientName] := properties
}

; As always, ensures an entry in a dictionary is properly initialized
EnsureInitialization(dict, key, defaultValue) {
	if (dict.hasKey(key))
		return
	dict[key] := defaultValue
}

; scores according to the given formula:
; for each property (except calories), add times the ingredient count
; if total less than 0, assign zero
; then take the product of all sums (again, except calories).
Score(ingredientList, recipe, exactCalories := 0) {
	cookie := {}

	; In Autohotkey, dict traversal is always done in the same order.
	; So, provided the recipe is an array of the same size as the amount
	; of keys, and we call score for all posible combinations of recipe,
	; we can ignore such ordering
	for ingredient, properties in ingredientList {
		index := A_Index
		for propertyName, value in properties {
			EnsureInitialization(cookie, propertyName, 0)
			cookie[propertyName] += value * recipe[index]
		}
	}

	acc := 1 ; the product neutral
	for property, value in cookie {
		; for calories, we use a special rule
		if (property == "calories") {
			; if we aren't asking for the calorie count, ignore
			if (exactCalories < 1)
				continue ; go to the next property, skip the product ahead
			; only accept this exact amount of calories (used in part B)
			if (value != exactCalories)
				return 0 ; no need to continue, reject score
			continue ; to skip product
		}
		if (value <= 0)
			return 0 ; 0 cancels product, so abort
		acc *= value
	}
	return acc
}

; we'll get a list of all posible recipes
Iterate(ingredientList, index, recipe, size, allRecipes) {
	if (index == ingredientList.count()) {
		recipe[index] := size
		allRecipes.push(recipe.clone())
		recipe[index] := 0
		return
	}

	loop, % (size + 1) {
		x := A_Index - 1
		recipe[index] := x
		Iterate(ingredientList, index + 1, recipe, size - x, allRecipes)
		recipe[index] := 0
	}
}

; this code will give us all the posible recipes
allRecipes := []
recipe := []
loop, % ingredientList.count() {
	recipe.push(0)
}
Iterate(ingredientList, 1, recipe, 100, allRecipes)

; And here we score them
GetBestCookie(ingredientList, allRecipes, exactCalories := 0) {
	maxScore := 0
	for _, recipe in allRecipes {
		s := Score(ingredientList, recipe, exactCalories)
		maxScore := max(maxScore, s)
	}

	return maxScore
}

msgbox, % "The max attainable score is: " GetBestCookie(ingredientList, allRecipes, 0)
msgbox, % "The max attainable score (for 500 calories) is: " GetBestCookie(ingredientList, allRecipes, 500)
