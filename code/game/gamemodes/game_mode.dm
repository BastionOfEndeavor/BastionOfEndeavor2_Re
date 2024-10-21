var/global/antag_add_failed // Used in antag type voting.
var/global/list/additional_antag_types = list()

/datum/game_mode
	/* Bastion of Endeavor Translation
	var/name = "invalid"
	var/round_description = "How did you even vote this in?"
	var/extended_round_description = "This roundtype should not be spawned, let alone votable. Someone contact a developer and tell them the game's broken again."
	*/
	var/name = "Недопустимый режим"
	var/round_description = "Как вы вообще за это проголосовали?"
	var/extended_round_description = "Этот игровой режим не должен быть активирован. Свистните разработчику и скажите, что что-то опять поломалось."
	// End of Bastion of Endeavor Translation
	var/config_tag = null
	var/votable = 1
	var/probability = 0

	var/required_players = 0                 // Minimum players for round to start if voted in.
	var/required_players_secret = 0          // Minimum number of players for that game mode to be chose in Secret
	var/required_enemies = 0                 // Minimum antagonists for round to start.
	var/newscaster_announcements = null
	var/end_on_antag_death = 0               // Round will end when all antagonists are dead.
	var/ert_disabled = 0                     // ERT cannot be called.
	var/deny_respawn = 0	                 // Disable respawn during this round.

	var/list/disabled_jobs = list()           // Mostly used for Malf.  This check is performed in job_controller so it doesn't spawn a regular AI.

	var/shuttle_delay = 1                    // Shuttle transit time is multiplied by this.
	var/auto_recall_shuttle = 0              // Will the shuttle automatically be recalled?

	var/list/antag_tags = list()             // Core antag templates to spawn.
	var/list/antag_templates                 // Extra antagonist types to include.
	var/list/latejoin_templates = list()
	var/round_autoantag = 0                  // Will this round attempt to periodically spawn more antagonists?
	var/antag_scaling_coeff = 5              // Coefficient for scaling max antagonists to player count.
	var/require_all_templates = 0            // Will only start if all templates are checked and can spawn.

	var/station_was_nuked = 0                // See nuclearbomb.dm and malfunction.dm.
	var/explosion_in_progress = 0            // Sit back and relax
	var/waittime_l = 600                     // Lower bound on time before intercept arrives (in tenths of seconds)
	var/waittime_h = 1800                    // Upper bound on time before intercept arrives (in tenths of seconds)

	var/event_delay_mod_moderate             // Modifies the timing of random events.
	var/event_delay_mod_major                // As above.

/datum/game_mode/New()
	..()

