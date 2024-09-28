#undef VIS_COUNT

#define VIS_CH_STATUS_R		28
#define VIS_CH_HEALTH_VR	29
#define VIS_CH_BACKUP		30
#define VIS_CH_VANTAG		31

#define VIS_AUGMENTED		32

#define VIS_CH_STOMACH		33
#define VIS_SOULCATCHER		34 // CHOMPAdd

#define VIS_COUNT			34

//Protean organs
// Bastion of Endeavor TODO: I'm not sure if we need these translated here specifically, can't easily test it either
#define O_ORCH		"orchestrator"
#define O_FACT		"refactory"

//Alraune organs
#define A_FRUIT	"fruit gland"

//species defines

//station species
// Bastion of Endeavor TODO: Again, mob defines MIGHT stay unlocalized but we'll see
#define SPECIES_AKULA			"Akula"
#define SPECIES_ALRAUNE			"Alraune"
#define SPECIES_NEVREAN			"Nevrean"
#define SPECIES_PROTEAN			"Protean"
#define SPECIES_RAPALA			"Rapala"
#define SPECIES_SERGAL			"Sergal"
#define SPECIES_ALTEVIAN		"Altevian"
#define SPECIES_SHADEKIN_CREW	"Black-Eyed Shadekin"
#define SPECIES_VASILISSAN		"Vasilissan"
#define SPECIES_VULPKANIN		"Vulpkanin"
#define SPECIES_XENOCHIMERA		"Xenochimera"
#define SPECIES_ZORREN_HIGH		"Zorren"
#define SPECIES_CUSTOM			"Custom Species"
#define SPECIES_TAJARAN			"Tajara"
#define SPECIES_LLEILL			"Lleill"
#define SPECIES_HANNER			"Hanner"
//monkey species
#define SPECIES_MONKEY_AKULA		"Sobaka"
#define SPECIES_MONKEY_NEVREAN		"Sparra"
#define SPECIES_MONKEY_SERGAL		"Saru"
#define SPECIES_MONKEY_VULPKANIN	"Wolpin"
//event species
#define SPECIES_WEREBEAST			"Werebeast"
#define SPECIES_SHADEKIN			"Shadekin"
//custom species base sprites
#define SPECIES_FENNEC				"Fennec"
#define SPECIES_XENOHYBRID			"Xenohybrid"

//for custom bodytypes

#define SELECTS_BODYTYPE_FALSE			0
#define SELECTS_BODYTYPE_CUSTOM			1
#define SELECTS_BODYTYPE_SHAPESHIFTER	2

#define MARKING_NONDIGI_ONLY 		(1 << 0)
#define MARKING_DIGITIGRADE_ONLY 	(1 << 1)
#define MARKING_ALL_LEGS 			MARKING_NONDIGI_ONLY|MARKING_DIGITIGRADE_ONLY

//Grabs
#define UPGRADE_COOLDOWN	40
