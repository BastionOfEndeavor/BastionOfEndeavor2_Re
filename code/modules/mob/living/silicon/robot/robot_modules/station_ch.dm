//TFF 5/1/20 - Add Ore Scanner for mining drones
/obj/item/weapon/robot_module/drone/mining/New()
	..()
	src.modules += new /obj/item/weapon/mining_scanner(src)

/obj/item/weapon/robot_module/robot/engineering/New()
	..()
	src.modules += new /obj/item/weapon/pipe_dispenser(src)


/obj/item/weapon/robot_module/robot/medihound/New()
	..()
	src.modules += new /obj/item/weapon/autopsy_scanner(src)
	src.modules += new /obj/item/weapon/surgical/scalpel/cyborg(src)
	src.modules += new /obj/item/weapon/surgical/hemostat/cyborg(src)
	src.modules += new /obj/item/weapon/surgical/retractor/cyborg(src)
	src.modules += new /obj/item/weapon/surgical/cautery/cyborg(src)
	src.modules += new /obj/item/weapon/surgical/bonegel/cyborg(src)
	src.modules += new /obj/item/weapon/surgical/FixOVein/cyborg(src)
	src.modules += new /obj/item/weapon/surgical/bonesetter/cyborg(src)
	src.modules += new /obj/item/weapon/surgical/circular_saw/cyborg(src)
	src.modules += new /obj/item/weapon/surgical/surgicaldrill/cyborg(src)