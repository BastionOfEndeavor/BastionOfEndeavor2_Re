#define SSMACHINES_PIPENETS      1
#define SSMACHINES_MACHINERY     2
#define SSMACHINES_POWERNETS     3
#define SSMACHINES_POWER_OBJECTS 4

//
// SSmachines subsystem - Processing machines, pipenets, and powernets!
//

SUBSYSTEM_DEF(machines)
	/* Bastion of Endeavor Translation
	name = "Machines"
	*/
	name = "Аппаратура"
	// End of Bastion of Endeavor Translation
	priority = FIRE_PRIORITY_MACHINES
	init_order = INIT_ORDER_MACHINES
	flags = SS_KEEP_TIMING
	runlevels = RUNLEVEL_GAME|RUNLEVEL_POSTGAME

	var/current_step = SSMACHINES_PIPENETS

	var/cost_pipenets      = 0
	var/cost_machinery     = 0
	var/cost_powernets     = 0
	var/cost_power_objects = 0

	var/list/current_run = list()

	var/list/all_machines = list()

	var/list/networks = list()
	var/list/processing_machines = list()
	var/list/powernets = list()
	var/list/powerobjs = list()

/datum/controller/subsystem/machines/Initialize() // CHOMPEdit
	makepowernets()
	/* Bastion of Endeavor Translation
	admin_notice(span_danger("Initializing atmos machinery."), R_DEBUG)
	*/
	admin_notice(span_danger("Инициализация атмосферной аппаратуры."), R_DEBUG)
	// End of Bastion of Endeavor Translation
	setup_atmos_machinery(all_machines)
	fire()
	return SS_INIT_SUCCESS // CHOMPEdit

/datum/controller/subsystem/machines/fire(resumed = 0)
	var/timer = TICK_USAGE

	INTERNAL_PROCESS_STEP(SSMACHINES_POWER_OBJECTS,FALSE,process_power_objects,cost_power_objects,SSMACHINES_PIPENETS) // Higher priority, damnit
	INTERNAL_PROCESS_STEP(SSMACHINES_PIPENETS,TRUE,process_pipenets,cost_pipenets,SSMACHINES_MACHINERY)
	INTERNAL_PROCESS_STEP(SSMACHINES_MACHINERY,FALSE,process_machinery,cost_machinery,SSMACHINES_POWERNETS)
	INTERNAL_PROCESS_STEP(SSMACHINES_POWERNETS,FALSE,process_powernets,cost_powernets,SSMACHINES_POWER_OBJECTS)

// rebuild all power networks from scratch - only called at world creation or by the admin verb
// The above is a lie. Turbolifts also call this proc.
/datum/controller/subsystem/machines/proc/makepowernets()
	// TODO - check to not run while in the middle of a tick!
	for(var/datum/powernet/PN as anything in powernets)
		qdel(PN)
	powernets.Cut()
	setup_powernets_for_cables(cable_list)

/datum/controller/subsystem/machines/proc/setup_powernets_for_cables(list/cables)
	for(var/obj/structure/cable/PC as anything in cables)
		if(!PC.powernet)
			var/datum/powernet/NewPN = new()
			NewPN.add_cable(PC)
			propagate_network(PC,PC.powernet)

/datum/controller/subsystem/machines/proc/setup_atmos_machinery(list/atmos_machines)
	var/list/actual_atmos_machines = list()

	for(var/obj/machinery/atmospherics/machine in atmos_machines)
		machine.atmos_init()
		actual_atmos_machines += machine
		CHECK_TICK

	for(var/obj/machinery/atmospherics/machine as anything in actual_atmos_machines)
		machine.build_network()
		CHECK_TICK

	for(var/obj/machinery/atmospherics/unary/U as anything in actual_atmos_machines)
		if(istype(U, /obj/machinery/atmospherics/unary/vent_pump))
			var/obj/machinery/atmospherics/unary/vent_pump/T = U
			T.broadcast_status()
		else if(istype(U, /obj/machinery/atmospherics/unary/vent_scrubber))
			var/obj/machinery/atmospherics/unary/vent_scrubber/T = U
			T.broadcast_status()
		CHECK_TICK

/datum/controller/subsystem/machines/stat_entry(msg)
	/* Bastion of Endeavor Translation
	msg = "C:{"
	msg += "PI:[round(cost_pipenets,1)]|"
	msg += "MC:[round(cost_machinery,1)]|"
	msg += "PN:[round(cost_powernets,1)]|"
	msg += "PO:[round(cost_power_objects,1)]"
	msg += "} "
	msg += "PI:[SSmachines.networks.len]|"
	msg += "MC:[SSmachines.processing_machines.len]|"
	msg += "PN:[SSmachines.powernets.len]|"
	msg += "PO:[SSmachines.powerobjs.len]|"
	msg += "MC/MS:[round((cost ? SSmachines.processing_machines.len/cost_machinery : 0),0.1)]"
	*/
	msg = "| С:{"
	msg += "ТС:[round(cost_pipenets,1)]|"
	msg += "МАШ:[round(cost_machinery,1)]|"
	msg += "ЭС:[round(cost_powernets,1)]|"
	msg += "ЭЛ:[round(cost_power_objects,1)]"
	msg += "} "
	msg += "ТР:[SSmachines.networks.len]|"
	msg += "МАШ:[SSmachines.processing_machines.len]|"
	msg += "ЭС:[SSmachines.powernets.len]|"
	msg += "ЭМ:[SSmachines.powerobjs.len]|"
	msg += "МАШ/МС:[round((cost ? SSmachines.processing_machines.len/cost_machinery : 0),0.1)]"
	// End of Bastion of Endeavor Translation
	return ..()

