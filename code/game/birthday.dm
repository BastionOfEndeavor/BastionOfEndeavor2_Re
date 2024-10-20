/mob/living/carbon/human/proc/consider_birthday()
	if(!bday_month || !bday_day) //If we don't have one of these set, don't worry about it
		return
	if(real_name != client.prefs.real_name) //let's not celebrate the birthday of that weird mob we got dropped into
		return
	if(!(client.prefs.last_birthday_notification < GLOB.world_time_year)) //you only get notified once a year // CHOMPEdit - Managed Globals
		return
	if((GLOB.world_time_month == bday_month) && (GLOB.world_time_day == bday_day)) //it is your birthday // CHOMPEdit - Managed Globals
		birthday(1)
	else if(GLOB.world_time_month > bday_month) //your birthday was in a previous month // CHOMPEdit - Managed Globals
		birthday()
	else if((GLOB.world_time_month == bday_month) && (GLOB.world_time_day > bday_day)) //your birthday was earlier this month // CHOMPEdit - Managed Globals
		birthday()

/mob/living/carbon/human/proc/birthday(var/birthday = 0)
	var/msg
	var/lastyear = client.prefs.last_birthday_notification
	client.prefs.last_birthday_notification = GLOB.world_time_year //We only want to ask once a year per character, this persists, update early in case of shenanigans // CHOMPEdit - Managed Globals
	if(birthday)	//woo
		/* Bastion of Endeavor Translation
		msg = "Today is your birthday! Do you want to increase your character's listed age?"
		*/
		msg = "Сегодня ваш День рождения! Хотели бы вы увеличить возраст вашего персонажа?"
		// End of Bastion of Endeavor Translation
		/* //Chomp DISABLE - Absolutely not.
		if(client.prefs.bday_announce)
			var/list/sounds = list('sound/voice/BIRTH.ogg')
			var/oursound = pickweight(sounds)
			command_announcement.Announce("Confirmed presence of BIRTHDAY aboard the station! It is [src.real_name]'s birthday or similar sort of celebration, name day, hatchday, WHATEVER! We encourage you to go find [src.real_name] and show them how we celebrate around here! Have a secure day!", "BIRTHDAY!", oursound)
		*/ //Chomp DISABLE END
	else
		/* Bastion of Endeavor Translation
		msg = "Your birthday has passed! Do you want to increase your character's listed age?"	//sad, but thus is the life of an adult
		*/
		msg = "Вы отметили День рождения! Хотели бы вы увеличить возраст вашего персонажа?"
		// End of Bastion of Endeavor Translation
	/* Bastion of Endeavor Translation
	if(tgui_alert(src, msg,"BIRTHDAY! ([bday_month]/[bday_day])",list("Level me up, baby","No way, I'mma stay young forever")) == "Level me up, baby")
	*/
	if(tgui_alert(src, msg,"ДЕНЬ РОЖДЕНИЯ! ([bday_month]/[bday_day])",list("Новый уровень, детка","Нет уж, остаюсь вечно молодым")) == "Новый уровень, детка")
	// End of Bastion of Endeavor Translation
		if(lastyear == 0)	//We've never been asked, so let's just assume you were keeping track before now and only add 1
			age += 1
		else
			var/howmuch = GLOB.world_time_year - lastyear // CHOMPEdit - Managed Globals
			age += howmuch
<<<<<<< HEAD
		/* Bastion of Endeavor Translation
		to_chat(src, "<span class = 'notice'>You are now [age]! Happy birthday!</span>")
		*/
		to_chat(src, "<span class = 'notice'>Вам теперь [count_ru(age, ";год;года;лет")]! С Днём рождения!</span>")
		// End of Bastion of Endeavor Translation
=======
		to_chat(src, span_notice("You are now [age]! Happy birthday!"))
>>>>>>> 14f0302bef ([MIRROR] some more spans (#9170))
		client.prefs.age = age	//Set the age on the character sheet

	client.prefs.save_character()	//Save the info