/datum/game_mode/Topic(href, href_list[])
	if(..())
		return
	if(href_list["toggle"])
		switch(href_list["toggle"])
			if("respawn")
				deny_respawn = !deny_respawn
			if("ert")
				ert_disabled = !ert_disabled
				announce_ert_disabled()
			if("shuttle_recall")
				auto_recall_shuttle = !auto_recall_shuttle
			if("autotraitor")
				round_autoantag = !round_autoantag
		/* Bastion of Endeavor Translation
		message_admins("Admin [key_name_admin(usr)] toggled game mode option '[href_list["toggle"]]'.")
		*/
		message_admins("[key_name_admin(usr)] переключил параметр игрового режима '[href_list["toggle"]]'")
		// End of Bastion of Endeavor Translation
	else if(href_list["set"])
		var/choice = ""
		switch(href_list["set"])
			if("shuttle_delay")
				/* Bastion of Endeavor Translation
				choice = tgui_input_number(usr, "Enter a new shuttle delay multiplier", null, null, 20, 1)
				*/
				choice = tgui_input_number(usr, "Введите новый модификатор задержки шаттла.", null, null, 20, 1)
				// End of Bastion of Endeavor Translation
				if(!choice || choice < 1 || choice > 20)
					return
				shuttle_delay = choice
			if("antag_scaling")
				/* Bastion of Endeavor Translation
				choice = tgui_input_number(usr, "Enter a new antagonist cap scaling coefficient.", null, null, 100, 0)
				*/
				choice = tgui_input_number(usr, "Введите новый множитель предела антагонистов.", null, null, 100, 0)
				// End of Bastion of Endeavor Translation
				if(isnull(choice) || choice < 0 || choice > 100)
					return
				antag_scaling_coeff = choice
			if("event_modifier_moderate")
				/* Bastion of Endeavor Translation
				choice = tgui_input_number(usr, "Enter a new moderate event time modifier.", null, null, 100, 0)
				*/
				choice = tgui_input_number(usr, "Введите новый модификатор событий средней тяжести.", null, null, 100, 0)
				// End of Bastion of Endeavor Translation
				if(isnull(choice) || choice < 0 || choice > 100)
					return
				event_delay_mod_moderate = choice
				refresh_event_modifiers()
			if("event_modifier_severe")
				/* Bastion of Endeavor Translation
				choice = tgui_input_number(usr, "Enter a new moderate event time modifier.", null, null, 100, 0)
				*/
				choice = tgui_input_number(usr, "Введите новый модификатор событий сильной тяжести.", null, null, 100, 0)
				// End of Bastion of Endeavor Translation
				if(isnull(choice) || choice < 0 || choice > 100)
					return
				event_delay_mod_major = choice
				refresh_event_modifiers()
		/* Bastion of Endeavor Translation
		message_admins("Admin [key_name_admin(usr)] set game mode option '[href_list["set"]]' to [choice].")
		*/
		message_admins("[key_name_admin(usr)] установил параметр игрового режима '[href_list["set"]]' = [choice].")
		// End of Bastion of Endeavor Translation
	else if(href_list["debug_antag"])
		if(href_list["debug_antag"] == "self")
			usr.client.debug_variables(src)
			return
		var/datum/antagonist/antag = all_antag_types[href_list["debug_antag"]]
		if(antag)
			usr.client.debug_variables(antag)
			/* Bastion of Endeavor Translation
			message_admins("Admin [key_name_admin(usr)] is debugging the [antag.role_text] template.")
			*/
			message_admins("[key_name_admin(usr)] производит отладку шаблона роли [antag.role_text].")
			// End of Bastion of Endeavor Translation
	else if(href_list["remove_antag_type"])
		if(antag_tags && (href_list["remove_antag_type"] in antag_tags))
			/* Bastion of Endeavor Translation
			to_chat(usr, "Cannot remove core mode antag type.")
			*/
			to_chat(usr, "Невозможно удалить основных антагонистов режима.")
			// End of Bastion of Endeavor Translation
			return
		var/datum/antagonist/antag = all_antag_types[href_list["remove_antag_type"]]
		if(antag_templates && antag_templates.len && antag && (antag in antag_templates) && (antag.id in additional_antag_types))
			antag_templates -= antag
			additional_antag_types -= antag.id
			/* Bastion of Endeavor Translation: Doesn't look good with the roles in question but don't care
			message_admins("Admin [key_name_admin(usr)] removed [antag.role_text] template from game mode.")
			*/
			message_admins("[key_name_admin(usr)] удалил шаблон '[antag.role_text]' из игрового режима.")
			// End of Bastion of Endeavor Translation
	else if(href_list["add_antag_type"])
		/* Bastion of Endeavor Translation
		var/choice = tgui_input_list(usr, "Which type do you wish to add?", "Select Antag Type", all_antag_types)
		*/
		var/choice = tgui_input_list(usr, "Какой тип вы хотели бы добавить?", "Выбор тип антагониста", all_antag_types)
		// End of Bastion of Endeavor Translation
		if(!choice)
			return
		var/datum/antagonist/antag = all_antag_types[choice]
		if(antag)
			if(!islist(ticker.mode.antag_templates))
				ticker.mode.antag_templates = list()
			ticker.mode.antag_templates |= antag
			/* Bastion of Endeavor Translation
			message_admins("Admin [key_name_admin(usr)] added [antag.role_text] template to game mode.")
			*/
			message_admins("[key_name_admin(usr)] добавил шаблон '[antag.role_text]' в игровой режим.")
			// End of Bastion of Endeavor Translation

	// I am very sure there's a better way to do this, but I'm not sure what it might be. ~Z
	spawn(1)
		for(var/datum/admins/admin in world)
			if(usr.client == admin.owner)
				admin.show_game_mode(usr)
				return

