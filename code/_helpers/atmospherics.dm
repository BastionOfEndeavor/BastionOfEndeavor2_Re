/obj/proc/analyze_gases(var/atom/A, var/mob/user)
	if(src != A)
<<<<<<< HEAD
		/* Bastion of Endeavor Translation
		user.visible_message("<span class='notice'>\The [user] has used \an [src] on \the [A]</span>")
		*/
		user.visible_message("<span class='notice'>[interact_ru(user, "проверил", A, ACASE)] [icase_ru(src, user)].</span>")
		// End of Bastion of Endeavor Translation
=======
		user.visible_message(span_notice("\The [user] has used \an [src] on \the [A]"))
>>>>>>> ab154b48b2 ([MIRROR] refactors most spans (#9139))

	A.add_fingerprint(user)
	var/list/result = A.atmosanalyze(user)
	if(result && result.len)
<<<<<<< HEAD
		/* Bastion of Endeavor Translation
		to_chat(user, "<span class='notice'>Results of the analysis[src == A ? "" : " of \the [A]"]</span>")
		*/
		to_chat(user, "<span class='notice'>Результаты анализа[src == A ? "" : " [gcase_ru(A)]"]:</span>")
		// End of Bastion of Endeavor Translation
=======
		to_chat(user, span_notice("Results of the analysis[src == A ? "" : " of \the [A]"]"))
>>>>>>> ab154b48b2 ([MIRROR] refactors most spans (#9139))
		for(var/line in result)
			to_chat(user, span_notice("[line]"))
		return 1

<<<<<<< HEAD
	/* Bastion of Endeavor Translation
	to_chat(user, "<span class='warning'>Your [src] flashes a red light as it fails to analyze \the [A].</span>")
	*/
	to_chat(user, "<span class='warning'>[cap_ru(src, DCASE)] не удалось провести анализ содержимого [gcase_ru(A)].</span>")
	// End of Bastion of Endeavor Translation
=======
	to_chat(user, span_warning("Your [src] flashes a red light as it fails to analyze \the [A]."))
>>>>>>> ab154b48b2 ([MIRROR] refactors most spans (#9139))
	return 0

/proc/atmosanalyzer_scan(var/atom/target, var/datum/gas_mixture/mixture, var/mob/user)
	var/list/results = list()

	if (mixture && mixture.total_moles > 0)
		var/pressure = mixture.return_pressure()
		var/total_moles = mixture.total_moles
<<<<<<< HEAD
		/* Bastion of Endeavor Translation
		results += "<span class='notice'>Pressure: [round(pressure,0.1)] kPa</span>"
		*/
		results += "<span class='notice'>Давление: [round(pressure,0.1)] кПа</span>"
		// End of Bastion of Endeavor Translation
		for(var/mix in mixture.gas)
			/* Bastion of Endeavor Translation
			results += "<span class='notice'>[gas_data.name[mix]]: [round((mixture.gas[mix] / total_moles) * 100)]% ([round(mixture.gas[mix], 0.01)] moles)</span>"
			*/
			results += "<span class='notice'>[gas_data.name[mix]]: [round((mixture.gas[mix] / total_moles) * 100)]% ([count_ru(round(mixture.gas[mix], 0.01), "мол;ь;я;ей")])</span>"
			// End of Bastion of Endeavor Translation
		/* Bastion of Endeavor Translation
		results += "<span class='notice'>Temperature: [round(mixture.temperature-T0C)]&deg;C</span>"
		results += "<span class='notice'>Heat Capacity: [round(mixture.heat_capacity(),0.1)]</span>"
		*/
		results += "<span class='notice'>Температура: [round(mixture.temperature-T0C)]&deg;C</span>"
		results += "<span class='notice'>Теплоемкость: [round(mixture.heat_capacity(),0.1)]</span>"
		// End of Bastion of Endeavor Translation
	else
		/* Bastion of Endeavor Translation
		results += "<span class='notice'>\The [target] is empty!</span>"
		*/
		results += "<span class='notice'>[prep_adv_ru("В", target, PCASE)] пусто!</span>"
		// End of Bastion of Endeavor Translation
=======
		results += span_notice("Pressure: [round(pressure,0.1)] kPa")
		for(var/mix in mixture.gas)
			results += span_notice("[gas_data.name[mix]]: [round((mixture.gas[mix] / total_moles) * 100)]% ([round(mixture.gas[mix], 0.01)] moles)")
		results += span_notice("Temperature: [round(mixture.temperature-T0C)]&deg;C")
		results += span_notice("Heat Capacity: [round(mixture.heat_capacity(),0.1)]")
	else
		results += span_notice("\The [target] is empty!")
>>>>>>> ab154b48b2 ([MIRROR] refactors most spans (#9139))

	return results

/turf/atmosanalyze(var/mob/user)
	return atmosanalyzer_scan(src, src.air, user)

/atom/proc/atmosanalyze(var/mob/user)
	return

/obj/item/tank/atmosanalyze(var/mob/user)
	return atmosanalyzer_scan(src, src.air_contents, user)

/obj/machinery/portable_atmospherics/atmosanalyze(var/mob/user)
	return atmosanalyzer_scan(src, src.air_contents, user)

/obj/machinery/atmospherics/pipe/atmosanalyze(var/mob/user)
	return atmosanalyzer_scan(src, src.parent.air, user)

/obj/machinery/atmospherics/portables_connector/atmosanalyze(var/mob/user)
	return atmosanalyzer_scan(src, src.network.gases, user)

/obj/machinery/atmospherics/unary/atmosanalyze(var/mob/user)
	return atmosanalyzer_scan(src, src.air_contents, user)

/obj/machinery/atmospherics/binary/atmosanalyze(var/mob/user)
	return atmosanalyzer_scan(src, src.air1, user)

/obj/machinery/atmospherics/trinary/atmos_filter/atmosanalyze(var/mob/user)
	return atmosanalyzer_scan(src, src.air1, user)

/obj/machinery/atmospherics/trinary/mixer/atmosanalyze(var/mob/user)
	return atmosanalyzer_scan(src, src.air3, user)

/obj/machinery/atmospherics/omni/atmos_filter/atmosanalyze(var/mob/user)
	return atmosanalyzer_scan(src, src.input.air, user)

/obj/machinery/atmospherics/omni/mixer/atmosanalyze(var/mob/user)
	return atmosanalyzer_scan(src, src.output.air, user)

/obj/machinery/meter/atmosanalyze(var/mob/user)
	var/datum/gas_mixture/mixture = null
	if(src.target)
		mixture = src.target.parent.air
	return atmosanalyzer_scan(src, mixture, user)

/obj/machinery/power/rad_collector/atmosanalyze(var/mob/user)
	if(P)	return atmosanalyzer_scan(src, src.P.air_contents, user)

/obj/item/flamethrower/atmosanalyze(var/mob/user)
	if(ptank)	return atmosanalyzer_scan(src, ptank.air_contents, user)
