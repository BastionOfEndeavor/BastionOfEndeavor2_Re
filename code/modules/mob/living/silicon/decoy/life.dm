/mob/living/silicon/decoy/Life()
	if (src.stat == 2)
		return
	else
		if (src.health <= CONFIG_GET(number/health_threshold_dead) && src.stat != 2) // CHOMPEdit
			death()
			return


/mob/living/silicon/decoy/updatehealth()
	if(status_flags & GODMODE)
		health = 100
		set_stat(CONSCIOUS)
	else
		health = 100 - getOxyLoss() - getToxLoss() - getFireLoss() - getBruteLoss()
