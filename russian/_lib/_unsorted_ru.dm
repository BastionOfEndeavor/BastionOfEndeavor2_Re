/datum/crafting_recipe
	var/result_name_ru


/proc/intent2russian_ru(var/intent)
	switch(intent)
		if(I_HELP) return "Помочь"
		if(I_DISARM) return "Обезвредить"
		if(I_GRAB) return "Схватить"
		if(I_HURT) return "Навредить"

/proc/movintent2russian_ru(var/mov_intent)
	if(mov_intent == "walk") return "Ходьба"
	else return "Бег"

/proc/season2russian_ru(var/season)
	switch(season)
		if("winter") return "Зима"
		if("spring") return "Весна"
		if("summer") return "Лето"
		if("autumn") return "Осень"

/proc/dirs2text_ru(direction)
	var/text = dirs2text(direction)
	text = replacetext_char(text, "NORTH", "СЕВЕР")
	text = replacetext_char(text, "WEST", "ЗАПАД")
	text = replacetext_char(text, "SOUTH", "ЮГ")
	text = replacetext_char(text, "EAST", "ВОСТОК")
	return text

/datum/sprite_accessory/hair/skyrat/halfshave
	name = "Half-shaved 2"
	icon = 'russian/_modular/icons/unsorted_ru.dmi'
	icon_add = 'russian/_modular/icons/unsorted_2.dmi'
	icon_state = "halfshave"

/datum/sprite_accessory/hair/skyrat/halfshave_snout
	name = "Half-shaved 2 (clipped)"
	icon = 'russian/_modular/icons/unsorted_ru.dmi'
	icon_add = 'russian/_modular/icons/unsorted_2.dmi'
	icon_state = "halfshavesnout"