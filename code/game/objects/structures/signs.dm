<<<<<<< HEAD
/obj/structure/sign
	icon = 'icons/obj/decals.dmi'
	anchored = TRUE
	opacity = 0
	density = FALSE
	layer = SIGN_LAYER
	max_integrity = 100
	armor = list(melee = 50, bullet = 0, laser = 0, energy = 0, bomb = 0, bio = 0, rad = 0, fire = 50, acid = 50)
	var/buildable_sign = 1 //unwrenchable and modifiable

/obj/structure/sign/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/rad_insulation, RAD_NO_INSULATION) // Since this is on a wall if it becomes irradiated it will smuggle the radiation past the wall

/obj/structure/sign/basic
	name = "blank sign"
	desc = "How can signs be real if our eyes aren't real?"
	icon_state = "backing"

/obj/structure/sign/play_attack_sound(damage_amount, damage_type = BRUTE, damage_flag = 0)
	switch(damage_type)
		if(BRUTE)
			if(damage_amount)
				playsound(src.loc, 'sound/weapons/slash.ogg', 80, 1)
			else
				playsound(loc, 'sound/weapons/tap.ogg', 50, 1)
		if(BURN)
			playsound(loc, 'sound/items/welder.ogg', 80, 1)

/obj/structure/sign/attackby(obj/item/O, mob/user, params)
	if(istype(O, /obj/item/wrench) && buildable_sign)
		user.visible_message("<span class='notice'>[user] starts removing [src]...</span>", \
							 "<span class='notice'>You start unfastening [src].</span>")
		playsound(src, O.usesound, 50, 1)
		if(!do_after(user, 30*O.toolspeed, target = src))
			return
		playsound(src, 'sound/items/deconstruct.ogg', 50, 1)
		user.visible_message("<span class='notice'>[user] unfastens [src].</span>", \
							 "<span class='notice'>You unfasten [src].</span>")
		var/obj/item/sign_backing/SB = new (get_turf(user))
		SB.icon_state = icon_state
		SB.sign_path = type
		qdel(src)
	else if(istype(O, /obj/item/pen) && buildable_sign)
		var/list/sign_types = list("Secure Area", "Biohazard", "High Voltage", "Radiation", "Hard Vacuum Ahead", "Disposal: Leads To Space", "Danger: Fire", "No Smoking", "Medbay", "Science", "Chemistry", \
		"Hydroponics", "Xenobiology")
		var/obj/structure/sign/sign_type
		switch(input(user, "Select a sign type.", "Sign Customization") as null|anything in sign_types)
			if("Blank")
				sign_type = /obj/structure/sign/basic
			if("Secure Area")
				sign_type = /obj/structure/sign/securearea
			if("Biohazard")
				sign_type = /obj/structure/sign/biohazard
			if("High Voltage")
				sign_type = /obj/structure/sign/electricshock
			if("Radiation")
				sign_type = /obj/structure/sign/radiation
			if("Hard Vacuum Ahead")
				sign_type = /obj/structure/sign/vacuum
			if("Disposal: Leads To Space")
				sign_type = /obj/structure/sign/deathsposal
			if("Danger: Fire")
				sign_type = /obj/structure/sign/fire
			if("No Smoking")
				sign_type = /obj/structure/sign/nosmoking_1
			if("Medbay")
				sign_type = /obj/structure/sign/bluecross_2
			if("Science")
				sign_type = /obj/structure/sign/science
			if("Chemistry")
				sign_type = /obj/structure/sign/chemistry
			if("Hydroponics")
				sign_type = /obj/structure/sign/botany
			if("Xenobiology")
				sign_type = /obj/structure/sign/xenobio

		//Make sure user is adjacent still
		if(!Adjacent(user))
			return

		if(!sign_type)
			return

		//It's import to clone the pixel layout information
		//Otherwise signs revert to being on the turf and
		//move jarringly
		var/obj/structure/sign/newsign = new sign_type(get_turf(src))
		newsign.pixel_x = pixel_x
		newsign.pixel_y = pixel_y
		qdel(src)
	else
		return ..()

/obj/item/sign_backing
	name = "sign backing"
	desc = "A sign with adhesive backing."
	icon = 'icons/obj/decals.dmi'
	icon_state = "backing"
	w_class = WEIGHT_CLASS_NORMAL
	resistance_flags = FLAMMABLE
	var/sign_path = /obj/structure/sign/basic //the type of sign that will be created when placed on a turf

