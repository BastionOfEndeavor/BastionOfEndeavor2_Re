/atom
	layer = TURF_LAYER //This was here when I got here. Why though?
	var/level = 2
	var/flags = 0
	var/list/fingerprints
	var/list/fingerprintshidden
	var/fingerprintslast = null
	var/list/blood_DNA
	var/was_bloodied
	var/blood_color
	var/pass_flags = 0
	var/throwpass = 0
	var/germ_level = GERM_LEVEL_AMBIENT // The higher the germ level, the more germ on the atom.
	var/simulated = TRUE //filter for actions - used by lighting overlays
	/* Bastion of Endeavor Translation: Bastion of Endeavor TODO: Might wanna come back to this after mobs are localized!
	var/atom_say_verb = "says"
	*/
	var/atom_say_verb = "говор;ит;ит;ит;ят;"
	// End of Bastion of Endeavor Translation
	var/bubble_icon = "normal" ///what icon the atom uses for speechbubbles
	var/fluorescent // Shows up under a UV light.

	var/last_bumped = 0

	///Chemistry.
	var/datum/reagents/reagents = null

	//var/chem_is_open_container = 0
	// replaced by OPENCONTAINER flags and atom/proc/is_open_container()
	///Chemistry.

	// Overlays
	///Our local copy of (non-priority) overlays without byond magic. Use procs in SSoverlays to manipulate
	var/list/our_overlays
	///Overlays that should remain on top and not normally removed when using cut_overlay functions, like c4.
	var/list/priority_overlays
	///vis overlays managed by SSvis_overlays to automaticaly turn them like other overlays
	var/list/managed_vis_overlays

	///Our local copy of filter data so we can add/remove it
	var/list/filter_data

	//Detective Work, used for the duplicate data points kept in the scanners
	var/list/original_atom
	// Track if we are already had initialize() called to prevent double-initialization.
	//var/initialized = FALSE CHOMPEdit moved to flag

	/// Last name used to calculate a color for the chatmessage overlays
	var/chat_color_name
	/// Last color calculated for the the chatmessage overlays
	var/chat_color
	/// A luminescence-shifted value of the last color calculated for chatmessage overlays
	var/chat_color_darkened
	/// The chat color var, without alpha.
	var/chat_color_hover
	//! Colors
	/**
	 * used to store the different colors on an atom
	 *
	 * its inherent color, the colored paint applied on it, special color effect etc...
	 */
	var/list/atom_colours

/atom/New(loc, ...)
	// Don't call ..() unless /datum/New() ever exists

	// During dynamic mapload (reader.dm) this assigns the var overrides from the .dmm file
	// Native BYOND maploading sets those vars before invoking New(), by doing this FIRST we come as close to that behavior as we can.
	if(GLOB.use_preloader && (src.type == GLOB._preloader.target_path))//in case the instanciated atom is creating other atoms in New()
		GLOB._preloader.load(src)

	// Pass our arguments to InitAtom so they can be passed to initialize(), but replace 1st with if-we're-during-mapload.
	var/do_initialize = SSatoms.initialized
	if(do_initialize > INITIALIZATION_INSSATOMS)
		args[1] = (do_initialize == INITIALIZATION_INNEW_MAPLOAD)
		if(SSatoms.InitAtom(src, args))
			// We were deleted. No sense continuing
			return

	// Uncomment if anything ever uses the return value of SSatoms.InitializeAtoms ~Leshana
	// If a map is being loaded, it might want to know about newly created objects so they can be handled.
	// var/list/created = SSatoms.created_atoms
	// if(created)
	// 	created += src

// Note: I removed "auto_init" feature (letting types disable auto-init) since it shouldn't be needed anymore.
// 	You can replicate the same by checking the value of the first parameter to initialize() ~Leshana

