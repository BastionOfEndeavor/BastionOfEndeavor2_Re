//Uses a couple different services
/client/update_ip_reputation()
	var/scores[] = list("GII" = ipr_getipintel(), "IPQS" = ipr_ipqualityscore())

	/* Bastion of Endeavor Translation
	var/log_output = "IP Reputation [key] from [address]"
	*/
	var/log_output = "Репутация IP [key] по адресу [address]"
	// End of Bastion of Endeavor Translation
	var/worst = 0

	for(var/service in scores)
		var/score = scores[service]
		if(score > worst)
			worst = score
		log_output += " - [service] ([num2text(score)])"

	log_admin(log_output)
	ip_reputation = worst
	return TRUE

//Service returns a single float in html body
/client/proc/ipr_getipintel()
	if(!CONFIG_GET(string/ipr_email)) // CHOMPEdit
		return -1

	var/request = "https://check.getipintel.net/check.php?ip=[address]&contact=[CONFIG_GET(string/ipr_email)]" // CHOMPEdit
	var/http[] = world.Export(request)

	if(!http || !islist(http)) //If we couldn't check, the service might be down, fail-safe.
		/* Bastion of Endeavor Translation
		log_admin("Couldn't connect to getipintel.net to check [address] for [key]")
		*/
		log_admin("Не удалось подключиться к getipintel.net для проверки [key] по адресу [address]")
		// End of Bastion of Endeavor Translation
		return -1

	//429 is rate limit exceeded
	if(text2num(http["STATUS"]) == 429)
		/* Bastion of Endeavor Translation
		log_and_message_admins("getipintel.net reports HTTP status 429. IP reputation checking is now disabled. If you see this, let a developer know.")
<<<<<<< HEAD
		*/
		log_and_message_admins("getipintel.net докладывает HTTP-статус 429. Проверка репутации IP отныне отключена. Сообщите об этом разработчику.")
		// End of Bastion of Endeavor Translation
		config.ip_reputation = FALSE
=======
		CONFIG_SET(flag/ip_reputation, FALSE) // CHOMPEdit
>>>>>>> e1a987c25c (Configuration Controller (#7857))
		return -1

	var/content = file2text(http["CONTENT"]) //world.Export actually returns a file object in CONTENT
	var/score = text2num(content)
	if(isnull(score))
		return -1

	//Error handling
	if(score < 0)
		var/fatal = TRUE
		/* Bastion of Endeavor Translation
		var/ipr_error = "getipintel.net IP reputation check error while checking [address] for [key]: "
		switch(score)
			if(-1)
				ipr_error += "No input provided"
			if(-2)
				fatal = FALSE
				ipr_error += "Invalid IP provided"
			if(-3)
				fatal = FALSE
				ipr_error += "Unroutable/private IP (spoofing?)"
			if(-4)
				fatal = FALSE
				ipr_error += "Unable to reach database"
			if(-5)
				ipr_error += "Our IP is banned or otherwise forbidden"
			if(-6)
				ipr_error += "Missing contact info"
		*/
		var/ipr_error = "Ошибка getipintel.net при проверке репутации IP [key] по адресу [address]: "
		switch(score)
			if(-1)
				ipr_error += "Не предоставлены входные данные"
			if(-2)
				fatal = FALSE
				ipr_error += "Неверный IP-адрес"
			if(-3)
				fatal = FALSE
				ipr_error += "Немаршрутизируемый/частный IP-адрес (спуфинг?)"
			if(-4)
				fatal = FALSE
				ipr_error += "Не удалось подключиться к базе данных"
			if(-5)
				ipr_error += "Наш IP-адрес заблокирован"
			if(-6)
				ipr_error += "Отсутствуют данные для связи"
		// End of Bastion of Endeavor Translation

		log_and_message_admins(ipr_error)
		if(fatal)
<<<<<<< HEAD
			config.ip_reputation = FALSE
			/* Bastion of Endeavor Translation
=======
			CONFIG_SET(flag/ip_reputation, FALSE) // CHOMPEdit
>>>>>>> e1a987c25c (Configuration Controller (#7857))
			log_and_message_admins("With this error, IP reputation checking is disabled for this shift. Let a developer know.")
			*/
			log_and_message_admins("В связи с этой ошибкой проверка репутации IP отключена на остаток смены. Сообщите разработчикам.")
			// End of Bastion of Endeavor Translation
		return -1

	//Went fine
	else
		return score

//Service returns JSON in html body
/client/proc/ipr_ipqualityscore()
	if(!CONFIG_GET(string/ipqualityscore_apikey)) // CHOMPEdit
		return -1

	var/request = "https://www.ipqualityscore.com/api/json/ip/[CONFIG_GET(string/ipqualityscore_apikey)]/[address]?strictness=1&fast=true&byond_key=[key]" // CHOMPEdit
	var/http[] = world.Export(request)

	if(!http || !islist(http)) //If we couldn't check, the service might be down, fail-safe.
		/* Bastion of Endeavor Translation
		log_admin("Couldn't connect to ipqualityscore.com to check [address] for [key]")
		*/
		log_admin("Не удалось подключиться к ipqualityscore.com для проверки [key] по адресу [address]")
		// End of Bastion of Endeavor Translation
		return -1

	var/content = file2text(http["CONTENT"]) //world.Export actually returns a file object in CONTENT
	var/response = json_decode(content)
	if(isnull(response))
		return -1

	//Error handling
	if(!response["success"])
		/* Bastion of Endeavor Translation
		log_admin("IPQualityscore.com returned an error while processing [key] from [address]: " + response["message"])
		*/
		log_admin("ipqualityscore.com выдал ошибку при проверке [key] по адресу [address]: " + response["message"])
		// End of Bastion of Endeavor Translation
		return -1

	var/score = 0
	if(response["proxy"])
		score = 100
	else
		score = response["fraud_score"]

	return score/100 //To normalize with the 0.0 to 1.0 scores.
