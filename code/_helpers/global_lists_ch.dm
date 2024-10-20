
//Reagent Vore belly Sounds
GLOBAL_LIST_INIT(slosh, list(
	'sound/vore/walkslosh1.ogg',
	'sound/vore/walkslosh2.ogg',
	'sound/vore/walkslosh3.ogg',
	'sound/vore/walkslosh4.ogg',
	'sound/vore/walkslosh5.ogg',
	'sound/vore/walkslosh6.ogg',
	'sound/vore/walkslosh7.ogg',
	'sound/vore/walkslosh8.ogg',
	'sound/vore/walkslosh9.ogg',
	'sound/vore/walkslosh10.ogg'
))

var/global/list/item_tf_spawnpoints = list() // Global variable tracking which items are item tf spawnpoints

/var/global/list/existing_metroids = list() //Global variable for tracking metroids for the event announcement. Needs to go here for load order.

//stuff that only synths can eat
var/global/list/edible_tech = list(/obj/item/cell,
				/obj/item/circuitboard,
				/obj/item/integrated_circuit,
				/obj/item/broken_device,
				/obj/item/brokenbug,
				)

var/global/list/item_digestion_blacklist = list(
		/obj/item/hand_tele,
		/obj/item/card/id,
		/obj/item/gun,
		/obj/item/pinpointer,
		/obj/item/clothing/shoes/magboots,
		/obj/item/areaeditor/blueprints,
		/obj/item/disk/nuclear,
		/obj/item/perfect_tele_beacon,
		/obj/item/organ/internal/brain/slime,
		/obj/item/mmi/digital/posibrain,
		/obj/item/mmi/digital/robot,
		/obj/item/rig/protean)