/datum/game_mode/proc/announce() //to be called when round starts
	/* Bastion of Endeavor Translation
	to_world(span_bold("The current game mode is [capitalize(name)]!"))
	*/
	to_world(span_bold("Текущий режим игры – [capitalize(name)]!"))
	// End of Bastion of Endeavor Translation
	if(round_description)
		to_world("[round_description]")
	if(round_autoantag)
		/* Bastion of Endeavor Translation
		to_world("Antagonists will be added to the round automagically as needed.")
		*/
		to_world("Антагонисты будут добавлены автомагически при необходимости.")
		// End of Bastion of Endeavor Translation
	if(antag_templates && antag_templates.len)
		/* Bastion of Endeavor Translation
		var/antag_summary = span_bold("Possible antagonist types:") + " "
		*/
		var/antag_summary = span_bold("Возможные антагонисты:") + " "
		// End of Bastion of Endeavor Translation
		var/i = 1
		for(var/datum/antagonist/antag in antag_templates)
			if(i > 1)
				if(i == antag_templates.len)
					/* Bastion of Endeavor Translation
					antag_summary += " and "
					*/
					antag_summary += " и "
					// End of Bastion of Endeavor Translation
				else
					antag_summary += ", "
			antag_summary += "[antag.role_text_plural]"
			i++
		antag_summary += "."
		if(antag_templates.len > 1 && master_mode != "secret")
			to_world("[antag_summary]")
		else
			message_admins("[antag_summary]")

///can_start()
///Checks to see if the game can be setup and ran with the current number of players or whatnot.
/datum/game_mode/proc/can_start(var/do_not_spawn)
	var/playerC = 0
	for(var/mob/new_player/player in player_list)
		if((player.client)&&(player.ready))
			playerC++

	if(master_mode=="secret")
		if(playerC < CONFIG_GET(keyed_list/player_requirements_secret)[config_tag]) // CHOMPEdit
			return 0
	else
		if(playerC < CONFIG_GET(keyed_list/player_requirements)[config_tag]) // CHOMPEdit
			return 0

	if(!(antag_templates && antag_templates.len))
		return 1

	var/enemy_count = 0
	if(antag_tags && antag_tags.len)
		for(var/antag_tag in antag_tags)
			var/datum/antagonist/antag = all_antag_types[antag_tag]
			if(!antag)
				continue
			var/list/potential = list()
			if(antag.flags & ANTAG_OVERRIDE_JOB)
				potential = antag.pending_antagonists
			else
				potential = antag.candidates
			if(islist(potential))
				if(require_all_templates && potential.len < antag.initial_spawn_req)
					return 0
				enemy_count += potential.len
				if(enemy_count >= required_enemies)
					return 1
	return 0

/datum/game_mode/proc/refresh_event_modifiers()
	if(event_delay_mod_moderate || event_delay_mod_major)
		SSevents.report_at_round_end = TRUE
		if(event_delay_mod_moderate)
			var/datum/event_container/EModerate = SSevents.event_containers[EVENT_LEVEL_MODERATE]
			EModerate.delay_modifier = event_delay_mod_moderate
		if(event_delay_mod_moderate)
			var/datum/event_container/EMajor = SSevents.event_containers[EVENT_LEVEL_MAJOR]
			EMajor.delay_modifier = event_delay_mod_major

/datum/game_mode/proc/pre_setup()
	for(var/datum/antagonist/antag in antag_templates)
		antag.build_candidate_list() //compile a list of all eligible candidates

		//antag roles that replace jobs need to be assigned before the job controller hands out jobs.
		if(antag.flags & ANTAG_OVERRIDE_JOB)
			antag.attempt_spawn() //select antags to be spawned

///post_setup()
/datum/game_mode/proc/post_setup()

	refresh_event_modifiers()

	spawn (ROUNDSTART_LOGOUT_REPORT_TIME)
		display_roundstart_logout_report()

	spawn (rand(waittime_l, waittime_h))
		spawn(rand(100,150))
			announce_ert_disabled()

	//Assign all antag types for this game mode. Any players spawned as antags earlier should have been removed from the pending list, so no need to worry about those.
	for(var/datum/antagonist/antag in antag_templates)
		if(!(antag.flags & ANTAG_OVERRIDE_JOB))
			antag.attempt_spawn() //select antags to be spawned
		antag.finalize_spawn() //actually spawn antags
		if(antag.is_latejoin_template())
			latejoin_templates |= antag

	if(emergency_shuttle && auto_recall_shuttle)
		emergency_shuttle.auto_recall = 1

	feedback_set_details("round_start","[time2text(world.realtime)]")
	INVOKE_ASYNC(SSdbcore, TYPE_PROC_REF(/datum/controller/subsystem/dbcore,SetRoundStart)) // CHOMPEdit
	if(ticker && ticker.mode)
		feedback_set_details("game_mode","[ticker.mode]")
	feedback_set_details("server_ip","[world.internet_address]:[world.port]")
	return 1

/datum/game_mode/proc/fail_setup()
	for(var/datum/antagonist/antag in antag_templates)
		antag.reset()