/obj/item/sign_backing/afterattack(atom/target, mob/user, proximity)
	if(isturf(target) && proximity)
		var/turf/T = target
		user.visible_message("<span class='notice'>[user] fastens [src] to [T].</span>", \
							 "<span class='notice'>You attach the sign to [T].</span>")
		playsound(T, 'sound/items/deconstruct.ogg', 50, 1)
		new sign_path(T)
		qdel(src)
	else
		return ..()

/obj/structure/sign/map
	name = "station map"
	desc = "A framed picture of the station."
	max_integrity = 500

/obj/structure/sign/map/left
	icon_state = "map-left"

/obj/structure/sign/map/left/dream
	icon_state = "map-left-DS"
	desc = "A framed picture of the station.\nClockwise from the top, you see Engineering(<b>yellow</b>), Arrivals(<b>blue and white</b>), Atmospherics(<b>yellow</b>), Security(<b>red</b>), \
	Cargo(<b>brown</b>), Science(<b>purple</b>), Escape(<b>red and white</b>), and Medbay(<b>blue</b>).\nIn the center of the station, you see the Bridge(<b>dark blue</b>).\n\
	Around those, you see Hallways/Entrances(<b>light grey</b>), Public Areas(<b>grey</b>), and Maintenance(<b>dark grey</b>)."

/obj/structure/sign/map/right
	icon_state = "map-right"

/obj/structure/sign/map/right/dream
	icon_state = "map-right-DS"
	desc = "A framed picture of the station.\nClockwise from the top, you see Engineering(<b>yellow</b>), Arrivals(<b>blue and white</b>), Atmospherics(<b>yellow</b>), Security(<b>red</b>), \
	Cargo(<b>brown</b>), Science(<b>purple</b>), Escape(<b>red and white</b>), and Medbay(<b>blue</b>).\nIn the center of the station, you see the Bridge(<b>dark blue</b>).\n\
	Around those, you see Hallways/Entrances(<b>light grey</b>), Public Areas(<b>grey</b>), and Maintenance(<b>dark grey</b>)."

/obj/structure/sign/securearea
	name = "\improper SECURE AREA"
	desc = "A warning sign which reads 'SECURE AREA'."
	icon_state = "securearea"

/obj/structure/sign/biohazard
	name = "\improper BIOHAZARD"
	desc = "A warning sign which reads 'BIOHAZARD'."
	icon_state = "bio"

/obj/structure/sign/electricshock
	name = "\improper HIGH VOLTAGE"
	desc = "A warning sign which reads 'HIGH VOLTAGE'."
	icon_state = "shock"

/obj/structure/sign/examroom
	name = "\improper EXAM ROOM"
	desc = "A guidance sign which reads 'EXAM ROOM'."
	icon_state = "examroom"

/obj/structure/sign/vacuum
	name = "\improper HARD VACUUM AHEAD"
	desc = "A warning sign which reads 'HARD VACUUM AHEAD'."
	icon_state = "space"

/obj/structure/sign/deathsposal
	name = "\improper DISPOSAL: LEADS TO SPACE"
	desc = "A warning sign which reads 'DISPOSAL: LEADS TO SPACE'."
	icon_state = "deathsposal"

/obj/structure/sign/pods
	name = "\improper ESCAPE PODS"
	desc = "A warning sign which reads 'ESCAPE PODS'."
	icon_state = "pods"

/obj/structure/sign/fire
	name = "\improper DANGER: FIRE"
	desc = "A warning sign which reads 'DANGER: FIRE'."
	icon_state = "fire"


/obj/structure/sign/nosmoking_1
	name = "\improper NO SMOKING"
	desc = "A warning sign which reads 'NO SMOKING'."
	icon_state = "nosmoking"


/obj/structure/sign/nosmoking_2
	name = "\improper NO SMOKING"
	desc = "A warning sign which reads 'NO SMOKING'."
	icon_state = "nosmoking2"

/obj/structure/sign/radiation
	name = "HAZARDOUS RADIATION"
	desc = "A warning sign alerting the user of potential radiation hazards."
	icon_state = "radiation"

