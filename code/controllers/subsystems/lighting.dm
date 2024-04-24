SUBSYSTEM_DEF(lighting)
	/* Bastion of Endeavor Translation
	name = "Lighting"
	*/
	name = "Освещение"
	// End of Bastion of Endeavor Translation
	wait = 2
	init_order = INIT_ORDER_LIGHTING
	flags = SS_TICKER
	var/sun_mult = 1.0
	var/static/list/sources_queue = list() // List of lighting sources queued for update.
	var/static/list/corners_queue = list() // List of lighting corners queued for update.
	var/static/list/objects_queue = list() // List of lighting objects queued for update.
	var/static/list/sunlight_queue = list() //CHOMPEdit // List of turfs that are affected by sunlight
	var/static/list/sunlight_queue_active = list() //CHOMPEdit // List of turfs that need to have their sunlight updated
	var/list/planet_shandlers = list() //CHOMPEdit //Precomputed lighting values for tiles only affected by the sun
	var/list/z_to_pshandler = list() //CHOMPEdit

/datum/controller/subsystem/lighting/stat_entry(msg)
	/* Bastion of Endeavor Translation
	msg = "L:[length(sources_queue)]|C:[length(corners_queue)]|O:[length(objects_queue)]"
	*/
	msg = "| Источников: [length(sources_queue)] | Углов: [length(corners_queue)] | Объектов: [length(objects_queue)]"
	// End of Bastion of Endeavor Translation
	return ..()


/datum/controller/subsystem/lighting/Initialize() // CHOMPEdit
	if(!subsystem_initialized)
		if (CONFIG_GET(flag/starlight)) // CHOMPEdit
			for(var/area/A in world)
				if (A.dynamic_lighting == DYNAMIC_LIGHTING_IFSTARLIGHT)
					A.luminosity = 0

		subsystem_initialized = TRUE
		create_all_lighting_objects()

	//CHOMPEdit Begin
	for(var/datum/planet/planet in SSplanets.planets)
		if(!planet_shandlers[planet])
			planet_shandlers[planet] = new /datum/planet_sunlight_handler(planet)
	//CHOMPEdit End

	fire(FALSE, TRUE)

	return SS_INIT_SUCCESS // CHOMPEdit

/datum/controller/subsystem/lighting/fire(resumed, init_tick_checks)
	MC_SPLIT_TICK_INIT(4)
	if(!init_tick_checks)
		MC_SPLIT_TICK

	var/list/queue = sources_queue
	var/i = 0

	// UPDATE SOURCE QUEUE
	queue = sources_queue
	while(i < length(queue)) //we don't use for loop here because i cannot be changed during an iteration
		i += 1

		var/datum/light_source/L = queue[i]
		L.update_corners()

		if(!QDELETED(L))
			L.needs_update = LIGHTING_NO_UPDATE
		else
			i -= 1 // update_corners() has removed L from the list, move back so we don't overflow or skip the next element

		// We unroll TICK_CHECK here so we can clear out the queue to ensure any removals/additions when sleeping don't fuck us
		if(init_tick_checks)
			if(!TICK_CHECK)
				continue
			queue.Cut(1, i + 1)
			i = 0
			stoplag()
		else if (MC_TICK_CHECK)
			break
	if (i)
		queue.Cut(1, i + 1)
		i = 0

	if(!init_tick_checks)
		MC_SPLIT_TICK

	// UPDATE CORNERS QUEUE
	queue = corners_queue
	while(i < length(queue)) //we don't use for loop here because i cannot be changed during an iteration
		i += 1

		var/datum/lighting_corner/C = queue[i]
		C.needs_update = FALSE //update_objects() can call qdel if the corner is storing no data
		C.update_objects()

		// We unroll TICK_CHECK here so we can clear out the queue to ensure any removals/additions when sleeping don't fuck us
		if(init_tick_checks)
			if(!TICK_CHECK)
				continue
			queue.Cut(1, i + 1)
			i = 0
			stoplag()
		else if (MC_TICK_CHECK)
			break
	if (i)
		queue.Cut(1, i + 1)
		i = 0

	if(!init_tick_checks)
		MC_SPLIT_TICK

	// UPDATE OBJECTS QUEUE
	queue = objects_queue
	while(i < length(queue)) //we don't use for loop here because i cannot be changed during an iteration
		i += 1

		var/datum/lighting_object/O = queue[i]
		if (QDELETED(O))
			continue
		O.update()
		O.needs_update = FALSE

		// We unroll TICK_CHECK here so we can clear out the queue to ensure any removals/additions when sleeping don't fuck us
		if(init_tick_checks)
			if(!TICK_CHECK)
				continue
			queue.Cut(1, i + 1)
			i = 0
			stoplag()
		else if (MC_TICK_CHECK)
			break
	if (i)
		queue.Cut(1, i + 1)
//CHOMPEdit Begin
		i = 0


	if(!init_tick_checks)
		MC_SPLIT_TICK

	// UPDATE SUNLIGHT QUEUE
	queue = sunlight_queue_active
	while(i < length(queue)) //we don't use for loop here because i cannot be changed during an iteration
		i += 1

		var/datum/sunlight_handler/shandler = queue[i]
		if (QDELETED(shandler))
			continue
		shandler.sunlight_update()

		// We unroll TICK_CHECK here so we can clear out the queue to ensure any removals/additions when sleeping don't fuck us
		if(init_tick_checks)
			if(!TICK_CHECK)
				continue
			queue.Cut(1, i + 1)
			i = 0
			stoplag()
		else if (MC_TICK_CHECK)
			break
	if (i)
		queue.Cut(1, i + 1)

/datum/controller/subsystem/lighting/proc/update_sunlight(var/datum/planet_sunlight_handler/pshandler)
	if(istype(pshandler))
		pshandler.update_sun()
		sunlight_queue_active |= pshandler.shandlers
	else
		for(var/datum/planet/planet in planet_shandlers)
			var/datum/planet_sunlight_handler/planet_shandler = planet_shandlers[planet]
			planet_shandler.update_sun()
		sunlight_queue_active = sunlight_queue.Copy()

/datum/controller/subsystem/lighting/proc/get_pshandler_planet(var/datum/planet/planet)
	if(!planet_shandlers[planet])
		planet_shandlers[planet] = new /datum/planet_sunlight_handler(planet)
	return planet_shandlers[planet]

//Wrapper for the list, because these type of lists are just awful to work with
//Also takes care of initialization order issues
/datum/controller/subsystem/lighting/proc/get_pshandler_z(var/z)
	if(z > z_to_pshandler.len)
		z_to_pshandler.len = z
	var/datum/planet_sunlight_handler/pshandler = z_to_pshandler[z]
	if(istype(pshandler))
		return pshandler
	else if(SSplanets && SSplanets.z_to_planet.len >= z && SSplanets.z_to_planet[z])
		var/datum/planet/P = SSplanets.z_to_planet[z]
		if(istype(P))
			pshandler = get_pshandler_planet(P)
			z_to_pshandler[z] = pshandler
	return pshandler

/datum/controller/subsystem/lighting
//CHOMPEdit End

/datum/controller/subsystem/lighting/Recover()
	subsystem_initialized = SSlighting.subsystem_initialized
	..()