/datum/game_mode/proc/announce_ert_disabled()
	if(!ert_disabled)
		return

	/* Bastion of Endeavor Translation: ugh
	var/list/reasons = list(
		"political instability",
		"quantum fluctuations",
		"hostile raiders",
		"derelict station debris",
		"REDACTED",
		"ancient alien artillery",
		"solar magnetic storms",
		"sentient time-travelling killbots",
		"gravitational anomalies",
		"wormholes to another dimension",
		"a telescience mishap",
		"radiation flares",
		"supermatter dust",
		"leaks into a negative reality",
		"antiparticle clouds",
		"residual bluespace energy",
		"suspected criminal operatives",
		"malfunctioning von Neumann probe swarms",
		"shadowy interlopers",
		"a stranded alien arkship",
		"haywire IPC constructs",
		"rogue Unathi exiles",
		"artifacts of eldritch horror",
		"a brain slug infestation",
		"killer bugs that lay eggs in the husks of the living",
		"a deserted transport carrying alien specimens",
		"an emissary for the gestalt requesting a security detail",
		"a Tajaran slave rebellion",
		"radical Skrellian transevolutionaries",
		"classified security operations"
		)
	command_announcement.Announce("The presence of [pick(reasons)] in the region is tying up all available local emergency resources; emergency response teams cannot be called at this time, and post-evacuation recovery efforts will be substantially delayed.","Emergency Transmission")
	*/
	var/list/reasons = list(
		"с политической нестабильностью",
		"с квантовыми флюктуациями",
		"с враждебными налетчиками",
		"с руинами устаревшей станции на орбите",
		"с (УДАЛЕНО)",
		"с древней инопланетной артиллерией",
		"с солнечными магнитными бурями",
		"с путешествующими во времени роботами-киллерами",
		"с гравитационными аномалиями",
		"с червоточинами, ведущими в другое измерение",
		"с телекоммуникационным инцидентом",
		"с радиационными вспышками",
		"с суперматериальной пылью",
		"с утечками в анти-реальность",
		"с облаками из анти-частиц",
		"с остаточной синепространственной энергией",
		"с преступной группировкой оперативников",
		"с роем заглючивших зондов фон Нейманна",
		"с тайными преступниками",
		"со сбившимся с курсом инопланетным ковчегом",
		"с восстанием роботов",
		"с разбойными отшельными унати",
		"с артефактами неописуемого ужаса",
		"с нашествием мозговых пиявок",
		"с жуками-убийцами, откладывающими яйца в трупах",
		"со сбившимся с курса судном, везущем инопланетян",
		"с восстанием таджарских рабов",
		"с радикальными скрелльскими трансреволюционерами",
		)
	command_announcement.Announce("Отряд быстрого реагирования на данный момент не может ответить на ваш вызов, так как все ресурсы отряда на данный момент уходят на борьбу [pick(reasons)] in the region is tying up all available local emergency resources; emergency response teams cannot be called at this time, and post-evacuation recovery efforts will be substantially delayed.","Emergency Transmission")
	// End of Bastion of Endeavor Translation

/datum/game_mode/proc/check_finished()
	if(emergency_shuttle.returned() || station_was_nuked)
		return 1
	if(end_on_antag_death && antag_templates && antag_templates.len)
		for(var/datum/antagonist/antag in antag_templates)
			if(!antag.antags_are_dead())
				return 0
		if(CONFIG_GET(flag/continuous_rounds)) // CHOMPEdit
			emergency_shuttle.auto_recall = 0
			return 0
		return 1
	return 0

/datum/game_mode/proc/cleanup()	//This is called when the round has ended but not the game, if any cleanup would be necessary in that case.
	return