/obj/structure/sign/bluecross
	name = "medbay"
	desc = "The Intergalactic symbol of Medical institutions. You'll probably get help here."
	icon_state = "bluecross"

/obj/structure/sign/bluecross_2
	name = "medbay"
	desc = "The Intergalactic symbol of Medical institutions. You'll probably get help here."
	icon_state = "bluecross2"

/obj/structure/sign/goldenplaque
	name = "The Most Robust Men Award for Robustness"
	desc = "To be Robust is not an action or a way of life, but a mental state. Only those with the force of Will strong enough to act during a crisis, saving friend from foe, are truly Robust. Stay Robust my friends."
	icon_state = "goldenplaque"

/obj/structure/sign/goldenplaque/captain
	name = "The Most Robust Captain Award for Robustness"

/obj/structure/sign/kiddieplaque
	name = "AI developers plaque"
	desc = "Next to the extremely long list of names and job titles, there is a drawing of a little child. The child appears to be retarded. Beneath the image, someone has scratched the word \"PACKETS\"."
	icon_state = "kiddieplaque"

/obj/structure/sign/kiddieplaque/badger
	name = "Remembrance Plaque"
	desc = "A plaque commemorating the fallen, may they rest in peace, forever asleep amongst the stars. Someone has drawn a picture of a crying badger at the bottom."

/obj/structure/sign/kiddieplaque/library
	name = "Library Rules Sign"
	desc = "A long list of rules to be followed when in the library, extolling the virtues of being quiet at all times and threatening those who would dare eat hot food inside."

/obj/structure/sign/kiddieplaque/perfect_man
	name = "\improper 'Perfect Man' sign"
	desc = "A guide to the exhibit, explaining how recent developments in mindshield implant and cloning technologies by Nanotrasen Corporation have led to the development and the effective immortality of the 'perfect man', the loyal Nanotrasen Employee."

/obj/structure/sign/kiddieplaque/perfect_drone
	name = "\improper 'Perfect Drone' sign"
	desc = "A guide to the drone shell dispenser, detailing the constructive and destructive applications of modern repair drones, as well as the development of the incorruptible cyborg servants of tomorrow, available today."

/obj/structure/sign/atmosplaque
	name = "\improper FEA Atmospherics Division plaque"
	desc = "This plaque commemorates the fall of the Atmos FEA division. For all the charred, dizzy, and brittle men who have died in its hands."
	icon_state = "atmosplaque"

/obj/structure/sign/atmosplaque/thunderdome
	name = "Thunderdome Plaque"
	desc = "This plaque commemorates those who have fallen in glorious combat.  For all the charred, dizzy, and beaten men who have died in its hands."

/obj/structure/sign/nanotrasen
	name = "\improper Nanotrasen Logo"
	desc = "A sign with the Nanotrasen Logo on it. Glory to Nanotrasen!"
	icon_state = "nanotrasen"

/obj/structure/sign/science			//These 3 have multiple types, just var-edit the icon_state to whatever one you want on the map
	name = "\improper SCIENCE"
	desc = "A sign labelling an area where research and science is performed."
	icon_state = "science1"

/obj/structure/sign/chemistry
	name = "\improper CHEMISTRY"
	desc = "A sign labelling an area containing chemical equipment."
	icon_state = "chemistry1"

/obj/structure/sign/botany
	name = "\improper HYDROPONICS"
	desc = "A sign labelling an area as a place where plants are grown."
	icon_state = "hydro1"

/obj/structure/sign/xenobio
	name = "\improper XENOBIOLOGY"
	desc = "A sign labelling an area as a place where xenobiological entities are researched."
	icon_state = "xenobio"

/obj/structure/sign/evac
	name = "\improper EVACUATION"
	desc = "A sign labelling an area where evacuation procedures take place."
	icon_state = "evac"

/obj/structure/sign/custodian
	name = "\improper CUSTODIAN"
	desc = "A sign labelling an area where the custodian works."
	icon_state = "custodian"

/obj/structure/sign/engineering
	name = "\improper ENGINEERING"
	desc = "A sign labelling an area where engineers work."
	icon_state = "engine"

/obj/structure/sign/cargo
	name = "\improper CARGO"
	desc = "A sign labelling an area where cargo ships dock."
	icon_state = "cargo"

