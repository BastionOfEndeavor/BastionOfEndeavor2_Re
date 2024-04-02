
/client/New()
	..()
	dir = NORTH

/client/verb/spinleft()
	/* Bastion of Endeavor Translation: YES I REALLY JUST DID THIS, SUE ME
	set name = "Spin View CCW"
	*/
	set name = "Повернуть камеру ↻"
	// End of Bastion of Endeavor Translation
	set category = "OOC"
	dir = turn(dir, 90)

/client/verb/spinright()
	/* Bastion of Endeavor Translation
	set name = "Spin View CW"
	*/
	set name = "Повернуть камеру ↺"
	// End of Bastion of Endeavor Translation
	set category = "OOC"
	dir = turn(dir, -90)