/datum/game_mode/proc/declare_completion()

	var/is_antag_mode = (antag_templates && antag_templates.len)
	check_victory()
	if(is_antag_mode)
		sleep(10)
		for(var/datum/antagonist/antag in antag_templates)
			sleep(10)
			antag.check_victory()
			antag.print_player_summary()
		sleep(10)

	var/clients = 0
	var/surviving_humans = 0
	var/surviving_total = 0
	var/ghosts = 0
	var/escaped_humans = 0
	var/escaped_total = 0
	var/escaped_on_pod_1 = 0
	var/escaped_on_pod_2 = 0
	var/escaped_on_pod_3 = 0
	var/escaped_on_pod_4 = 0 //CHOMP Add
	var/escaped_on_pod_5 = 0
	var/escaped_on_pod_6 = 0 //CHOMP Add
	var/escaped_on_shuttle = 0
	var/escaped_on_pod_large_1 = 0 //CHOMP Add
	var/escaped_on_pod_large_2 = 0 //CHOMP Add
	var/escaped_on_cryopod = 0 //CHOMP Add

	var/list/area/escape_locations = list(/area/shuttle/escape/centcom, /area/shuttle/cryo/centcom, /area/shuttle/escape_pod1/centcom, /area/shuttle/escape_pod2/centcom, /area/shuttle/escape_pod3/centcom, /area/shuttle/escape_pod5/centcom, /area/shuttle/escape_pod6/centcom, /area/shuttle/large_escape_pod1/centcom
, /area/shuttle/large_escape_pod2/centcom) //CHOMP Edit: Appended /centcom to the escape shuttle again to fix transfer message. Added some escape pods to the list.

	for(var/mob/M in player_list)
		if(M.client)
			clients++
			var/M_area_type = (get_turf(M))?.loc?.type
			if(ishuman(M))
				if(M.stat != DEAD)
					surviving_humans++
					if(M_area_type in escape_locations)
						escaped_humans++
			if(M.stat != DEAD)
				surviving_total++
				if(M_area_type in escape_locations)
					escaped_total++

				if(M_area_type == /area/shuttle/escape/centcom)
					escaped_on_shuttle++

				if(M_area_type == /area/shuttle/escape_pod1/centcom)
					escaped_on_pod_1++
				if(M_area_type == /area/shuttle/escape_pod2/centcom)
					escaped_on_pod_2++
				if(M_area_type == /area/shuttle/escape_pod3/centcom)
					escaped_on_pod_3++
				if(M_area_type == /area/shuttle/escape_pod4/centcom) //CHOMP Add
					escaped_on_pod_4++
				if(M_area_type == /area/shuttle/escape_pod5/centcom)
					escaped_on_pod_5++
				if(M_area_type == /area/shuttle/escape_pod6/centcom) //CHOMP Add
					escaped_on_pod_6++
				if(M_area_type == /area/shuttle/large_escape_pod1/centcom) //CHOMP Add
					escaped_on_pod_large_1++
				if(M_area_type == /area/shuttle/large_escape_pod2/centcom) //CHOMP Add
					escaped_on_pod_large_2++
				if(M_area_type == /area/shuttle/cryo/centcom) //CHOMP Add
					escaped_on_cryopod++



			if(isobserver(M))
				ghosts++

	var/text = ""
	if(surviving_total > 0)
		/* Bastion of Endeavor Translation: rewriting a part of this for simplicity sake
		text += "<br>There [surviving_total>1 ? ("were " + span_bold("[surviving_total] survivors")) : ("was " + span_bold("one survivor"))] ("
		text += span_bold("[escaped_total>0 ? escaped_total : "none"] [emergency_shuttle.evac ? "escaped" : "transferred"]</b>) and <b>[ghosts] ghosts")
		text += ".<br>"
		*/
		text += "<br>[count_ru(surviving_total, "Остал;ся;ось;ось", TRUE)] <b>[count_ru(surviving_total, "выживш;ий;их;их")]</b>"
		if(escaped_total == 0)
			text += " (<b>никто не [emergency_shuttle.evac ? "сбежал" : "отправился на трансфер"]</b>)"
		else text+= " (<b>[emergency_shuttle.evac ? count_ru(escaped_total, "сбежал;;и;и") : "[count_ru(escaped_total, "попал;;и;и")] на трансфер"])</b>"
		text += " и <b>[count_ru(ghosts, "призрак;;а;ов")]</b>.<br>"
		// End of Bastion of Endeavor Translation
	else
		/* Bastion of Endeavor Translation
		text += "There were <b>no survivors</b> (<b>[ghosts] ghosts</b>)."
		*/
		text += "Выживших <b>нет</b> (<b>[count_ru(ghosts, "призрак;;а;ов")]</b>)."
		// End of Bastion of Endeavor Translation
	to_world(text)

	if(clients > 0)
		feedback_set("round_end_clients",clients)
	if(ghosts > 0)
		feedback_set("round_end_ghosts",ghosts)
	if(surviving_humans > 0)
		feedback_set("survived_human",surviving_humans)
	if(surviving_total > 0)
		feedback_set("survived_total",surviving_total)
	if(escaped_humans > 0)
		feedback_set("escaped_human",escaped_humans)
	if(escaped_total > 0)
		feedback_set("escaped_total",escaped_total)
	if(escaped_on_shuttle > 0)
		feedback_set("escaped_on_shuttle",escaped_on_shuttle)
	if(escaped_on_pod_1 > 0)
		feedback_set("escaped_on_pod_1",escaped_on_pod_1)
	if(escaped_on_pod_2 > 0)
		feedback_set("escaped_on_pod_2",escaped_on_pod_2)
	if(escaped_on_pod_3 > 0)
		feedback_set("escaped_on_pod_3",escaped_on_pod_3)
	if(escaped_on_pod_4 > 0) //CHOMP Add
		feedback_set("escaped_on_pod_4",escaped_on_pod_4)
	if(escaped_on_pod_5 > 0)
		feedback_set("escaped_on_pod_5",escaped_on_pod_5)
	if(escaped_on_pod_6 > 0) //CHOMP Add
		feedback_set("escaped_on_pod_6",escaped_on_pod_6)
	if(escaped_on_pod_large_1 > 0) //CHOMP Add
		feedback_set("escaped_on_pod_large_1",escaped_on_pod_large_1)
	if(escaped_on_pod_large_2 > 0) //CHOMP Add
		feedback_set("escaped_on_pod_large_2",escaped_on_pod_large_2)
	if(escaped_on_cryopod > 0) //CHOMP Add
		feedback_set("escaped_on_cryopod",escaped_on_cryopod)

	/* Bastion of Endeavor Translation
	send2mainirc("A round of [src.name] has ended - [surviving_total] survivors, [ghosts] ghosts.")
	*/
	send2mainirc("Закончился раунд в режиме '[src.name]' – [count_ru(surviving_total, "выживш;ий;их;их")], [count_ru(ghosts, "призрак;;а;ов")].")
	// End of Bastion of Endeavor Translation
	SSwebhooks.send(
		WEBHOOK_ROUNDEND,
		list(
			"survivors" = surviving_total,
			"escaped" = escaped_total,
			"ghosts" = ghosts,
			"clients" = clients
		)
	)

	return 0