/obj/structure/sign/security
	name = "\improper SECURITY"
	desc = "A sign labelling an area where the law is law."
	icon_state = "security"

/obj/structure/sign/holy
	name = "\improper HOLY"
	desc = "A sign labelling a religious area."
	icon_state = "holy"

/obj/structure/sign/restroom
	name = "\improper RESTROOM"
	desc = "A sign labelling a restroom."
	icon_state = "restroom"

/obj/structure/sign/xeno_warning_mining
	name = "DANGEROUS ALIEN LIFE"
	desc = "A sign that warns would-be travellers of hostile alien life in the vicinity."
	icon = 'icons/obj/mining.dmi'
	icon_state = "xeno_warning"

/obj/structure/sign/enginesafety
	name = "\improper ENGINEERING SAFETY"
	desc = "A sign detailing the various safety protocols when working on-site to ensure a safe shift."
	icon_state = "safety"

/obj/structure/sign/directions/science
	name = "science department"
	desc = "A direction sign, pointing out which way the Science department is."
	icon_state = "direction_sci"

/obj/structure/sign/directions/engineering
	name = "engineering department"
	desc = "A direction sign, pointing out which way the Engineering department is."
	icon_state = "direction_eng"

/obj/structure/sign/directions/security
	name = "security department"
	desc = "A direction sign, pointing out which way the Security department is."
	icon_state = "direction_sec"

/obj/structure/sign/directions/medical
	name = "medical bay"
	desc = "A direction sign, pointing out which way the Medical Bay is."
	icon_state = "direction_med"

/obj/structure/sign/directions/evac
	name = "escape arm"
	desc = "A direction sign, pointing out which way the escape shuttle dock is."
	icon_state = "direction_evac"

/obj/structure/sign/directions/supply
	name = "cargo bay"
	desc = "A direction sign, pointing out which way the Cargo Bay is."
	icon_state = "direction_supply"

/obj/structure/sign/directions/command
	name = "command department"
	desc = "A direction sign, pointing out which way the Command department is."
	icon_state = "direction_bridge"

/obj/structure/sign/logo
	name = "nanotrasen logo"
	desc = "The Nanotrasen corporate logo."
	icon_state = "nanotrasen_sign1"
=======
/obj/structure/sign
	icon = 'icons/obj/decals.dmi'
	anchored = TRUE
	opacity = 0
	density = FALSE
	layer = SIGN_LAYER
	max_integrity = 100
	armor = list(melee = 50, bullet = 0, laser = 0, energy = 0, bomb = 0, bio = 0, rad = 0, fire = 50, acid = 50)
	var/buildable_sign = 1 //unwrenchable and modifiable

/obj/structure/sign/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/rad_insulation, RAD_NO_INSULATION) // Since this is on a wall if it becomes irradiated it will smuggle the radiation past the wall

/obj/structure/sign/basic
	name = "blank sign"
	desc = "How can signs be real if our eyes aren't real?"
	icon_state = "backing"

/obj/structure/sign/play_attack_sound(damage_amount, damage_type = BRUTE, damage_flag = 0)
	switch(damage_type)
		if(BRUTE)
			if(damage_amount)
				playsound(src.loc, 'sound/weapons/slash.ogg', 80, 1)
			else
				playsound(loc, 'sound/weapons/tap.ogg', 50, 1)
		if(BURN)
			playsound(loc, 'sound/items/welder.ogg', 80, 1)