// Called after New if the map is being loaded, with mapload = TRUE
// Called from base of New if the map is not being loaded, with mapload = FALSE
// This base must be called or derivatives must set initialized to TRUE
// Must not sleep!
// Other parameters are passed from New (excluding loc), this does not happen if mapload is TRUE
// Must return an Initialize hint. Defined in code/__defines/subsystems.dm
/atom/proc/Initialize(mapload, ...)
	if(QDELETED(src))
		/* Bastion of Endeavor Translation
		stack_trace("GC: -- [type] had initialize() called after qdel() --")
		*/
		stack_trace("Мусоросборщик: [type] вызвал initialize() после qdel().")
		// End of Bastion of Endeavor Translation
	if(flags & ATOM_INITIALIZED) //CHOMPEdit moved initialized to flag
		/* Bastion of Endeavor Translation
		stack_trace("Warning: [src]([type]) initialized multiple times!")
		*/
		stack_trace("Внимание: [src] ([type]) инициализирован несколько раз!")
		// End of Bastion of Endeavor Translation
	flags |= ATOM_INITIALIZED //CHOMPEdit moved initialized to flag
	return INITIALIZE_HINT_NORMAL

/atom/Destroy()
	if(reagents)
		QDEL_NULL(reagents)
	if(light)
		QDEL_NULL(light)
	return ..()

// Called after all object's normal initialize() if initialize() returns INITIALIZE_HINT_LATELOAD
/atom/proc/LateInitialize()
	return

/atom/proc/reveal_blood()
	return

/atom/proc/assume_air(datum/gas_mixture/giver)
	return null

/atom/proc/remove_air(amount)
	return null

/atom/proc/return_air()
	if(loc)
		return loc.return_air()
	else
		return null

//return flags that should be added to the viewer's sight var.
//Otherwise return a negative number to indicate that the view should be cancelled.
/atom/proc/check_eye(user as mob)
	if (istype(user, /mob/living/silicon/ai)) // WHYYYY
		return 0
	return -1

/atom/proc/Bumped(AM as mob|obj)
	set waitfor = FALSE

	SEND_SIGNAL(src, COMSIG_ATOM_BUMPED, AM)

// Convenience proc to see if a container is open for chemistry handling
// returns true if open
// false if closed
/atom/proc/is_open_container()
	return flags & OPENCONTAINER

/*//Convenience proc to see whether a container can be accessed in a certain way.

	proc/can_subract_container()
		return flags & EXTRACT_CONTAINER

	proc/can_add_container()
		return flags & INSERT_CONTAINER
*/

// Used to be for the PROXMOVE flag, but that was terrible, so instead it's just here as a stub for
// all the atoms that still have the proc, but get events other ways.
/atom/proc/HasProximity(turf/T, datum/weakref/WF, old_loc)
	SIGNAL_HANDLER // CHOMPAdd
	return

//Register listeners on turfs in a certain range
/atom/proc/sense_proximity(var/range = 1, var/callback)
	ASSERT(callback)
	ASSERT(isturf(loc))
	var/list/turfs = trange(range, src)
	for(var/turf/T as anything in turfs)
		RegisterSignal(T, COMSIG_OBSERVER_TURF_ENTERED, callback)

//Unregister from prox listening in a certain range. You should do this BEFORE you move, but if you
// really can't, then you can set the center where you moved from.
/atom/proc/unsense_proximity(var/range = 1, var/callback, var/center)
	ASSERT(isturf(center) || isturf(loc))
	var/list/turfs = trange(range, center ? center : src)
	for(var/turf/T as anything in turfs)
		UnregisterSignal(T, COMSIG_OBSERVER_TURF_ENTERED)


/atom/proc/emp_act(var/severity)
	return

/atom/proc/bullet_act(obj/item/projectile/P, def_zone)
	if(SEND_SIGNAL(src, COMSIG_ATOM_BULLET_ACT, P, def_zone) & COMPONENT_CANCEL_ATTACK_CHAIN)
		return

	P.on_hit(src, 0, def_zone)
	. = 0

// Called when a blob expands onto the tile the atom occupies.
/atom/proc/blob_act()
	return

/atom/proc/in_contents_of(container)//can take class or object instance as argument
	if(ispath(container))
		if(istype(src.loc, container))
			return 1
	else if(src in container)
		return 1
	return

/*
 *	atom/proc/search_contents_for(path,list/filter_path=null)
 * Recursevly searches all atom contens (including contents contents and so on).
 *
 * ARGS: path - search atom contents for atoms of this type
 *	   list/filter_path - if set, contents of atoms not of types in this list are excluded from search.
 *
 * RETURNS: list of found atoms
 */