/datum/game_mode/proc/check_win() //universal trigger to be called at mob death, nuke explosion, etc. To be called from everywhere.
	return 0

/datum/game_mode/proc/get_players_for_role(var/role, var/antag_id, var/ghosts_only)
	var/list/players = list()
	var/list/candidates = list()

	var/datum/antagonist/antag_template = all_antag_types[antag_id]
	if(!antag_template)
		return candidates

	// If this is being called post-roundstart then it doesn't care about ready status.
	if(ticker && ticker.current_state == GAME_STATE_PLAYING)
		for(var/mob/player in player_list)
			if(!player.client)
				continue
			if(istype(player, /mob/new_player))
				continue
			if(istype(player, /mob/observer/dead) && !ghosts_only)
				continue
			if(!role || (player.client.prefs.be_special & role))
				/* Bastion of Endeavor Translation
				log_debug("[player.key] had [antag_id] enabled, so we are drafting them.")
				*/
				log_debug("У игрока [player.key] включена кандидатура на роль [antag_id], выбираем его.")
				// End of Bastion of Endeavor Translation
				candidates |= player.mind
	else
		// Assemble a list of active players without jobbans.
		for(var/mob/new_player/player in player_list)
			if( player.client && player.ready )
				players += player

		// Get a list of all the people who want to be the antagonist for this round
		for(var/mob/new_player/player in players)
			if(!role || (player.client.prefs.be_special & role))
				/* Bastion of Endeavor Translation
				log_debug("[player.key] had [antag_id] enabled, so we are drafting them.")
				*/
				log_debug("У игрока [player.key] включена кандидатура на роль [antag_id], выбираем его.")
				// End of Bastion of Endeavor Translation
				candidates += player.mind
				players -= player

		// Below is commented out as an attempt to solve an issue of too little people wanting to join the round due to wanting to have cake and eat it too.
		/*
		// If we don't have enough antags, draft people who voted for the round.
		if(candidates.len < required_enemies)
			for(var/mob/new_player/player in players)
				if(player.ckey in round_voters)
					log_debug("[player.key] voted for this round, so we are drafting them.")
					candidates += player.mind
					players -= player
					break
		*/

	return candidates		// Returns: The number of people who had the antagonist role set to yes, regardless of recomended_enemies, if that number is greater than required_enemies
							//			required_enemies if the number of people with that role set to yes is less than recomended_enemies,
							//			Less if there are not enough valid players in the game entirely to make required_enemies.

/datum/game_mode/proc/num_players()
	. = 0
	for(var/mob/new_player/P in player_list)
		if(P.client && P.ready)
			. ++

/datum/game_mode/proc/check_antagonists_topic(href, href_list[])
	return 0