/obj/structure/sign/attackby(obj/item/O, mob/user, params)
	if(istype(O, /obj/item/wrench) && buildable_sign)
		user.visible_message("<span class='notice'>[user] starts removing [src]...</span>", \
							 "<span class='notice'>You start unfastening [src].</span>")
		playsound(src, O.usesound, 50, 1)
		if(!do_after(user, 30*O.toolspeed, target = src))
			return
		playsound(src, 'sound/items/deconstruct.ogg', 50, 1)
		user.visible_message("<span class='notice'>[user] unfastens [src].</span>", \
							 "<span class='notice'>You unfasten [src].</span>")
		var/obj/item/sign_backing/SB = new (get_turf(user))
		SB.icon_state = icon_state
		SB.sign_path = type
		qdel(src)
	else if(istype(O, /obj/item/pen) && buildable_sign)
		var/list/sign_types = list("Secure Area", "Biohazard", "High Voltage", "Radiation", "Hard Vacuum Ahead", "Disposal: Leads To Space", "Danger: Fire", "No Smoking", "Medbay", "Science", "Chemistry", \
		"Hydroponics", "Xenobiology")
		var/obj/structure/sign/sign_type
		switch(input(user, "Select a sign type.", "Sign Customization") as null|anything in sign_types)
			if("Blank")
				sign_type = /obj/structure/sign/basic
			if("Secure Area")
				sign_type = /obj/structure/sign/securearea
			if("Biohazard")
				sign_type = /obj/structure/sign/biohazard
			if("High Voltage")
				sign_type = /obj/structure/sign/electricshock
			if("Radiation")
				sign_type = /obj/structure/sign/radiation
			if("Hard Vacuum Ahead")
				sign_type = /obj/structure/sign/vacuum
			if("Disposal: Leads To Space")
				sign_type = /obj/structure/sign/deathsposal
			if("Danger: Fire")
				sign_type = /obj/structure/sign/fire
			if("No Smoking")
				sign_type = /obj/structure/sign/nosmoking_1
			if("Medbay")
				sign_type = /obj/structure/sign/bluecross_2
			if("Science")
				sign_type = /obj/structure/sign/science
			if("Chemistry")
				sign_type = /obj/structure/sign/chemistry
			if("Hydroponics")
				sign_type = /obj/structure/sign/botany
			if("Xenobiology")
				sign_type = /obj/structure/sign/xenobio

		//Make sure user is adjacent still
		if(!Adjacent(user))
			return

		if(!sign_type)
			return

		//It's import to clone the pixel layout information
		//Otherwise signs revert to being on the turf and
		//move jarringly
		var/obj/structure/sign/newsign = new sign_type(get_turf(src))
		newsign.pixel_x = pixel_x
		newsign.pixel_y = pixel_y
		qdel(src)
	else
		return ..()

/obj/item/sign_backing
	name = "sign backing"
	desc = "A sign with adhesive backing."
	icon = 'icons/obj/decals.dmi'
	icon_state = "backing"
	w_class = WEIGHT_CLASS_NORMAL
	resistance_flags = FLAMMABLE
	var/sign_path = /obj/structure/sign/basic //the type of sign that will be created when placed on a turf

/obj/item/sign_backing/afterattack(atom/target, mob/user, proximity)
	if(isturf(target) && proximity)
		var/turf/T = target
		user.visible_message("<span class='notice'>[user] fastens [src] to [T].</span>", \
							 "<span class='notice'>You attach the sign to [T].</span>")
		playsound(T, 'sound/items/deconstruct.ogg', 50, 1)
		new sign_path(T)
		qdel(src)
	else
		return ..()

/obj/structure/sign/map
	name = "station map"
	desc = "A framed picture of the station."
	max_integrity = 500

/obj/structure/sign/map/left
	icon_state = "map-left"

/obj/structure/sign/map/left/dream
	icon_state = "map-left-DS"
	desc = "A framed picture of the station.\nClockwise from the top, you see Engineering(<b>yellow</b>), Arrivals(<b>blue and white</b>), Atmospherics(<b>yellow</b>), Security(<b>red</b>), \
	Cargo(<b>brown</b>), Science(<b>purple</b>), Escape(<b>red and white</b>), and Medbay(<b>blue</b>).\nIn the center of the station, you see the Bridge(<b>dark blue</b>).\n\
	Around those, you see Hallways/Entrances(<b>light grey</b>), Public Areas(<b>grey</b>), and Maintenance(<b>dark grey</b>)."

/obj/structure/sign/map/right
	icon_state = "map-right"

/obj/structure/sign/map/right/dream
	icon_state = "map-right-DS"
	desc = "A framed picture of the station.\nClockwise from the top, you see Engineering(<b>yellow</b>), Arrivals(<b>blue and white</b>), Atmospherics(<b>yellow</b>), Security(<b>red</b>), \
	Cargo(<b>brown</b>), Science(<b>purple</b>), Escape(<b>red and white</b>), and Medbay(<b>blue</b>).\nIn the center of the station, you see the Bridge(<b>dark blue</b>).\n\
	Around those, you see Hallways/Entrances(<b>light grey</b>), Public Areas(<b>grey</b>), and Maintenance(<b>dark grey</b>)."