/atom/proc/search_contents_for(path,list/filter_path=null)
	var/list/found = list()
	for(var/atom/A in src)
		if(istype(A, path))
			found += A
		if(filter_path)
			var/pass = 0
			for(var/type in filter_path)
				pass |= istype(A, type)
			if(!pass)
				continue
		if(A.contents.len)
			found += A.search_contents_for(path,filter_path)
	return found

/atom/proc/get_examine_desc()
	return desc

//All atoms
/atom/proc/examine(mob/user, var/infix = "", var/suffix = "")
	//This reformat names to get a/an properly working on item descriptions when they are bloody
	/* Bastion of Endeavor Translation: There is some polishing done here.
	var/f_name = "\a [src][infix]."
	*/
	var/f_name = "[ncase_ru(src)][infix]."
	// End of Bastion of Endeavor Translation
	if(src.blood_DNA && !istype(src, /obj/effect/decal))
		if(gender == PLURAL)
			/* Bastion of Endeavor Translation
			f_name = "some "
			*/
			f_name = ""
			// End of Bastion of Endeavor Translation
		else
			/* Bastion of Endeavor Translation
			f_name = "a "
			*/
			f_name = ""
			// End of Bastion of Endeavor Translation
		if(blood_color != SYNTH_BLOOD_COLOUR)
			/* Bastion of Endeavor Translation
			f_name += "[span_danger("blood-stained")] [name][infix]!"
			*/
			f_name += "[span_danger(verb_ru(src, "окровавленн;ый;ая;ое;ые;"))] [ncase_ru(src)][infix]!"
			// End of Bastion of Endeavor Translation
		else
			/* Bastion of Endeavor Translation
			f_name += "oil-stained [name][infix]."
			*/
			f_name += "[verb_ru(src, "замасленн;ый;ая;ое;ые;")] [ncase_ru(src)][infix]."
			// End of Bastion of Endeavor Translation

	/* Bastion of Endeavor Translation
	var/list/output = list("[icon2html(src,user.client)] That's [f_name] [suffix]", get_examine_desc())
	*/
	var/list/output = list("[icon2html(src,user.client)] Это [f_name] [suffix]", get_examine_desc())
	// End of Bastion of Endeavor Translation

	if(user.client?.prefs.examine_text_mode == EXAMINE_MODE_INCLUDE_USAGE)
		output += description_info

	if(user.client?.prefs.examine_text_mode == EXAMINE_MODE_SWITCH_TO_PANEL)
		/* Bastion of Endeavor Translation
		user.client.statpanel = "Examine" // Switch to stat panel
		*/
		user.client.statpanel = "Осмотр" // Switch to stat panel
		// End of Bastion of Endeavor Translation
	SEND_SIGNAL(src, COMSIG_PARENT_EXAMINE, user, output)
	return output

// Don't make these call bicon or anything, these are what bicon uses. They need to return an icon.
/atom/proc/examine_icon()
	return src //CHOMPEdit 99% of the time just returning src will be sufficient. More complex examine icon things are available where they are needed
	//return icon(icon=src.icon, icon_state=src.icon_state, dir=SOUTH, frame=1, moving=0) CHOMPEdit-- N O

// called by mobs when e.g. having the atom as their machine, pulledby, loc (AKA mob being inside the atom) or buckled var set.
// see code/modules/mob/mob_movement.dm for more.
/atom/proc/relaymove()
	return

//called to set the atom's dir and used to add behaviour to dir-changes
/atom/proc/set_dir(new_dir)
	SEND_SIGNAL(src, COMSIG_ATOM_DIR_CHANGE, dir, new_dir)
	. = new_dir != dir
	dir = new_dir

// Called to set the atom's density and used to add behavior to density changes.
/atom/proc/set_density(var/new_density)
	if(density == new_density)
		return FALSE
	density = !!new_density // Sanitize to be strictly 0 or 1
	return TRUE

// Called to set the atom's invisibility and usd to add behavior to invisibility changes.
/atom/proc/set_invisibility(var/new_invisibility)
	if(invisibility == new_invisibility)
		return FALSE
	invisibility = new_invisibility
	return TRUE

