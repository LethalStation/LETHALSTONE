// LETHALSTONE ADDITION: give pies qualities based on cooking skill
/obj/item/reagent_containers/food/snacks/rogue/pie/OnCrafted(dirin, user)
	. = ..()
	if (ishuman(user))
		var/mob/living/carbon/human/H = user
		var/cooking_level = H.mind.get_skill_level(/datum/skill/craft/cooking)
		if (cooking_level >= SKILL_LEVEL_JOURNEYMAN)
			var/hq_prob = (cooking_level - 2) * 5
			var/fortune_modifier = (10-H.STALUC) * 2
			hq_prob += fortune_modifier
			if (hq_prob > 0 && prob(hq_prob))
				to_chat(H, "This [name] comes together just perfect - I've made something really special!")
				high_quality = TRUE
				name = "exquisite [name]"
				
/obj/item/reagent_containers/food/snacks/rogue/pie/microwave_act(atom/A)
	. = ..()
	if (high_quality) // make sure our high quality stuff carries across
		var/obj/item/reagent_containers/food/snacks/rogue/pie/new_pie = .
		new_pie.high_quality = TRUE
		if (new_pie.foodtype & SUGAR)
			new_pie.eat_effect = /datum/status_effect/buff/foodbuff/sweet/lavish
		else if (new_pie.foodtype & MEAT)
			new_pie.eat_effect = /datum/status_effect/buff/foodbuff/lavish

/obj/item/reagent_containers/food/snacks/rogue/pie/initialize_slice(obj/item/reagent_containers/food/snacks/slice, reagents_per_slice)
	. = ..()
	if (high_quality)
		if (foodtype & SUGAR)
			slice.eat_effect = /datum/status_effect/buff/foodbuff/sweet/lavish
		else if (foodtype & MEAT)
			slice.eat_effect = /datum/status_effect/buff/foodbuff/lavish

// Type additions

/obj/item/reagent_containers/food/snacks/rogue/pie
	/// Is our pie of exceptional quality, and should it give better buffs?
	var/high_quality = TRUE
	foodtype = GRAIN | DAIRY

/obj/item/reagent_containers/food/snacks/rogue/pie/cooked
	tastes = list("indulgent buttery, savoury crust")

/obj/item/reagent_containers/food/snacks/rogue/pieslice
	foodtype = GRAIN | DAIRY 

/obj/item/reagent_containers/food/snacks/rogue/pie/berry
	foodtype = GRAIN | DAIRY | SUGAR

/obj/item/reagent_containers/food/snacks/rogue/pie/cooked/berry
	eat_effect = /datum/status_effect/buff/foodbuff/sweet
	tastes = list("sweet, fruity berry jam" = 1, "buttery, sugary crust" = 1)
	foodtype = GRAIN | DAIRY | SUGAR

/obj/item/reagent_containers/food/snacks/rogue/pie/apple
	foodtype = GRAIN | DAIRY | SUGAR

/obj/item/reagent_containers/food/snacks/rogue/pie/cooked/apple
	eat_effect = /datum/status_effect/buff/foodbuff/sweet
	tastes = list("stewed and spiced apples" = 1, "buttery, sugary crust" = 1)
	foodtype = GRAIN | DAIRY | SUGAR

/obj/item/reagent_containers/food/snacks/rogue/pie/meat
	foodtype = GRAIN | DAIRY | MEAT

/obj/item/reagent_containers/food/snacks/rogue/pie/cooked/meat
	tastes = list("buttery, savoury crust" = 1, "braised, saucy meat" = 1)
	foodtype = GRAIN | DAIRY | MEAT

/obj/item/reagent_containers/food/snacks/rogue/pie/meat/fish
	foodtype = GRAIN | DAIRY | MEAT

/obj/item/reagent_containers/food/snacks/rogue/pie/cooked/meat/fish
	tastes = list("buttery, savoury crust" = 1, "flaky fish" = 1)
	foodtype = GRAIN | DAIRY | MEAT

/obj/item/reagent_containers/food/snacks/rogue/pie/meat/poultry
	foodtype = GRAIN | DAIRY | MEAT

/obj/item/reagent_containers/food/snacks/rogue/pie/cooked/meat/poultry
	tastes = list("buttery, savoury crust" = 1, "stewed chicken bits" = 1)
	foodtype = GRAIN | DAIRY | MEAT

/obj/item/reagent_containers/food/snacks/rogue/pie/egg
	foodtype = GRAIN | DAIRY | EGG

/obj/item/reagent_containers/food/snacks/rogue/pie/cooked/egg
	tastes = list("hearty streaks of braised egg" = 1, "buttery, savoury crust" =  1)
	foodtype = GRAIN | DAIRY | EGG