/obj/structure/sign/securearea
	name = "\improper SECURE AREA"
	desc = "A warning sign which reads 'SECURE AREA'."
	icon_state = "securearea"

/obj/structure/sign/biohazard
	name = "\improper BIOHAZARD"
	desc = "A warning sign which reads 'BIOHAZARD'."
	icon_state = "bio"

/obj/structure/sign/electricshock
	name = "\improper HIGH VOLTAGE"
	desc = "A warning sign which reads 'HIGH VOLTAGE'."
	icon_state = "shock"

/obj/structure/sign/examroom
	name = "\improper EXAM ROOM"
	desc = "A guidance sign which reads 'EXAM ROOM'."
	icon_state = "examroom"

/obj/structure/sign/vacuum
	name = "\improper HARD VACUUM AHEAD"
	desc = "A warning sign which reads 'HARD VACUUM AHEAD'."
	icon_state = "space"

/obj/structure/sign/deathsposal
	name = "\improper DISPOSAL: LEADS TO SPACE"
	desc = "A warning sign which reads 'DISPOSAL: LEADS TO SPACE'."
	icon_state = "deathsposal"

/obj/structure/sign/pods
	name = "\improper ESCAPE PODS"
	desc = "A warning sign which reads 'ESCAPE PODS'."
	icon_state = "pods"

/obj/structure/sign/fire
	name = "\improper DANGER: FIRE"
	desc = "A warning sign which reads 'DANGER: FIRE'."
	icon_state = "fire"


/obj/structure/sign/nosmoking_1
	name = "\improper NO SMOKING"
	desc = "A warning sign which reads 'NO SMOKING'."
	icon_state = "nosmoking"


/obj/structure/sign/nosmoking_2
	name = "\improper NO SMOKING"
	desc = "A warning sign which reads 'NO SMOKING'."
	icon_state = "nosmoking2"

/obj/structure/sign/radiation
	name = "HAZARDOUS RADIATION"
	desc = "A warning sign alerting the user of potential radiation hazards."
	icon_state = "radiation"

/obj/structure/sign/bluecross
	name = "medbay"
	desc = "The Intergalactic symbol of Medical institutions. You'll probably get help here."
	icon_state = "bluecross"

/obj/structure/sign/bluecross_2
	name = "medbay"
	desc = "The Intergalactic symbol of Medical institutions. You'll probably get help here."
	icon_state = "bluecross2"

/obj/structure/sign/goldenplaque
	name = "The Most Robust Men Award for Robustness"
	desc = "To be Robust is not an action or a way of life, but a mental state. Only those with the force of Will strong enough to act during a crisis, saving friend from foe, are truly Robust. Stay Robust my friends."
	icon_state = "goldenplaque"

/obj/structure/sign/goldenplaque/captain
	name = "The Most Robust Captain Award for Robustness"

/obj/structure/sign/kiddieplaque
	name = "AI developers plaque"
	desc = "Next to the extremely long list of names and job titles, there is a drawing of a little child. The child appears to be retarded. Beneath the image, someone has scratched the word \"PACKETS\"."
	icon_state = "kiddieplaque"

/obj/structure/sign/kiddieplaque/badger
	name = "Remembrance Plaque"
	desc = "A plaque commemorating the fallen, may they rest in peace, forever asleep amongst the stars. Someone has drawn a picture of a crying badger at the bottom."

/obj/structure/sign/kiddieplaque/library
	name = "Library Rules Sign"
	desc = "A long list of rules to be followed when in the library, extolling the virtues of being quiet at all times and threatening those who would dare eat hot food inside."

/obj/structure/sign/kiddieplaque/perfect_man
	name = "\improper 'Perfect Man' sign"
	desc = "A guide to the exhibit, explaining how recent developments in mindshield implant and cloning technologies by Nanotrasen Corporation have led to the development and the effective immortality of the 'perfect man', the loyal Nanotrasen Employee."

/obj/structure/sign/kiddieplaque/perfect_drone
	name = "\improper 'Perfect Drone' sign"
	desc = "A guide to the drone shell dispenser, detailing the constructive and destructive applications of modern repair drones, as well as the development of the incorruptible cyborg servants of tomorrow, available today."