/datum/game_mode/proc/create_antagonists()

	if(!CONFIG_GET(flag/traitor_scaling)) // CHOMPEdit
		antag_scaling_coeff = 0

	if(antag_tags && antag_tags.len)
		antag_templates = list()
		for(var/antag_tag in antag_tags)
			var/datum/antagonist/antag = all_antag_types[antag_tag]
			if(antag)
				antag_templates |= antag

	if(additional_antag_types && additional_antag_types.len)
		if(!antag_templates)
			antag_templates = list()
		for(var/antag_type in additional_antag_types)
			var/datum/antagonist/antag = all_antag_types[antag_type]
			if(antag)
				antag_templates |= antag

	newscaster_announcements = pick(newscaster_standard_feeds)

/datum/game_mode/proc/check_victory()
	return

//////////////////////////
//Reports player logouts//
//////////////////////////
/proc/display_roundstart_logout_report()
	/* Bastion of Endeavor Translation
	var/msg = span_bold("Roundstart logout report")
	*/
	var/msg = span_bold("Отчёт об отключениях на старте раунда:")
	// End of Bastion of Endeavor Translation
	msg += "<br><br>"
	for(var/mob/living/L in mob_list)

		if(L.ckey)
			var/found = 0
			for(var/client/C in GLOB.clients)
				if(C.ckey == L.ckey)
					found = 1
					break
			if(!found)
				/* Bastion of Endeavor Translation
				msg += "[span_bold(L.name)] ([L.ckey]), the [L.job] ([span_yellow(span_bold("Disconnected"))])<br>"
				*/
				msg += "[span_bold(L.name)] ([L.ckey]), [L.job] ([span_yellow(span_bold("[verb_ru(L, "Отключ;ён;ена;ено;ены;")]"))])<br>"
				// End of Bastion of Endeavor Translation

		if(L.ckey && L.client)
			if(L.client.inactivity >= (ROUNDSTART_LOGOUT_REPORT_TIME / 2))	//Connected, but inactive (alt+tabbed or something)
				/* Bastion of Endeavor Translation
				msg += "[span_bold(L.name)] ([L.ckey]), the [L.job] ([span_yellow(span_bold("Connected, Inactive"))])<br>"
				*/
				msg += "[span_bold(L.name)] ([L.ckey]), [L.job] ([span_yellow(span_bold("[verb_ru(L, "Подключ;ён;ена;ено;ены;")], [verb_ru(L, "неактив;ен;на;но;ны;")]"))])<br>"
				// End of Bastion of Endeavor Translation
				continue //AFK client
			if(L.stat)
				if(L.suiciding)	//Suicider
					/* Bastion of Endeavor Translation
					msg += "[span_bold(L.name)] ([L.ckey]), the [L.job] ([span_red(span_bold("Suicide"))])<br>"
					*/
					msg += "[span_bold(L.name)] ([L.ckey]), [L.job] ([span_red(span_bold("[verb_ru(L, "Самоубил;ся;ась;ось;ись;")]"))])<br>"
					// End of Bastion of Endeavor Translation
					continue //Disconnected client
				if(L.stat == UNCONSCIOUS)
					/* Bastion of Endeavor Translation
					msg += "[span_bold(L.name)] ([L.ckey]), the [L.job] (Dying)<br>"
					*/
					msg += "[span_bold(L.name)] ([L.ckey]), [L.job] ([verb_ru(L, "Умира;ет;ет;ет;ют;")])<br>"
					// End of Bastion of Endeavor Translation
					continue //Unconscious
				if(L.stat == DEAD)
					/* Bastion of Endeavor Translation
					msg += "[span_bold(L.name)] ([L.ckey]), the [L.job] (Dead)<br>"
					*/
					msg += "[span_bold(L.name)] ([L.ckey]), [L.job] ([verb_ru(L, ";Мёртв;Мертва;Мертво;Мертвы;")])<br>"
					// End of Bastion of Endeavor Translation
					continue //Dead

			continue //Happy connected client
		for(var/mob/observer/dead/D in mob_list)
			if(D.mind && (D.mind.original == L || D.mind.current == L))
				if(L.stat == DEAD)
					if(L.suiciding)	//Suicider
						/* Bastion of Endeavor Translation
						msg += "[span_bold(L.name)] ([ckey(D.mind.key)]), the [L.job] ([span_red(span_bold("Suicide"))])<br>"
						*/
						msg += "[span_bold(L.name)] ([ckey(D.mind.key)]), [L.job] ([span_red(span_bold("[verb_ru(L, "Самоубил;ся;ась;ось;ись;")]"))])<br>"
						// End of Bastion of Endeavor Translation
						continue //Disconnected client
					else
						/* Bastion of Endeavor Translation
						msg += "[span_bold(L.name)] ([ckey(D.mind.key)]), the [L.job] (Dead)<br>"
						*/
						msg += "[span_bold(L.name)] ([ckey(D.mind.key)]), [L.job] ([verb_ru(L, ";Мёртв;Мертва;Мертво;Мертвы;")])<br>"
						// End of Bastion of Endeavor Translation
						continue //Dead mob, ghost abandoned
				else
					if(D.can_reenter_corpse)
						/* Bastion of Endeavor Translation
						msg += "[span_bold(L.name)] ([ckey(D.mind.key)]), the [L.job] ([span_red(span_bold("Adminghosted"))])<br>"
						*/
						msg += "[span_bold(L.name)] ([ckey(D.mind.key)]), [L.job] ([span_red(span_bold("В режиме админ-призрака"))])<br>"
						// End of Bastion of Endeavor Translation
						continue //Lolwhat
					else
						/* Bastion of Endeavor Translation
						msg += "[span_bold(L.name)] ([ckey(D.mind.key)]), the [L.job] ([span_red(span_bold("Ghosted"))])<br>"
						*/
						msg += "[span_bold(L.name)] ([ckey(D.mind.key)]), [L.job] ([span_red(span_bold("В режиме призрака"))])<br>"
						// End of Bastion of Endeavor Translation
						continue //Ghosted while alive

			continue // CHOMPEdit: Escape infinite loop in case there's nobody connected. Shouldn't happen ever, but.

	msg = span_notice(msg)// close the span from right at the top

	for(var/mob/M in mob_list)
		if(M.client && M.client.holder)
			to_chat(M,msg)