/datum/controller/subsystem/machines/proc/process_pipenets(resumed = 0)
	if (!resumed)
		src.current_run = networks.Copy()
	//cache for sanic speed (lists are references anyways)
	var/wait = src.wait
	var/list/current_run = src.current_run
	while(current_run.len)
		var/datum/pipe_network/PN = current_run[current_run.len]
		current_run.len--
		if(!PN || QDELETED(PN)) //CHOMPEdit
			networks.Remove(PN)
			DISABLE_BITFIELD(PN?.datum_flags, DF_ISPROCESSING)
		else
			PN.process(wait)
		if(MC_TICK_CHECK)
			return

/datum/controller/subsystem/machines/proc/process_machinery(resumed = 0)
	if (!resumed)
		src.current_run = processing_machines.Copy()

	var/wait = src.wait
	var/list/current_run = src.current_run
	while(current_run.len)
		var/obj/machinery/M = current_run[current_run.len]
		current_run.len--
		if(!istype(M) || QDELETED(M) || (M.process(wait) == PROCESS_KILL)) //CHOMPEdit
			processing_machines.Remove(M)
			DISABLE_BITFIELD(M?.datum_flags, DF_ISPROCESSING)
		if(MC_TICK_CHECK)
			return

/datum/controller/subsystem/machines/proc/process_powernets(resumed = 0)
	if (!resumed)
		src.current_run = powernets.Copy()

	var/wait = src.wait
	var/list/current_run = src.current_run
	while(current_run.len)
		var/datum/powernet/PN = current_run[current_run.len]
		current_run.len--
		if(!PN)
			powernets.Remove(PN)
			DISABLE_BITFIELD(PN?.datum_flags, DF_ISPROCESSING)
		else
			PN.reset(wait)
		if(MC_TICK_CHECK)
			return

// Actually only processes power DRAIN objects.
// Currently only used by powersinks. These items get priority processed before machinery
/datum/controller/subsystem/machines/proc/process_power_objects(resumed = 0)
	if (!resumed)
		src.current_run = powerobjs.Copy()

	var/wait = src.wait
	var/list/current_run = src.current_run
	while(current_run.len)
		var/obj/item/I = current_run[current_run.len]
		current_run.len--
		if(!I || (I.pwr_drain(wait) == PROCESS_KILL))
			powerobjs.Remove(I)
			DISABLE_BITFIELD(I?.datum_flags, DF_ISPROCESSING)
		if(MC_TICK_CHECK)
			return

/datum/controller/subsystem/machines/Recover()
	for(var/datum/D as anything in SSmachines.networks)
		if(!istype(D, /datum/pipe_network))
			/* Bastion of Endeavor Translation
			error("Found wrong type during SSmachinery recovery: list=SSmachines.networks, item=[D], type=[D?.type]")
			SSmachines.networks -= D
			*/
			error("Во время Recover() SSmachinery найден неправильный тип: list=SSmachines.networks, item=[D], type=[D?.type].")
			SSmachines.networks -= D
			// End of Bastion of Endeavor Translation
	for(var/datum/D as anything in SSmachines.processing_machines)
		if(!istype(D, /obj/machinery))
			/* Bastion of Endeavor Translation
			error("Found wrong type during SSmachinery recovery: list=SSmachines.machines, item=[D], type=[D?.type]")
			*/
			error("Во время Recover() SSmachinery найден неправильный тип: list=SSmachines.machines, item=[D], type=[D?.type].")
			// End of Bastion of Endeavor Translation
			SSmachines.processing_machines -= D
	for(var/datum/D as anything in SSmachines.powernets)
		if(!istype(D, /datum/powernet))
			/* Bastion of Endeavor Translation
			error("Found wrong type during SSmachinery recovery: list=SSmachines.powernets, item=[D], type=[D?.type]")
			*/
			error("Во время Recover() SSmachinery найден неправильный тип: list=SSmachines.powernets, item=[D], type=[D?.type].")
			// End of Bastion of Endeavor Translation
			SSmachines.powernets -= D
	for(var/datum/D as anything in SSmachines.powerobjs)
		if(!istype(D, /obj/item))
			/* Bastion of Endeavor Translation
			error("Found wrong type during SSmachinery recovery: list=SSmachines.powerobjs, item=[D], type=[D?.type]")
			*/
			error("Во время Recover() SSmachinery найден неправильный тип: list=SSmachines.powerobjs, item=[D], type=[D?.type].")
			// End of Bastion of Endeavor Translation
			SSmachines.powerobjs -= D

	all_machines = SSmachines.all_machines
	networks = SSmachines.networks
	processing_machines = SSmachines.processing_machines
	powernets = SSmachines.powernets
	powerobjs = SSmachines.powerobjs

#undef SSMACHINES_PIPENETS
#undef SSMACHINES_MACHINERY
#undef SSMACHINES_POWERNETS
#undef SSMACHINES_POWER_OBJECTS