/atom/proc/ex_act(var/strength = 3)
	return (SEND_SIGNAL(src, COMSIG_ATOM_EX_ACT, strength, src) & COMPONENT_IGNORE_EXPLOSION)

/atom/proc/emag_act(var/remaining_charges, var/mob/user, var/emag_source)
	return -1

/atom/proc/fire_act()
	return


// Returns an assoc list of RCD information.
// Example would be: list(RCD_VALUE_MODE = RCD_DECONSTRUCT, RCD_VALUE_DELAY = 50, RCD_VALUE_COST = RCD_SHEETS_PER_MATTER_UNIT * 4)
// This occurs before rcd_act() is called, and it won't be called if it returns FALSE.
/atom/proc/rcd_values(mob/living/user, obj/item/rcd/the_rcd, passed_mode)
	return FALSE

/atom/proc/rcd_act(mob/living/user, obj/item/rcd/the_rcd, passed_mode)
	return

/atom/proc/melt()
	return

// Previously this was defined both on /obj/ and /turf/ seperately.  And that's bad.
/atom/proc/update_icon()
	return


/atom/proc/hitby(atom/movable/AM as mob|obj)
	if (density)
		AM.throwing = 0
	return

/atom/proc/add_hiddenprint(mob/living/M as mob)
	if(isnull(M)) return
	if(isnull(M.key)) return
	if (ishuman(M))
		var/mob/living/carbon/human/H = M
		if (!istype(H.dna, /datum/dna))
			return 0
		if (H.gloves)
			if(src.fingerprintslast != H.key)
				/* Bastion of Endeavor Translation
				src.fingerprintshidden += text("\[[time_stamp()]\] (Wearing gloves). Real name: [], Key: []",H.real_name, H.key)
				*/
				src.fingerprintshidden += text("\[[time_stamp()]\] (в перчатках). Настоящее имя: [], кей: []",H.real_name, H.key)
				// End of Bastion of Endeavor Translation
				src.fingerprintslast = H.key
			return 0
		if (!( src.fingerprints ))
			if(src.fingerprintslast != H.key)
				/* Bastion of Endeavor Translation
				src.fingerprintshidden += text("\[[time_stamp()]\] Real name: [], Key: []",H.real_name, H.key)
				*/
				src.fingerprintshidden += text("\[[time_stamp()]\] Настоящее имя: [], кей: []",H.real_name, H.key)
				// End of Bastion of Endeavor Translation
				src.fingerprintslast = H.key
			return 1
	else
		if(src.fingerprintslast != M.key)
			/* Bastion of Endeavor Translation
			src.fingerprintshidden += text("\[[time_stamp()]\] Real name: [], Key: []",M.real_name, M.key)
			*/
			src.fingerprintshidden += text("\[[time_stamp()]\] Настоящее имя: [], кей: []",M.real_name, M.key)
			// End of Bastion of Endeavor Translation
			src.fingerprintslast = M.key
	return