/obj/structure/sign/atmosplaque
	name = "\improper FEA Atmospherics Division plaque"
	desc = "This plaque commemorates the fall of the Atmos FEA division. For all the charred, dizzy, and brittle men who have died in its hands."
	icon_state = "atmosplaque"

/obj/structure/sign/atmosplaque/thunderdome
	name = "Thunderdome Plaque"
	desc = "This plaque commemorates those who have fallen in glorious combat.  For all the charred, dizzy, and beaten men who have died in its hands."

/obj/structure/sign/nanotrasen
	name = "\improper Nanotrasen Logo"
	desc = "A sign with the Nanotrasen Logo on it. Glory to Nanotrasen!"
	icon_state = "nanotrasen"

/obj/structure/sign/science			//These 3 have multiple types, just var-edit the icon_state to whatever one you want on the map
	name = "\improper SCIENCE"
	desc = "A sign labelling an area where research and science is performed."
	icon_state = "science1"

/obj/structure/sign/chemistry
	name = "\improper CHEMISTRY"
	desc = "A sign labelling an area containing chemical equipment."
	icon_state = "chemistry1"

/obj/structure/sign/botany
	name = "\improper HYDROPONICS"
	desc = "A sign labelling an area as a place where plants are grown."
	icon_state = "hydro1"

/obj/structure/sign/xenobio
	name = "\improper XENOBIOLOGY"
	desc = "A sign labelling an area as a place where xenobiological entities are researched."
	icon_state = "xenobio"

/obj/structure/sign/evac
	name = "\improper EVACUATION"
	desc = "A sign labelling an area where evacuation procedures take place."
	icon_state = "evac"

/obj/structure/sign/custodian
	name = "\improper CUSTODIAN"
	desc = "A sign labelling an area where the custodian works."
	icon_state = "custodian"

/obj/structure/sign/engineering
	name = "\improper ENGINEERING"
	desc = "A sign labelling an area where engineers work."
	icon_state = "engine"

/obj/structure/sign/cargo
	name = "\improper CARGO"
	desc = "A sign labelling an area where cargo ships dock."
	icon_state = "cargo"

/obj/structure/sign/security
	name = "\improper SECURITY"
	desc = "A sign labelling an area where the law is law."
	icon_state = "security"

/obj/structure/sign/holy
	name = "\improper HOLY"
	desc = "A sign labelling a religious area."
	icon_state = "holy"

/obj/structure/sign/restroom
	name = "\improper RESTROOM"
	desc = "A sign labelling a restroom."
	icon_state = "restroom"

/obj/structure/sign/xeno_warning_mining
	name = "DANGEROUS ALIEN LIFE"
	desc = "A sign that warns would-be travellers of hostile alien life in the vicinity."
	icon = 'icons/obj/mining.dmi'
	icon_state = "xeno_warning"

/obj/structure/sign/enginesafety
	name = "\improper ENGINEERING SAFETY"
	desc = "A sign detailing the various safety protocols when working on-site to ensure a safe shift."
	icon_state = "safety"

/obj/structure/sign/directions/science
	name = "science department"
	desc = "A direction sign, pointing out which way the Science department is."
	icon_state = "direction_sci"

/obj/structure/sign/directions/engineering
	name = "engineering department"
	desc = "A direction sign, pointing out which way the Engineering department is."
	icon_state = "direction_eng"

/obj/structure/sign/directions/security
	name = "security department"
	desc = "A direction sign, pointing out which way the Security department is."
	icon_state = "direction_sec"

/obj/structure/sign/directions/medical
	name = "medical bay"
	desc = "A direction sign, pointing out which way the Medical Bay is."
	icon_state = "direction_med"

/obj/structure/sign/directions/evac
	name = "escape arm"
	desc = "A direction sign, pointing out which way the escape shuttle dock is."
	icon_state = "direction_evac"

/obj/structure/sign/directions/supply
	name = "cargo bay"
	desc = "A direction sign, pointing out which way the Cargo Bay is."
	icon_state = "direction_supply"

/obj/structure/sign/directions/command
	name = "command department"
	desc = "A direction sign, pointing out which way the Command department is."
	icon_state = "direction_bridge"

/obj/structure/sign/logo
	name = "nanotrasen logo"
	desc = "The Nanotrasen corporate logo."
	icon_state = "nanotrasen_sign1"
>>>>>>> 228af28... initial commit
