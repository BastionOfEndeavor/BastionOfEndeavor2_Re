SUBSYSTEM_DEF(input)
	/* Bastion of Endeavor Translation
	name = "Input"
	*/
	name = "Управление"
	// End of Bastion of Endeavor Translation
	wait = 1 // SS_TICKER means this runs every tick
	init_order = INIT_ORDER_INPUT
	flags = SS_TICKER | SS_NO_INIT // CHOMPEdit
	priority = FIRE_PRIORITY_INPUT
	runlevels = RUNLEVELS_DEFAULT | RUNLEVEL_LOBBY

/datum/controller/subsystem/input/fire()
	var/list/clients = GLOB.clients // Let's sing the list cache song
	for(var/i in 1 to clients.len)
		var/client/C = clients[i]
		C?.keyLoop()
