// meat pies etc
/obj/item/reagent_containers/food/snacks/rogue/pie
	name = "pie"
	desc = ""
	icon = 'icons/roguetown/items/food.dmi'
	icon_state = "pieuncooked"
	list_reagents = list(/datum/reagent/consumable/nutriment = 5)
	tastes = list("raw shortdough" = 1)
	filling_color = "#FFFFFF"
	foodtype = GRAIN | DAIRY
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/pie/cooked
	slices_num = 0
	bitesize = 5
	var/stunning = FALSE
	var/high_quality = FALSE
	eat_effect = /datum/status_effect/debuff/uncookedfood

/obj/item/reagent_containers/food/snacks/rogue/pie/cooked
	icon_state = "pie"
	desc = ""
	tastes = list("indulgent buttery, savoury crust")
	list_reagents = list(/datum/reagent/consumable/nutriment = 30)
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/pieslice
	slices_num = 6
	slice_batch = TRUE
	warming = 10 MINUTES
	eat_effect = null

/obj/item/reagent_containers/food/snacks/rogue/pie/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	. = ..()
	if(!.) //if we're not being caught
		splat(hit_atom)

/obj/item/reagent_containers/food/snacks/rogue/pie/proc/splat(atom/movable/hit_atom)
	if(isliving(loc)) //someone caught us!
		return
	var/turf/T = get_turf(hit_atom)
	new/obj/effect/decal/cleanable/food/pie_smudge(T)
	if(reagents && reagents.total_volume)
		reagents.reaction(hit_atom, TOUCH)
	if(isliving(hit_atom))
		var/mob/living/L = hit_atom
		if(stunning)
			L.Paralyze(20) //splat!
		L.adjust_blurriness(1)
		L.visible_message(span_warning("[L] is hit by [src]!"), span_danger("I'm hit by [src]!"))
	if(is_type_in_typecache(hit_atom, GLOB.creamable))
		hit_atom.AddComponent(/datum/component/creamed, src)
	qdel(src)

/obj/item/reagent_containers/food/snacks/rogue/pie/CheckParts(list/parts_list)
	..()
	for(var/obj/item/reagent_containers/food/snacks/M in parts_list)
		filling_color = M.filling_color
		update_snack_overlays(M)
		color = M.filling_color
		if(M.reagents)
			M.reagents.remove_reagent(/datum/reagent/consumable/nutriment, M.reagents.total_volume)
			M.reagents.trans_to(src, M.reagents.total_volume)
		qdel(M)

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
			if (hq_prob > 0)// && prob(hq_prob))
				to_chat(H, "This [src] comes together just perfect - I've made something really special!")
				high_quality = TRUE
				name = "exquisite [name]"
				
/obj/item/reagent_containers/food/snacks/rogue/pie/microwave_act(atom/A)
	. = ..()
	if (high_quality) // make sure our high quality stuff carries across
		var/obj/item/reagent_containers/food/snacks/rogue/pie/new_pie = .
		new_pie.high_quality = TRUE
		new_pie.name = "exquisite [name]"
		if (new_pie.foodtype & SUGAR)
			new_pie.eat_effect = /datum/status_effect/buff/foodbuff/sweet/lavish
		else if (new_pie.foodtype & MEAT)
			new_pie.eat_effect = /datum/status_effect/buff/foodbuff/lavish

/obj/item/reagent_containers/food/snacks/rogue/pie/initialize_slice(obj/item/reagent_containers/food/snacks/slice, reagents_per_slice)
	. = ..()
	if (high_quality)
		slice.name = "exquisite [name]"
		if (foodtype & SUGAR)
			slice.eat_effect = /datum/status_effect/buff/foodbuff/sweet/lavish
		else if (foodtype & MEAT)
			slice.eat_effect = /datum/status_effect/buff/foodbuff/lavish

/obj/item/reagent_containers/food/snacks/rogue/pieslice
	icon = 'icons/roguetown/items/food.dmi'
	list_reagents = list(/datum/reagent/consumable/nutriment = 5)
	tastes = list("buttery, savoury crust" = 1)
	name = "pie slice"
	desc = ""
	icon_state = "slice"
	filling_color = "#FFFFFF"
	foodtype = GRAIN | DAIRY 
	warming = 10 MINUTES
	bitesize = 3
	eat_effect = /datum/status_effect/buff/foodbuff