// Options for transforming into a different mob in virtual reality.
var/global/list/vr_mob_tf_options = list(
	/* Bastion of Endeavor Translation: Bastion of Endeavor TODO: Oh dear god here we go. Double check when localizing simplemobs
	"Borg" = /mob/living/silicon/robot,
	"Cortical borer" = /mob/living/simple_mob/animal/borer/non_antag,
	"Hyena" = /mob/living/simple_mob/animal/hyena,
	"Giant spider" = /mob/living/simple_mob/animal/giant_spider/thermic,
	"Armadillo" = /mob/living/simple_mob/animal/passive/armadillo,
	"Parrot" = /mob/living/simple_mob/animal/passive/bird/parrot,
	"Cat" = /mob/living/simple_mob/animal/passive/cat,
	"Corgi" = /mob/living/simple_mob/animal/passive/dog/corgi,
	"Squirrel" = /mob/living/simple_mob/vore/squirrel,
	"Frog" = /mob/living/simple_mob/vore/aggressive/frog,
	"Seagull" =/mob/living/simple_mob/vore/seagull,
	"Fox" = /mob/living/simple_mob/animal/passive/fox,
	"Racoon" = /mob/living/simple_mob/animal/passive/raccoon_ch,
	"Shantak" = /mob/living/simple_mob/animal/sif/shantak,
	"Goose" = /mob/living/simple_mob/animal/space/goose,
	"Space shark" = /mob/living/simple_mob/animal/space/shark,
	"Synx" = /mob/living/simple_mob/animal/synx,
	"Dire wolf" = /mob/living/simple_mob/vore/wolf/direwolf,
	"Construct Artificer" = /mob/living/simple_mob/construct/artificer,
	"Tech golem" = /mob/living/simple_mob/mechanical/technomancer_golem,
	"Metroid" = /mob/living/simple_mob/metroid/juvenile/baby,
	"Otie" = /mob/living/simple_mob/vore/otie/cotie/chubby,
	"Red-eyed Shadekin" = /mob/living/simple_mob/shadekin/red,
	"Blue-eyed Shadekin" = /mob/living/simple_mob/shadekin/blue,
	"Purple-eyed Shadekin" = /mob/living/simple_mob/shadekin/purple,
	"Green-eyed Shadekin" = /mob/living/simple_mob/shadekin/green,
	"Yellow-eyed Shadekin" = /mob/living/simple_mob/shadekin/yellow,
	"Slime" = /mob/living/simple_mob/slime/xenobio/metal,
	"Corrupt hound" = /mob/living/simple_mob/vore/aggressive/corrupthound,
	"Deathclaw" = /mob/living/simple_mob/vore/aggressive/deathclaw/den,
	"Weretiger" = /mob/living/simple_mob/vore/weretiger,
	"Mimic" = /mob/living/simple_mob/vore/aggressive/mimic/floor/plating,
	"Giant rat" = /mob/living/simple_mob/vore/aggressive/rat,
	"Catslug" = /mob/living/simple_mob/vore/alienanimals/catslug,
	"Dust jumper" = /mob/living/simple_mob/vore/alienanimals/dustjumper,
	"Space ghost" = /mob/living/simple_mob/vore/alienanimals/spooky_ghost,
	"Teppi" = /mob/living/simple_mob/vore/alienanimals/teppi,
	"Bee" = /mob/living/simple_mob/vore/bee,
	"Dragon" = /mob/living/simple_mob/vore/bigdragon/friendly,
	"Riftwalker" = /mob/living/simple_mob/vore/demon/wendigo,
	"Horse" = /mob/living/simple_mob/vore/horse/big,
	"Morph" = /mob/living/simple_mob/vore/morph,
	"Leopardmander" = /mob/living/simple_mob/vore/leopardmander,
	"Rabbit" = /mob/living/simple_mob/vore/rabbit,
	"Red panda" = /mob/living/simple_mob/vore/redpanda,
	"Sect drone" = /mob/living/simple_mob/vore/sect_drone,
	"Armalis vox" = /mob/living/simple_mob/vox/armalis,
	"Xeno hunter" = /mob/living/simple_mob/xeno_ch/hunter,
	"Xeno queen" = /mob/living/simple_mob/xeno_ch/queen/maid,
	"Xeno sentinel" = /mob/living/simple_mob/xeno_ch/sentinel,
	"Space carp" = /mob/living/simple_mob/animal/space/carp,
	"Jelly blob" = /mob/living/simple_mob/vore/jelly,
	"SWOOPIE XL" = /mob/living/simple_mob/vore/aggressive/corrupthound/swoopie,
	"Abyss lurker" = /mob/living/simple_mob/vore/vore_hostile/abyss_lurker,
	"Abyss leaper" = /mob/living/simple_mob/vore/vore_hostile/leaper,
<<<<<<< HEAD
	"Gelatinous cube" = /mob/living/simple_mob/vore/vore_hostile/gelatinous_cube)
	*/
	"Борг" = /mob/living/silicon/robot,
	"Мозговой бурильщик" = /mob/living/simple_mob/animal/borer/non_antag,
	"Гиена" = /mob/living/simple_mob/animal/hyena,
	"Гигантский паук" = /mob/living/simple_mob/animal/giant_spider/thermic,
	"Броненосец" = /mob/living/simple_mob/animal/passive/armadillo,
	"Попугай" = /mob/living/simple_mob/animal/passive/bird/parrot,
	"Кот" = /mob/living/simple_mob/animal/passive/cat, // might wanna code a gender check
	"Корги" = /mob/living/simple_mob/animal/passive/dog/corgi,
	"Белка" = /mob/living/simple_mob/vore/squirrel,
	"Лягушка" = /mob/living/simple_mob/vore/aggressive/frog,
	"Чайка" =/mob/living/simple_mob/vore/seagull,
	"Лис" = /mob/living/simple_mob/animal/passive/fox,
	"Енот" = /mob/living/simple_mob/animal/passive/raccoon_ch,
	"Шантак" = /mob/living/simple_mob/animal/sif/shantak,
	"Гусь" = /mob/living/simple_mob/animal/space/goose,
	"Космическая акула" = /mob/living/simple_mob/animal/space/shark,
	"Синкс" = /mob/living/simple_mob/animal/synx,
	"Лютоволк" = /mob/living/simple_mob/vore/wolf/direwolf,
	"Творец конструктов" = /mob/living/simple_mob/construct/artificer, // no idea
	"Техноголем" = /mob/living/simple_mob/mechanical/technomancer_golem,
	"Метроид" = /mob/living/simple_mob/metroid/juvenile/baby,
	"Оти" = /mob/living/simple_mob/vore/otie/cotie/chubby,
	"Красноглазый тенерождённый" = /mob/living/simple_mob/shadekin/red,
	"Синеглазый тенерождённый" = /mob/living/simple_mob/shadekin/blue,
	"Фиолетовоглазый тенерождённый" = /mob/living/simple_mob/shadekin/purple,
	"Зеленоглазый тенерождённый" = /mob/living/simple_mob/shadekin/green,
	"Жёлтоглазый тенерождённый" = /mob/living/simple_mob/shadekin/yellow,
	"Слизень" = /mob/living/simple_mob/slime/xenobio/metal,
	"Испорченный робопёс" = /mob/living/simple_mob/vore/aggressive/corrupthound,
	"Коготь смерти" = /mob/living/simple_mob/vore/aggressive/deathclaw/den,
	"Тигроборотень" = /mob/living/simple_mob/vore/weretiger,
	"Мимик" = /mob/living/simple_mob/vore/aggressive/mimic/floor/plating,
	"Гигантская крыса" = /mob/living/simple_mob/vore/aggressive/rat,
	"Слизнекот" = /mob/living/simple_mob/vore/alienanimals/catslug,
	"Дюнный попрыгун" = /mob/living/simple_mob/vore/alienanimals/dustjumper, // no
	"Космический призрак" = /mob/living/simple_mob/vore/alienanimals/spooky_ghost,
	"Теппи" = /mob/living/simple_mob/vore/alienanimals/teppi,
	"Пчела" = /mob/living/simple_mob/vore/bee,
	//"Dragon" = /mob/living/simple_mob/vore/bigdragon/friendly, //Currently adds 12 bellies to the user when transformed into. Do not uncomment without fixing this.
	"Вендиго" = /mob/living/simple_mob/vore/demon/wendigo,
	"Лошадь" = /mob/living/simple_mob/vore/horse/big,
	"Метаморф" = /mob/living/simple_mob/vore/morph,
	"Леопардмандер" = /mob/living/simple_mob/vore/leopardmander,
	"Кролик" = /mob/living/simple_mob/vore/rabbit,
	"Красная панда" = /mob/living/simple_mob/vore/redpanda,
	"Трутень" = /mob/living/simple_mob/vore/sect_drone,
	"Вокс армалис" = /mob/living/simple_mob/vox/armalis,
	"Ксеноморф-охотник" = /mob/living/simple_mob/xeno_ch/hunter,
	"Ксеноморф-королева" = /mob/living/simple_mob/xeno_ch/queen/maid,
	"Ксеноморф-страж" = /mob/living/simple_mob/xeno_ch/sentinel,
	"Космический карп" = /mob/living/simple_mob/animal/space/carp,
	"Желеобразная глыба" = /mob/living/simple_mob/vore/jelly,
	"ПЫЛЕЖОР ДЕЛЮКС" = /mob/living/simple_mob/vore/aggressive/corrupthound/swoopie,
	"Наблюдатель бездны" = /mob/living/simple_mob/vore/vore_hostile/abyss_lurker,
	"Прыгун бездны" = /mob/living/simple_mob/vore/vore_hostile/leaper,
	"Желеобразный куб" = /mob/living/simple_mob/vore/vore_hostile/gelatinous_cube)
	// End of Bastion of Endeavor Translation