/atom/proc/add_fingerprint(mob/living/M as mob, ignoregloves = 0)
	if(isnull(M)) return
	if(isAI(M)) return
	if(isnull(M.key)) return
	if (ishuman(M))
		//Add the list if it does not exist.
		if(!fingerprintshidden)
			fingerprintshidden = list()

		//Fibers~
		add_fibers(M)

		//He has no prints!
		if (mFingerprints in M.mutations)
			if(fingerprintslast != M.key)
				/* Bastion of Endeavor Translation
				fingerprintshidden += "[time_stamp()]: [key_name(M)] (No fingerprints mutation)"
				*/
				fingerprintshidden += "[time_stamp()]: [key_name(M)] (мутация – без отпечатков)"
				// End of Bastion of Endeavor Translation
				fingerprintslast = M.key
			return 0		//Now, lets get to the dirty work.
		//First, make sure their DNA makes sense.
		var/mob/living/carbon/human/H = M
		if (!istype(H.dna, /datum/dna) || !H.dna.uni_identity || (length(H.dna.uni_identity) != 32))
			if(!istype(H.dna, /datum/dna))
				H.dna = new /datum/dna(null)
				H.dna.real_name = H.real_name
		H.check_dna()

		//Now, deal with gloves.
		if (H.gloves && H.gloves != src)
			if(fingerprintslast != H.key)
				/* Bastion of Endeavor Translation
				fingerprintshidden += "[time_stamp()]: [key_name(H)] (Wearing [H.gloves])"
				*/
				fingerprintshidden += "[time_stamp()]: [key_name(H)] ([prep_adv_ru("в", H.gloves, PCASE)])"
				// End of Bastion of Endeavor Translation
				fingerprintslast = H.key
			H.gloves.add_fingerprint(M)

		//Deal with gloves the pass finger/palm prints.
		if(!ignoregloves)
			if(H.gloves && H.gloves != src)
				if(istype(H.gloves, /obj/item/clothing/gloves))
					var/obj/item/clothing/gloves/G = H.gloves
					if(!prob(G.fingerprint_chance))
						return 0

		//More adminstuffz
		if(fingerprintslast != H.key)
			fingerprintshidden += "[time_stamp()]: [key_name(H)]"
			fingerprintslast = H.key

		//Make the list if it does not exist.
		if(!fingerprints)
			fingerprints = list()

		//Hash this shit.
		var/full_print = H.get_full_print()

		// Add the fingerprints
		//
		if(fingerprints[full_print])
			switch(stringpercent(fingerprints[full_print]))		//tells us how many stars are in the current prints.

				if(28 to 32)
					if(prob(1))
						fingerprints[full_print] = full_print 		// You rolled a one buddy.
					else
						fingerprints[full_print] = stars(full_print, rand(0,40)) // 24 to 32

				if(24 to 27)
					if(prob(3))
						fingerprints[full_print] = full_print     	//Sucks to be you.
					else
						fingerprints[full_print] = stars(full_print, rand(15, 55)) // 20 to 29

				if(20 to 23)
					if(prob(5))
						fingerprints[full_print] = full_print		//Had a good run didn't ya.
					else
						fingerprints[full_print] = stars(full_print, rand(30, 70)) // 15 to 25

				if(16 to 19)
					if(prob(5))
						fingerprints[full_print] = full_print		//Welp.
					else
						fingerprints[full_print]  = stars(full_print, rand(40, 100))  // 0 to 21

				if(0 to 15)
					if(prob(5))
						fingerprints[full_print] = stars(full_print, rand(0,50)) 	// small chance you can smudge.
					else
						fingerprints[full_print] = full_print

		else
			fingerprints[full_print] = stars(full_print, rand(0, 20))	//Initial touch, not leaving much evidence the first time.


		return 1
	else
		//Smudge up dem prints some
		if(fingerprintslast != M.key)
			fingerprintshidden += "[time_stamp()]: [key_name(M)]"
			fingerprintslast = M.key

	//Cleaning up shit.
	if(fingerprints && !fingerprints.len)
		qdel(fingerprints)
	return


/atom/proc/transfer_fingerprints_to(var/atom/A)

	if(!istype(A.fingerprints,/list))
		A.fingerprints = list()

	if(!istype(A.fingerprintshidden,/list))
		A.fingerprintshidden = list()

	if(!istype(fingerprintshidden, /list))
		fingerprintshidden = list()

	//skytodo
	//A.fingerprints |= fingerprints            //detective
	//A.fingerprintshidden |= fingerprintshidden    //admin
	if(A.fingerprints && fingerprints)
		A.fingerprints |= fingerprints.Copy()            //detective
	if(A.fingerprintshidden && fingerprintshidden)
		A.fingerprintshidden |= fingerprintshidden.Copy()    //admin	A.fingerprintslast = fingerprintslast


//returns 1 if made bloody, returns 0 otherwise
/atom/proc/add_blood(mob/living/carbon/human/M as mob)

	if(flags & NOBLOODY)
		return 0

	if(!blood_DNA || !istype(blood_DNA, /list))	//if our list of DNA doesn't exist yet (or isn't a list) initialise it.
		blood_DNA = list()

	was_bloodied = TRUE
	if(!blood_color)
		blood_color = SYNTH_BLOOD_COLOUR
	if(istype(M))
		if (!istype(M.dna, /datum/dna))
			M.dna = new /datum/dna(null)
			M.dna.real_name = M.real_name
		M.check_dna()
		blood_color = M.species.get_blood_colour(M)
	. = 1
	return 1