/obj/item/reagent_containers/food/snacks/rogue/piedough
	name = "pie dough"
	desc = ""
	icon = 'icons/roguetown/items/food.dmi'
	icon_state = "piedough"
	slices_num = 0
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/pie/cooked
	list_reagents = list(/datum/reagent/consumable/nutriment = 5)
	w_class = WEIGHT_CLASS_NORMAL
	tastes = list("dough" = 1)
	foodtype = GRAIN
	eat_effect = /datum/status_effect/debuff/uncookedfood

/datum/crafting_recipe/roguetown/cooking/piedough
	name = "pie dough"
	reqs = list(
		/datum/reagent/water = 10,
		/obj/item/reagent_containers/powder/flour= 2,
		/obj/item/reagent_containers/food/snacks/butterslice = 1,
	)
	result = /obj/item/reagent_containers/food/snacks/rogue/piedough

/datum/crafting_recipe/roguetown/cooking/berrypie
	name = "berry pie"
	reqs = list(
		/obj/item/reagent_containers/food/snacks/grown/berries/rogue = 3,
		/obj/item/reagent_containers/food/snacks/rogue/piedough = 1)
	parts = list(
		/obj/item/reagent_containers/food/snacks/grown/berries/rogue = 3)
	result = /obj/item/reagent_containers/food/snacks/rogue/pie/berry

/datum/crafting_recipe/roguetown/cooking/applepie
	name = "apple pie"
	reqs = list(
		/obj/item/reagent_containers/food/snacks/grown/apple = 3,
		/obj/item/reagent_containers/food/snacks/rogue/piedough = 1)
	parts = list(
		/obj/item/reagent_containers/food/snacks/grown/apple = 3)
	result = /obj/item/reagent_containers/food/snacks/rogue/pie/apple

/obj/item/reagent_containers/food/snacks/rogue/pie/berry
	name = "berry pie"
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/pie/cooked/berry
	eat_effect = /datum/status_effect/debuff/uncookedfood
	tastes = list("mushy berries" = 1, "uncooked shortdough" = 1)
	foodtype = GRAIN | DAIRY | SUGAR

/obj/item/reagent_containers/food/snacks/rogue/pie/cooked/berry
	name = "berry pie"
	desc = ""
	list_reagents = list(/datum/reagent/consumable/nutriment = 30)
	eat_effect = /datum/status_effect/buff/foodbuff/sweet
	tastes = list("sweet, fruity berry jam" = 1, "buttery, sugary crust" = 1)
	foodtype = GRAIN | DAIRY | SUGAR

/obj/item/reagent_containers/food/snacks/rogue/pie/apple
	name = "apple pie"
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/pie/cooked/apple
	eat_effect = /datum/status_effect/debuff/uncookedfood
	tastes = list("crunchy apples" = 1, "uncooked shortdough" = 1)
	foodtype = GRAIN | DAIRY | SUGAR

/obj/item/reagent_containers/food/snacks/rogue/pie/cooked/apple
	name = "apple pie"
	desc = ""
	list_reagents = list(/datum/reagent/consumable/nutriment = 30)
	eat_effect = /datum/status_effect/buff/foodbuff/sweet
	tastes = list("stewed and spiced apples" = 1, "buttery, sugary crust" = 1)
	foodtype = GRAIN | DAIRY | SUGAR

/datum/crafting_recipe/roguetown/cooking/meatpie
	name = "meat pie"
	reqs = list(
		/obj/item/reagent_containers/food/snacks/rogue/meat/mince/beef = 3,
		/obj/item/reagent_containers/food/snacks/rogue/piedough = 1)
	parts = list(
		/obj/item/reagent_containers/food/snacks/rogue/meat/mince = 3)
	result = /obj/item/reagent_containers/food/snacks/rogue/pie/meat

	subtype_reqs = FALSE