/proc/get_nt_opposed()
	var/list/dudes = list()
	for(var/mob/living/carbon/human/man in player_list)
		if(man.client)
			if(man.client.prefs.economic_status == CLASS_LOWER)
				dudes += man
			else if(man.client.prefs.economic_status == CLASS_LOWMID && prob(50))
				dudes += man
	if(dudes.len == 0) return null
	return pick(dudes)

/proc/show_objectives(var/datum/mind/player)

	if(!player || !player.current) return

	var/obj_count = 1
	/* Bastion of Endeavor Translation
	to_chat(player.current, span_notice("Your current objectives:"))
	*/
	to_chat(player.current, span_notice("Ваши текущие цели:"))
	// End of Bastion of Endeavor Translation
	for(var/datum/objective/objective in player.objectives)
		/* Bastion of Endeavor Translation
		to_chat(player.current, span_bold("Objective #[obj_count]") + ": [objective.explanation_text]")
		*/
		to_chat(player.current, span_bold("Цель #[obj_count]") + ": [objective.explanation_text]")
		// End of Bastion of Endeavor Translation
		obj_count++

/mob/verb/check_round_info()
	/* Bastion of Endeavor Translation
	set name = "Check Round Info"
	set category = "OOC.Game" //CHOMPEdit
	*/
	set name = "Информация о раунде"
	set category = "OOC.Игра"
	// End of Bastion of Endeavor Translation

	if(!ticker || !ticker.mode)
		/* Bastion of Endeavor Translation
		to_chat(usr, span_warning("Something is terribly wrong; there is no gametype."))
		*/
		to_chat(usr, span_warning("Что-то пошло совершенно наперекосяк; отсутствует тип игры."))
		// End of Bastion of Endeavor Translation
		return

	if(master_mode != "secret")
		/* Bastion of Endeavor Translation
		to_chat(usr, span_notice(span_bold("The roundtype is [capitalize(ticker.mode.name)]")))
		*/
		to_chat(usr, span_notice(span_bold("Игровой режим – [capitalize(ticker.mode.name)]")))
		// End of Bastion of Endeavor Translation
		if(ticker.mode.round_description)
			to_chat(usr, span_notice(span_italics("[ticker.mode.round_description]")))
		if(ticker.mode.extended_round_description)
			to_chat(usr, span_notice("[ticker.mode.extended_round_description]"))
	else
		/* Bastion of Endeavor Translation
		to_chat(usr, span_notice(span_italics("Shhhh") + ". It's a secret."))
		*/
		to_chat(usr, span_notice(span_italics("Тссс") + ". Это секрет."))
		// End of Bastion of Endeavor Translation
	return
