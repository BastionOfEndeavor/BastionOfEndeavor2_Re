/client/proc/pingfromtime(time)
	return ((world.time+world.tick_lag*world.tick_usage/100)-time)*100

/client/verb/display_ping(time as num)
	set instant = TRUE
	set name = ".display_ping"
<<<<<<< HEAD
	/* Bastion of Endeavor Translation
	to_chat(src, "<span class='notice'>Round trip ping took [round(pingfromtime(time),1)]ms</span>")
	*/
	to_chat(src, "<span class='notice'>Пинг составляет [round(pingfromtime(time),1)] мс.</span>")
	// End of Bastion of Endeavor Translation
=======
	to_chat(src, span_notice("Round trip ping took [round(pingfromtime(time),1)]ms"))
>>>>>>> ab154b48b2 ([MIRROR] refactors most spans (#9139))

/client/verb/ping()
	/* Bastion of Endeavor Translation
	set name = "Ping"
	set category = "OOC.Debug" //CHOMPEdit
	*/
	set name = "Пинг"
	set category = "OOC.Отладка"
	// End of Bastion of Endeavor Translation
	winset(src, null, "command=.display_ping+[world.time+world.tick_lag*world.tick_usage/100]") 
