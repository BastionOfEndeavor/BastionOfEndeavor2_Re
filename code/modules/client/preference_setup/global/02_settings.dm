/datum/category_item/player_setup_item/player_global/settings
	name = "Settings"
	sort_order = 2

/datum/category_item/player_setup_item/player_global/settings/load_preferences(datum/json_savefile/savefile)
	pref.lastchangelog			= savefile.get_entry("lastchangelog")
	pref.lastnews				= savefile.get_entry("lastnews")
	pref.lastlorenews			= savefile.get_entry("lastlorenews")
	pref.default_slot			= savefile.get_entry("default_slot")

/datum/category_item/player_setup_item/player_global/settings/save_preferences(datum/json_savefile/savefile)
	savefile.set_entry("lastchangelog",			pref.lastchangelog)
	savefile.set_entry("lastnews",				pref.lastnews)
	savefile.set_entry("lastlorenews",			pref.lastlorenews)
	savefile.set_entry("default_slot",			pref.default_slot)

/datum/category_item/player_setup_item/player_global/settings/sanitize_preferences()
	pref.lastchangelog	= sanitize_text(pref.lastchangelog, initial(pref.lastchangelog))
	pref.lastnews		= sanitize_text(pref.lastnews, initial(pref.lastnews))
	pref.default_slot	= sanitize_integer(pref.default_slot, 1, CONFIG_GET(number/character_slots), initial(pref.default_slot)) // CHOMPEdit
<<<<<<< HEAD

/datum/category_item/player_setup_item/player_global/settings/content(var/mob/user)
	. = list()
	/* Bastion of Endeavor Translation
	. += "<b>Preferences</b><br>"
	*/
	. += "<b>Предпочтения</b><br>"
	// End of Bastion of Endeavor Translation
	. += "<table>"
	var/mob/pref_mob = preference_mob()
	for(var/datum/client_preference/client_pref as anything in get_client_preferences())
		if(!client_pref.may_toggle(pref_mob))
			continue

		/* Bastion of Endeavor Translation
		. += "<tr><td>[client_pref.description]: </td>"
		*/
		. += "<tr><td style=\"white-space: nowrap\">[client_pref.description]: </td>"
		// End of Bastion of Endeavor Translation
		if(pref_mob.is_preference_enabled(client_pref.key))
			. += "<td><span class='linkOn'><b>[client_pref.enabled_description]</b></span></td> <td><a href='?src=\ref[src];toggle_off=[client_pref.key]'>[client_pref.disabled_description]</a></td>"
		else
			. += "<td><a  href='?src=\ref[src];toggle_on=[client_pref.key]'>[client_pref.enabled_description]</a></td> <td><span class='linkOn'><b>[client_pref.disabled_description]</b></span></td>"
		. += "</tr>"

	. += "</table>"
	return jointext(., "")

/datum/category_item/player_setup_item/player_global/settings/OnTopic(var/href,var/list/href_list, var/mob/user)
	var/mob/pref_mob = preference_mob()
	if(href_list["toggle_on"])
		. = pref_mob.set_preference(href_list["toggle_on"], TRUE)
	else if(href_list["toggle_off"])
		. = pref_mob.set_preference(href_list["toggle_off"], FALSE)
	if(.)
		return TOPIC_REFRESH

	return ..()

/**
 * This can take either a single preference datum or a list of preferences, and will return true if *all* preferences in the arguments are enabled.
 */
/client/proc/is_preference_enabled(var/preference)
	if(!islist(preference))
		preference = list(preference)
	for(var/p in preference)
		var/datum/client_preference/cp = get_client_preference(p)
		if(!prefs || !cp || !istype(cp, /datum/client_preference) || !(cp.key in prefs.preferences_enabled))
			return FALSE
	return TRUE

/client/proc/set_preference(var/preference, var/set_preference)
	var/datum/client_preference/cp = get_client_preference(preference)
	if(!cp)
		return FALSE
	preference = cp.key

	if(set_preference && !(preference in prefs.preferences_enabled))
		return toggle_preference(cp)
	else if(!set_preference && (preference in prefs.preferences_enabled))
		return toggle_preference(cp)

/client/proc/toggle_preference(var/preference, var/set_preference)
	var/datum/client_preference/cp = get_client_preference(preference)
	if(!cp)
		return FALSE
	preference = cp.key

	var/enabled
	if(preference in prefs.preferences_disabled)
		prefs.preferences_enabled  |= preference
		prefs.preferences_disabled -= preference
		enabled = TRUE
		. = TRUE
	else if(preference in prefs.preferences_enabled)
		prefs.preferences_enabled  -= preference
		prefs.preferences_disabled |= preference
		enabled = FALSE
		. = TRUE
	if(.)
		cp.toggled(mob, enabled)

/mob/proc/is_preference_enabled(var/preference)
	if(!client)
		return FALSE
	return client.is_preference_enabled(preference)

/mob/proc/set_preference(var/preference, var/set_preference)
	if(!client)
		return FALSE
	if(!client.prefs)
		/* Bastion of Endeavor Translation
		log_debug("Client prefs found to be null for mob [src] and client [ckey], this should be investigated.")
		*/
		log_debug("Предпочтения клиента для существа [src] и клиента [ckey] равны null.")
		// End of Bastion of Endeavor Translation
		return FALSE

	return client.set_preference(preference, set_preference)
=======
>>>>>>> 2986497a43 ([MIRROR] Revert "Revert "/tg/ preference datums part 1: take two"" (#8929))