=======
	"Gelatinous cube" = /mob/living/simple_mob/vore/vore_hostile/gelatinous_cube,
	"Gryphon" = /mob/living/simple_mob/vore/gryphon
	)
>>>>>>> 7454025939 (Add gryphon simplemob (#9253))

var/global/list/vr_mob_spawner_options = list(
	/* Bastion of Endeavor Translation
	"Parrot" = /mob/living/simple_mob/animal/passive/bird/parrot,
	"Rabbit" = /mob/living/simple_mob/vore/rabbit,
	"Cat" = /mob/living/simple_mob/animal/passive/cat,
	"Fox" = /mob/living/simple_mob/animal/passive/fox,
	"Cow" = /mob/living/simple_mob/animal/passive/cow,
	"Dog" = /mob/living/simple_mob/vore/woof,
	"Horse" = /mob/living/simple_mob/vore/horse/big,
	"Hippo" = /mob/living/simple_mob/vore/hippo,
	"Sheep" = /mob/living/simple_mob/vore/sheep,
	"Squirrel" = /mob/living/simple_mob/vore/squirrel,
	"Red panda" = /mob/living/simple_mob/vore/redpanda,
	"Fennec" = /mob/living/simple_mob/vore/fennec,
	"Seagull" =/mob/living/simple_mob/vore/seagull,
	"Corgi" = /mob/living/simple_mob/animal/passive/dog/corgi,
	"Armadillo" = /mob/living/simple_mob/animal/passive/armadillo,
	"Racoon" = /mob/living/simple_mob/animal/passive/raccoon_ch,
	"Goose" = /mob/living/simple_mob/animal/space/goose,
	"Frog" = /mob/living/simple_mob/vore/aggressive/frog,
	"Dust jumper" = /mob/living/simple_mob/vore/alienanimals/dustjumper,
	"Dire wolf" = /mob/living/simple_mob/vore/wolf/direwolf,
	"Space bumblebee" = /mob/living/simple_mob/vore/bee,
	"Space bear" = /mob/living/simple_mob/animal/space/bear,
	"Otie" = /mob/living/simple_mob/vore/otie,
	"Mutated otie" =/mob/living/simple_mob/vore/otie/feral,
	"Red otie" = /mob/living/simple_mob/vore/otie/red,
	"Giant rat" = /mob/living/simple_mob/vore/aggressive/rat,
	"Giant snake" = /mob/living/simple_mob/vore/aggressive/giant_snake,
	"Hyena" = /mob/living/simple_mob/animal/hyena,
	"Space shark" = /mob/living/simple_mob/animal/space/shark,
	"Shantak" = /mob/living/simple_mob/animal/sif/shantak,
	"Kururak" = /mob/living/simple_mob/animal/sif/kururak,
	"Teppi" = /mob/living/simple_mob/vore/alienanimals/teppi,
	"Slug" = /mob/living/simple_mob/vore/slug,
	"Catslug" = /mob/living/simple_mob/vore/alienanimals/catslug,
	"Weretiger" = /mob/living/simple_mob/vore/weretiger,
	"Dust jumper" = /mob/living/simple_mob/vore/alienanimals/dustjumper,
	"Star treader" = /mob/living/simple_mob/vore/alienanimals/startreader,
	"Space ghost" = /mob/living/simple_mob/vore/alienanimals/spooky_ghost,
	"Space carp" = /mob/living/simple_mob/animal/space/carp,
	"Space jelly fish" = /mob/living/simple_mob/vore/alienanimals/space_jellyfish,
	"Abyss lurker" = /mob/living/simple_mob/vore/vore_hostile/abyss_lurker,
	"Abyss leaper" = /mob/living/simple_mob/vore/vore_hostile/leaper,
	"Gelatinous cube" = /mob/living/simple_mob/vore/vore_hostile/gelatinous_cube,
	"Panther" = /mob/living/simple_mob/vore/aggressive/panther,
	"Lizard man" = /mob/living/simple_mob/vore/aggressive/lizardman,
	"Pakkun" = /mob/living/simple_mob/vore/pakkun,
	"Synx" = /mob/living/simple_mob/animal/synx,
	"Jelly blob" = /mob/living/simple_mob/vore/jelly,
	"Voracious lizard" = /mob/living/simple_mob/vore/aggressive/dino,
	"Baby metroid" = /mob/living/simple_mob/metroid/juvenile/baby,
	"Super metroid" = /mob/living/simple_mob/metroid/juvenile/super,
	"Alpha metroid" = /mob/living/simple_mob/metroid/juvenile/alpha,
	"Gamma metroid" = /mob/living/simple_mob/metroid/juvenile/gamma,
	"Zeta metroid" = /mob/living/simple_mob/metroid/juvenile/zeta,
	"Omega metroid" = /mob/living/simple_mob/metroid/juvenile/omega,
	"Queen metroid" = /mob/living/simple_mob/metroid/juvenile/queen,
	"Xeno hunter" = /mob/living/simple_mob/animal/space/alien,
	"Xeno sentinel" = /mob/living/simple_mob/animal/space/alien/sentinel,
	"Xeno Praetorian" = /mob/living/simple_mob/animal/space/alien/sentinel/praetorian,
	"Xeno queen" = /mob/living/simple_mob/animal/space/alien/queen,
	"Xeno Empress" = /mob/living/simple_mob/animal/space/alien/queen/empress,
	"Xeno Queen Mother" = /mob/living/simple_mob/animal/space/alien/queen/empress/mother,
	"Defanged xeno" = /mob/living/simple_mob/vore/xeno_defanged,
	"Sect drone" = /mob/living/simple_mob/vore/sect_drone,
	"Sect queen" = /mob/living/simple_mob/vore/sect_queen,
	"Deathclaw" = /mob/living/simple_mob/vore/aggressive/deathclaw,
	"Great White Wolf" = /mob/living/simple_mob/vore/greatwolf,
	"Great Black Wolf" = /mob/living/simple_mob/vore/greatwolf/black,
	"Solar grub" = /mob/living/simple_mob/vore/solargrub,
	"Pitcher plant" = /mob/living/simple_mob/vore/pitcher_plant,
	"Red gummy kobold" = /mob/living/simple_mob/vore/candy/redcabold,
	"Blue gummy kobold" = /mob/living/simple_mob/vore/candy/bluecabold,
	"Yellow gummy kobold" = /mob/living/simple_mob/vore/candy/yellowcabold,
	"Marshmellow serpent" = /mob/living/simple_mob/vore/candy/marshmellowserpent,
	"Riftwalker" = /mob/living/simple_mob/vore/demon,
	"Wendigo" = /mob/living/simple_mob/vore/demon/wendigo,
	"Shadekin" = /mob/living/simple_mob/shadekin,
	"Catgirl" = /mob/living/simple_mob/vore/catgirl,
	"Wolfgirl" = /mob/living/simple_mob/vore/wolfgirl,
	"Wolftaur" = /mob/living/simple_mob/vore/wolftaur,
	"Lamia" = /mob/living/simple_mob/vore/lamia,
	"Corrupt hound" = /mob/living/simple_mob/vore/aggressive/corrupthound,
	"Corrupt corrupt hound" = /mob/living/simple_mob/vore/aggressive/corrupthound/prettyboi,
	"SWOOPIE XL" = /mob/living/simple_mob/vore/aggressive/corrupthound/swoopie,
	"Cultist Teshari" = /mob/living/simple_mob/humanoid/cultist/tesh,
	"Burning Mage" = /mob/living/simple_mob/humanoid/cultist/human/bloodjaunt/fireball,
	"Converted" = /mob/living/simple_mob/humanoid/cultist/noodle,
	"Cultist Teshari Mage" = /mob/living/simple_mob/humanoid/cultist/castertesh,
	"Monkey" = /mob/living/carbon/human/monkey,
	"Wolpin" = /mob/living/carbon/human/wolpin,
	"Sparra" = /mob/living/carbon/human/sparram,
	"Saru" = /mob/living/carbon/human/sergallingm,
	"Sobaka" = /mob/living/carbon/human/sharkm,
	"Farwa" = /mob/living/carbon/human/farwa,
	"Neaera" = /mob/living/carbon/human/neaera,
<<<<<<< HEAD
	"Stok" = /mob/living/carbon/human/stok
	*/
	"Попугай" = /mob/living/simple_mob/animal/passive/bird/parrot,
	"Кролик" = /mob/living/simple_mob/vore/rabbit,
	"Кот" = /mob/living/simple_mob/animal/passive/cat,
	"Лис" = /mob/living/simple_mob/animal/passive/fox,
	"Корова" = /mob/living/simple_mob/animal/passive/cow,
	"Собака" = /mob/living/simple_mob/vore/woof,
	"Лошадь" = /mob/living/simple_mob/vore/horse/big,
	"Бегемот" = /mob/living/simple_mob/vore/hippo,
	"Овца" = /mob/living/simple_mob/vore/sheep,
	"Белка" = /mob/living/simple_mob/vore/squirrel,
	"Красная панда" = /mob/living/simple_mob/vore/redpanda,
	"Фенёк" = /mob/living/simple_mob/vore/fennec,
	"Чайка" =/mob/living/simple_mob/vore/seagull,
	"Корги" = /mob/living/simple_mob/animal/passive/dog/corgi,
	"Броненосец" = /mob/living/simple_mob/animal/passive/armadillo,
	"Енот" = /mob/living/simple_mob/animal/passive/raccoon_ch,
	"Гусь" = /mob/living/simple_mob/animal/space/goose,
	"Лягушка" = /mob/living/simple_mob/vore/aggressive/frog,
	"Дюнный попрыгун" = /mob/living/simple_mob/vore/alienanimals/dustjumper,
	"Лютоволк" = /mob/living/simple_mob/vore/wolf/direwolf,
	"Космическая пчела" = /mob/living/simple_mob/vore/bee,
	"Космический медведь" = /mob/living/simple_mob/animal/space/bear,
	"Оти" = /mob/living/simple_mob/vore/otie,
	"Оти-мутант" =/mob/living/simple_mob/vore/otie/feral,
	"Красный оти" = /mob/living/simple_mob/vore/otie/red,
	"Гигантская крыса" = /mob/living/simple_mob/vore/aggressive/rat,
	"Гигантская змея" = /mob/living/simple_mob/vore/aggressive/giant_snake,
	"Гиена" = /mob/living/simple_mob/animal/hyena,
	"Космическая акула" = /mob/living/simple_mob/animal/space/shark,
	"Шантак" = /mob/living/simple_mob/animal/sif/shantak,
	"Курурак" = /mob/living/simple_mob/animal/sif/kururak,
	"Теппи" = /mob/living/simple_mob/vore/alienanimals/teppi,
	"Слизняк" = /mob/living/simple_mob/vore/slug,
	"Слизнекот" = /mob/living/simple_mob/vore/alienanimals/catslug,
	"Тигроборотень" = /mob/living/simple_mob/vore/weretiger,
	// "Dust jumper" = /mob/living/simple_mob/vore/alienanimals/dustjumper, // duplicate entry
	"Покоритель звёзд" = /mob/living/simple_mob/vore/alienanimals/startreader,
	"Космический призрак" = /mob/living/simple_mob/vore/alienanimals/spooky_ghost,
	"Космический карп" = /mob/living/simple_mob/animal/space/carp,
	"Космическая медуза" = /mob/living/simple_mob/vore/alienanimals/space_jellyfish,
	"Наблюдатель бездны" = /mob/living/simple_mob/vore/vore_hostile/abyss_lurker,
	"Прыгун бездны" = /mob/living/simple_mob/vore/vore_hostile/leaper,
	"Желеобразный куб" = /mob/living/simple_mob/vore/vore_hostile/gelatinous_cube,
	"Пантера" = /mob/living/simple_mob/vore/aggressive/panther,
	"Ящеролюд" = /mob/living/simple_mob/vore/aggressive/lizardman,
	"Паккун" = /mob/living/simple_mob/vore/pakkun,
	"Синкс" = /mob/living/simple_mob/animal/synx,
	"Желеобразная глыба" = /mob/living/simple_mob/vore/jelly,
	"Ненасытный ящер" = /mob/living/simple_mob/vore/aggressive/dino,
	"Молодой метроид" = /mob/living/simple_mob/metroid/juvenile/baby,
	"Супер метроид" = /mob/living/simple_mob/metroid/juvenile/super,
	"Альфа метроид" = /mob/living/simple_mob/metroid/juvenile/alpha,
	"Гамма метроид" = /mob/living/simple_mob/metroid/juvenile/gamma,
	"Зета метроид" = /mob/living/simple_mob/metroid/juvenile/zeta,
	"Омега метроид" = /mob/living/simple_mob/metroid/juvenile/omega,
	"Королева метроидов" = /mob/living/simple_mob/metroid/juvenile/queen,
	"Ксеноморф-охотник" = /mob/living/simple_mob/animal/space/alien,
	"Ксеноморф-страж" = /mob/living/simple_mob/animal/space/alien/sentinel,
	"Ксеноморф-преторианец" = /mob/living/simple_mob/animal/space/alien/sentinel/praetorian,
	"Ксеноморф-королева" = /mob/living/simple_mob/animal/space/alien/queen,
	"Ксеноморф-императрица" = /mob/living/simple_mob/animal/space/alien/queen/empress,
	"Ксеноморф-королева-мать" = /mob/living/simple_mob/animal/space/alien/queen/empress/mother,
	"Бесклыковый ксеноморф" = /mob/living/simple_mob/vore/xeno_defanged,
	"Трутень" = /mob/living/simple_mob/vore/sect_drone,
	"Королева трутней" = /mob/living/simple_mob/vore/sect_queen,
	"Коготь смерти" = /mob/living/simple_mob/vore/aggressive/deathclaw,
	"Великий белый волк" = /mob/living/simple_mob/vore/greatwolf,
	"Великий чёрный волк" = /mob/living/simple_mob/vore/greatwolf/black,
	"Солнечная личинка" = /mob/living/simple_mob/vore/solargrub,
	"Плотоядная кувшинка" = /mob/living/simple_mob/vore/pitcher_plant,
	"Красный мармеладный кобольд" = /mob/living/simple_mob/vore/candy/redcabold, // this isnt a kobold but ok
	"Синий мармеладный кобольд" = /mob/living/simple_mob/vore/candy/bluecabold,
	"Жёлтый мармеладный кобольд" = /mob/living/simple_mob/vore/candy/yellowcabold,
	"Зефирная змейка" = /mob/living/simple_mob/vore/candy/marshmellowserpent,
	"Странник разлома" = /mob/living/simple_mob/vore/demon,
	"Вендиго" = /mob/living/simple_mob/vore/demon/wendigo,
	"Тенерождённый" = /mob/living/simple_mob/shadekin,
	"Кошкодевочка" = /mob/living/simple_mob/vore/catgirl,
	"Волкодевочка" = /mob/living/simple_mob/vore/wolfgirl,
	"Волкотавр" = /mob/living/simple_mob/vore/wolftaur,
	"Ламия" = /mob/living/simple_mob/vore/lamia,
	"Испорченный робопёс " = /mob/living/simple_mob/vore/aggressive/corrupthound,
	"Испорченный испорченный робопёс" = /mob/living/simple_mob/vore/aggressive/corrupthound/prettyboi,
	"ПЫЛЕЖОР ДЕЛЮКС" = /mob/living/simple_mob/vore/aggressive/corrupthound/swoopie,
	"Тешари-культист" = /mob/living/simple_mob/humanoid/cultist/tesh,
	"Огненный маг" = /mob/living/simple_mob/humanoid/cultist/human/bloodjaunt/fireball,
	"Кобра-культист" = /mob/living/simple_mob/humanoid/cultist/noodle,
	"Тешари-культист-маг" = /mob/living/simple_mob/humanoid/cultist/castertesh,
	"Мартышка" = /mob/living/carbon/human/monkey,
	"Вольпин" = /mob/living/carbon/human/wolpin,
	"Спарра" = /mob/living/carbon/human/sparram,
	"Сару" = /mob/living/carbon/human/sergallingm,
	"Самэ" = /mob/living/carbon/human/sharkm, // i hate this but i'm not keeping the original name, this one is chosen for parity with saru
	"Фарва" = /mob/living/carbon/human/farwa,
	"Неера" = /mob/living/carbon/human/neaera,
	"Сток" = /mob/living/carbon/human/stok
	// End of Bastion of Endeavor Translation
=======
	"Stok" = /mob/living/carbon/human/stok,
	//"Gryphon" = /mob/living/simple_mob/vore/gryphon // Disabled until tested
>>>>>>> 7454025939 (Add gryphon simplemob (#9253))
	)

var/global/list/selectable_footstep = list(
	"Default" = FOOTSTEP_MOB_HUMAN,
	"Claw" = FOOTSTEP_MOB_CLAW,
	"Light Claw" = FOOTSTEP_MOB_TESHARI,
	"Slither" = FOOTSTEP_MOB_SLITHER,
)
