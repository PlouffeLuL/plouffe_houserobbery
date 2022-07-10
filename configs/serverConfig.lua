Server = {
	WebHook = "",
	LogWebHook = "",
	Init = false,
	lootables = {},
	avaiblePlayers = {},
	onJobPlayers = {},
	-- processTimer = math.random(1000),
	processTimer = math.random(1000 * 60 * 1, 1000 * 60 * 5),
	processThreadActive = false,
	currentlyActiveZones = {},
	acceptedPlayerJobs = {},
	houseData = {
		high = {},
		medium = {},
		low = {}
	},
	createHouse = {
		high = {},
		medium = {},
		low = {}
	},
	ignoredHouse = {
		high = {},
		medium = {},
		low = {}
	},
	cooldown = {},
	cooldownThreadTimer = 1000 * 60 * 30,
	cooldownClearTimer = 1 * 60 * 120
}

Hr = {}
HrFnc = {} 

Hr.Player = {}

Hr.Props = {}

Hr.SavedNames = {}

Hr.Utils = {
	ped = 0,
	pedCoords = vector3(0,0,0),
	isInHouse = false,
	houseEntry = vector3(0,0,0),
	waitingToAcceptJob = false,
	lockpickSucces = false,
	skillCheckSucces = false,
	currentHouseId = 0,
	policeJobs = {"police"}
}

Hr.Coords = {
	registerForHouseRobbery = {
		name = "registerForHouseRobbery",
		coords = vector3(-319.8395690918, -1394.1025390625, 36.500106811523),
		maxDst = 2.0,
		protectEvents = true,
		isKey = true,
		isZone = true,
		isPed = true,
		nuiLabel = "S'enregistrer pour du travail",
		keyMap = {
			checkCoordsBeforeTrigger = true,
			onRelease = true,
			releaseEvent = "plouffe_houserobbery:register",
			key = "E"
		},
		pedInfo = {
			coords = vector3(-319.8395690918, -1394.1025390625, 36.500106811523),
			heading = 90.762008666992,
			model = 's_m_m_migrant_01', 
			scenario = 'WORLD_HUMAN_COP_IDLES',
			pedId = 0,
		}
	}
}

