#define XENOARCH_SPAWN_CHANCE 0.5
#define DIGSITESIZE_LOWER 4
#define DIGSITESIZE_UPPER 12
#define ARTIFACTSPAWNNUM_LOWER 12
#define ARTIFACTSPAWNNUM_UPPER 24

//
// Xenoarch subsystem handles initialization of Xenoarcheaology artifacts and digsites.
//
SUBSYSTEM_DEF(xenoarch)
	/* Bastion of Endeavor Translation
	name = "Xenoarch"
	*/
	name = "Ксеноархеология"
	// End of Bastion of Endeavor Translation
	init_order = INIT_ORDER_XENOARCH
	flags = SS_NO_FIRE
	var/list/artifact_spawning_turfs = list()
	var/list/digsite_spawning_turfs = list()

/datum/controller/subsystem/xenoarch/Initialize() // CHOMPEdit
	SetupXenoarch()
	return SS_INIT_SUCCESS // CHOMPEdit

/datum/controller/subsystem/xenoarch/Recover()
	if (istype(SSxenoarch.artifact_spawning_turfs))
		artifact_spawning_turfs = SSxenoarch.artifact_spawning_turfs
	if (istype(SSxenoarch.digsite_spawning_turfs))
		digsite_spawning_turfs = SSxenoarch.digsite_spawning_turfs

/datum/controller/subsystem/xenoarch/stat_entry(msg)
	if (!Debug2)
		return // Only show up in stat panel if debugging is enabled.
	return ..() //CHOMPEdit

/datum/controller/subsystem/xenoarch/proc/SetupXenoarch()
	for(var/turf/simulated/mineral/M in world)
		if(!M.density)
			continue

		/*if(isnull(M.geologic_data)) CHOMP Removal. Initialized when needed now.
			M.geologic_data = new /datum/geosample(M)*/

		if((M.z in using_map.xenoarch_exempt_levels) || !prob(XENOARCH_SPAWN_CHANCE))
			continue

		var/farEnough = 1
		for(var/turf/T as anything in digsite_spawning_turfs)
			if(T in range(5, M))
				farEnough = 0
				break
		if(!farEnough)
			continue

		digsite_spawning_turfs.Add(M)

		var/digsite = get_random_digsite_type()
		var/target_digsite_size = rand(DIGSITESIZE_LOWER, DIGSITESIZE_UPPER)

		var/list/processed_turfs = list()
		var/list/turfs_to_process = list(M)

		var/list/viable_adjacent_turfs = list()
		if(target_digsite_size > 1)
			for(var/turf/simulated/mineral/T in orange(2, M))
				if(!T.density)
					continue
				if(T.finds)
					continue
				if(T in processed_turfs)
					continue
				viable_adjacent_turfs.Add(T)

			target_digsite_size = min(target_digsite_size, viable_adjacent_turfs.len)

		for(var/i = 1 to target_digsite_size)
			turfs_to_process += pick_n_take(viable_adjacent_turfs)

		while(turfs_to_process.len)
			var/turf/simulated/mineral/archeo_turf = pop(turfs_to_process)

			processed_turfs.Add(archeo_turf)
			if(isnull(archeo_turf.finds))
				archeo_turf.finds = list()
				if(prob(50))
					archeo_turf.finds.Add(new /datum/find(digsite, rand(10, 190)))
				else if(prob(75))
					archeo_turf.finds.Add(new /datum/find(digsite, rand(10, 90)))
					archeo_turf.finds.Add(new /datum/find(digsite, rand(110, 190)))
				else
					archeo_turf.finds.Add(new /datum/find(digsite, rand(10, 50)))
					archeo_turf.finds.Add(new /datum/find(digsite, rand(60, 140)))
					archeo_turf.finds.Add(new /datum/find(digsite, rand(150, 190)))

				//sometimes a find will be close enough to the surface to show
				var/datum/find/F = archeo_turf.finds[1]
				if(F.excavation_required <= F.view_range)
					archeo_turf.archaeo_overlay = "overlay_archaeo[rand(1,3)]"
					archeo_turf.update_icon()

			//have a chance for an artifact to spawn here, but not in animal or plant digsites
			if(isnull(M.artifact_find) && digsite != DIGSITE_GARDEN && digsite != DIGSITE_ANIMAL)
				artifact_spawning_turfs.Add(archeo_turf)

		//Larger maps will convince byond this is an infinite loop, so let go for a second
		CHECK_TICK

	//create artifact machinery
	var/num_artifacts_spawn = rand(ARTIFACTSPAWNNUM_LOWER, ARTIFACTSPAWNNUM_UPPER)
	while(artifact_spawning_turfs.len > num_artifacts_spawn)
		pick_n_take(artifact_spawning_turfs)

	var/list/artifacts_spawnturf_temp = artifact_spawning_turfs.Copy()
	while(artifacts_spawnturf_temp.len > 0)
		var/turf/simulated/mineral/artifact_turf = pop(artifacts_spawnturf_temp)
		artifact_turf.artifact_find = new()

#undef XENOARCH_SPAWN_CHANCE
#undef DIGSITESIZE_LOWER
#undef DIGSITESIZE_UPPER
#undef ARTIFACTSPAWNNUM_LOWER
#undef ARTIFACTSPAWNNUM_UPPER
