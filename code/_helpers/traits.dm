#define TRAIT_CALLBACK_ADD(target, trait, source) CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(___TraitAdd), ##target, ##trait, ##source)
#define TRAIT_CALLBACK_REMOVE(target, trait, source) CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(___TraitRemove), ##target, ##trait, ##source)

///DO NOT USE ___TraitAdd OR ___TraitRemove as a replacement for ADD_TRAIT / REMOVE_TRAIT defines. To be used explicitly for callback.
/proc/___TraitAdd(target, trait, source)
	if(!target || !trait || !source)
		return

	if(islist(target))
		for(var/datum/listed_target in target)
			ADD_TRAIT(listed_target, trait, source)
		return

	/* Bastion of Endeavor Translation
	ASSERT(isdatum(target), "Invalid target used in TRAIT_CALLBACK_ADD! Expected a datum reference, got [target] instead.")
	*/
	ASSERT(isdatum(target), "Недопустимая цель в TRAIT_CALLBACK_ADD! Ожидалась ссылка на датум, получено: [target].")
	// End of Bastion of Endeavor Translation

	var/datum/datum_target = target
	ADD_TRAIT(datum_target, trait, source)

///DO NOT USE ___TraitAdd OR ___TraitRemove as a replacement for ADD_TRAIT / REMOVE_TRAIT defines. To be used explicitly for callback.
/proc/___TraitRemove(target, trait, source)
	if(!target || !trait || !source)
		return

	if(islist(target))
		for(var/datum/listed_target in target)
			REMOVE_TRAIT(listed_target, trait, source)
		return

	/* Bastion of Endeavor Translation
	ASSERT(isdatum(target), "Invalid target used in TRAIT_CALLBACK_REMOVE! Expected a datum reference, got [target] instead.")
	*/
	ASSERT(isdatum(target), "Недопустимая цель в TRAIT_CALLBACK_REMOVE! Ожидалась ссылка на датум, получено: [target].")
	// End of Bastion of Endeavor Translation

	var/datum/datum_target = target
	REMOVE_TRAIT(datum_target, trait, source)


/// Proc that handles adding multiple traits to a target via a list. Must have a common source and target.
/datum/proc/add_traits(list/list_of_traits, source)
	/* Bastion of Endeavor Translation
	ASSERT(islist(list_of_traits), "Invalid arguments passed to add_traits! Invoked on [src] with [list_of_traits], source being [source].")
	*/
	ASSERT(islist(list_of_traits), "Недопустимые аргументы в add_traits! Прок вызван на [src] с [list_of_traits], источник: [source].")
	// End of Bastion of Endeavor Translation
	for(var/trait in list_of_traits)
		ADD_TRAIT(src, trait, source)

/// Proc that handles removing multiple traits from a target via a list. Must have a common source and target.
/datum/proc/remove_traits(list/list_of_traits, source)
	/* Bastion of Endeavor Translation
	ASSERT(islist(list_of_traits), "Invalid arguments passed to remove_traits! Invoked on [src] with [list_of_traits], source being [source].")
	*/
	ASSERT(islist(list_of_traits), "Недопустимые аргументы в remove_traits! Прок вызван на [src] с [list_of_traits], источник: [source].")
	// End of Bastion of Endeavor Translation
	for(var/trait in list_of_traits)
		REMOVE_TRAIT(src, trait, source)