Hr.Houses = {
	high = {
		doors = {},
		shells = {
			{
				ped = {dogChances = 7, ownerChances = 5, coords = vector3(2.2, 8.6, 0.0)},
				model = "furnitured_midapart",
				offSets = {
					{coords = vector3(1.5, -10.0, 0.0), type = "exit"}, -- NEEEEEEEEEEEEEEEEEEEEEED TO BE THE FIRST ONE CAUSE IM BS
					{coords = vector3(4.3, -5.0, 0.0), type = "smallcabinet"}, -- -- Premier petit meuble bs dans l'entré
					{coords = vector3(1.0, 1.5, 0.0), type = "cabinet"}, -- Deuxieme petit meuble bs dans l'entré
					{coords = vector3(6.3, 3.6, 0.0), type = "smallcabinet"}, -- Meuble blanc bs dans la chambre
					{coords = vector3(6.1, 9.3, 0.0), type = "largecabinet"}, -- Armoir blanche bs dans la chambre de bs
					{coords = vector3(4.1, 8.0, 0.0), type = "smallcabinet"}, -- Table de nuit
					{coords = vector3(2.2, 8.6, 0.0), type = "cabinet"}, -- -- Robinet Chambre de bain
					{coords = vector3(0.2, 9.7, 0.0), type = "largecabinet"}, -- etagere 1
					{coords = vector3(0.2, 8.3, 0.0), type = "largecabinet"}, -- etagere 2
					{coords = vector3(0.2, 7.2, 0.0), type = "largecabinet"}, -- etagere 3 
					{coords = vector3(0.2, 5.8, 0.0), type = "largecabinet"}, -- etagere 4
					{coords = vector3(-7.1, 4.5, 0.0), type = "largecabinet"}, -- Gauche de la tv
					{coords = vector3(-7.1, 7.8, 0.0), type = "largecabinet"}, -- Droite de la tv
					{coords = vector3(-1.1, 0.7, 0.0), type = "cabinet"}, -- Cuisine 1
					{coords = vector3(-2.5, -0.5, 0.0), type = "cabinet"}, -- Cuisine 2
					{coords = vector3(-4.5, -0.5, 0.0), type = "cabinet"} -- Meuble Bs Sale a manger
				}
			}
		},
	},
	medium = {
		doors = {},
		shells = {
			{
				ped = {dogChances = 4, ownerChances = 4, coords = vector3(2.2, 8.6, 0.0)},
				model = "furnitured_midapart",
				offSets = {
					{coords = vector3(1.5, -10.0, 0.0), type = "exit"}, --
					{coords = vector3(4.3, -5.0, 0.0), type = "smallcabinet"}, -- -- Premier petit meuble bs dans l'entré
					{coords = vector3(1.0, 1.5, 0.0), type = "cabinet"}, -- Deuxieme petit meuble bs dans l'entré
					{coords = vector3(6.3, 3.6, 0.0), type = "smallcabinet"}, -- Meuble blanc bs dans la chambre
					{coords = vector3(6.1, 9.3, 0.0), type = "largecabinet"}, -- Armoir blanche bs dans la chambre de bs
					{coords = vector3(4.1, 8.0, 0.0), type = "smallcabinet"}, -- Table de nuit
					{coords = vector3(2.2, 8.6, 0.0), type = "cabinet"}, -- -- Robinet Chambre de bain
					{coords = vector3(0.2, 9.7, 0.0), type = "largecabinet"}, -- etagere 1
					{coords = vector3(0.2, 8.3, 0.0), type = "largecabinet"}, -- etagere 2
					{coords = vector3(0.2, 7.2, 0.0), type = "largecabinet"}, -- etagere 3 
					{coords = vector3(0.2, 5.8, 0.0), type = "largecabinet"}, -- etagere 4
					{coords = vector3(-7.1, 4.5, 0.0), type = "largecabinet"}, -- Gauche de la tv
					{coords = vector3(-7.1, 7.8, 0.0), type = "largecabinet"}, -- Droite de la tv
					{coords = vector3(-1.1, 0.7, 0.0), type = "cabinet"}, -- Cuisine 1
					{coords = vector3(-2.5, -0.5, 0.0), type = "cabinet"}, -- Cuisine 2
					{coords = vector3(-4.5, -0.5, 0.0), type = "cabinet"} -- Meuble Bs Sale a manger
				}
			}
		}
	},
	low = {
		doors = {},
		shells = {
			{
				ped = {dogChances = 3, ownerChances = 2, coords = vector3(2.2, 8.6, 0.0)},
				model = "furnitured_midapart",
				offSets = {
					{coords = vector3(1.5, -10.0, 0.0), type = "exit"}, --
					{coords = vector3(4.3, -5.0, 0.0), type = "smallcabinet"}, -- -- Premier petit meuble bs dans l'entré
					{coords = vector3(1.0, 1.5, 0.0), type = "cabinet"}, -- Deuxieme petit meuble bs dans l'entré
					{coords = vector3(6.3, 3.6, 0.0), type = "smallcabinet"}, -- Meuble blanc bs dans la chambre
					{coords = vector3(6.1, 9.3, 0.0), type = "largecabinet"}, -- Armoir blanche bs dans la chambre de bs
					{coords = vector3(4.1, 8.0, 0.0), type = "smallcabinet"}, -- Table de nuit
					{coords = vector3(2.2, 8.6, 0.0), type = "cabinet"}, -- -- Robinet Chambre de bain
					{coords = vector3(0.2, 9.7, 0.0), type = "largecabinet"}, -- etagere 1
					{coords = vector3(0.2, 8.3, 0.0), type = "largecabinet"}, -- etagere 2
					{coords = vector3(0.2, 7.2, 0.0), type = "largecabinet"}, -- etagere 3 
					{coords = vector3(0.2, 5.8, 0.0), type = "largecabinet"}, -- etagere 4
					{coords = vector3(-7.1, 4.5, 0.0), type = "largecabinet"}, -- Gauche de la tv
					{coords = vector3(-7.1, 7.8, 0.0), type = "largecabinet"}, -- Droite de la tv
					{coords = vector3(-1.1, 0.7, 0.0), type = "cabinet"}, -- Cuisine 1
					{coords = vector3(-2.5, -0.5, 0.0), type = "cabinet"}, -- Cuisine 2
					{coords = vector3(-4.5, -0.5, 0.0), type = "cabinet"} -- Meuble Bs Sale a manger
				}
			}
		}
	}
}