/atom/proc/add_vomit_floor(mob/living/carbon/M as mob, var/toxvomit = 0)
	if( istype(src, /turf/simulated) )
		var/obj/effect/decal/cleanable/vomit/this = new /obj/effect/decal/cleanable/vomit(src)
		this.virus2 = virus_copylist(M.virus2)

		// Make toxins vomit look different
		if(toxvomit)
			this.icon_state = "vomittox_[pick(1,4)]"

/atom/proc/clean_blood()
	if(!simulated)
		return
	fluorescent = 0
	src.germ_level = 0
	if(istype(blood_DNA, /list))
		blood_DNA = null
		return TRUE
	blood_color = null //chompfixy, cleaning objects saved its future blood color no matter what

/atom/proc/on_rag_wipe(var/obj/item/reagent_containers/glass/rag/R)
	clean_blood()
	R.reagents.splash(src, 1)

/atom/proc/get_global_map_pos()
	if(!islist(global_map) || isemptylist(global_map)) return
	var/cur_x = null
	var/cur_y = null
	var/list/y_arr = null
	for(cur_x=1,cur_x<=global_map.len,cur_x++)
		y_arr = global_map[cur_x]
		cur_y = y_arr.Find(src.z)
		if(cur_y)
			break
//	to_world("X = [cur_x]; Y = [cur_y]")
	if(cur_x && cur_y)
		return list("x"=cur_x,"y"=cur_y)
	else
		return 0

/atom/proc/checkpass(passflag)
	return (pass_flags&passflag)

/atom/proc/isinspace()
	if(istype(get_turf(src), /turf/space))
		return 1
	else
		return 0
//CHOMPEdit Begin
/atom/proc/visible_message(var/message, var/blind_message, var/list/exclude_mobs, var/range = world.view, var/runemessage = "<span style='font-size: 1.5em'>👁</span>")
	SEND_GLOBAL_SIGNAL(COMSIG_VISIBLE_MESSAGE, src, message, blind_message, exclude_mobs, range, runemessage, isbelly(loc))
//CHOMPEdit End
// Show a message to all mobs and objects in earshot of this atom
// Use for objects performing audible actions
// message is the message output to anyone who can hear.
// deaf_message (optional) is what deaf people will see.
// hearing_distance (optional) is the range, how many tiles away the message can be heard.
/atom/proc/audible_message(var/message, var/deaf_message, var/hearing_distance, var/radio_message, var/runemessage)

	var/range = hearing_distance || world.view
	var/list/hear = get_mobs_and_objs_in_view_fast(get_turf(src),range,remote_ghosts = FALSE)

	var/list/hearing_mobs = hear["mobs"]
	var/list/hearing_objs = hear["objs"]

	if(radio_message)
		for(var/obj/O as anything in hearing_objs)
			/* Bastion of Endeavor Translation
			O.hear_talk(src, list(new /datum/multilingual_say_piece(GLOB.all_languages["Noise"], radio_message)), null)
			*/
			O.hear_talk(src, list(new /datum/multilingual_say_piece(GLOB.all_languages["Звук"], radio_message)), null)
			// End of Bastion of Endeavor Translation
	else
		for(var/obj/O as anything in hearing_objs)
			O.show_message(message, AUDIBLE_MESSAGE, deaf_message, VISIBLE_MESSAGE)

	for(var/mob/M as anything in hearing_mobs)
		var/msg = message
		M.show_message(msg, AUDIBLE_MESSAGE, deaf_message, VISIBLE_MESSAGE)
		if(runemessage != -1)
			M.create_chat_message(src, "[runemessage || message]", FALSE, list("emote"))

/atom/movable/proc/dropInto(var/atom/destination)
	while(istype(destination))
		var/atom/drop_destination = destination.onDropInto(src)
		if(!istype(drop_destination) || drop_destination == destination)
			return forceMove(destination)
		destination = drop_destination
	return moveToNullspace()

/atom/proc/onDropInto(var/atom/movable/AM)
	return // If onDropInto returns null, then dropInto will forceMove AM into us.

