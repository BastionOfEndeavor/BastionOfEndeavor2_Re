//
// Lets read our settings from the configuration file on startup too!
//

/datum/configuration
	var/static/time_off = FALSE
	var/static/pto_job_change = FALSE
	var/static/limit_interns = -1 //Unlimited by default
	var/static/limit_visitors = -1 //Unlimited by default
	var/static/pto_cap = 100 //Hours
	var/static/require_flavor = FALSE
	var/static/ipqualityscore_apikey //API key for ipqualityscore.com
	var/static/use_playtime_restriction_for_jobs = FALSE

/hook/startup/proc/read_vs_config()
	var/list/Lines = file2list("config/config.txt")
	for(var/t in Lines)
		if(!t)	continue

		t = trim(t)
		/* Bastion of Endeavor Unicode Edit
		if (length(t) == 0)
		*/
		if (length_char(t) == 0)
		// End of Bastion of Endeavor Unicode Edit
			continue
		/* Bastion of Endeavor Unicode Edit
		else if (copytext(t, 1, 2) == "#")
		*/
		else if (copytext_char(t, 1, 2) == "#")
		// End of Bastion of Endeavor Unicode Edit
			continue

		/* Bastion of Endeavor Unicode Edit
		var/pos = findtext(t, " ")
		*/
		var/pos = findtext_char(t, " ")
		// End of Bastion of Endeavor Unicode Edit
		var/name = null
		var/value = null

		if (pos)
			/* Bastion of Endeavor Unicode Edit
			name = lowertext(copytext(t, 1, pos))
			value = copytext(t, pos + 1)
			*/
			name = lowertext(copytext_char(t, 1, pos))
			value = copytext_char(t, pos + 1)
			// End of Bastion of Endeavor Unicode Edit
		else
			name = lowertext(t)

		if (!name)
			continue

		switch (name)
			if ("chat_webhook_url")
				config.chat_webhook_url = value
			if ("chat_webhook_key")
				config.chat_webhook_key = value
			if ("fax_export_dir")
				config.fax_export_dir = value
			if ("items_survive_digestion")
				config.items_survive_digestion = 1
			if ("limit_interns")
				config.limit_interns = text2num(value)
			if ("limit_visitors")
				config.limit_visitors = text2num(value)
			if ("pto_cap")
				config.pto_cap = text2num(value)
			if ("time_off")
				config.time_off = TRUE
			if ("pto_job_change")
				config.pto_job_change = TRUE
			if ("require_flavor")
				config.require_flavor = TRUE
			if ("ipqualityscore_apikey")
				config.ipqualityscore_apikey = value
			if ("use_playtime_restriction_for_jobs")
				config.use_playtime_restriction_for_jobs = TRUE
	return 1
