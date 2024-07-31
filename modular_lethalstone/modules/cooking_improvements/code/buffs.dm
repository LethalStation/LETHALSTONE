/atom/movable/screen/alert/status_effect/buff/foodbuff
	desc = "Above-average fare, a rarity in a land like Enigma."

/datum/status_effect/buff/foodbuff/lavish
	id = "foodbuff"
	alert_type = /atom/movable/screen/alert/status_effect/buff/foodbuff/lavish
	effectedstats = list("constitution" = 1, "endurance" = 1, "strength" = 1)
	duration = 20 MINUTES

/atom/movable/screen/alert/status_effect/buff/foodbuff/lavish
	name = "Lavish Meal"
	desc = "A meal fit for a king!"
	icon_state = "foodbuff"
	
/datum/status_effect/buff/foodbuff/sweet
	id = "foodbuff-dessert"
	alert_type = /atom/movable/screen/alert/status_effect/buff/foodbuff/sweet
	effectedstats = list("perception" = 1, "intelligence" = 1)
	duration = 10 MINUTES

/atom/movable/screen/alert/status_effect/buff/foodbuff/sweet
	name = "Great Treat"
	desc = "Something sweet is a rare treat indeed, and helps hone the mind."
	icon_state = "foodbuff"

/datum/status_effect/buff/foodbuff/sweet/lavish
	id = "foodbuff-dessert"
	alert_type = /atom/movable/screen/alert/status_effect/buff/foodbuff/sweet/lavish
	effectedstats = list("perception" = 1, "intelligence" = 1, "speed" = 1)
	duration = 10 MINUTES

/atom/movable/screen/alert/status_effect/buff/foodbuff/sweet/lavish
	name = "Decadent Treat"
	desc = "An exquisite dessert really is something!"
	icon_state = "foodbuff"