/atom/movable/onDropInto(var/atom/movable/AM)
	return loc // If onDropInto returns something, then dropInto will attempt to drop AM there.

/atom/proc/InsertedContents()
	return contents

/atom/proc/has_gravity(turf/T)
	if(!T || !isturf(T))
		T = get_turf(src)
	if(istype(T, /turf/space)) // Turf never has gravity
		return FALSE
	var/area/A = get_area(T)
	if(A && A.has_gravity())
		return TRUE
	return FALSE

/atom/proc/is_incorporeal()
	return FALSE

/atom/proc/drop_location()
	var/atom/L = loc
	if(!L)
		return null
	return L.AllowDrop() ? L : L.drop_location()

/atom/proc/AllowDrop()
	return FALSE

/atom/proc/get_nametag_name(mob/user)
	return name

/atom/proc/get_nametag_desc(mob/user)
	return "" //Desc itself is often too long to use

/atom/vv_get_dropdown()
	. = ..()
	/* Bastion of Endeavor Translation
	VV_DROPDOWN_OPTION(VV_HK_ATOM_EXPLODE, "Explosion")
	VV_DROPDOWN_OPTION(VV_HK_ATOM_EMP, "Emp Pulse")
	*/
	VV_DROPDOWN_OPTION(VV_HK_ATOM_EXPLODE, "Создать взрыв")
	VV_DROPDOWN_OPTION(VV_HK_ATOM_EMP, "Создать ЭМИ")
	// End of Bastion of Endeavor Translation

/atom/vv_do_topic(list/href_list)
	. = ..()
	IF_VV_OPTION(VV_HK_ATOM_EXPLODE)
		if(!check_rights(R_DEBUG|R_FUN))
			return
		usr.client.cmd_admin_explosion(src)
		href_list["datumrefresh"] = "\ref[src]"
	IF_VV_OPTION(VV_HK_ATOM_EMP)
		if(!check_rights(R_DEBUG|R_FUN))
			return
		usr.client.cmd_admin_emp(src)
		href_list["datumrefresh"] = "\ref[src]"