Hr.Loots = {
	high = {
		smallcabinet = {
			{item = "money", amount = math.random(200, 500), chances = math.random(0,10)},
			{item = "oxy", amount = 3, chances = math.random(0,10)},
			{item = "lockpick", amount = 1, chances = math.random(0,10)},
			{item = "cuffs", amount = 1, chances = math.random(0,10)},
			{item = "cuff_keys", amount = 1, chances = math.random(0,10)},
			{item = "plantpot", amount = 1, chances = math.random(0,10)},
			{item = "lithium", amount = 1, chances = math.random(0,10)},
			{item = "methkit", amount = 1, chances = math.random(0,10)},
			{item = "ephedrine", amount = 1, chances = math.random(0,10)},
			{item = "nitro", amount = 1, chances = math.random(0,10)},
			{item = "plastic", amount = 1, chances = math.random(0,10)},
			{item = "steel", amount = 1, chances = math.random(0,10)},
			{item = "allum", amount = 1, chances = math.random(0,10)},
			{item = "gsr_purel", amount = 1, chances = math.random(0,10)},
			{item = "oxygen_mask", amount = 1, chances = math.random(0,10)},
			{item = "bulletproof", amount = 1, chances = math.random(0,10)},
			{item = "binoculars", amount = 1, chances = math.random(0,10)},
			{item = "fishingrod", amount = 1, chances = math.random(0,10)},
			{item = "wine_yeast", amount = 1, chances = math.random(0,10)},
			{item = "wine_sugar", amount = 1, chances = math.random(0,10)},
			{item = "vine_barrel", amount = 1, chances = math.random(0,10)},
			{item = "useless_papers", amount = 1, chances = math.random(0,10)},
			{item = "sponge", amount = 1, chances = math.random(0,10)},
			{item = "card_shop", amount = 1, chances = math.random(0,10)},
			{item = "drill_bit", amount = 1, chances = math.random(0,10)},
			{item = "grinder_disc", amount = 1, chances = math.random(0,10)},
			{item = "diamond_ring", amount = 1, chances = math.random(0,10)},
			{item = "gold_chain", amount = 1, chances = math.random(0,10)},
			{item = "gold_ring", amount = 1, chances = math.random(0,10)},
			{item = "gold_watch", amount = 1, chances = math.random(0,10)},
			{item = "silver_watch", amount = 1, chances = math.random(0,10)},
			{item = "gauze", amount = 1, chances = math.random(0,10)},
			{item = "bandage", amount = 1, chances = math.random(0,10)},
			{item = "beer", amount = 1, chances = math.random(0,10)},
			{item = "cigar", amount = 1, chances = math.random(0,10)},
			{item = "cigarette", amount = 1, chances = math.random(0,10)},
			{item = "paille", amount = 1, chances = math.random(0,10)},
			{item = "bong", amount = 1, chances = math.random(0,10)},
			{item = "methpipe", amount = 1, chances = math.random(0,10)},
			{item = "burner_phone", amount = 1, chances = math.random(0,10)},
			{item = "ounceweed", amount = 1, chances = math.random(0,10)},

		},
		cabinet = {
			{item = "money", amount = math.random(200, 500), chances = math.random(0,10)},
			{item = "oxy", amount = 3, chances = math.random(0,10)},
			{item = "lockpick", amount = 1, chances = math.random(0,10)},
			{item = "cuffs", amount = 1, chances = math.random(0,10)},
			{item = "cuff_keys", amount = 1, chances = math.random(0,10)},
			{item = "plantpot", amount = 1, chances = math.random(0,10)},
			{item = "lithium", amount = 1, chances = math.random(0,10)},
			{item = "methkit", amount = 1, chances = math.random(0,10)},
			{item = "ephedrine", amount = 1, chances = math.random(0,10)},
			{item = "nitro", amount = 1, chances = math.random(0,10)},
			{item = "plastic", amount = 1, chances = math.random(0,10)},
			{item = "steel", amount = 1, chances = math.random(0,10)},
			{item = "allum", amount = 1, chances = math.random(0,10)},
			{item = "gsr_purel", amount = 1, chances = math.random(0,10)},
			{item = "oxygen_mask", amount = 1, chances = math.random(0,10)},
			{item = "bulletproof", amount = 1, chances = math.random(0,10)},
			{item = "binoculars", amount = 1, chances = math.random(0,10)},
			{item = "fishingrod", amount = 1, chances = math.random(0,10)},
			{item = "wine_yeast", amount = 1, chances = math.random(0,10)},
			{item = "wine_sugar", amount = 1, chances = math.random(0,10)},
			{item = "vine_barrel", amount = 1, chances = math.random(0,10)},
			{item = "useless_papers", amount = 1, chances = math.random(0,10)},
			{item = "sponge", amount = 1, chances = math.random(0,10)},
			{item = "card_shop", amount = 1, chances = math.random(0,10)},
			{item = "drill_bit", amount = 1, chances = math.random(0,10)},
			{item = "grinder_disc", amount = 1, chances = math.random(0,10)},
			{item = "diamond_ring", amount = 1, chances = math.random(0,10)},
			{item = "gold_chain", amount = 1, chances = math.random(0,10)},
			{item = "gold_ring", amount = 1, chances = math.random(0,10)},
			{item = "gold_watch", amount = 1, chances = math.random(0,10)},
			{item = "silver_watch", amount = 1, chances = math.random(0,10)},
			{item = "gauze", amount = 1, chances = math.random(0,10)},
			{item = "bandage", amount = 1, chances = math.random(0,10)},
			{item = "beer", amount = 1, chances = math.random(0,10)},
			{item = "cigar", amount = 1, chances = math.random(0,10)},
			{item = "cigarette", amount = 1, chances = math.random(0,10)},
			{item = "paille", amount = 1, chances = math.random(0,10)},
			{item = "bong", amount = 1, chances = math.random(0,10)},
			{item = "methpipe", amount = 1, chances = math.random(0,10)},
			{item = "burner_phone", amount = 1, chances = math.random(0,10)},
			{item = "ounceweed", amount = 1, chances = math.random(0,10)},
		},
		largecabinet = {
			{item = "money", amount = math.random(200, 500), chances = math.random(0,10)},
			{item = "oxy", amount = 3, chances = math.random(0,10)},
			{item = "lockpick", amount = 1, chances = math.random(0,10)},
			{item = "cuffs", amount = 1, chances = math.random(0,10)},
			{item = "cuff_keys", amount = 1, chances = math.random(0,10)},
			{item = "plantpot", amount = 1, chances = math.random(0,10)},
			{item = "lithium", amount = 1, chances = math.random(0,10)},
			{item = "methkit", amount = 1, chances = math.random(0,10)},
			{item = "ephedrine", amount = 1, chances = math.random(0,10)},
			{item = "nitro", amount = 1, chances = math.random(0,10)},
			{item = "plastic", amount = 1, chances = math.random(0,10)},
			{item = "steel", amount = 1, chances = math.random(0,10)},
			{item = "allum", amount = 1, chances = math.random(0,10)},
			{item = "gsr_purel", amount = 1, chances = math.random(0,10)},
			{item = "oxygen_mask", amount = 1, chances = math.random(0,10)},
			{item = "bulletproof", amount = 1, chances = math.random(0,10)},
			{item = "binoculars", amount = 1, chances = math.random(0,10)},
			{item = "fishingrod", amount = 1, chances = math.random(0,10)},
			{item = "wine_yeast", amount = 1, chances = math.random(0,10)},
			{item = "wine_sugar", amount = 1, chances = math.random(0,10)},
			{item = "vine_barrel", amount = 1, chances = math.random(0,10)},
			{item = "useless_papers", amount = 1, chances = math.random(0,10)},
			{item = "sponge", amount = 1, chances = math.random(0,10)},
			{item = "card_shop", amount = 1, chances = math.random(0,10)},
			{item = "drill_bit", amount = 1, chances = math.random(0,10)},
			{item = "grinder_disc", amount = 1, chances = math.random(0,10)},
			{item = "diamond_ring", amount = 1, chances = math.random(0,10)},
			{item = "gold_chain", amount = 1, chances = math.random(0,10)},
			{item = "gold_ring", amount = 1, chances = math.random(0,10)},
			{item = "gold_watch", amount = 1, chances = math.random(0,10)},
			{item = "silver_watch", amount = 1, chances = math.random(0,10)},
			{item = "gauze", amount = 1, chances = math.random(0,10)},
			{item = "bandage", amount = 1, chances = math.random(0,10)},
			{item = "beer", amount = 1, chances = math.random(0,10)},
			{item = "cigar", amount = 1, chances = math.random(0,10)},
			{item = "cigarette", amount = 1, chances = math.random(0,10)},
			{item = "paille", amount = 1, chances = math.random(0,10)},
			{item = "bong", amount = 1, chances = math.random(0,10)},
			{item = "methpipe", amount = 1, chances = math.random(0,10)},
			{item = "burner_phone", amount = 1, chances = math.random(0,10)},
			{item = "ounceweed", amount = 1, chances = math.random(0,10)},
		}
	},
	medium = {
		smallcabinet = {
			{item = "money", amount = math.random(150, 350), chances = math.random(0,10)},
			{item = "oxy", amount = 2, chances = math.random(0,10)},
			{item = "lockpick", amount = 1, chances = math.random(0,10)},
			{item = "cuffs", amount = 1, chances = math.random(0,10)},
			{item = "cuff_keys", amount = 1, chances = math.random(0,10)},
			{item = "plantpot", amount = 1, chances = math.random(0,10)},
			{item = "lithium", amount = 1, chances = math.random(0,10)},
			{item = "methkit", amount = 1, chances = math.random(0,10)},
			{item = "ephedrine", amount = 1, chances = math.random(0,10)},
			{item = "nitro", amount = 1, chances = math.random(0,10)},
			{item = "plastic", amount = 1, chances = math.random(0,10)},
			{item = "steel", amount = 1, chances = math.random(0,10)},
			{item = "allum", amount = 1, chances = math.random(0,10)},
			{item = "gsr_purel", amount = 1, chances = math.random(0,10)},
			{item = "oxygen_mask", amount = 1, chances = math.random(0,10)},
			{item = "bulletproof", amount = 1, chances = math.random(0,10)},
			{item = "binoculars", amount = 1, chances = math.random(0,10)},
			{item = "fishingrod", amount = 1, chances = math.random(0,10)},
			{item = "wine_yeast", amount = 1, chances = math.random(0,10)},
			{item = "wine_sugar", amount = 1, chances = math.random(0,10)},
			{item = "vine_barrel", amount = 1, chances = math.random(0,10)},
			{item = "useless_papers", amount = 1, chances = math.random(0,10)},
			{item = "sponge", amount = 1, chances = math.random(0,10)},
			{item = "card_shop", amount = 1, chances = math.random(0,10)},
			{item = "drill_bit", amount = 1, chances = math.random(0,10)},
			{item = "grinder_disc", amount = 1, chances = math.random(0,10)},
			{item = "diamond_ring", amount = 1, chances = math.random(0,10)},
			{item = "gold_chain", amount = 1, chances = math.random(0,10)},
			{item = "gold_ring", amount = 1, chances = math.random(0,10)},
			{item = "gold_watch", amount = 1, chances = math.random(0,10)},
			{item = "silver_watch", amount = 1, chances = math.random(0,10)},
			{item = "gauze", amount = 1, chances = math.random(0,10)},
			{item = "bandage", amount = 1, chances = math.random(0,10)},
			{item = "beer", amount = 1, chances = math.random(0,10)},
			{item = "cigar", amount = 1, chances = math.random(0,10)},
			{item = "cigarette", amount = 1, chances = math.random(0,10)},
			{item = "paille", amount = 1, chances = math.random(0,10)},
			{item = "bong", amount = 1, chances = math.random(0,10)},
			{item = "methpipe", amount = 1, chances = math.random(0,10)},
			{item = "burner_phone", amount = 1, chances = math.random(0,10)},
			{item = "ounceweed", amount = 1, chances = math.random(0,10)},
		},
		cabinet = {
			{item = "money", amount = math.random(150, 350), chances = math.random(0,10)},
			{item = "oxy", amount = 2, chances = math.random(0,10)},
			{item = "lockpick", amount = 1, chances = math.random(0,10)},
			{item = "cuffs", amount = 1, chances = math.random(0,10)},
			{item = "cuff_keys", amount = 1, chances = math.random(0,10)},
			{item = "plantpot", amount = 1, chances = math.random(0,10)},
			{item = "lithium", amount = 1, chances = math.random(0,10)},
			{item = "methkit", amount = 1, chances = math.random(0,10)},
			{item = "ephedrine", amount = 1, chances = math.random(0,10)},
			{item = "nitro", amount = 1, chances = math.random(0,10)},
			{item = "plastic", amount = 1, chances = math.random(0,10)},
			{item = "steel", amount = 1, chances = math.random(0,10)},
			{item = "allum", amount = 1, chances = math.random(0,10)},
			{item = "gsr_purel", amount = 1, chances = math.random(0,10)},
			{item = "oxygen_mask", amount = 1, chances = math.random(0,10)},
			{item = "bulletproof", amount = 1, chances = math.random(0,10)},
			{item = "binoculars", amount = 1, chances = math.random(0,10)},
			{item = "fishingrod", amount = 1, chances = math.random(0,10)},
			{item = "wine_yeast", amount = 1, chances = math.random(0,10)},
			{item = "wine_sugar", amount = 1, chances = math.random(0,10)},
			{item = "vine_barrel", amount = 1, chances = math.random(0,10)},
			{item = "useless_papers", amount = 1, chances = math.random(0,10)},
			{item = "sponge", amount = 1, chances = math.random(0,10)},
			{item = "card_shop", amount = 1, chances = math.random(0,10)},
			{item = "drill_bit", amount = 1, chances = math.random(0,10)},
			{item = "grinder_disc", amount = 1, chances = math.random(0,10)},
			{item = "diamond_ring", amount = 1, chances = math.random(0,10)},
			{item = "gold_chain", amount = 1, chances = math.random(0,10)},
			{item = "gold_ring", amount = 1, chances = math.random(0,10)},
			{item = "gold_watch", amount = 1, chances = math.random(0,10)},
			{item = "silver_watch", amount = 1, chances = math.random(0,10)},
			{item = "gauze", amount = 1, chances = math.random(0,10)},
			{item = "bandage", amount = 1, chances = math.random(0,10)},
			{item = "beer", amount = 1, chances = math.random(0,10)},
			{item = "cigar", amount = 1, chances = math.random(0,10)},
			{item = "cigarette", amount = 1, chances = math.random(0,10)},
			{item = "paille", amount = 1, chances = math.random(0,10)},
			{item = "bong", amount = 1, chances = math.random(0,10)},
			{item = "methpipe", amount = 1, chances = math.random(0,10)},
			{item = "burner_phone", amount = 1, chances = math.random(0,10)},
			{item = "ounceweed", amount = 1, chances = math.random(0,10)},
		},
		largecabinet = {
			{item = "money", amount = math.random(150, 350), chances = math.random(0,10)},
			{item = "oxy", amount = 2, chances = math.random(0,10)},
			{item = "lockpick", amount = 1, chances = math.random(0,10)},
			{item = "cuffs", amount = 1, chances = math.random(0,10)},
			{item = "cuff_keys", amount = 1, chances = math.random(0,10)},
			{item = "plantpot", amount = 1, chances = math.random(0,10)},
			{item = "lithium", amount = 1, chances = math.random(0,10)},
			{item = "methkit", amount = 1, chances = math.random(0,10)},
			{item = "ephedrine", amount = 1, chances = math.random(0,10)},
			{item = "nitro", amount = 1, chances = math.random(0,10)},
			{item = "plastic", amount = 1, chances = math.random(0,10)},
			{item = "steel", amount = 1, chances = math.random(0,10)},
			{item = "allum", amount = 1, chances = math.random(0,10)},
			{item = "gsr_purel", amount = 1, chances = math.random(0,10)},
			{item = "oxygen_mask", amount = 1, chances = math.random(0,10)},
			{item = "bulletproof", amount = 1, chances = math.random(0,10)},
			{item = "binoculars", amount = 1, chances = math.random(0,10)},
			{item = "fishingrod", amount = 1, chances = math.random(0,10)},
			{item = "wine_yeast", amount = 1, chances = math.random(0,10)},
			{item = "wine_sugar", amount = 1, chances = math.random(0,10)},
			{item = "vine_barrel", amount = 1, chances = math.random(0,10)},
			{item = "useless_papers", amount = 1, chances = math.random(0,10)},
			{item = "sponge", amount = 1, chances = math.random(0,10)},
			{item = "card_shop", amount = 1, chances = math.random(0,10)},
			{item = "drill_bit", amount = 1, chances = math.random(0,10)},
			{item = "grinder_disc", amount = 1, chances = math.random(0,10)},
			{item = "diamond_ring", amount = 1, chances = math.random(0,10)},
			{item = "gold_chain", amount = 1, chances = math.random(0,10)},
			{item = "gold_ring", amount = 1, chances = math.random(0,10)},
			{item = "gold_watch", amount = 1, chances = math.random(0,10)},
			{item = "silver_watch", amount = 1, chances = math.random(0,10)},
			{item = "gauze", amount = 1, chances = math.random(0,10)},
			{item = "bandage", amount = 1, chances = math.random(0,10)},
			{item = "beer", amount = 1, chances = math.random(0,10)},
			{item = "cigar", amount = 1, chances = math.random(0,10)},
			{item = "cigarette", amount = 1, chances = math.random(0,10)},
			{item = "paille", amount = 1, chances = math.random(0,10)},
			{item = "bong", amount = 1, chances = math.random(0,10)},
			{item = "methpipe", amount = 1, chances = math.random(0,10)},
			{item = "burner_phone", amount = 1, chances = math.random(0,10)},
			{item = "ounceweed", amount = 1, chances = math.random(0,10)},
		}
	},
	low = {
		smallcabinet = {
			{item = "money", amount = math.random(50, 150), chances = math.random(0,10)},
			{item = "oxy", amount = 1, chances = math.random(0,10)},
			{item = "lockpick", amount = 1, chances = math.random(0,10)},
			{item = "cuffs", amount = 1, chances = math.random(0,10)},
			{item = "cuff_keys", amount = 1, chances = math.random(0,10)},
			{item = "plantpot", amount = 1, chances = math.random(0,10)},
			{item = "lithium", amount = 1, chances = math.random(0,10)},
			{item = "methkit", amount = 1, chances = math.random(0,10)},
			{item = "ephedrine", amount = 1, chances = math.random(0,10)},
			{item = "nitro", amount = 1, chances = math.random(0,10)},
			{item = "plastic", amount = 1, chances = math.random(0,10)},
			{item = "steel", amount = 1, chances = math.random(0,10)},
			{item = "allum", amount = 1, chances = math.random(0,10)},
			{item = "gsr_purel", amount = 1, chances = math.random(0,10)},
			{item = "oxygen_mask", amount = 1, chances = math.random(0,10)},
			{item = "bulletproof", amount = 1, chances = math.random(0,10)},
			{item = "binoculars", amount = 1, chances = math.random(0,10)},
			{item = "fishingrod", amount = 1, chances = math.random(0,10)},
			{item = "wine_yeast", amount = 1, chances = math.random(0,10)},
			{item = "wine_sugar", amount = 1, chances = math.random(0,10)},
			{item = "vine_barrel", amount = 1, chances = math.random(0,10)},
			{item = "useless_papers", amount = 1, chances = math.random(0,10)},
			{item = "sponge", amount = 1, chances = math.random(0,10)},
			{item = "card_shop", amount = 1, chances = math.random(0,10)},
			{item = "drill_bit", amount = 1, chances = math.random(0,10)},
			{item = "grinder_disc", amount = 1, chances = math.random(0,10)},
			{item = "diamond_ring", amount = 1, chances = math.random(0,10)},
			{item = "gold_chain", amount = 1, chances = math.random(0,10)},
			{item = "gold_ring", amount = 1, chances = math.random(0,10)},
			{item = "gold_watch", amount = 1, chances = math.random(0,10)},
			{item = "silver_watch", amount = 1, chances = math.random(0,10)},
			{item = "gauze", amount = 1, chances = math.random(0,10)},
			{item = "bandage", amount = 1, chances = math.random(0,10)},
			{item = "beer", amount = 1, chances = math.random(0,10)},
			{item = "cigar", amount = 1, chances = math.random(0,10)},
			{item = "cigarette", amount = 1, chances = math.random(0,10)},
			{item = "paille", amount = 1, chances = math.random(0,10)},
			{item = "bong", amount = 1, chances = math.random(0,10)},
			{item = "methpipe", amount = 1, chances = math.random(0,10)},
			{item = "burner_phone", amount = 1, chances = math.random(0,10)},
			{item = "ounceweed", amount = 1, chances = math.random(0,10)},
		},
		cabinet = {
			{item = "money", amount = math.random(50, 150), chances = math.random(0,10)},
			{item = "oxy", amount = 1, chances = math.random(0,10)},
			{item = "lockpick", amount = 1, chances = math.random(0,10)},
			{item = "cuffs", amount = 1, chances = math.random(0,10)},
			{item = "cuff_keys", amount = 1, chances = math.random(0,10)},
			{item = "plantpot", amount = 1, chances = math.random(0,10)},
			{item = "lithium", amount = 1, chances = math.random(0,10)},
			{item = "methkit", amount = 1, chances = math.random(0,10)},
			{item = "ephedrine", amount = 1, chances = math.random(0,10)},
			{item = "nitro", amount = 1, chances = math.random(0,10)},
			{item = "plastic", amount = 1, chances = math.random(0,10)},
			{item = "steel", amount = 1, chances = math.random(0,10)},
			{item = "allum", amount = 1, chances = math.random(0,10)},
			{item = "gsr_purel", amount = 1, chances = math.random(0,10)},
			{item = "oxygen_mask", amount = 1, chances = math.random(0,10)},
			{item = "bulletproof", amount = 1, chances = math.random(0,10)},
			{item = "binoculars", amount = 1, chances = math.random(0,10)},
			{item = "fishingrod", amount = 1, chances = math.random(0,10)},
			{item = "wine_yeast", amount = 1, chances = math.random(0,10)},
			{item = "wine_sugar", amount = 1, chances = math.random(0,10)},
			{item = "vine_barrel", amount = 1, chances = math.random(0,10)},
			{item = "useless_papers", amount = 1, chances = math.random(0,10)},
			{item = "sponge", amount = 1, chances = math.random(0,10)},
			{item = "card_shop", amount = 1, chances = math.random(0,10)},
			{item = "drill_bit", amount = 1, chances = math.random(0,10)},
			{item = "grinder_disc", amount = 1, chances = math.random(0,10)},
			{item = "diamond_ring", amount = 1, chances = math.random(0,10)},
			{item = "gold_chain", amount = 1, chances = math.random(0,10)},
			{item = "gold_ring", amount = 1, chances = math.random(0,10)},
			{item = "gold_watch", amount = 1, chances = math.random(0,10)},
			{item = "silver_watch", amount = 1, chances = math.random(0,10)},
			{item = "gauze", amount = 1, chances = math.random(0,10)},
			{item = "bandage", amount = 1, chances = math.random(0,10)},
			{item = "beer", amount = 1, chances = math.random(0,10)},
			{item = "cigar", amount = 1, chances = math.random(0,10)},
			{item = "cigarette", amount = 1, chances = math.random(0,10)},
			{item = "paille", amount = 1, chances = math.random(0,10)},
			{item = "bong", amount = 1, chances = math.random(0,10)},
			{item = "methpipe", amount = 1, chances = math.random(0,10)},
			{item = "burner_phone", amount = 1, chances = math.random(0,10)},
			{item = "ounceweed", amount = 1, chances = math.random(0,10)},
		},
		largecabinet = {
			{item = "money", amount = math.random(50, 150), chances = math.random(0,10)},
			{item = "oxy", amount = 1, chances = math.random(0,10)},
			{item = "lockpick", amount = 1, chances = math.random(0,10)},
			{item = "cuffs", amount = 1, chances = math.random(0,10)},
			{item = "cuff_keys", amount = 1, chances = math.random(0,10)},
			{item = "plantpot", amount = 1, chances = math.random(0,10)},
			{item = "lithium", amount = 1, chances = math.random(0,10)},
			{item = "methkit", amount = 1, chances = math.random(0,10)},
			{item = "ephedrine", amount = 1, chances = math.random(0,10)},
			{item = "nitro", amount = 1, chances = math.random(0,10)},
			{item = "plastic", amount = 1, chances = math.random(0,10)},
			{item = "steel", amount = 1, chances = math.random(0,10)},
			{item = "allum", amount = 1, chances = math.random(0,10)},
			{item = "gsr_purel", amount = 1, chances = math.random(0,10)},
			{item = "oxygen_mask", amount = 1, chances = math.random(0,10)},
			{item = "bulletproof", amount = 1, chances = math.random(0,10)},
			{item = "binoculars", amount = 1, chances = math.random(0,10)},
			{item = "fishingrod", amount = 1, chances = math.random(0,10)},
			{item = "wine_yeast", amount = 1, chances = math.random(0,10)},
			{item = "wine_sugar", amount = 1, chances = math.random(0,10)},
			{item = "vine_barrel", amount = 1, chances = math.random(0,10)},
			{item = "useless_papers", amount = 1, chances = math.random(0,10)},
			{item = "sponge", amount = 1, chances = math.random(0,10)},
			{item = "card_shop", amount = 1, chances = math.random(0,10)},
			{item = "drill_bit", amount = 1, chances = math.random(0,10)},
			{item = "grinder_disc", amount = 1, chances = math.random(0,10)},
			{item = "diamond_ring", amount = 1, chances = math.random(0,10)},
			{item = "gold_chain", amount = 1, chances = math.random(0,10)},
			{item = "gold_ring", amount = 1, chances = math.random(0,10)},
			{item = "gold_watch", amount = 1, chances = math.random(0,10)},
			{item = "silver_watch", amount = 1, chances = math.random(0,10)},
			{item = "gauze", amount = 1, chances = math.random(0,10)},
			{item = "bandage", amount = 1, chances = math.random(0,10)},
			{item = "beer", amount = 1, chances = math.random(0,10)},
			{item = "cigar", amount = 1, chances = math.random(0,10)},
			{item = "cigarette", amount = 1, chances = math.random(0,10)},
			{item = "paille", amount = 1, chances = math.random(0,10)},
			{item = "bong", amount = 1, chances = math.random(0,10)},
			{item = "methpipe", amount = 1, chances = math.random(0,10)},
			{item = "burner_phone", amount = 1, chances = math.random(0,10)},
			{item = "ounceweed", amount = 1, chances = math.random(0,10)},
		}
	}
}

Hr.Peds = {
	dog = {
		"a_c_chop",
		"a_c_husky",
		"a_c_poodle",
		"a_c_pug",
		"a_c_retriever",
		"a_c_rottweiler",
		"a_c_shepherd",
		"a_c_westy"
	},

	owners = {
		"a_m_y_beach_03",
		"a_m_y_bevhills_02",
		"a_m_y_breakdance_01",
		"a_f_m_soucentmc_01",
		"a_f_m_downtown_01",
		"a_f_y_bevhills_01"
	},

	weapons = {
		"weapon_pistol50",
		"weapon_pistol",
		"weapon_knife",
		"weapon_bat"
	}
}