/obj/item/reagent_containers/food/snacks/rogue/pie/meat
	name = "meat pie"
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/pie/cooked/meat
	eat_effect = /datum/status_effect/debuff/uncookedfood
	filling_color = "#8f433a"
	tastes = list("uncooked shortdough" = 1, "raw ground meat" = 1)
	foodtype = GRAIN | DAIRY | MEAT

/obj/item/reagent_containers/food/snacks/rogue/pie/cooked/meat
	name = "meat pie"
	desc = ""
	list_reagents = list(/datum/reagent/consumable/nutriment = 30)
	eat_effect = /datum/status_effect/buff/foodbuff
	tastes = list("buttery, savoury crust" = 1, "braised, saucy meat" = 1)
	foodtype = GRAIN | DAIRY | MEAT

/datum/crafting_recipe/roguetown/cooking/meatpie/fish
	name = "fish pie"
	reqs = list(
		/obj/item/reagent_containers/food/snacks/rogue/meat/mince/fish = 3,
		/obj/item/reagent_containers/food/snacks/rogue/piedough = 1
	)
	parts = list(
		/obj/item/reagent_containers/food/snacks/rogue/meat/mince/fish = 3
	)
	result = /obj/item/reagent_containers/food/snacks/rogue/pie/meat/fish

/obj/item/reagent_containers/food/snacks/rogue/pie/meat/fish
	name = "fish pie"
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/pie/cooked/meat/fish
	eat_effect = /datum/status_effect/debuff/uncookedfood
	tastes = list("raw minced fish" = 1, "uncooked shortdough" = 1)
	foodtype = GRAIN | DAIRY | MEAT

/obj/item/reagent_containers/food/snacks/rogue/pie/cooked/meat/fish
	name = "fish pie"
	eat_effect = /datum/status_effect/buff/foodbuff
	tastes = list("buttery, savoury crust" = 1, "flaky fish" = 1)
	foodtype = GRAIN | DAIRY | MEAT

/datum/crafting_recipe/roguetown/cooking/meatpie/poultry
	name = "pot pie"
	reqs = list(
		/obj/item/reagent_containers/food/snacks/rogue/meat/mince/poultry = 3,
		/obj/item/reagent_containers/food/snacks/rogue/piedough = 1
	)
	parts = list(
		/obj/item/reagent_containers/food/snacks/rogue/meat/mince/poultry = 3
	)
	result = /obj/item/reagent_containers/food/snacks/rogue/pie/meat/poultry


/obj/item/reagent_containers/food/snacks/rogue/pie/meat/poultry
	name = "pot pie"
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/pie/cooked/meat/poultry
	eat_effect = /datum/status_effect/debuff/uncookedfood
	tastes = list("raw minced white meat" = 1, "uncooked shortdough" = 1)
	foodtype = GRAIN | DAIRY | MEAT

/obj/item/reagent_containers/food/snacks/rogue/pie/cooked/meat/poultry
	name = "pot pie"
	eat_effect = /datum/status_effect/buff/foodbuff
	tastes = list("buttery, savoury crust" = 1, "stewed chicken bits" = 1)
	foodtype = GRAIN | DAIRY | MEAT

/datum/crafting_recipe/roguetown/cooking/eggpie
	name = "egg pie"
	reqs = list(
		/obj/item/reagent_containers/food/snacks/egg = 3,
		/obj/item/reagent_containers/food/snacks/rogue/piedough = 1)
	parts = list(
		/obj/item/reagent_containers/food/snacks/egg = 3)
	result = /obj/item/reagent_containers/food/snacks/rogue/pie/egg

/obj/item/reagent_containers/food/snacks/rogue/pie/egg
	name = "egg pie"
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/pie/cooked/egg
	eat_effect = /datum/status_effect/debuff/uncookedfood
	tastes = list("raw egg" = 1, "uncooked shortdough" = 1)
	foodtype = GRAIN | DAIRY | EGG

/obj/item/reagent_containers/food/snacks/rogue/pie/cooked/egg
	name = "egg pie"
	desc = ""
	list_reagents = list(/datum/reagent/consumable/nutriment = 30)
	eat_effect = /datum/status_effect/buff/foodbuff
	tastes = list("hearty streaks of braised egg" = 1, "buttery, savoury crust" =  1)
	foodtype = GRAIN | DAIRY | EGG