/atom/vv_get_header()
	. = ..()
	var/custom_edit_name
	if(!isliving(src))
		custom_edit_name = "<a href='?_src_=vars;[HrefToken()];datumedit=\ref[src];varnameedit=name'><b>[src]</b></a>"
	. += {"
		[custom_edit_name]
		<br><font size='1'>
		<a href='?_src_=vars;[HrefToken()];rotatedatum=\ref[src];rotatedir=left'><<</a>
		<!-- Bastion of Endeavor Translation
		<a href='?_src_=vars;[HrefToken()];datumedit=\ref[src];varnameedit=dir'>[dir2text(dir)]</a>
		-->
		<a href='?_src_=vars;[HrefToken()];datumedit=\ref[src];varnameedit=dir'>[dir2text_ru(dir)]</a>
		<!-- End of Bastion of Endeavor Translation -->
		<a href='?_src_=vars;[HrefToken()];rotatedatum=\ref[src];rotatedir=right'>>></a>
		</font>
		"}
	var/turf/T = get_turf(src)
	. += "<br><font size='1'>[ADMIN_COORDJMP(T)]</font>"

/atom/vv_edit_var(var_name, var_value)
	switch(var_name)
		if(NAMEOF(src, light_range))
			if(light_system == STATIC_LIGHT)
				set_light(l_range = var_value)
			else
				set_light_range(var_value)
			. =  TRUE
		if(NAMEOF(src, light_power))
			if(light_system == STATIC_LIGHT)
				set_light(l_power = var_value)
			else
				set_light_power(var_value)
			. =  TRUE
		if(NAMEOF(src, light_color))
			if(light_system == STATIC_LIGHT)
				set_light(l_color = var_value)
			else
				set_light_color(var_value)
			. =  TRUE
		if(NAMEOF(src, light_on))
			set_light_on(var_value)
			. =  TRUE
		if(NAMEOF(src, light_flags))
			set_light_flags(var_value)
			. =  TRUE
		if(NAMEOF(src, opacity))
			set_opacity(var_value)
			. =  TRUE

	if(!isnull(.))
		datum_flags |= DF_VAR_EDITED
		return

	. = ..()

/atom/proc/atom_say(message)
	if(!message)
		return
	var/list/speech_bubble_hearers = list()
	for(var/mob/M in get_mobs_in_view(7, src))
		/* Bastion of Endeavor Translation: Bastion of Endeavor Note: Changing to ncase, kinda experimental
		M.show_message(span_npcsay("<span class='name'>[src]</span> [atom_say_verb], \"[message]\""), 2, null, 1)
		*/
		M.show_message(span_npcsay("<span class='name'>[cap_ru(src)]</span> [verb_ru(src, atom_say_verb)], \"[message]\""), 2, null, 1)
		// End of Bastion of Endeavor Translation
		if(M.client)
			speech_bubble_hearers += M.client

	if(length(speech_bubble_hearers))
		var/image/I = generate_speech_bubble(src, "[bubble_icon][say_test(message)]", FLY_LAYER)
		I.appearance_flags = APPEARANCE_UI_IGNORE_ALPHA
		INVOKE_ASYNC(GLOBAL_PROC, GLOBAL_PROC_REF(flick_overlay), I, speech_bubble_hearers, 30)

/atom/proc/speech_bubble(bubble_state = "", bubble_loc = src, list/bubble_recipients = list())
	return

/atom/Entered(atom/movable/AM, atom/old_loc)
	. = ..()
	SEND_SIGNAL(AM, COMSIG_OBSERVER_MOVED, old_loc, AM.loc)
	SEND_SIGNAL(src, COMSIG_ATOM_ENTERED, AM, old_loc)
	SEND_SIGNAL(AM, COMSIG_ATOM_ENTERING, src, old_loc)

/atom/Exit(atom/movable/AM, atom/new_loc)
	. = ..()
	if(SEND_SIGNAL(src, COMSIG_ATOM_EXIT, AM, new_loc) & COMPONENT_ATOM_BLOCK_EXIT)
		return FALSE

/atom/Exited(atom/movable/AM, atom/new_loc)
	. = ..()
	SEND_SIGNAL(src, COMSIG_ATOM_EXITED, AM, new_loc)

/atom/proc/get_visible_gender(mob/user, force)
	return gender

/atom/proc/interact(mob/user)
	return

// Purpose: Determines if the object can pass this atom.
// Called by: Movement.
// Inputs: The moving atom, target turf.
// Outputs: Boolean if can pass.
// Airflow and ZAS zones now uses CanZASPass() instead of this proc.
/atom/proc/CanPass(atom/movable/mover, turf/target)
	return !density


//! ## Atom Colour Priority System
/**
 * A System that gives finer control over which atom colour to colour the atom with.
 * The "highest priority" one is always displayed as opposed to the default of
 * "whichever was set last is displayed"
 */

/// Adds an instance of colour_type to the atom's atom_colours list
/atom/proc/add_atom_colour(coloration, colour_priority)
	if(!atom_colours || !atom_colours.len)
		atom_colours = list()
		atom_colours.len = COLOUR_PRIORITY_AMOUNT //four priority levels currently.
	if(!coloration)
		return
	if(colour_priority > atom_colours.len)
		return
	atom_colours[colour_priority] = coloration
	update_atom_colour()

/// Removes an instance of colour_type from the atom's atom_colours list
/atom/proc/remove_atom_colour(colour_priority, coloration)
	if(!atom_colours)
		atom_colours = list()
		atom_colours.len = COLOUR_PRIORITY_AMOUNT //four priority levels currently.
	if(colour_priority > atom_colours.len)
		return
	if(coloration && atom_colours[colour_priority] != coloration)
		return //if we don't have the expected color (for a specific priority) to remove, do nothing
	atom_colours[colour_priority] = null
	update_atom_colour()

/// Resets the atom's color to null, and then sets it to the highest priority colour available
/atom/proc/update_atom_colour()
	if(!atom_colours)
		atom_colours = list()
		atom_colours.len = COLOUR_PRIORITY_AMOUNT //four priority levels currently.
	color = null
	for(var/C in atom_colours)
		if(islist(C))
			var/list/L = C
			if(L.len)
				color = L
				return
		else if(C)
			color = C
			return
