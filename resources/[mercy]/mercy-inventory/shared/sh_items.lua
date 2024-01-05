Shared = Shared or {}
Shared.ItemList = {}

-- [ Needs ] --

local StringCharset = {}
local NumberCharset = {}

for i = 48,  57 do table.insert(NumberCharset, string.char(i)) end
for i = 65,  90 do table.insert(StringCharset, string.char(i)) end
for i = 97, 122 do table.insert(StringCharset, string.char(i)) end

Shared.RandomStr = function(Length)
	if Length > 0 then
		return Shared.RandomStr(Length - 1)..StringCharset[math.random(1, #StringCharset)]
	else
		return ''
	end
end

Shared.RandomInt = function(Length)
	if Length > 0 then
		return Shared.RandomInt(Length - 1)..NumberCharset[math.random(1, #NumberCharset)]
	else
		return ''
	end
end

Shared.SplitStr = function(str, delimiter)
	local result = {}
	local from = 1
	local delim_from, delim_to = string.find(str, delimiter, from)
	while delim_from do
		result[#result + 1] = string.sub(str, from, delim_from - 1)
		from = delim_to + 1
		delim_from, delim_to = string.find(str, delimiter, from)
	end
	result[#result + 1] = string.sub(str, from)
	return result
end

-- [ Weapons ] --

Shared.ItemList['weapon_rocketlauncher'] = {
    ['ItemName'] = "weapon_rocketlauncher",
	['Label'] = "Rocket Launcher",
	['Weight'] = 4.0,
	['Type'] = "Weapon",
	['Metal'] = true,
	['Melee'] = true,
	['Image'] = "w_mp7.png",
	['Unique'] = true,
	['Combinable'] = nil,
	['Description'] = "Boom?",
	['DecayRate'] = 2.0,
	['RemoveWhenDecayed'] = false,
	['Price'] = 1,
}

Shared.ItemList['weapon_mp7'] = {
    ['ItemName'] = "weapon_mp7",
	['Label'] = "Tactical SMG",
	['Weight'] = 4.0,
	['Type'] = "Weapon",
	['Metal'] = true,
	['Melee'] = true,
	['Image'] = "w_mp7.png",
	['Unique'] = true,
	['Combinable'] = nil,
	['Description'] = "Is this the MP5 but with compensatory behavior?",
	['DecayRate'] = 2.0,
	['RemoveWhenDecayed'] = false,
	['Price'] = 1,
}

Shared.ItemList['weapon_bats'] = {
    ['ItemName'] = "weapon_bats",
	['Label'] = "Metal Bat",
	['Weight'] = 4.0,
	['Type'] = "Weapon",
	['Metal'] = true,
	['Melee'] = true,
	['Image'] = "w_bat.png",
	['Unique'] = true,
	['Combinable'] = nil,
	['Description'] = "A metal bat, used for hitting balls, and people..",
	['DecayRate'] = 2.0,
	['RemoveWhenDecayed'] = false,
	['Price'] = 1,
}

Shared.ItemList['weapon_katanas'] = {
    ['ItemName'] = "weapon_katanas",
	['Label'] = "Katana",
	['Weight'] = 7.0,
	['Type'] = "Weapon",
	['Metal'] = true,
	['Melee'] = true,
	['Image'] = "w_katana.png",
	['Unique'] = true,
	['Combinable'] = nil,
	['Description'] = "Yuh..",
	['DecayRate'] = 2.0,
	['RemoveWhenDecayed'] = false,
	['Price'] = 1,
}

Shared.ItemList['weapon_nightstick'] = {
    ['ItemName'] = "weapon_nightstick",
	['Label'] = "Nightstick",
	['Weight'] = 4.0,
	['Type'] = "Weapon",
	['Metal'] = true,
	['Melee'] = true,
	['Image'] = "w_nightstick.png",
	['Unique'] = true,
	['Combinable'] = nil,
	['Description'] = "Government (PD/EMS/DOC) Issued Equipment",
	['DecayRate'] = 2.0,
	['RemoveWhenDecayed'] = false,
	['Price'] = 1,
}

Shared.ItemList['weapon_hammer'] = {
    ['ItemName'] = "weapon_hammer",
	['Label'] = "Hammer",
	['Weight'] = 8.0,
	['Type'] = "Weapon",
	['Metal'] = true,
	['Melee'] = true,
	['Image'] = "w_hammer.png",
	['Unique'] = true,
	['Combinable'] = nil,
	['Description'] = "To build stuff?",
	['DecayRate'] = 2.0,
	['RemoveWhenDecayed'] = false,
	['Price'] = 1,
}

Shared.ItemList['weapon_knife'] = {
    ['ItemName'] = "weapon_knife",
	['Label'] = "Knife",
	['Weight'] = 7.0,
	['Type'] = "Weapon",
	['Metal'] = true,
	['Melee'] = true,
	['Image'] = "w_knife.png",
	['Unique'] = true,
	['Combinable'] = nil,
	['Description'] = "A very normal knife.",
	['DecayRate'] = 2.0,
	['RemoveWhenDecayed'] = false,
	['Price'] = 1,
}

Shared.ItemList['weapon_hatchet'] = {
    ['ItemName'] = "weapon_hatchet",
	['Label'] = "Hatchet",
	['Weight'] = 17.0,
	['Type'] = "Weapon",
	['Metal'] = true,
	['Melee'] = true,
	['Image'] = "w_hatchet.png",
	['Unique'] = true,
	['Combinable'] = nil,
	['Description'] = "To chop down trees?",
	['DecayRate'] = 2.0,
	['RemoveWhenDecayed'] = false,
	['Price'] = 1,
}

Shared.ItemList['weapon_wrench'] = {
    ['ItemName'] = "weapon_wrench",
	['Label'] = "Wrench",
	['Weight'] = 12.0,
	['Type'] = "Weapon",
	['Metal'] = true,
	['Melee'] = true,
	['Image'] = "w_wrench.png",
	['Unique'] = true,
	['Combinable'] = nil,
	['Description'] = "Things mechanic's use to fix stuff.",
	['DecayRate'] = 2.0,
	['RemoveWhenDecayed'] = false,
	['Price'] = 1,
	['Cost'] = {
		{ Item = 'steel', Amount = 75 },
		{ Item = 'scrapmetal', Amount = 75 },
	}
}

Shared.ItemList['weapon_machete'] = {
    ['ItemName'] = "weapon_machete",
	['Label'] = "Machete",
	['Weight'] = 15.0,
	['Type'] = "Weapon",
	['Metal'] = true,
	['Melee'] = true,
	['Image'] = "w_machete.png",
	['Unique'] = true,
	['Combinable'] = nil,
	['Description'] = "Looks sharp.",
	['DecayRate'] = 2.0,
	['RemoveWhenDecayed'] = false,
	['Price'] = 1,
	['Cost'] = {
		{ Item = 'aluminum', Amount = 140 },
		{ Item = 'rubber', Amount = 40 },
	}
}

Shared.ItemList['weapon_bottle'] = {
    ['ItemName'] = "weapon_bottle",
	['Label'] = "Broken Bottle",
	['Weight'] = 2.0,
	['Type'] = "Weapon",
	['Metal'] = true,
	['Melee'] = true,
	['Image'] = "w_glass-bottle.png",
	['Unique'] = true,
	['Combinable'] = nil,
	['Description'] = "Looks like a green, premium, Karlsberg bottle.",
	['DecayRate'] = 2.0,
	['RemoveWhenDecayed'] = false,
	['Price'] = 1,
	['Cost'] = {
		{ Item = 'glass', Amount = 30 },
	}
}

Shared.ItemList['weapon_bat'] = {
    ['ItemName'] = "weapon_bat",
	['Label'] = "Bat",
	['Weight'] = 14.0,
	['Type'] = "Weapon",
	['Metal'] = true,
	['Melee'] = true,
	['Image'] = "w_bat.png",
	['Unique'] = true,
	['Combinable'] = nil,
	['Description'] = "Not only hitting home runs with this one..",
	['DecayRate'] = 2.0,
	['RemoveWhenDecayed'] = false,
	['Price'] = 1,
	['Cost'] = {
		{ Item = 'aluminum', Amount = 75 },
		{ Item = 'scrapmetal',  Amount = 75 },
	}
}

Shared.ItemList['weapon_knuckle'] = {
    ['ItemName'] = "weapon_knuckle",
	['Label'] = "Knuckle",
	['Weight'] = 2.0,
	['Type'] = "Weapon",
	['Metal'] = true,
	['Melee'] = true,
	['Image'] = "w_knuckle.png",
	['Unique'] = true,
	['Combinable'] = nil,
	['Description'] = "You don't see me..",
	['DecayRate'] = 2.0,
	['RemoveWhenDecayed'] = false,
	['Price'] = 1,
	['Cost'] = {
		{ Item = 'aluminum', Amount = 125 },
		{ Item = 'scrapmetal',  Amount = 10 },
	}
}

Shared.ItemList['weapon_katana'] = {
    ['ItemName'] = "weapon_katana",
	['Label'] = "Katana",
	['Weight'] = 7.0,
	['Type'] = "Weapon",
	['Metal'] = true,
	['Melee'] = true,
	['Image'] = "w_katana.png",
	['Unique'] = true,
	['Combinable'] = nil,
	['Description'] = "Yuh.",
	['DecayRate'] = 0.25,
	['RemoveWhenDecayed'] = false,
	['Prop'] = true,
	['Price'] = 250,
	['Cost'] = {
		{ Item = 'steel', Amount = 1950 },
		{ Item = 'aluminum',  Amount = 750 },
	}
}

Shared.ItemList['weapon_crutch'] = {
    ['ItemName'] = "weapon_crutch",
	['Label'] = "Crutch",
	['Weight'] = 3.0,
	['Type'] = "Weapon",
	['Metal'] = true,
	['Melee'] = true,
	['Image'] = "w_crutch.png",
	['Unique'] = true,
	['Combinable'] = nil,
	['Description'] = "Not only for walking.",
	['DecayRate'] = 0.25,
	['RemoveWhenDecayed'] = false,
	['Prop'] = true,
	['Price'] = 250,
}

Shared.ItemList['weapon_unicorn'] = {
    ['ItemName'] = "weapon_unicorn",
	['Label'] = "Unicorn",
	['Weight'] = 2.0,
	['Type'] = "Weapon",
	['Metal'] = true,
	['Melee'] = true,
	['Image'] = "w_unicorn.png",
	['Unique'] = true,
	['Combinable'] = nil,
	['Description'] = "Cute unicorn.",
	['DecayRate'] = 0.25,
	['RemoveWhenDecayed'] = false,
	['Prop'] = true,
	['Price'] = 250,
}

-- Default

Shared.ItemList['weapon_sniperrifle2'] = {
    ['ItemName'] = "weapon_sniperrifle2",
	['Label'] = "Hunting Rifle",
	['Weight'] = 17.0,
	['Type'] = "Weapon",
	['Metal'] = true,
	['Melee'] = false,
	['Image'] = "w_huntingrifle.png",
	['Unique'] = true,
	['Combinable'] = nil,
	['Description'] = "Only shoot on animals please!",
	['DecayRate'] = 2.0,
	['RemoveWhenDecayed'] = true,
	['Prop'] = true,
	['Price'] = 500,
}

Shared.ItemList['weapon_empgun'] = {
    ['ItemName'] = "weapon_empgun",
	['Label'] = "EMP Gun",
	['Weight'] = 17.0,
	['Type'] = "Weapon",
	['Metal'] = true,
	['Melee'] = false,
	['Image'] = "w_empgun.png",
	['Unique'] = true,
	['Combinable'] = nil,
	['Description'] = "There goes your vehicle..",
	['DecayRate'] = 2.0,
	['RemoveWhenDecayed'] = true,
	['Prop'] = true,
	['Price'] = 1,
}

Shared.ItemList['weapon_remington'] = {
    ['ItemName'] = "weapon_remington",
	['Label'] = "PD Shotgun",
	['Weight'] = 17.0,
	['Type'] = "Weapon",
	['Metal'] = true,
	['Melee'] = false,
	['Image'] = "w_remington.png",
	['Unique'] = true,
	['Combinable'] = nil,
	['Description'] = "So much fire power!",
	['DecayRate'] = 2.0,
	['RemoveWhenDecayed'] = true,
	['Prop'] = true,
	['Price'] = 1,
}

Shared.ItemList['weapon_rubberslug'] = {
    ['ItemName'] = "weapon_rubberslug",
	['Label'] = "PD Shotgun (Rubber)",
	['Weight'] = 17.0,
	['Type'] = "Weapon",
	['Metal'] = true,
	['Melee'] = false,
	['Image'] = "w_rubberslug.png",
	['Unique'] = true,
	['Combinable'] = nil,
	['Description'] = "So much fire power! (Not really...)",
	['DecayRate'] = 2.0,
	['RemoveWhenDecayed'] = true,
	['Prop'] = true,
	['Price'] = 1,
}

Shared.ItemList['weapon_m4'] = {
    ['ItemName'] = "weapon_m4",
	['Label'] = "PD M4",
	['Weight'] = 17.0,
	['Type'] = "Weapon",
	['Metal'] = true,
	['Melee'] = false,
	['Image'] = "w_m4.png",
	['Unique'] = true,
	['Combinable'] = nil,
	['Description'] = "I like to shoot.",
	['DecayRate'] = 2.0,
	['RemoveWhenDecayed'] = true,
	['Prop'] = true,
	['Price'] = 1,
}

Shared.ItemList['weapon_scar'] = {
    ['ItemName'] = "weapon_scar",
	['Label'] = "PD Scar-H",
	['Weight'] = 17.0,
	['Type'] = "Weapon",
	['Metal'] = true,
	['Melee'] = false,
	['Image'] = "w_scar.png",
	['Unique'] = true,
	['Combinable'] = nil,
	['Description'] = "Is this from fortnut?",
	['DecayRate'] = 2.0,
	['RemoveWhenDecayed'] = true,
	['Prop'] = true,
	['Price'] = 1,
}

Shared.ItemList['weapon_groza'] = {
    ['ItemName'] = "weapon_groza",
	['Label'] = "OTs-14 Groza",
	['Weight'] = 17.0,
	['Type'] = "Weapon",
	['Metal'] = true,
	['Melee'] = false,
	['Image'] = "w_groza.png",
	['Unique'] = true,
	['Combinable'] = nil,
	['Description'] = "Groza my balls bitchhhh.",
	['DecayRate'] = 2.0,
	['RemoveWhenDecayed'] = true,
	['Prop'] = true,
	['Price'] = 1,
}

Shared.ItemList['weapon_ak74'] = {
    ['ItemName'] = "weapon_ak74",
	['Label'] = "AK-74",
	['Weight'] = 17.0,
	['Type'] = "Weapon",
	['Metal'] = true,
	['Melee'] = false,
	['Image'] = "w_ak47.png",
	['Unique'] = true,
	['Combinable'] = nil,
	['Description'] = "Ratatata am i in the ghetto?",
	['DecayRate'] = 2.0,
	['RemoveWhenDecayed'] = true,
	['Prop'] = true,
	['Price'] = 1,
}


Shared.ItemList['weapon_ak47'] = {
    ['ItemName'] = "weapon_ak47",
	['Label'] = "AK-47",
	['Weight'] = 17.0,
	['Type'] = "Weapon",
	['Metal'] = true,
	['Melee'] = false,
	['Image'] = "w_ak47.png",
	['Unique'] = true,
	['Combinable'] = nil,
	['Description'] = "Ratatata am i in the ghetto?",
	['DecayRate'] = 2.0,
	['RemoveWhenDecayed'] = true,
	['Prop'] = true,
	['Price'] = 1,
}

Shared.ItemList['weapon_m70'] = {
    ['ItemName'] = "weapon_m70",
	['Label'] = "M70",
	['Weight'] = 17.0,
	['Type'] = "Weapon",
	['Metal'] = true,
	['Melee'] = false,
	['Image'] = "w_m70.png",
	['Unique'] = true,
	['Combinable'] = nil,
	['Description'] = "Wow this looks neat!",
	['DecayRate'] = 2.0,
	['RemoveWhenDecayed'] = true,
	['Prop'] = true,
	['Price'] = 1,
}

Shared.ItemList['weapon_mpx'] = {
    ['ItemName'] = "weapon_mpx",
	['Label'] = "PD MPX",
	['Weight'] = 15.5,
	['Type'] = "Weapon",
	['Metal'] = true,
	['Melee'] = false,
	['Image'] = "w_mpx.png",
	['Unique'] = true,
	['Combinable'] = nil,
	['Description'] = "What a nice gun.",
	['DecayRate'] = 2.0,
	['RemoveWhenDecayed'] = true,
	['Prop'] = true,
	['Price'] = 1,
}

Shared.ItemList['weapon_draco'] = {
    ['ItemName'] = "weapon_draco",
	['Label'] = "Draco",
	['Weight'] = 15.5,
	['Type'] = "Weapon",
	['Metal'] = true,
	['Melee'] = false,
	['Image'] = "w_draco.png",
	['Unique'] = true,
	['Combinable'] = nil,
	['Description'] = "Am i in the ghetto?",
	['DecayRate'] = 2.0,
	['RemoveWhenDecayed'] = true,
	['Prop'] = true,
	['Price'] = 1,
	['Cost'] = {
		{Item = 'scrapmetal', Amount = 92},
		{Item = 'copper', Amount = 77},
		{Item = 'steel', Amount = 85},
	}
}

Shared.ItemList['weapon_mac10'] = {
    ['ItemName'] = "weapon_mac10",
	['Label'] = "Mac-10",
	['Weight'] = 15.5,
	['Type'] = "Weapon",
	['Metal'] = true,
	['Melee'] = false,
	['Image'] = "w_mac10.png",
	['Unique'] = true,
	['Combinable'] = nil,
	['Description'] = "Is this from Mac Donald's?",
	['DecayRate'] = 2.0,
	['RemoveWhenDecayed'] = true,
	['Prop'] = true,
	['Price'] = 1,
	['Cost'] = {
		{Item = 'scrapmetal', Amount = 92},
		{Item = 'copper', Amount = 77},
		{Item = 'steel', Amount = 85},
	}
}

Shared.ItemList['weapon_uzi'] = {
    ['ItemName'] = "weapon_uzi",
	['Label'] = "Uzi",
	['Weight'] = 15.5,
	['Type'] = "Weapon",
	['Metal'] = true,
	['Melee'] = false,
	['Image'] = "w_uzi.png",
	['Unique'] = true,
	['Combinable'] = nil,
	['Description'] = "Wow this is some sick shit.",
	['DecayRate'] = 2.0,
	['RemoveWhenDecayed'] = true,
	['Prop'] = true,
	['Price'] = 1,
	['Cost'] = {
		{Item = 'scrapmetal', Amount = 92},
		{Item = 'copper', Amount = 77},
		{Item = 'steel', Amount = 85},
	}
}

-- Pistols

Shared.ItemList['weapon_paintball'] = {
    ['ItemName'] = "weapon_paintball",
	['Label'] = "Paintball Gun",
	['Weight'] = 8.5,
	['Type'] = "Weapon",
	['Metal'] = true,
	['Melee'] = false,
	['Image'] = "w_paintball.png",
	['Unique'] = true,
	['Combinable'] = nil,
	['Description'] = "Sexy gun that shoots balls.",
	['DecayRate'] = 2.0,
	['RemoveWhenDecayed'] = true,
	['Price'] = 250,
}

Shared.ItemList['weapon_beretta'] = {
    ['ItemName'] = "weapon_beretta",
	['Label'] = "Beretta M9",
	['Weight'] = 8.5,
	['Type'] = "Weapon",
	['Metal'] = true,
	['Melee'] = false,
	['Image'] = "w_beretta.png",
	['Unique'] = true,
	['Combinable'] = nil,
	['Description'] = "This is a spicy gun init?",
	['DecayRate'] = 2.0,
	['RemoveWhenDecayed'] = true,
	['Price'] = 250,
}

Shared.ItemList['weapon_colt'] = {
    ['ItemName'] = "weapon_colt",
	['Label'] = "Colt M1911",
	['Weight'] = 8.5,
	['Type'] = "Weapon",
	['Metal'] = true,
	['Melee'] = false,
	['Image'] = "w_colt.png",
	['Unique'] = true,
	['Combinable'] = nil,
	['Description'] = "I think this one is from call of duty.",
	['DecayRate'] = 2.0,
	['RemoveWhenDecayed'] = true,
	['Price'] = 250,
}

Shared.ItemList['weapon_waltherp99'] = {
	['ItemName'] = "weapon_waltherp99",
	['Label'] = "Walther P99",
	['Weight'] = 8.5,
	['Type'] = "Weapon",
	['Metal'] = true,
	['Melee'] = false,
	['Image'] = "w_waltherp99.png",
	['Unique'] = true,
	['Combinable'] = nil,
	['Description'] = "",
	['DecayRate'] = 2.0,
	['RemoveWhenDecayed'] = true,
	['Price'] = 1,
}

Shared.ItemList['weapon_browning'] = {
	['ItemName'] = "weapon_browning",
	['Label'] = "Browning Hi-P",
	['Weight'] = 8.5,
	['Type'] = "Weapon",
	['Metal'] = true,
	['Melee'] = false,
	['Image'] = "w_browning.png",
	['Unique'] = true,
	['Combinable'] = nil,
	['Description'] = "Hi-P?? Oh! High Power duh!",
	['DecayRate'] = 2.0,
	['RemoveWhenDecayed'] = true,
	['Price'] = 1,
	['Cost'] = {
		{Item = 'scrapmetal', Amount = 72},
		{Item = 'copper', Amount = 57},
		{Item = 'steel', Amount = 65},
	}
}

Shared.ItemList['weapon_python'] = {
	['ItemName'] = "weapon_python",
	['Label'] = "Python",
	['Weight'] = 8.5,
	['Type'] = "Weapon",
	['Metal'] = true,
	['Melee'] = false,
	['Image'] = "w_python.png",
	['Unique'] = true,
	['Combinable'] = nil,
	['Description'] = "",
	['DecayRate'] = 2.0,
	['RemoveWhenDecayed'] = true,
	['Price'] = 1,
}

Shared.ItemList['weapon_diamond'] = {
	['ItemName'] = "weapon_diamond",
	['Label'] = "Diamondback DB9",
	['Weight'] = 8.5,
	['Type'] = "Weapon",
	['Metal'] = true,
	['Melee'] = false,
	['Image'] = "w_diamond.png",
	['Unique'] = true,
	['Combinable'] = nil,
	['Description'] = "",
	['DecayRate'] = 2.0,
	['RemoveWhenDecayed'] = true,
	['Price'] = 1,
}

Shared.ItemList["weapon_heavypistol"] = {
	['ItemName'] = "weapon_heavypistol",
	['Label'] = "Heavy Pistol",
	['Weight'] = 11.0,
	['Type'] = "Weapon",
	['Metal'] = true,
	['Melee'] = false,
	['Image'] = "w_heavypistol.png",
	['Unique'] = true,
	['Combinable'] = nil,
	['Description'] = "This one is soooo heavy!",
	['DecayRate'] = 2.0,
	['RemoveWhenDecayed'] = true,
	['Price'] = 1,
}

Shared.ItemList["weapon_glock"] = {
	['ItemName'] = "weapon_glock",
	['Label'] = "PD Glock",
	['Weight'] = 8.5,
	['Type'] = "Weapon",
	['Metal'] = true,
	['Melee'] = false,
	['Image'] = "w_glock.png",
	['Unique'] = true,
	['Combinable'] = nil,
	['Description'] = "PD Issued pistol.",
	['DecayRate'] = 2.0,
	['RemoveWhenDecayed'] = true,
	['Price'] = 1,
}

Shared.ItemList["weapon_glock18c"] = {
	['ItemName'] = "weapon_glock18c",
	['Label'] = "Glock 18C",
	['Weight'] = 8.5,
	['Type'] = "Weapon",
	['Metal'] = true,
	['Melee'] = false,
	['Image'] = "w_glock18c.png",
	['Unique'] = true,
	['Combinable'] = nil,
	['Description'] = "Ratatatatta blam blam.",
	['DecayRate'] = 2.0,
	['RemoveWhenDecayed'] = true,
	['Price'] = 1,
}

Shared.ItemList["weapon_taser"] = {
	['ItemName'] = "weapon_taser",
	['Label'] = "PD Taser",
	['Weight'] = 8.5,
	['Type'] = "Weapon",
	['Metal'] = true,
	['Melee'] = false,
	['Image'] = "w_taser.png",
	['Unique'] = true,
	['Combinable'] = nil,
	['Description'] = "PD Issued taser.",
	['DecayRate'] = 2.0,
	['RemoveWhenDecayed'] = true,
	['Price'] = 1,
}

Shared.ItemList["weapon_sledgeham"] = {
	['ItemName'] = "weapon_sledgeham",
	['Label'] = "Sledgehammer",
	['Weight'] = 4.5,
	['Type'] = "Weapon",
	['Metal'] = true,
	['Melee'] = true,
	['Image'] = "w_sledgehammer.png",
	['Unique'] = true,
	['Combinable'] = nil,
	['Description'] = "Can i break walls with this?",
	['DecayRate'] = 2.0,
	['RemoveWhenDecayed'] = true,
	['Prop'] = true,
	['Price'] = 1,
}

Shared.ItemList["weapon_flashlight"] = {
	['ItemName'] = "weapon_flashlight",
	['Label'] = "Flashlight",
	['Weight'] = 4.5,
	['Type'] = "Weapon",
	['Metal'] = true,
	['Melee'] = true,
	['Image'] = "w_flashlight.png",
	['Unique'] = true,
	['Combinable'] = nil,
	['Description'] = "HWAHA MMY EYES!",
	['DecayRate'] = 2.0,
	['RemoveWhenDecayed'] = true,
	['Price'] = 1,
}

Shared.ItemList["weapon_switchblade"] = {
	['ItemName'] = "weapon_switchblade",
	['Label'] = "Shank",
	['Weight'] = 4.5,
	['Type'] = "Weapon",
	['Metal'] = true,
	['Melee'] = true,
	['Image'] = "w_shank.png",
	['Unique'] = true,
	['Combinable'] = nil,
	['Description'] = "Only 2 stabs needed I guess.",
	['DecayRate'] = 2.0,
	['RemoveWhenDecayed'] = true,
	['Price'] = 1,
}

Shared.ItemList["weapon_shiv"] = {
	['ItemName'] = "weapon_shiv",
	['Label'] = "Shiv",
	['Weight'] = 4.5,
	['Type'] = "Weapon",
	['Metal'] = true,
	['Melee'] = true,
	['Image'] = "w_shiv.png",
	['Unique'] = true,
	['Combinable'] = nil,
	['Description'] = "Looks a bit sharp!",
	['DecayRate'] = 0.7,
	['RemoveWhenDecayed'] = true,
	['Price'] = 1,
	['Cost'] = {
		{Item = 'slushy', Amount = 12},
	}
}

Shared.ItemList["weapon_gavel"] = {
	['ItemName'] = "weapon_gavel",
	['Label'] = "Gavel",
	['Weight'] = 4.5,
	['Type'] = "Weapon",
	['Metal'] = false,
	['Melee'] = true,
	['Image'] = "w_gavel.png",
	['Unique'] = true,
	['Combinable'] = nil,
	['Description'] = "Order in the court!",
	['DecayRate'] = 2.0,
	['RemoveWhenDecayed'] = true,
	['Price'] = 1,
}

Shared.ItemList["weapon_shoe"] = {
	['ItemName'] = "weapon_shoe",
	['Label'] = "Shoes",
	['Weight'] = 4.5,
	['Type'] = "Weapon",
	['Metal'] = true,
	['Melee'] = true,
	['Image'] = "w_shoes.png",
	['Unique'] = true,
	['Combinable'] = nil,
	['Description'] = "These might stink.",
	['DecayRate'] = 2.0,
	['RemoveWhenDecayed'] = true,
	['Price'] = 1,
}

Shared.ItemList["weapon_grenade"] = {
	['ItemName'] = "weapon_grenade",
	['Label'] = "M67 Grenade",
	['Weight'] = 5.0,
	['Type'] = "Weapon",
	['Metal'] = true,
	['Melee'] = true,
	['Image'] = "w_grenade.png",
	['Unique'] = true,
	['Combinable'] = nil,
	['Description'] = "And boem goes the dynamite!",
	['DecayRate'] = 0.5,
	['RemoveWhenDecayed'] = true,
	['Price'] = 1,
}

Shared.ItemList["weapon_smokegrenade"] = {
	['ItemName'] = "weapon_smokegrenade",
	['Label'] = "Smoke Grenade",
	['Weight'] = 5.0,
	['Type'] = "Weapon",
	['Metal'] = true,
	['Melee'] = true,
	['Image'] = "w_smokegrenade.png",
	['Unique'] = true,
	['Combinable'] = nil,
	['Description'] = "Where are you?",
	['DecayRate'] = 0.25,
	['RemoveWhenDecayed'] = true,
	['Price'] = 1,
}

Shared.ItemList["weapon_molotov"] = {
	['ItemName'] = "weapon_molotov",
	['Label'] = "Smoke Grenade",
	['Weight'] = 5.0,
	['Type'] = "Weapon",
	['Metal'] = false,
	['Melee'] = true,
	['Image'] = "w_molotov.png",
	['Unique'] = true,
	['Combinable'] = nil,
	['Description'] = "Is it just me, or is something burning?",
	['DecayRate'] = 2.0,
	['RemoveWhenDecayed'] = true,
	['Price'] = 1,
}

Shared.ItemList["weapon_flare"] = {
	['ItemName'] = "weapon_flare",
	['Label'] = "Flare",
	['Weight'] = 5.0,
	['Type'] = "Weapon",
	['Metal'] = true,
	['Melee'] = true,
	['Image'] = "w_flare.png",
	['Unique'] = true,
	['Combinable'] = nil,
	['Description'] = "Nice light!",
	['DecayRate'] = 0.25,
	['RemoveWhenDecayed'] = true,
	['Price'] = 1,
}

Shared.ItemList["weapon_stickybomb"] = {
	['ItemName'] = "weapon_stickybomb",
	['Label'] = "C4",
	['Weight'] = 15.0,
	['Type'] = "Weapon",
	['Metal'] = true,
	['Melee'] = true,
	['Image'] = "w_c4.png",
	['Unique'] = true,
	['Combinable'] = nil,
	['Description'] = "BOOM!",
	['DecayRate'] = 0.5,
	['RemoveWhenDecayed'] = true,
	['Price'] = 1,
}

-- [ Special 

Shared.ItemList["weapon_grapple"] = {
	['ItemName'] = "weapon_grapple",
	['Label'] = "Grapple Gun",
	['Weight'] = 20.0,
	['Type'] = "Item",
	['Metal'] = true,
	['Image'] = "w_grapple.png",
	['Unique'] = true,
	['Combinable'] = nil,
	['Description'] = "Don\'t fall.",
	['DecayRate'] = 0.5,
	['RemoveWhenDecayed'] = true,
	['Price'] = 1,
}

-- [ Attachments

Shared.ItemList["silencer_oilcan"] = {
	['ItemName'] = "silencer_oilcan",
	['Label'] = "Oil Filter",
	['Weight'] = 15.0,
	['Type'] = "Weapon",
	['Metal'] = true,
	['Melee'] = true,
	['Image'] = "a_oilcan.png",
	['Unique'] = true,
	['Combinable'] = nil,
	['Description'] = "Old, used oil filter. Do not seem to last long.",
	['DecayRate'] = 0.1,
	['RemoveWhenDecayed'] = true,
	['Attachment'] = true,
	['Price'] = 1,
	['Cost'] = {
		{Item = 'aluminum', Amount = 30},
		{Item = 'copper', Amount = 30},
		{Item = 'steel', Amount = 30},
	}
}

-- [ Ammo

Shared.ItemList["taser-ammo"] = {
	['ItemName'] = "taser-ammo",
	['Label'] = "Taser Cartridges",
	['Weight'] = 0.5,
	['Type'] = "Item",
	['Metal'] = true,
	['Image'] = "a_taser.png",
	['Unique'] = false,
	['Combinable'] = nil,
	['Description'] = "Taser ammunition.",
	['DecayRate'] = 0.1,
	['RemoveWhenDecayed'] = true,
	['Price'] = 25,
}

Shared.ItemList["pistol-ammo"] = {
	['ItemName'] = "pistol-ammo",
	['Label'] = "Pistol Ammo x50",
	['Weight'] = 0.5,
	['Type'] = "Item",
	['Metal'] = true,
	['Image'] = "a_pistol.png",
	['Unique'] = false,
	['Combinable'] = nil,
	['Description'] = "Pistol ammunition.",
	['DecayRate'] = 0.1,
	['RemoveWhenDecayed'] = true,
	['Price'] = 25,
}

Shared.ItemList["smg-ammo"] = {
	['ItemName'] = "smg-ammo",
	['Label'] = "Sub Ammo x120",
	['Weight'] = 0.5,
	['Type'] = "Item",
	['Metal'] = true,
	['Image'] = "a_smg.png",
	['Unique'] = false,
	['Combinable'] = nil,
	['Description'] = "Smg ammunition.",
	['DecayRate'] = 0.1,
	['RemoveWhenDecayed'] = true,
	['Price'] = 25,
	['Cost'] = {
		{Item = 'copper', Amount = 37},
		{Item = 'aluminum', Amount = 25},
	}
}

Shared.ItemList["shotgun-ammo"] = {
	['ItemName'] = "shotgun-ammo",
	['Label'] = "SG Ammo x24",
	['Weight'] = 0.5,
	['Type'] = "Item",
	['Metal'] = true,
	['Image'] = "a_shotgun.png",
	['Unique'] = false,
	['Combinable'] = nil,
	['Description'] = "Shotgun Slugs.",
	['DecayRate'] = 0.1,
	['RemoveWhenDecayed'] = true,
	['Price'] = 25,
}

Shared.ItemList["rubber-shotgun-ammo"] = {
	['ItemName'] = "rubber-shotgun-ammo",
	['Label'] = "Rubber Slugs x20",
	['Weight'] = 0.5,
	['Type'] = "Item",
	['Metal'] = true,
	['Image'] = "a_rubber.png",
	['Unique'] = false,
	['Combinable'] = nil,
	['Description'] = "Rubber Slugs.",
	['DecayRate'] = 0.1,
	['RemoveWhenDecayed'] = true,
	['Price'] = 25,
}

Shared.ItemList["rifle-ammo"] = {
	['ItemName'] = "rifle-ammo",
	['Label'] = "Rifle Ammo x120",
	['Weight'] = 0.5,
	['Type'] = "Item",
	['Metal'] = true,
	['Image'] = "a_rifle.png",
	['Unique'] = false,
	['Combinable'] = nil,
	['Description'] = "Rifle ammunition.",
	['DecayRate'] = 0.1,
	['RemoveWhenDecayed'] = true,
	['Price'] = 25,
	['Cost'] = {
		{Item = 'copper', Amount = 37},
		{Item = 'aluminum', Amount = 25},
	}
}

Shared.ItemList["sniper-ammo"] = {
	['ItemName'] = "sniper-ammo",
	['Label'] = "Sniper Ammo x10",
	['Weight'] = 0.5,
	['Type'] = "Item",
	['Metal'] = true,
	['Image'] = "a_sniper.png",
	['Unique'] = false,
	['Combinable'] = nil,
	['Description'] = "Sniper ammunition.",
	['DecayRate'] = 0.1,
	['RemoveWhenDecayed'] = true,
	['Price'] = 100,
}

Shared.ItemList["emp-ammo"] = {
	['ItemName'] = "emp-ammo",
	['Label'] = "EMP Ammo x1",
	['Weight'] = 0.5,
	['Type'] = "Item",
	['Metal'] = true,
	['Image'] = "a_empammo.png",
	['Unique'] = false,
	['Combinable'] = nil,
	['Description'] = "Emp ammunition.",
	['DecayRate'] = 0.1,
	['RemoveWhenDecayed'] = true,
	['Price'] = 45,
}

Shared.ItemList["paintball-ammo"] = {
	['ItemName'] = "paintball-ammo",
	['Label'] = "Paintball Ammo x100",
	['Weight'] = 0.5,
	['Type'] = "Item",
	['Metal'] = true,
	['Image'] = "a_paintball.png",
	['Unique'] = false,
	['Combinable'] = nil,
	['Description'] = "Paintball ammunition.",
	['DecayRate'] = 0.1,
	['RemoveWhenDecayed'] = true,
	['Price'] = 35,
}

Shared.ItemList["revolver-ammo"] = {
	['ItemName'] = "revolver-ammo",
	['Label'] = "Revolver Ammo x12",
	['Weight'] = 0.5,
	['Type'] = "Item",
	['Metal'] = true,
	['Image'] = "a_revolver.png",
	['Unique'] = false,
	['Combinable'] = nil,
	['Description'] = "Revolver ammunition.",
	['DecayRate'] = 0.1,
	['RemoveWhenDecayed'] = true,
	['Price'] = 45,
}

-- [ Ingredients 

Shared.ItemList["ingredient-buns"] = {
	['ItemName'] = "ingredient-buns",
	['Label'] = "Hamburger Bun",
	['Weight'] = 0.5,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "f_buns.png",
	['Unique'] = false,
	['Combinable'] = nil,
	['Description'] = "Used to make food - be aware, food doesnt last forever!",
	['DecayRate'] =  0.025,
	['RemoveWhenDecayed'] = true,
	['Price'] = 3,
}

Shared.ItemList["ingredient-lettuce"] = {
	['ItemName'] = "ingredient-lettuce",
	['Label'] = "Lettuce",
	['Weight'] = 0.5,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "f_lettuce.png",
	['Unique'] = false,
	['Combinable'] = nil,
	['Description'] = "Used to make food - be aware, food doesnt last forever!",
	['DecayRate'] =  0.025,
	['RemoveWhenDecayed'] = true,
	['Price'] = 3,
}

Shared.ItemList["ingredient-patty"] = {
	['ItemName'] = "ingredient-patty",
	['Label'] = "Hamburger Patty",
	['Weight'] = 0.5,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "f_patty.png",
	['Unique'] = false,
	['Combinable'] = nil,
	['Description'] = "Used to make food - be aware, food doesnt last forever!",
	['DecayRate'] =  0.025,
	['RemoveWhenDecayed'] = true,
	['Price'] = 1,
	['Cost'] = {
		{Item = 'ingredient-patty-raw', Amount = 1},
	}
}

Shared.ItemList["ingredient-patty-raw"] = {
	['ItemName'] = "ingredient-patty-raw",
	['Label'] = "Hamburger Patty (Raw)",
	['Weight'] = 0.5,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "f_patty-raw.png",
	['Unique'] = false,
	['Combinable'] = nil,
	['Description'] = "Maybe cook it first?!",
	['DecayRate'] =  0.025,
	['RemoveWhenDecayed'] = true,
	['Price'] = 3,
}

Shared.ItemList["ingredient-milk"] = {
	['ItemName'] = "ingredient-milk",
	['Label'] = "Milk",
	['Weight'] = 0.5,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "f_milk.png",
	['Unique'] = false,
	['Combinable'] = nil,
	['Description'] = "Used to make food - be aware, food doesnt last forever!",
	['DecayRate'] =  0.025,
	['RemoveWhenDecayed'] = true,
	['Price'] = 3,
}

Shared.ItemList["ingredient-icecream"] = {
	['ItemName'] = "ingredient-icecream",
	['Label'] = "Ice Cream",
	['Weight'] = 0.5,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "f_icecream.png",
	['Unique'] = false,
	['Combinable'] = nil,
	['Description'] = "Used to make food - be aware, food doesnt last forever!",
	['DecayRate'] =  0.025,
	['RemoveWhenDecayed'] = true,
	['Price'] = 3,
}

Shared.ItemList["ingredient-syrup"] = {
	['ItemName'] = "ingredient-syrup",
	['Label'] = "Syrup",
	['Weight'] = 0.5,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "f_syrup.png",
	['Unique'] = false,
	['Combinable'] = nil,
	['Description'] = "Used to make food - be aware, food doesnt last forever!",
	['DecayRate'] =  0.025,
	['RemoveWhenDecayed'] = true,
	['Price'] = 3,
}

Shared.ItemList["ingredient-beans"] = {
	['ItemName'] = "ingredient-beans",
	['Label'] = "Coffee Beans",
	['Weight'] = 0.5,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "f_beans.png",
	['Unique'] = false,
	['Combinable'] = nil,
	['Description'] = "Used to make food - be aware, food doesnt last forever!",
	['DecayRate'] =  0.025,
	['RemoveWhenDecayed'] = true,
	['Price'] = 3,
}

Shared.ItemList["ingredient-potatoes"] = {
	['ItemName'] = "ingredient-potatoes",
	['Label'] = "Potatoes",
	['Weight'] = 0.5,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "f_potatoes.png",
	['Unique'] = false,
	['Combinable'] = nil,
	['Description'] = "Used to make food - be aware, food doesnt last forever!",
	['DecayRate'] =  0.025,
	['RemoveWhenDecayed'] = true,
	['Price'] = 3,
}

Shared.ItemList["ingredient-cheese"] = {
	['ItemName'] = "ingredient-cheese",
	['Label'] = "Cheese",
	['Weight'] = 0.5,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "f_cheese.png",
	['Unique'] = false,
	['Combinable'] = nil,
	['Description'] = "Used to make food - be aware, food doesnt last forever!",
	['DecayRate'] =  0.025,
	['RemoveWhenDecayed'] = true,
	['Price'] = 3,
}

-- [ Food

Shared.ItemList["bread"] = {
	['ItemName'] = "bread",
	['Label'] = "Bread",
	['Weight'] = 0.25,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "f_bread.png",
	['Unique'] = false,
	['Combinable'] = nil,
	['Description'] = "I think you can eat this.",
	['DecayRate'] = 0.01,
	['RemoveWhenDecayed'] = true,
	['Price'] = 42,
}

Shared.ItemList["muffin"] = {
	['ItemName'] = "muffin",
	['Label'] = "Muffin",
	['Weight'] = 0.25,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "f_muffin.png",
	['Unique'] = false,
	['Combinable'] = nil,
	['Description'] = "Is your muffin buttered?",
	['DecayRate'] = 0.01,
	['RemoveWhenDecayed'] = true,
	['Price'] = 1,
}

-- Fruits

Shared.ItemList["apple"] = {
	['ItemName'] = "apple",
	['Label'] = "Apple",
	['Weight'] = 0.25,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "f_apple.png",
	['Unique'] = false,
	['Combinable'] = nil,
	['Description'] = "One fruit a day keeps the doctor away.",
	['DecayRate'] = 0.75,
	['RemoveWhenDecayed'] = false,
	['Price'] = 5,
}

Shared.ItemList["banana"] = {
	['ItemName'] = "banana",
	['Label'] = "Banana",
	['Weight'] = 0.25,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "f_banana.png",
	['Unique'] = false,
	['Combinable'] = nil,
	['Description'] = "One fruit a day keeps the doctor away.",
	['DecayRate'] = 0.75,
	['RemoveWhenDecayed'] = false,
	['Price'] = 5,
}

Shared.ItemList["cherry"] = {
	['ItemName'] = "cherry",
	['Label'] = "Cherry",
	['Weight'] = 0.25,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "f_cherry.png",
	['Unique'] = false,
	['Combinable'] = nil,
	['Description'] = "One fruit a day keeps the doctor away.",
	['DecayRate'] = 0.75,
	['RemoveWhenDecayed'] = false,
	['Price'] = 5,
}

Shared.ItemList["coconut"] = {
	['ItemName'] = "coconut",
	['Label'] = "Coconut",
	['Weight'] = 0.25,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "f_coconut.png",
	['Unique'] = false,
	['Combinable'] = nil,
	['Description'] = "One fruit a day keeps the doctor away.",
	['DecayRate'] = 0.75,
	['RemoveWhenDecayed'] = false,
	['Price'] = 5,
}

Shared.ItemList["grapes"] = {
	['ItemName'] = "grapes",
	['Label'] = "Grapes",
	['Weight'] = 0.25,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "f_grapes.png",
	['Unique'] = false,
	['Combinable'] = nil,
	['Description'] = "One fruit a day keeps the doctor away.",
	['DecayRate'] = 0.75,
	['RemoveWhenDecayed'] = false,
	['Price'] = 5,
}

Shared.ItemList["kiwi"] = {
	['ItemName'] = "kiwi",
	['Label'] = "Kiwi",
	['Weight'] = 0.25,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "f_kiwi.png",
	['Unique'] = false,
	['Combinable'] = nil,
	['Description'] = "One fruit a day keeps the doctor away.",
	['DecayRate'] = 0.75,
	['RemoveWhenDecayed'] = false,
	['Price'] = 5,
}

Shared.ItemList["lemon"] = {
	['ItemName'] = "lemon",
	['Label'] = "Lemon",
	['Weight'] = 0.25,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "f_lemon.png",
	['Unique'] = false,
	['Combinable'] = nil,
	['Description'] = "One fruit a day keeps the doctor away.",
	['DecayRate'] = 0.75,
	['RemoveWhenDecayed'] = false,
	['Price'] = 5,
}

Shared.ItemList["lime"] = {
	['ItemName'] = "lime",
	['Label'] = "Lime",
	['Weight'] = 0.25,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "f_lime.png",
	['Unique'] = false,
	['Combinable'] = nil,
	['Description'] = "One fruit a day keeps the doctor away.",
	['DecayRate'] = 0.75,
	['RemoveWhenDecayed'] = false,
	['Price'] = 5,
}

Shared.ItemList["orange"] = {
	['ItemName'] = "orange",
	['Label'] = "Orange",
	['Weight'] = 0.25,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "f_orange.png",
	['Unique'] = false,
	['Combinable'] = nil,
	['Description'] = "One fruit a day keeps the doctor away.",
	['DecayRate'] = 0.75,
	['RemoveWhenDecayed'] = false,
	['Price'] = 5,
}

Shared.ItemList["peach"] = {
	['ItemName'] = "peach",
	['Label'] = "Peach",
	['Weight'] = 0.25,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "f_peach.png",
	['Unique'] = false,
	['Combinable'] = nil,
	['Description'] = "One fruit a day keeps the doctor away.",
	['DecayRate'] = 0.75,
	['RemoveWhenDecayed'] = false,
	['Price'] = 5,
}

Shared.ItemList["strawberry"] = {
	['ItemName'] = "strawberry",
	['Label'] = "Strawberry",
	['Weight'] = 0.25,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "f_strawberry.png",
	['Unique'] = false,
	['Combinable'] = nil,
	['Description'] = "One fruit a day keeps the doctor away.",
	['DecayRate'] = 0.75,
	['RemoveWhenDecayed'] = false,
	['Price'] = 5,
}

Shared.ItemList["watermelon"] = {
	['ItemName'] = "watermelon",
	['Label'] = "Watermelon",
	['Weight'] = 0.25,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "f_watermelon.png",
	['Unique'] = false,
	['Combinable'] = nil,
	['Description'] = "One fruit a day keeps the doctor away.",
	['DecayRate'] = 0.75,
	['RemoveWhenDecayed'] = false,
	['Price'] = 5,
}

-- Business Food

Shared.ItemList["heartstopper"] = {
	['ItemName'] = "heartstopper",
	['Label'] = "The Heart Stopper",
	['Weight'] = 1.0,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "f_heartstopper.png",
	['Unique'] = false,
	['Combinable'] = nil,
	['Description'] = "Sates Hunger and reduces stress.",
	['DecayRate'] = 0.01,
	['RemoveWhenDecayed'] = true,
	['Price'] = 1,
	['Cost'] = {
		{Item = 'ingredient-buns', Amount = 1},
		{Item = 'ingredient-cheese', Amount = 2},
		{Item = 'ingredient-patty', Amount = 4},
		{Item = 'ingredient-lettuce', Amount = 1},
	}
}

Shared.ItemList["bleeder"] = {
	['ItemName'] = "bleeder",
	['Label'] = "Bleeder",
	['Weight'] = 1.0,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "f_bleeder.png",
	['Unique'] = false,
	['Combinable'] = nil,
	['Description'] = "Sates Hunger and reduces stress.",
	['DecayRate'] = 0.01,
	['RemoveWhenDecayed'] = true,
	['Price'] = 1,
	['Cost'] = {
		{Item = 'ingredient-buns', Amount = 1},
		{Item = 'ingredient-patty', Amount = 1},
		{Item = 'ingredient-lettuce', Amount = 1},
	}
}

Shared.ItemList["torpedo"] = {
	['ItemName'] = "torpedo",
	['Label'] = "Torpedo",
	['Weight'] = 1.0,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "f_torpedo.png",
	['Unique'] = false,
	['Combinable'] = nil,
	['Description'] = "Sates Hunger and reduces stress.",
	['DecayRate'] = 0.01,
	['RemoveWhenDecayed'] = true,
	['Price'] = 1,
	['Cost'] = {
		{Item = 'ingredient-buns', Amount = 1},
		{Item = 'ingredient-patty', Amount = 2},
	}
}

Shared.ItemList["moneyshot"] = {
	['ItemName'] = "moneyshot",
	['Label'] = "Money Shot",
	['Weight'] = 1.0,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "f_moneyshot.png",
	['Unique'] = false,
	['Combinable'] = nil,
	['Description'] = "Sates Hunger and reduces stress.",
	['DecayRate'] = 0.01,
	['RemoveWhenDecayed'] = true,
	['Price'] = 1,
	['Cost'] = {
		{Item = 'ingredient-buns', Amount = 1},
		{Item = 'ingredient-cheese', Amount = 2},
		{Item = 'ingredient-patty', Amount = 2},
		{Item = 'ingredient-lettuce', Amount = 1},
	}
}

Shared.ItemList["fries"] = {
	['ItemName'] = "fries",
	['Label'] = "Fries",
	['Weight'] = 1.0,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "f_fries.png",
	['Unique'] = false,
	['Combinable'] = nil,
	['Description'] = "Sates Hunger and reduces stress.",
	['DecayRate'] = 0.01,
	['RemoveWhenDecayed'] = true,
	['Price'] = 1,
	['Cost'] = {
		{Item = 'ingredient-potatoes', Amount = 1},
	}
}

-- Shared.ItemList["unionrings"] = {
-- 	['ItemName'] = "unionrings",
-- 	['Label'] = "Unionrings",
-- 	['Weight'] = 1.0,
-- 	['Type'] = "Item",
-- 	['Metal'] = false,
-- 	['Image'] = "f_unionrings.png",
-- 	['Unique'] = false,
-- 	['Combinable'] = nil,
-- 	['Description'] = "Sates Hunger and reduces stress.",
-- 	['DecayRate'] = 0.01,
-- 	['RemoveWhenDecayed'] = true,
-- 	['Price'] = 1,
-- 	['Cost'] = {
-- 		{Item = 'ingredient-potatoes', Amount = 1},
-- 	}
-- }

Shared.ItemList["jailfood"] = {
	['ItemName'] = "jailfood",
	['Label'] = "Jail Food",
	['Weight'] = 20.0,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "f_jailfood.png",
	['Unique'] = false,
	['Combinable'] = nil,
	['Description'] = "Looks as bad as the sheriff's aim.",
	['DecayRate'] = 0.01,
	['RemoveWhenDecayed'] = true,
	['Price'] = 1,
}

-- [ Drinks

Shared.ItemList["water"] = {
	['ItemName'] = "water",
	['Label'] = "Water",
	['Weight'] = 0.25,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "f_water.png",
	['Unique'] = false,
	['Combinable'] = nil,
	['Description'] = "I think you can drink this.",
	['DecayRate'] = 0.01,
	['RemoveWhenDecayed'] = true,
	['Price'] = 34,
}

Shared.ItemList["slushy"] = {
	['ItemName'] = "slushy",
	['Label'] = "God Slushy",
	['Weight'] = 20.0,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "f_slushy.png",
	['Unique'] = false,
	['Combinable'] = nil,
	['Description'] = "The only thing in Jail that tastes good.",
	['DecayRate'] = 0.0,
	['RemoveWhenDecayed'] = false,
	['Price'] = 1,
}

Shared.ItemList["beer"] = {
	['ItemName'] = "beer",
	['Label'] = "Mug of Beer",
	['Weight'] = 1.0,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "f_beer.png",
	['Unique'] = false,
	['Combinable'] = nil,
	['Description'] = "Cheers!",
	['DecayRate'] = 0.0,
	['RemoveWhenDecayed'] = false,
	['Price'] = 1,
}

-- Business Drinks

Shared.ItemList["milkshake"] = {
	['ItemName'] = "milkshake",
	['Label'] = "Milkshake",
	['Weight'] = 1.0,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "f_milkshake.png",
	['Unique'] = false,
	['Combinable'] = nil,
	['Description'] = "Hand-scooped for you..",
	['DecayRate'] = 0.01,
	['RemoveWhenDecayed'] = false,
	['Price'] = 1,
	['Cost'] = {
		{Item = 'ingredient-milk', Amount = 1},
		{Item = 'ingredient-icecream', Amount = 1},
	}
}

Shared.ItemList["softdrink"] = {
	['ItemName'] = "softdrink",
	['Label'] = "Softdrink",
	['Weight'] = 1.0,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "f_softdrink.png",
	['Unique'] = false,
	['Combinable'] = nil,
	['Description'] = "..",
	['DecayRate'] = 0.01,
	['RemoveWhenDecayed'] = false,
	['Price'] = 1,
	['Cost'] = {
		{Item = 'ingredient-syrup', Amount = 1},
	}
}

Shared.ItemList["coffee"] = {
	['ItemName'] = "coffee",
	['Label'] = "Coffee",
	['Weight'] = 1.0,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "f_coffee.png",
	['Unique'] = false,
	['Combinable'] = nil,
	['Description'] = "Tastes like dirt, but has the caffeine you need.",
	['DecayRate'] = 0.01,
	['RemoveWhenDecayed'] = false,
	['Price'] = 1,
	['Cost'] = {
		{Item = 'ingredient-beans', Amount = 1},
	}
}

Shared.ItemList["catpuccino"] = {
	['ItemName'] = "catpuccino",
	['Label'] = "Catpuccino",
	['Weight'] = 1.0,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "catpuccino.png",
	['Unique'] = false,
	['Combinable'] = nil,
	['Description'] = "Tastes like miauw, but has the caffeine you need.",
	['DecayRate'] = 0.01,
	['RemoveWhenDecayed'] = false,
	['Price'] = 1,
	['Cost'] = {
		{Item = 'ingredient-beans', Amount = 1},
	}
}

Shared.ItemList["icedcoffee"] = {
	['ItemName'] = "icedcoffee",
	['Label'] = "Icecoffee",
	['Weight'] = 1.0,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "catpuccino.png",
	['Unique'] = false,
	['Combinable'] = nil,
	['Description'] = "So cold, but has the caffeine you need.",
	['DecayRate'] = 0.01,
	['RemoveWhenDecayed'] = false,
	['Price'] = 1,
	['Cost'] = {
		{Item = 'ingredient-beans', Amount = 1},
	}
}

Shared.ItemList["matchalatte"] = {
	['ItemName'] = "matchalatte",
	['Label'] = "Matchalatte",
	['Weight'] = 1.0,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "matchalatte.png",
	['Unique'] = false,
	['Combinable'] = nil,
	['Description'] = "Tasts like miauw , but has the caffeine you need.",
	['DecayRate'] = 0.01,
	['RemoveWhenDecayed'] = false,
	['Price'] = 1,
	['Cost'] = {
		{Item = 'ingredient-beans', Amount = 1},
	}
}


Shared.ItemList["kittylatte"] = {
	['ItemName'] = "kittylatte",
	['Label'] = "Kittylatte",
	['Weight'] = 1.0,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "kittylatte.png",
	['Unique'] = false,
	['Combinable'] = nil,
	['Description'] = "Miauw Miauw Miauw",
	['DecayRate'] = 0.01,
	['RemoveWhenDecayed'] = false,
	['Price'] = 1,
	['Cost'] = {
		{Item = 'ingredient-beans', Amount = 1},
	}
}

Shared.ItemList["bubbleteablueberry"] = {
	['ItemName'] = "bubbleteablueberry",
	['Label'] = "Blueberry Bubbletea",
	['Weight'] = 1.0,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "bubbleteablueberry.png",
	['Unique'] = false,
	['Combinable'] = nil,
	['Description'] = "Tasts like miauw , but has the caffeine you need.",
	['DecayRate'] = 0.01,
	['RemoveWhenDecayed'] = false,
	['Price'] = 1,
	['Cost'] = {
		{Item = 'ingredient-beans', Amount = 1},
	}
}

Shared.ItemList["bubbleteamint"] = {
	['ItemName'] = "bubbleteamint",
	['Label'] = "Mint Bubbletea",
	['Weight'] = 1.0,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "bubbleteamint.png",
	['Unique'] = false,
	['Combinable'] = nil,
	['Description'] = "Tasts like miauw , but has the caffeine you need.",
	['DecayRate'] = 0.01,
	['RemoveWhenDecayed'] = false,
	['Price'] = 1,
	['Cost'] = {
		{Item = 'ingredient-beans', Amount = 1},
	}
}

Shared.ItemList["bubbletearose"] = {
	['ItemName'] = "bubbletearose",
	['Label'] = "Rose Bubbletea",
	['Weight'] = 1.0,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "bubbletearose.png",
	['Unique'] = false,
	['Combinable'] = nil,
	['Description'] = "Tasts like miauw , but has the caffeine you need.",
	['DecayRate'] = 0.01,
	['RemoveWhenDecayed'] = false,
	['Price'] = 1,
	['Cost'] = {
		{Item = 'ingredient-beans', Amount = 1},
	}
}

Shared.ItemList["chocotea"] = {
	['ItemName'] = "chocotea",
	['Label'] = "Chocolat Tea",
	['Weight'] = 1.0,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "chocotea.png",
	['Unique'] = false,
	['Combinable'] = nil,
	['Description'] = "Chocolate Tea, Hmm Nice",
	['DecayRate'] = 0.01,
	['RemoveWhenDecayed'] = false,
	['Price'] = 1,
	['Cost'] = {
		{Item = 'ingredient-beans', Amount = 1},
	}
}

Shared.ItemList["lemonlimeicedtea"] = {
	['ItemName'] = "lemonlimeicedtea",
	['Label'] = "Iced Lemon Tea",
	['Weight'] = 1.0,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "lemonlimeicedtea.png",
	['Unique'] = false,
	['Combinable'] = nil,
	['Description'] = "Cold Lemon Tea, Hmm Nice",
	['DecayRate'] = 0.01,
	['RemoveWhenDecayed'] = false,
	['Price'] = 1,
	['Cost'] = {
		{Item = 'ingredient-beans', Amount = 1},
	}
}

Shared.ItemList["matchatea"] = {
	['ItemName'] = "matchatea",
	['Label'] = "Matcha Tea",
	['Weight'] = 1.0,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "lemonlimeicedtea.png",
	['Unique'] = false,
	['Combinable'] = nil,
	['Description'] = "Matcha, Hmm Nice",
	['DecayRate'] = 0.01,
	['RemoveWhenDecayed'] = false,
	['Price'] = 1,
	['Cost'] = {
		{Item = 'ingredient-beans', Amount = 1},
	}
}

Shared.ItemList["strawberrytea"] = {
	['ItemName'] = "strawberrytea",
	['Label'] = "Strawberry Tea",
	['Weight'] = 1.0,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "strawberrytea.png",
	['Unique'] = false,
	['Combinable'] = nil,
	['Description'] = "Strawberry's, Hmm Nice",
	['DecayRate'] = 0.01,
	['RemoveWhenDecayed'] = false,
	['Price'] = 1,
	['Cost'] = {
		{Item = 'ingredient-beans', Amount = 1},
	}
}

Shared.ItemList["uwu_toy1"] = {
	['ItemName'] = "uwu_toy1",
	['Label'] = "UwU Squishy",
	['Weight'] = 1.0,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "uwu_toy1.png",
	['Unique'] = false,
	['Combinable'] = nil,
	['Description'] = "Play with me UwU",
	['DecayRate'] = 0.01,
	['RemoveWhenDecayed'] = false,
	['Price'] = 1,
}

Shared.ItemList["uwu_toy2"] = {
	['ItemName'] = "uwu_toy2",
	['Label'] = "UwU Squishy",
	['Weight'] = 1.0,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "uwu_toy2.png",
	['Unique'] = false,
	['Combinable'] = nil,
	['Description'] = "Play with me UwU",
	['DecayRate'] = 0.01,
	['RemoveWhenDecayed'] = false,
	['Price'] = 1,
}

Shared.ItemList["uwu_toy3"] = {
	['ItemName'] = "uwu_toy3",
	['Label'] = "UwU Squishy",
	['Weight'] = 1.0,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "uwu_toy3.png",
	['Unique'] = false,
	['Combinable'] = nil,
	['Description'] = "Play with me UwU",
	['DecayRate'] = 0.01,
	['RemoveWhenDecayed'] = false,
	['Price'] = 1,
}

Shared.ItemList["uwu_toy4"] = {
	['ItemName'] = "uwu_toy4",
	['Label'] = "UwU Squishy",
	['Weight'] = 1.0,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "uwu_toy4.png",
	['Unique'] = false,
	['Combinable'] = nil,
	['Description'] = "Play with me UwU",
	['DecayRate'] = 0.01,
	['RemoveWhenDecayed'] = false,
	['Price'] = 1,
}

Shared.ItemList["uwubentobox"] = {
	['ItemName'] = "uwubentobox",
	['Label'] = "Bento Box",
	['Weight'] = 1.0,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "uwubentobox.png",
	['Unique'] = false,
	['Combinable'] = nil,
	['Description'] = "HIDE THE STUFF!",
	['DecayRate'] = 0.01,
	['RemoveWhenDecayed'] = false,
	['Price'] = 1,
}

Shared.ItemList["mochi"] = {
	['ItemName'] = "mochi",
	['Label'] = "Mochi",
	['Weight'] = 1.0,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "mochi.png",
	['Unique'] = false,
	['Combinable'] = nil,
	['Description'] = "Eat me!",
	['DecayRate'] = 0.01,
	['RemoveWhenDecayed'] = false,
	['Price'] = 1,
}

Shared.ItemList["kittyricecake"] = {
	['ItemName'] = "kittyricecake",
	['Label'] = "Kitty Ricecake",
	['Weight'] = 1.0,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "kittyricecake.png",
	['Unique'] = false,
	['Combinable'] = nil,
	['Description'] = "Eat me!",
	['DecayRate'] = 0.01,
	['RemoveWhenDecayed'] = false,
	['Price'] = 1,
}

Shared.ItemList["kittydoughnut"] = {
	['ItemName'] = "kittydoughnut",
	['Label'] = "Kitty Doughut",
	['Weight'] = 1.0,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "kittydoughnut.png",
	['Unique'] = false,
	['Combinable'] = nil,
	['Description'] = "Eat me!",
	['DecayRate'] = 0.01,
	['RemoveWhenDecayed'] = false,
	['Price'] = 1,
}

Shared.ItemList["kittycupcake"] = {
	['ItemName'] = "kittycupcake",
	['Label'] = "Kitty Cupcake",
	['Weight'] = 1.0,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "kittycupcake.png",
	['Unique'] = false,
	['Combinable'] = nil,
	['Description'] = "Eat me!",
	['DecayRate'] = 0.01,
	['RemoveWhenDecayed'] = false,
	['Price'] = 1,
}

Shared.ItemList["kittybrownie"] = {
	['ItemName'] = "kittybrownie",
	['Label'] = "Kitty Brownie",
	['Weight'] = 1.0,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "kittybrownie.png",
	['Unique'] = false,
	['Combinable'] = nil,
	['Description'] = "Eat me!",
	['DecayRate'] = 0.01,
	['RemoveWhenDecayed'] = false,
	['Price'] = 1,
}

Shared.ItemList["kittybentobox"] = {
	['ItemName'] = "kittybentobox",
	['Label'] = "Kitty Bentobox",
	['Weight'] = 1.0,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "kittybentobox.png",
	['Unique'] = false,
	['Combinable'] = nil,
	['Description'] = "Eat me!",
	['DecayRate'] = 0.01,
	['RemoveWhenDecayed'] = false,
	['Price'] = 1,
}

Shared.ItemList["katsusalad"] = {
	['ItemName'] = "katsusalad",
	['Label'] = "Katsu Salad",
	['Weight'] = 1.0,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "katsusalad.png",
	['Unique'] = false,
	['Combinable'] = nil,
	['Description'] = "You're a wanne be healthy person.",
	['DecayRate'] = 0.01,
	['RemoveWhenDecayed'] = false,
	['Price'] = 1,
}

Shared.ItemList["katsucurry"] = {
	['ItemName'] = "katsucurry",
	['Label'] = "Katsu Curry",
	['Weight'] = 1.0,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "katsucurry.png",
	['Unique'] = false,
	['Combinable'] = nil,
	['Description'] = "You're a wanne be healthy person.",
	['DecayRate'] = 0.01,
	['RemoveWhenDecayed'] = false,
	['Price'] = 1,
}
-- [ Medical ] --

Shared.ItemList["ifak"] = {
	['ItemName'] = "ifak",
	['Label'] = "Ifak",
	['Weight'] = 0.25,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "h_ifak.png",
	['Unique'] = false,
	['Combinable'] = nil,
	['Description'] = "Heals you over time and clots wounds.",
	['DecayRate'] = 0.25,
	['RemoveWhenDecayed'] = true,
	['Price'] = 50,
}

Shared.ItemList["bandage"] = {
	['ItemName'] = "bandage",
	['Label'] = "First Aid Kit",
	['Weight'] = 0.25,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "h_bandage.png",
	['Unique'] = false,
	['Combinable'] = nil,
	['Description'] = "Are you bleeding?",
	['DecayRate'] = 0.25,
	['RemoveWhenDecayed'] = true,
	['Price'] = 56,
}

Shared.ItemList["joint"] = {
	['ItemName'] = "joint",
	['Label'] = "3g Joint",
	['Weight'] = 0.20,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "h_joint.png",
	['Unique'] = false,
	['Combinable'] = nil,
	['Description'] = "Its a Joint, man.",
	['DecayRate'] = 0.2,
	['RemoveWhenDecayed'] = false,
	['Price'] = 1,
	['Cost'] = {
		{Item = 'rolling-paper', Amount = 1},
		{Item = 'weed-dried-bud-two', Amount = 1},
	}
}

Shared.ItemList["chestarmor"] = {
	['ItemName'] = "chestarmor",
	['Label'] = "Chest Armor",
	['Weight'] = 20.0,
	['Type'] = "Item",
	['Metal'] = true,
	['Image'] = "h_armor.png",
	['Unique'] = false,
	['Combinable'] = nil,
	['Description'] = "Protects you from bleeding and stumbling on injuries.",
	['DecayRate'] = 0.25,
	['RemoveWhenDecayed'] = true,
	['Price'] = 750,
}

Shared.ItemList["pdchestarmor"] = {
	['ItemName'] = "pdchestarmor",
	['Label'] = "PD Chest Armor",
	['Weight'] = 20.0,
	['Type'] = "Item",
	['Metal'] = true,
	['Image'] = "h_armor.png",
	['Unique'] = false,
	['Combinable'] = nil,
	['Description'] = "Protects you from bleeding and stumbling on injuries.",
	['DecayRate'] = 0.25,
	['RemoveWhenDecayed'] = true,
	['Price'] = 350,
}

-- [ Crime

Shared.ItemList["fertilizer"] = {
	['ItemName'] = "fertilizer",
	['Label'] = "Fertilizer",
	['Weight'] = 2.5,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "c_fertilizer.png",
	['Unique'] = false,
	['Combinable'] = nil,
	['Description'] = "Did you shit in it?!",
	['DecayRate'] = 0.25,
	['RemoveWhenDecayed'] = false,
	['Price'] = 112,
}

-- Weed Plants Cayo

Shared.ItemList["weed-seed-male-cayo"] = {
	['ItemName'] = "weed-seed-male-cayo",
	['Label'] = "Weed Seeds (M)",
	['Weight'] = 1.5,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "c_weed-seeds.png",
	['Unique'] = false,
	['Combinable'] = nil,
	['Description'] = "Grow my youngling!",
	['DecayRate'] = 0.1,
	['RemoveWhenDecayed'] = false,
	['Price'] = 1,
}

Shared.ItemList["weed-seed-female-cayo"] = {
	['ItemName'] = "weed-seed-female-cayo",
	['Label'] = "Weed Seeds (F)",
	['Weight'] = 1.5,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "c_weed-seeds.png",
	['Unique'] = false,
	['Combinable'] = nil,
	['Description'] = "Grow my youngling!",
	['DecayRate'] = 0.1,
	['RemoveWhenDecayed'] = false,
	['Price'] = 101,
}

-- Weed Plants

Shared.ItemList["weed-seed-male"] = {
	['ItemName'] = "weed-seed-male",
	['Label'] = "Weed Seeds (M)",
	['Weight'] = 1.5,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "c_weed-seeds.png",
	['Unique'] = false,
	['Combinable'] = nil,
	['Description'] = "Grow my youngling!",
	['DecayRate'] = 0.1,
	['RemoveWhenDecayed'] = false,
	['Price'] = 1,
}

Shared.ItemList["weed-seed-female"] = {
	['ItemName'] = "weed-seed-female",
	['Label'] = "Weed Seeds (F)",
	['Weight'] = 1.5,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "c_weed-seeds.png",
	['Unique'] = false,
	['Combinable'] = nil,
	['Description'] = "Grow my youngling!",
	['DecayRate'] = 0.1,
	['RemoveWhenDecayed'] = false,
	['Price'] = 101,
}

Shared.ItemList["weed-branch"] = {
	['ItemName'] = "weed-branch",
	['Label'] = "Weed Branch",
	['Weight'] = 25.0,
	['Type'] = "Item", -- Item
	['Metal'] = false,
	['Image'] = "c_weed-branch.png",
	['Unique'] = true,
	['Combinable'] = nil,
	['Description'] = "The best smell ever!!!",
	['DecayRate'] = 0.1,
	['RemoveWhenDecayed'] = false,
	['Prop'] = true,
	['Price'] = 1,
}

Shared.ItemList["weed-dried-bud-one"] = {
	['ItemName'] = "weed-dried-bud-one",
	['Label'] = "Dried Bud (7g)",
	['Weight'] = 5.0,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "c_weed-dried-bud-one.png",
	['Unique'] = false,
	['Combinable'] = nil,
	['Description'] = "The best smell ever!!!",
	['DecayRate'] = 0.1,
	['RemoveWhenDecayed'] = false,
	['Price'] = 1,
}

Shared.ItemList["weed-dried-bud-two"] = {
	['ItemName'] = "weed-dried-bud-two",
	['Label'] = "Dried Bud (3g)",
	['Weight'] = 3.0,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "c_weed-dried-bud-two.png",
	['Unique'] = false,
	['Combinable'] = nil,
	['Description'] = "The best smell ever!!!",
	['DecayRate'] = 0.1,
	['RemoveWhenDecayed'] = false,
	['Price'] = 1,
	['Cost'] = {
		{Item = 'weed-dried-bud-one', Amount = 1},
	}
}

Shared.ItemList["weed-bag"] = {
	['ItemName'] = "weed-bag",
	['Label'] = "Baggie (7g)",
	['Weight'] = 0.70,
	['Type'] = "Item",
	['Metal'] = true,
	['Image'] = "c_weed-baged.png",
	['Unique'] = false,
	['Combinable'] = nil,
	['Description'] = "Sold on the streets yo.",
	['DecayRate'] = 0.3,
	['RemoveWhenDecayed'] = false,
	['Price'] = 1,
	['Cost'] = {
		{Item = 'emptybaggies', Amount = 1},
		{Item = 'weed-dried-bud-one', Amount = 1},
	}
}

Shared.ItemList["rolling-paper"] = {
	['ItemName'] = "rolling-paper",
	['Label'] = "Rolling Paper",
	['Weight'] = 0.30,
	['Type'] = "Item",
	['Metal'] = true,
	['Image'] = "c_rolling-paper.png",
	['Unique'] = false,
	['Combinable'] = nil,
	['Description'] = "Required to roll joints!",
	['DecayRate'] = 0.0,
	['RemoveWhenDecayed'] = false,
	['Price'] = 2,
}

Shared.ItemList["vpn"] = {
	['ItemName'] = "vpn",
	['Label'] = "VPN",
	['Weight'] = 4.5,
	['Type'] = "Item",
	['Metal'] = true,
	['Image'] = "c_vpn.png",
	['Unique'] = true,
	['Combinable'] = nil,
	['Description'] = "Let me connect to china please and claim that nice and moist ping.",
	['DecayRate'] = 0.7,
	['RemoveWhenDecayed'] = false,
	['Price'] = 1,
}

Shared.ItemList["advancedvpn"] = {
	['ItemName'] = "advancedvpn",
	['Label'] = "Advanced VPN",
	['Weight'] = 4.5,
	['Type'] = "Item",
	['Metal'] = true,
	['Image'] = "c_vpn.png",
	['Unique'] = true,
	['Combinable'] = nil,
	['Description'] = "Let me connect to antarctica please and claim that nice and moist ping.",
	['DecayRate'] = 0.7,
	['RemoveWhenDecayed'] = false,
	['Price'] = 1,
}

Shared.ItemList["laptop"] = {
	['ItemName'] = "laptop",
	['Label'] = "Laptop",
	['Weight'] = 2.5,
	['Type'] = "Item",
	['Metal'] = true,
	['Image'] = "c_laptop.png",
	['Unique'] = true,
	['Combinable'] = nil,
	['Description'] = "Don\'t go to my history!",
	['DecayRate'] = 0.5,
	['RemoveWhenDecayed'] = false,
	['Price'] = 1,
}

Shared.ItemList["scales"] = {
	['ItemName'] = "scales",
	['Label'] = "Scales",
	['Weight'] = 1.5,
	['Type'] = "Item",
	['Metal'] = true,
	['Image'] = "c_scales.png",
	['Unique'] = false,
	['Combinable'] = nil,
	['Description'] = "Is this acurate?!",
	['DecayRate'] = 0.1,
	['RemoveWhenDecayed'] = false,
	['Price'] = 95,
}

Shared.ItemList["handcuffs"] = {
	['ItemName'] = "handcuffs",
	['Label'] = "Handcuffs",
	['Weight'] = 0.15,
	['Type'] = "Item",
	['Metal'] = true,
	['Image'] = "c_handcuffs.png",
	['Unique'] = false,
	['Combinable'] = nil,
	['Description'] = "You want to do some kinky shit?",
	['DecayRate'] = 0.1,
	['RemoveWhenDecayed'] = false,
	['Price'] = 1,
	['Cost'] = {
		{Item = 'steel', Amount = 47},
		{Item = 'aluminum', Amount = 38},
	}
}

Shared.ItemList["lockpick"] = {
	['ItemName'] = "lockpick",
	['Label'] = "Lockpick",
	['Weight'] = 0.15,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "c_lockpick.png",
	['Unique'] = false,
	['Combinable'] = nil,
	['Description'] = "A lockpick..",
	['DecayRate'] = 0.1,
	['RemoveWhenDecayed'] = true,
	['Price'] = 1,
	['Cost'] = {
		{Item = 'steel', Amount = 23},
		{Item = 'plastic', Amount = 27},
		{Item = 'aluminum', Amount = 34},
	}
}

Shared.ItemList["advlockpick"] = {
	['ItemName'] = "advlockpick",
	['Label'] = "Advanced Lockpick",
	['Weight'] = 0.30,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "c_advlockpick.png",
	['Unique'] = false,
	['Combinable'] = nil,
	['Description'] = "A advanced lockpick..",
	['DecayRate'] = 0.1,
	['RemoveWhenDecayed'] = true,
	['Price'] = 1,
	['Cost'] = {
		{Item = 'steel', Amount = 34},
		{Item = 'plastic', Amount = 48},
		{Item = 'aluminum', Amount = 69},
	}
}

Shared.ItemList["heist-usb-green"] = {
	['ItemName'] = "heist-usb-green",
	['Label'] = "Green USB",
	['Weight'] = 0.15,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "c_heist_usb_green.png",
	['Unique'] = false,
	['Combinable'] = nil,
	['Description'] = "A green usb?",
	['DecayRate'] = 0.1,
	['RemoveWhenDecayed'] = true,
	['Price'] = 1,
}

Shared.ItemList["heist-usb-blue"] = {
	['ItemName'] = "heist-usb-blue",
	['Label'] = "Blue USB",
	['Weight'] = 0.15,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "c_heist_usb_blue.png",
	['Unique'] = false,
	['Combinable'] = nil,
	['Description'] = "A blue usb?",
	['DecayRate'] = 0.1,
	['RemoveWhenDecayed'] = true,
	['Price'] = 1,
}

Shared.ItemList["heist-usb-red"] = {
	['ItemName'] = "heist-usb-red",
	['Label'] = "Red USB",
	['Weight'] = 0.15,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "c_heist_usb_red.png",
	['Unique'] = false,
	['Combinable'] = nil,
	['Description'] = "A red usb?",
	['DecayRate'] = 0.1,
	['RemoveWhenDecayed'] = true,
	['Price'] = 1,
}

Shared.ItemList["heist-laptop-green"] = {
	['ItemName'] = "heist-laptop-green",
	['Label'] = "Green Laptop",
	['Weight'] = 0.15,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "c_heist_laptop_green.png",
	['Unique'] = false,
	['Combinable'] = nil,
	['Description'] = "Dont go to my history please daddy!",
	['DecayRate'] = 0.1,
	['RemoveWhenDecayed'] = true,
	['Price'] = 1,
}

Shared.ItemList["heist-laptop-blue"] = {
	['ItemName'] = "heist-laptop-blue",
	['Label'] = "Blue Laptop",
	['Weight'] = 0.15,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "c_heist_laptop_blue.png",
	['Unique'] = false,
	['Combinable'] = nil,
	['Description'] = "Dont go to my history please daddy!",
	['DecayRate'] = 0.1,
	['RemoveWhenDecayed'] = true,
	['Price'] = 1,
}

Shared.ItemList["heist-laptop-red"] = {
	['ItemName'] = "heist-laptop-red",
	['Label'] = "Red Laptop",
	['Weight'] = 0.15,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "c_heist_laptop_red.png",
	['Unique'] = false,
	['Combinable'] = nil,
	['Description'] = "Dont go to my history please daddy!",
	['DecayRate'] = 0.1,
	['RemoveWhenDecayed'] = true,
	['Price'] = 1,
}

Shared.ItemList["nightvison-goggles"] = {
	['ItemName'] = "nightvison-goggles",
	['Label'] = "Night Vision Goggles",
	['Weight'] = 10.0,
	['Type'] = "Item",
	['Metal'] = true,
	['Image'] = "c_nightvision.png",
	['Unique'] = false,
	['Combinable'] = nil,
	['Description'] = "High price, low quality.",
	['DecayRate'] = 0.2,
	['RemoveWhenDecayed'] = false,
	['Price'] = 5000,
}

Shared.ItemList["cash-bands"] = {
	['ItemName'] = "cash-bands",
	['Label'] = "Band of Notes",
	['Weight'] = 0.01,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "c_bands.png",
	['Unique'] = false,
	['Combinable'] = nil,
	['Description'] = "A stack with money..",
	['DecayRate'] = 0.0,
	['RemoveWhenDecayed'] = false,
	['Price'] = 1,
}

Shared.ItemList["cash-rolls"] = {
	['ItemName'] = "cash-rolls",
	['Label'] = "Roll of Small Notes",
	['Weight'] = 0.01,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "c_rolls.png",
	['Unique'] = false,
	['Combinable'] = nil,
	['Description'] = "Rolls of money..",
	['DecayRate'] = 30.0,
	['RemoveWhenDecayed'] = false,
	['Price'] = 1,
}

Shared.ItemList["markedbills"] = {
	['ItemName'] = "markedbills",
	['Label'] = "Markedbills",
	['Weight'] = 0.10,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "c_markedbills.png",
	['Unique'] = false,
	['Combinable'] = nil,
	['Description'] = "A bag of ink?",
	['DecayRate'] = 0.0,
	['RemoveWhenDecayed'] = false,
	['Prop'] = true,
	['Price'] = 1,
}

Shared.ItemList["gemstone"] = {
	['ItemName'] = "gemstone",
	['Label'] = "Gemstone",
	['Weight'] = 1.0,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "c_gemstone.png",
	['Unique'] = true,
	['Combinable'] = nil,
	['Description'] = "Its so shiny!",
	['DecayRate'] = 0.1,
	['RemoveWhenDecayed'] = false,
	['Price'] = 1,
}

Shared.ItemList["thermitecharge"] = {
	['ItemName'] = "thermitecharge",
	['Label'] = "Thermite Charge",
	['Weight'] = 6.0,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "c_thermitecharge.png",
	['Unique'] = false,
	['Combinable'] = nil,
	['Description'] = "This thing burns!",
	['DecayRate'] = 1.0,
	['RemoveWhenDecayed'] = true,
	['Price'] = 1,
}

Shared.ItemList["goldbar"] = {
	['ItemName'] = "goldbar",
	['Label'] = "Gold Bar",
	['Weight'] = 11.0,
	['Type'] = "Item",
	['Metal'] = true,
	['Image'] = "c_goldbar.png",
	['Unique'] = false,
	['Combinable'] = nil,
	['Description'] = "This do be shiny!",
	['DecayRate'] = 0.0,
	['RemoveWhenDecayed'] = false,
	['Price'] = 1,
}

Shared.ItemList["rolexwatch"] = {
	['ItemName'] = "rolexwatch",
	['Label'] = "Rolex Watch (P)",
	['Weight'] = 1.0,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "c_rolexwatch.png",
	['Unique'] = false,
	['Combinable'] = nil,
	['Description'] = "What's the time mate?",
	['DecayRate'] = 0.0,
	['RemoveWhenDecayed'] = false,
	['Price'] = 1,
}

Shared.ItemList["ring"] = {
	['ItemName'] = "ring",
	['Label'] = "Diamond Ring (P)",
	['Weight'] = 1.0,
	['Type'] = "Item",
	['Metal'] = true,
	['Image'] = "c_ring.png",
	['Unique'] = false,
	['Combinable'] = nil,
	['Description'] = "Is that a real diamond?",
	['DecayRate'] = 0.0,
	['RemoveWhenDecayed'] = false,
	['Price'] = 1,
}

Shared.ItemList["2ctchain"] = {
	['ItemName'] = "2ctchain",
	['Label'] = "2ct Gold Chain (P)",
	['Weight'] = 1.0,
	['Type'] = "Item",
	['Metal'] = true,
	['Image'] = "c_2ctchain.png",
	['Unique'] = false,
	['Combinable'] = nil,
	['Description'] = "Oi mate, that looks shiny.",
	['DecayRate'] = 0.0,
	['RemoveWhenDecayed'] = false,
	['Price'] = 1,
}

Shared.ItemList["5ctchain"] = {
	['ItemName'] = "5ctchain",
	['Label'] = "5ct Gold Chain (P)",
	['Weight'] = 1.5,
	['Type'] = "Item",
	['Metal'] = true,
	['Image'] = "c_5ctchain.png",
	['Unique'] = false,
	['Combinable'] = nil,
	['Description'] = "Oi mate, that looks shiny.",
	['DecayRate'] = 0.0,
	['RemoveWhenDecayed'] = false,
	['Price'] = 1,
}

Shared.ItemList["8ctchain"] = {
	['ItemName'] = "8ctchain",
	['Label'] = "8ct Gold Chain (P)",
	['Weight'] = 2.0,
	['Type'] = "Item",
	['Metal'] = true,
	['Image'] = "c_8ctchain.png",
	['Unique'] = false,
	['Combinable'] = nil,
	['Description'] = "Oi mate, that looks shiny.",
	['DecayRate'] = 0.0,
	['RemoveWhenDecayed'] = false,
	['Price'] = 1,
}

Shared.ItemList["goldtrophy"] = {
	['ItemName'] = "goldtrophy",
	['Label'] = "Golden Trophy (P)",
	['Weight'] = 1.0,
	['Type'] = "Item",
	['Metal'] = true,
	['Image'] = "c_trophy.png",
	['Unique'] = false,
	['Combinable'] = nil,
	['Description'] = "A star is born!",
	['DecayRate'] = 0.0,
	['RemoveWhenDecayed'] = false,
	['Price'] = 1,
}

Shared.ItemList["moonshine"] = {
	['ItemName'] = "moonshine",
	['Label'] = "Moonshine Jug (P)",
	['Weight'] = 5.0,
	['Type'] = "Item",
	['Metal'] = true,
	['Image'] = "c_moonshine.png",
	['Unique'] = false,
	['Combinable'] = nil,
	['Description'] = "Using the same jugs since 1910. Charisma incoming!",
	['DecayRate'] = 0.5,
	['RemoveWhenDecayed'] = false,
	['Price'] = 1,
}

Shared.ItemList["darkmarketdeliveries"] = {
	['ItemName'] = "darkmarketdeliveries",
	['Label'] = "Delivery List",
	['Weight'] = 1,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "c_darkmarketdeliveries.png",
	['Unique'] = true,
	['Combinable'] = nil,
	['Description'] = 'A suspicious list with transport instructions. Marked for Police Seizure.',
	['DecayRate'] = 0.006,
	['RemoveWhenDecayed'] = false,
	['Price'] = 1,
}

Shared.ItemList["darkmarketpackage"] = {
	['ItemName'] = "darkmarketpackage",
	['Label'] = "Suspicious Package",
	['Weight'] = 35,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "c_darkmarketpackage.png",
	['Unique'] = true,
	['Combinable'] = nil,
	['Description'] = "Package covered in tape and milk stickers. Marked for Police Seizure.",
	['DecayRate'] = 0.002,
	['RemoveWhenDecayed'] = false,
	['Prop'] = true,
	['Price'] = 1,
}

Shared.ItemList["oxy"] = {
	['ItemName'] = "oxy",
	['Label'] = "Oxy 100mg",
	['Weight'] = 3,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "c_oxy.png",
	['Unique'] = false,
	['Combinable'] = nil,
	['Description'] = "Take em all in one go.",
	['DecayRate'] = 0.75,
	['RemoveWhenDecayed'] = true,
	['Price'] = 1,
}

-- [ Misc

Shared.ItemList["binoculars"] = {
	['ItemName'] = "binoculars",
	['Label'] = "Binoculars",
	['Weight'] = 1.0,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "m_binoculars.png",
	['Unique'] = true,
	['Combinable'] = nil,
	['Description'] = "You are a little bit sneaky..",
	['DecayRate'] = 0.0,
	['RemoveWhenDecayed'] = false,
	['Price'] = 1,
}

Shared.ItemList["rental-papers"] = {
	['ItemName'] = "rental-papers",
	['Label'] = "Rental Papers",
	['Weight'] = 0.15,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "m_rental-papers.png",
	['Unique'] = true,
	['Combinable'] = nil,
	['Description'] = "I did not steal this vehicle..",
	['DecayRate'] = 0.0,
	['RemoveWhenDecayed'] = false,
	['Price'] = 1,
}

Shared.ItemList["casinomember"] = {
	['ItemName'] = "casinomember",
	['Label'] = "Member Card",
	['Weight'] = 0.15,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "m_casino_member.png",
	['Unique'] = true,
	['Combinable'] = nil,
	['Description'] = "All the games, all the fun. Diamond Casino.",
	['DecayRate'] = 0.25,
	['RemoveWhenDecayed'] = true,
	['Price'] = 3500,
}

Shared.ItemList["casinoloyalty"] = {
	['ItemName'] = "casinoloyalty",
	['Label'] = "Loyalty Card",
	['Weight'] = 0.15,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "m_casino_member.png",
	['Unique'] = true,
	['Combinable'] = nil,
	['Description'] = "All the games, all the fun. Diamond Casino.",
	['DecayRate'] = 0.01,
	['RemoveWhenDecayed'] = true,
	['Price'] = 3500,
}

Shared.ItemList["casinovip"] = {
	['ItemName'] = "casinovip",
	['Label'] = "High Roller Card",
	['Weight'] = 0.15,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "m_casino_high_roller.png",
	['Unique'] = true,
	['Combinable'] = nil,
	['Description'] = "Stacks on stacks on stacks. Diamond Casino.",
	['DecayRate'] = 0.025,
	['RemoveWhenDecayed'] = true,
	['Price'] = 60000,
}

Shared.ItemList["idcard"] = {
	['ItemName'] = "idcard",
	['Label'] = "Id Card",
	['Weight'] = 0.15,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "m_idcard.png",
	['Unique'] = true,
	['Combinable'] = nil,
	['Description'] = "Is that me on this card?!?",
	['DecayRate'] = 0.0,
	['RemoveWhenDecayed'] = false,
	['Price'] = 1,
}

Shared.ItemList["evidence"] = {
	['ItemName'] = "evidence",
	['Label'] = "Evidence",
	['Weight'] = 0.15,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "m_evidence.png",
	['Unique'] = false,
	['Combinable'] = nil,
	['Description'] = "Put some evidence in me..",
	['DecayRate'] = 0.0,
	['RemoveWhenDecayed'] = false,
	['Price'] = 1,
}

Shared.ItemList["evidence-finger"] = {
	['ItemName'] = "evidence-finger",
	['Label'] = "Fingerprint Evidence",
	['Weight'] = 0.10,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "m_evidence-green.png",
	['Unique'] = true,
	['Combinable'] = nil,
	['Description'] = "Who was bad?!?",
	['DecayRate'] = 0.0,
	['RemoveWhenDecayed'] = false,
	['Price'] = 1,
}

Shared.ItemList["evidence-blood"] = {
	['ItemName'] = "evidence-blood",
	['Label'] = "Blood Sample",
	['Weight'] = 0.10,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "m_evidence-red.png",
	['Unique'] = true,
	['Combinable'] = nil,
	['Description'] = "Requires scan..",
	['DecayRate'] = 0.0,
	['RemoveWhenDecayed'] = false,
	['Price'] = 1,
}

Shared.ItemList["evidence-bullet"] = {
	['ItemName'] = "evidence-bullet",
	['Label'] = "Bullet Evidence",
	['Weight'] = 0.10,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "m_evidence-orange.png",
	['Unique'] = true,
	['Combinable'] = nil,
	['Description'] = "Who was bad?!?",
	['DecayRate'] = 0.0,
	['RemoveWhenDecayed'] = false,
	['Price'] = 1,
}

Shared.ItemList["present"] = {
	['ItemName'] = "present",
	['Label'] = "Present",
	['Weight'] = 0.15,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "m_present.png",
	['Unique'] = false,
	['Combinable'] = nil,
	['Description'] = "Whats in it?",
	['DecayRate'] = 0.0,
	['RemoveWhenDecayed'] = false,
	['Price'] = 1,
}

Shared.ItemList["nitrous"] = {
	['ItemName'] = "nitrous",
	['Label'] = "Nitrous",
	['Weight'] = 2.1,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "m_nitrous.png",
	['Unique'] = false,
	['Combinable'] = nil,
	['Description'] = "Do not sniff please.",
	['DecayRate'] = 0.1,
	['RemoveWhenDecayed'] = false,
	['Price'] = 1,
}

Shared.ItemList["harness"] = {
	['ItemName'] = "harness",
	['Label'] = "Harness",
	['Weight'] = 2.1,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "m_harness.png",
	['Unique'] = false,
	['Combinable'] = nil,
	['Description'] = "So you don't fall out of your vehicle..",
	['DecayRate'] = 0.1,
	['RemoveWhenDecayed'] = false,
	['Price'] = 1,
}

Shared.ItemList["megaphone"] = {
	['ItemName'] = "megaphone",
	['Label'] = "Megaphone",
	['Weight'] = 0.20,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "m_megaphone.png",
	['Unique'] = false,
	['Combinable'] = nil,
	['Description'] = "Its sooo loud..",
	['DecayRate'] = 0.0,
	['RemoveWhenDecayed'] = false,
	['Price'] = 100,
}

Shared.ItemList["spikes"] = {
	['ItemName'] = "spikes",
	['Label'] = "PD Spikes",
	['Weight'] = 12.0,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "m_spikes.png",
	['Unique'] = false,
	['Combinable'] = nil,
	['Description'] = "Watch out it may pop a tire..",
	['DecayRate'] = 0.0,
	['RemoveWhenDecayed'] = false,
	['Price'] = 450,
}

Shared.ItemList["lawnchair"] = {
	['ItemName'] = "lawnchair",
	['Label'] = "Lawnchair",
	['Weight'] = 0.85,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "m_lawnchair.png",
	['Unique'] = false,
	['Combinable'] = nil,
	['Description'] = "Thi sits really nice wow!",
	['DecayRate'] = 0.0,
	['RemoveWhenDecayed'] = false,
	['Price'] = 450,
}

Shared.ItemList["radio"] = {
	['ItemName'] = "radio",
	['Label'] = "Radio",
	['Weight'] = 0.15,
	['Type'] = "Item",
	['Metal'] = true,
	['Image'] = "m_walkie.png",
	['Unique'] = false,
	['Combinable'] = nil,
	['Description'] = "This is bravo six copy..",
	['DecayRate'] = 0.1,
	['RemoveWhenDecayed'] = false,
	['Price'] = 1100,
	['Cost'] = {
		{Item = 'electronics', Amount = 15},
		{Item = 'plastic', Amount = 19},
		{Item = 'aluminum', Amount = 41},
		{Item = 'scrapmetal', Amount = 23},
	}
}

Shared.ItemList["pdradio"] = {
	['ItemName'] = "pdradio",
	['Label'] = "PD Radio",
	['Weight'] = 0.15,
	['Type'] = "Item",
	['Metal'] = true,
	['Image'] = "m_walkie.png",
	['Unique'] = false,
	['Combinable'] = nil,
	['Description'] = "This is bravo six copy..",
	['DecayRate'] = 0.1,
	['RemoveWhenDecayed'] = false,
	['Price'] = 200,
}

Shared.ItemList["pdwatch"] = {
	['ItemName'] = "pdwatch",
	['Label'] = "PD Watch & Compass",
	['Weight'] = 0.0,
	['Type'] = "Item",
	['Metal'] = true,
	['Image'] = "m_watch.png",
	['Unique'] = false,
	['Combinable'] = nil,
	['Description'] = "Government (PD/EMS/DOC) Issued Equipment",
	['DecayRate'] = 0.5,
	['RemoveWhenDecayed'] = false,
	['Price'] = 50,
}

Shared.ItemList["phone"] = {
	['ItemName'] = "phone",
	['Label'] = "Phone",
	['Weight'] = 0.15,
	['Type'] = "Item",
	['Metal'] = true,
	['Image'] = "m_phone.png",
	['Unique'] = false,
	['Combinable'] = nil,
	['Description'] = "Gimme that phone bitch",
	['DecayRate'] = 0.1,
	['RemoveWhenDecayed'] = false,
	['Price'] = 240,
	['Cost'] = {
		{Item = 'plastic', Amount = 30},
		{Item = 'scrapmetal', Amount = 5},
		{Item = 'electronics', Amount = 20},
	}
}

Shared.ItemList["toolbox"] = {
	['ItemName'] = "toolbox",
	['Label'] = "Toolbox",
	['Weight'] = 0.15,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "m_toolbox.png",
	['Unique'] = false,
	['Combinable'] = nil,
	['Description'] = "Repairs now pls..",
	['DecayRate'] = 0.1,
	['RemoveWhenDecayed'] = false,
	['Price'] = 140,
	['Cost'] = {
		{Item = 'plastic', Amount = 34},
		{Item = 'scrapmetal', Amount = 31},
		{Item = 'steel', Amount = 32},
		{Item = 'copper', Amount = 22},
	}
}

Shared.ItemList["tirekit"] = {
	['ItemName'] = "tirekit",
	['Label'] = "Tire Repairset",
	['Weight'] = 1.15,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "m_tirekit.png",
	['Unique'] = false,
	['Combinable'] = nil,
	['Description'] = "Repairs now pls..",
	['DecayRate'] = 0.1,
	['RemoveWhenDecayed'] = false,
	['Price'] = 100,
	['Cost'] = {
		{Item = 'plastic', Amount = 34},
		{Item = 'rubber', Amount = 50},
	}
}

Shared.ItemList["car-polish"] = {
	['ItemName'] = "car-polish",
	['Label'] = "Car Polish",
	['Weight'] = 1.15,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "m_car-polish.png",
	['Unique'] = false,
	['Combinable'] = nil,
	['Description'] = "Cleaning my ride yeeeeeee.",
	['DecayRate'] = 0.1,
	['RemoveWhenDecayed'] = false,
	['Price'] = 0,
	['Cost'] = {
		{Item = 'cleaningproduct', Amount = 1},
		{Item = 'bee-wax', Amount = 2},
	}
}

Shared.ItemList["cleaningproduct"] = {
	['ItemName'] = "cleaningproduct",
	['Label'] = "Cleaning Product",
	['Weight'] = 0.10,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "m_cleaningproduct.png",
	['Unique'] = false,
	['Combinable'] = nil,
	['Description'] = "Cleans n shit yo",
	['DecayRate'] = 0.01,
	['RemoveWhenDecayed'] = false,
	['Price'] = 240,
}

Shared.ItemList["bakingsoda"] = {
	['ItemName'] = "bakingsoda",
	['Label'] = "Baking Soda",
	['Weight'] = 0.10,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "m_bakingsoda.png",
	['Unique'] = false,
	['Combinable'] = nil,
	['Description'] = "Its Baking Soda..?",
	['DecayRate'] = 0.01,
	['RemoveWhenDecayed'] = false,
	['Price'] = 72,
}

Shared.ItemList["emptybaggies"] = {
	['ItemName'] = "emptybaggies",
	['Label'] = "Empty Baggies",
	['Weight'] = 0.10,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "m_emptybaggies.png",
	['Unique'] = false,
	['Combinable'] = nil,
	['Description'] = "Why is this empty?",
	['DecayRate'] = 0.0,
	['RemoveWhenDecayed'] = false,
	['Price'] = 8,
}

Shared.ItemList["gopro"] = {
	['ItemName'] = "gopro",
	['Label'] = "GoPro",
	['Weight'] = 1.0,
	['Type'] = "Item",
	['Metal'] = true,
	['Image'] = "m_gopro.png",
	['Unique'] = false,
	['Combinable'] = nil,
	['Description'] = "Security camera for things.",
	['DecayRate'] = 0.5,
	['RemoveWhenDecayed'] = true,
	['Price'] = 2000,
	['Cost'] = {
		{Item = 'rubber', Amount = 5},
		{Item = 'plastic', Amount = 25},
		{Item = 'scrapmetal', Amount = 10},
		{Item = 'electronics', Amount = 13},
	}
}

Shared.ItemList["gopropd"] = {
	['ItemName'] = "gopropd",
	['Label'] = "PD GoPro",
	['Weight'] = 1.0,
	['Type'] = "Item",
	['Metal'] = true,
	['Image'] = "m_gopro.png",
	['Unique'] = false,
	['Combinable'] = nil,
	['Description'] = "Government (PD/EMS/DOC) Issued Equipment",
	['DecayRate'] = 0.5,
	['RemoveWhenDecayed'] = true,
	['Price'] = 450,
}

Shared.ItemList["pdcamera"] = {
	['ItemName'] = "pdcamera",
	['Label'] = "PD Camera",
	['Weight'] = 1.0,
	['Type'] = "Item",
	['Metal'] = true,
	['Image'] = "m_camera.png",
	['Unique'] = false,
	['Combinable'] = nil,
	['Description'] = "Government (PD/EMS/DOC) Issued Equipment",
	['DecayRate'] = 0.0,
	['RemoveWhenDecayed'] = false,
	['Price'] = 2000,
}

Shared.ItemList["detcord"] = {
	['ItemName'] = "detcord",
	['Label'] = "Detcord",
	['Weight'] = 5.0,
	['Type'] = "Item",
	['Metal'] = true,
	['Image'] = "m_detcord.png",
	['Unique'] = false,
	['Combinable'] = nil,
	['Description'] = "FBI OPEN UP!",
	['DecayRate'] = 2.0,
	['RemoveWhenDecayed'] = false,
	['Price'] = 150,
}

Shared.ItemList["bee-queen"] = {
	['ItemName'] = "bee-queen",
	['Label'] = "Bee Queen",
	['Weight'] = 0.15,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "j_bee-queen.png",
	['Unique'] = false,
	['Combinable'] = nil,
	['Description'] = "And it looks like i am the queen!",
	['DecayRate'] = 0.1,
	['RemoveWhenDecayed'] = true,
	['Price'] = 125,
}

Shared.ItemList["bee-wax"] = {
	['ItemName'] = "bee-wax",
	['Label'] = "Bee Wax",
	['Weight'] = 0.75,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "j_bee-wax.png",
	['Unique'] = false,
	['Combinable'] = nil,
	['Description'] = "This is really sticky wtf..",
	['DecayRate'] = 0.1,
	['RemoveWhenDecayed'] = true,
	['Price'] = 1,
}

Shared.ItemList["bee-honey"] = {
	['ItemName'] = "bee-honey",
	['Label'] = "Bee Honey",
	['Weight'] = 1.15,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "j_bee-honey.png",
	['Unique'] = false,
	['Combinable'] = nil,
	['Description'] = "This smells good hmm..",
	['DecayRate'] = 0.1,
	['RemoveWhenDecayed'] = true,
	['Price'] = 1,
}

Shared.ItemList["beehive"] = {
	['ItemName'] = "beehive",
	['Label'] = "Beehive",
	['Weight'] = 11.5,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "j_beehive.png",
	['Unique'] = false,
	['Combinable'] = nil,
	['Description'] = "ZZZzzzZZZZzzzzzzzz..",
	['DecayRate'] = 0.1,
	['RemoveWhenDecayed'] = true,
	['Price'] = 450,
}

Shared.ItemList["hunting-bait"] = {
	['ItemName'] = "hunting-bait",
	['Label'] = "Animal Bait",
	['Weight'] = 0.50,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "j_hunting_bait.png",
	['Unique'] = false,
	['Combinable'] = nil,
	['Description'] = "Smells like old fish and shoes.",
	['DecayRate'] = 0.02,
	['RemoveWhenDecayed'] = true,
	['Price'] = 50,
}

Shared.ItemList["hunting-knife"] = {
	['ItemName'] = "hunting-knife",
	['Label'] = "Hunting Knife",
	['Weight'] = 4.5,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "j_hunting_knife.png",
	['Unique'] = false,
	['Combinable'] = nil,
	['Description'] = "Only cut animals! *Wink!*",
	['DecayRate'] = 2.0,
	['RemoveWhenDecayed'] = false,
	['Price'] = 100,
}

Shared.ItemList["hunting-carcass-one"] = {
	['ItemName'] = "hunting-carcass-one",
	['Label'] = "Animal Pelt",
	['Weight'] = 90.0,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "j_hunting_pelt_one.png",
	['Unique'] = true,
	['Combinable'] = nil,
	['Description'] = "What is this? Did you shoot it with an AK?",
	['DecayRate'] = 0.02,
	['RemoveWhenDecayed'] = false,
	['Prop'] = true,
	['Price'] = 1,
}

Shared.ItemList["hunting-carcass-two"] = {
	['ItemName'] = "hunting-carcass-two",
	['Label'] = "Animal Pelt",
	['Weight'] = 90.0,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "j_hunting_pelt_two.png",
	['Unique'] = true,
	['Combinable'] = nil,
	['Description'] = "Someone might pay a pretty penny for this.",
	['DecayRate'] = 0.02,
	['RemoveWhenDecayed'] = false,
	['Prop'] = true,
	['Price'] = 1,
}

Shared.ItemList["hunting-carcass-three"] = {
	['ItemName'] = "hunting-carcass-three",
	['Label'] = "Animal Pelt",
	['Weight'] = 90.0,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "j_hunting_pelt_three.png",
	['Unique'] = true,
	['Combinable'] = nil,
	['Description'] = "I am sure we can turn this in to something fancy.",
	['DecayRate'] = 0.02,
	['RemoveWhenDecayed'] = false,
	['Prop'] = true,
	['Price'] = 1,
}

Shared.ItemList["hunting-carcass-four"] = {
	['ItemName'] = "hunting-carcass-four",
	['Label'] = "Animal Pelt",
	['Weight'] = 90.0,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "j_hunting_pelt_four.png",
	['Unique'] = true,
	['Combinable'] = nil,
	['Description'] = "Hunting in Grove Street are we?",
	['DecayRate'] = 0.02,
	['RemoveWhenDecayed'] = false,
	['Prop'] = true,
	['Price'] = 1,
}

Shared.ItemList["hunting-meat"] = {
	['ItemName'] = "hunting-meat",
	['Label'] = "Animal Meat",
	['Weight'] = 1.0,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "j_hunting_meat.png",
	['Unique'] = false,
	['Combinable'] = nil,
	['Description'] = "I am sure this could turn in to a killer burger.",
	['DecayRate'] = 0.02,
	['RemoveWhenDecayed'] = false,
	['Price'] = 1,
}

Shared.ItemList["fishingrod"] = {
	['ItemName'] = "fishingrod",
	['Label'] = "Fishing Rod",
	['Weight'] = 1.0,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "j_fishingrod.png",
	['Unique'] = false,
	['Combinable'] = nil,
	['Description'] = "Lets fish.",
	['DecayRate'] = 0.0,
	['RemoveWhenDecayed'] = false,
	['Price'] = 100,
}

Shared.ItemList["fish-bass"] = {
	['ItemName'] = "fish-bass",
	['Label'] = "Bass",
	['Weight'] = 0.50,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "j_fishing-bass.png",
	['Unique'] = false,
	['Combinable'] = nil,
	['Description'] = "A bass not the guitar bass but the fish bass.",
	['DecayRate'] = 0.02,
	['RemoveWhenDecayed'] = false,
	['Price'] = 1,
}

Shared.ItemList["fish-blue"] = {
	['ItemName'] = "fish-blue",
	['Label'] = "Blue Fish",
	['Weight'] = 0.50,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "j_fishing-bluefish.png",
	['Unique'] = false,
	['Combinable'] = nil,
	['Description'] = "Whoever coined this name was a genius.",
	['DecayRate'] = 0.02,
	['RemoveWhenDecayed'] = false,
	['Price'] = 1,
}

Shared.ItemList["fish-cod"] = {
	['ItemName'] = "fish-cod",
	['Label'] = "Cod",
	['Weight'] = 0.50,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "j_fishing-cod.png",
	['Unique'] = false,
	['Combinable'] = nil,
	['Description'] = "Black Ops II.",
	['DecayRate'] = 0.02,
	['RemoveWhenDecayed'] = false,
	['Price'] = 1,
}

Shared.ItemList["fish-flounder"] = {
	['ItemName'] = "fish-flounder",
	['Label'] = "Flounder",
	['Weight'] = 0.50,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "j_fishing-flounder.png",
	['Unique'] = false,
	['Combinable'] = nil,
	['Description'] = "I went fishing and all I got was this lousy flounder.",
	['DecayRate'] = 0.02,
	['RemoveWhenDecayed'] = false,
	['Price'] = 1,
}

Shared.ItemList["fish-mackerel"] = {
	['ItemName'] = "fish-mackerel",
	['Label'] = "Mackerel",
	['Weight'] = 0.50,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "j_fishing-mackerel.png",
	['Unique'] = false,
	['Combinable'] = nil,
	['Description'] = "Sometimes holy.",
	['DecayRate'] = 0.02,
	['RemoveWhenDecayed'] = false,
	['Price'] = 1,
}

Shared.ItemList["fish-shark"] = {
	['ItemName'] = "fish-shark",
	['Label'] = "Baby Shark",
	['Weight'] = 90.0,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "j_fishing-shark.png",
	['Unique'] = false,
	['Combinable'] = nil,
	['Description'] = "A fucking shark! Someone might be interested in buying it? Lol, jk. Throw it back. Unless..?",
	['DecayRate'] = 0.02,
	['RemoveWhenDecayed'] = false,
	['Price'] = 1,
}

Shared.ItemList["fish-whale"] = {
	['ItemName'] = "fish-whale",
	['Label'] = "Baby Whale",
	['Weight'] = 90.0,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "j_fishing-whale.png",
	['Unique'] = false,
	['Combinable'] = nil,
	['Description'] = "A fucking whale! Someone might be interested in buying it? Lol, jk. Throw it back. Unless..?",
	['DecayRate'] = 0.02,
	['RemoveWhenDecayed'] = false,
	['Price'] = 1,
}

Shared.ItemList["mugoftea"] = {
	['ItemName'] = "mugoftea",
	['Label'] = "Mug of tea",
	['Weight'] = 0.0,
	['Type'] = "Item",
	['Metal'] = true,
	['Image'] = "mugoftea.png",
	['Unique'] = false,
	['Combinable'] = nil,
	['Description'] = "Slurp, slurp...",
	['DecayRate'] = 0.0,
	['RemoveWhenDecayed'] = true,
	['Price'] = 200,
}

Shared.ItemList["trowel"] = {
	['ItemName'] = "trowel",
	['Label'] = "Trowel",
	['Weight'] = 2.0,
	['Type'] = "Item",
	['Metal'] = true,
	['Image'] = "trowel.png",
	['Unique'] = true,
	['Combinable'] = nil,
	['Description'] = "Useful for digging holes",
	['DecayRate'] = 1.0,
	['RemoveWhenDecayed'] = true,
	['Price'] = 400,
}

Shared.ItemList["notepad"] = {
	['ItemName'] = "notepad",
	['Label'] = "Notepad",
	['Weight'] = 0.0,
	['Type'] = "Item",
	['Metal'] = true,
	['Image'] = "notepad.png",
	['Unique'] = false,
	['Combinable'] = nil,
	['Description'] = "A notepad with 10 pages",
	['DecayRate'] = 1.0,
	['RemoveWhenDecayed'] = true,
	['Price'] = 200,
}

Shared.ItemList["notepad-page"] = {
	['ItemName'] = "notepad-page",
	['Label'] = "A Note",
	['Weight'] = 0.0,
	['Type'] = "Item",
	['Metal'] = true,
	['Image'] = "notepad-page.png",
	['Unique'] = true,
	['Combinable'] = nil,
	['Description'] = "A note with text?",
	['DecayRate'] = 0.0,
	['RemoveWhenDecayed'] = true,
}

Shared.ItemList["metaldetector"] = {
	['ItemName'] = "metaldetector",
	['Label'] = "Metaldetector",
	['Weight'] = 20.0,
	['Type'] = "Item",
	['Metal'] = true,
	['Image'] = "metaldetector.png",
	['Unique'] = true,
	['Combinable'] = nil,
	['Description'] = "If I have to believe the internet, you can find similar gold diggers",
	['DecayRate'] = 0.5,
	['RemoveWhenDecayed'] = false,
	['Price'] = 25000,
}

Shared.ItemList["pickaxe"] = {
	['ItemName'] = "pickaxe",
	['Label'] = "Mining Pickaxe",
	['Weight'] = 20.0,
	['Type'] = "Item",
	['Metal'] = true,
	['Image'] = "j_pickaxe.png",
	['Unique'] = true,
	['Combinable'] = nil,
	['Description'] = "Minecwaft?",
	['DecayRate'] = 0.00277,
	['RemoveWhenDecayed'] = false,
	['Price'] = 1,
}

Shared.ItemList["scrapmetal"] = {
	['ItemName'] = "scrapmetal",
	['Label'] = "Scrap Metal",
	['Weight'] = 0.05,
	['Type'] = "Item",
	['Metal'] = true,
	['Image'] = "m_scrapmetal.png",
	['Unique'] = false,
	['Combinable'] = nil,
	['Description'] = "Its a material dude.",
	['DecayRate'] = 0.2,
	['RemoveWhenDecayed'] = true,
	['Price'] = 1,
	['Cost'] = {
		{ Item = 'recyclablematerial', Amount = 1 },
	}
}

Shared.ItemList["steel"] = {
	['ItemName'] = "steel",
	['Label'] = "Steel",
	['Weight'] = 0.05,
	['Type'] = "Item",
	['Metal'] = true,
	['Image'] = "m_steel.png",
	['Unique'] = false,
	['Combinable'] = nil,
	['Description'] = "Its a material dude.",
	['DecayRate'] = 0.2,
	['RemoveWhenDecayed'] = true,
	['Price'] = 1,
	['Cost'] = {
		{ Item = 'recyclablematerial', Amount = 1 },
	}
}

Shared.ItemList["plastic"] = {
	['ItemName'] = "plastic",
	['Label'] = "Plastic",
	['Weight'] = 0.05,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "m_plastic.png",
	['Unique'] = false,
	['Combinable'] = nil,
	['Description'] = "Its a material dude.",
	['DecayRate'] = 0.2,
	['RemoveWhenDecayed'] = true,
	['Price'] = 1,
	['Cost'] = {
		{ Item = 'recyclablematerial', Amount = 1 },
	}
}

Shared.ItemList["aluminum"] = {
	['ItemName'] = "aluminum",
	['Label'] = "Aluminum",
	['Weight'] = 0.05,
	['Type'] = "Item",
	['Metal'] = true,
	['Image'] = "m_aluminum.png",
	['Unique'] = false,
	['Combinable'] = nil,
	['Description'] = "Its a material dude.",
	['DecayRate'] = 0.2,
	['RemoveWhenDecayed'] = true,
	['Price'] = 1,
	['Cost'] = {
		{ Item = 'recyclablematerial', Amount = 1 },
	}
}

Shared.ItemList["copper"] = {
	['ItemName'] = "copper",
	['Label'] = "Copper",
	['Weight'] = 0.05,
	['Type'] = "Item",
	['Metal'] = true,
	['Image'] = "m_copper.png",
	['Unique'] = false,
	['Combinable'] = nil,
	['Description'] = "Its a material dude.",
	['DecayRate'] = 0.2,
	['RemoveWhenDecayed'] = true,
	['Price'] = 1,
	['Cost'] = {
		{ Item = 'recyclablematerial', Amount = 1 },
	}
}

Shared.ItemList["electronics"] = {
	['ItemName'] = "electronics",
	['Label'] = "Electronics",
	['Weight'] = 0.05,
	['Type'] = "Item",
	['Metal'] = true,
	['Image'] = "m_electronics.png",
	['Unique'] = false,
	['Combinable'] = nil,
	['Description'] = "Its a material dude.",
	['DecayRate'] = 0.2,
	['RemoveWhenDecayed'] = true,
	['Price'] = 1,
	['Cost'] = {
		{ Item = 'recyclablematerial', Amount = 1 },
	}
}

Shared.ItemList["rubber"] = {
	['ItemName'] = "rubber",
	['Label'] = "Rubber",
	['Weight'] = 0.05,
	['Type'] = "Item",
	['Metal'] = true,
	['Image'] = "m_rubber.png",
	['Unique'] = false,
	['Combinable'] = nil,
	['Description'] = "Its a material dude.",
	['DecayRate'] = 0.2,
	['RemoveWhenDecayed'] = true,
	['Price'] = 1,
	['Cost'] = {
		{ Item = 'recyclablematerial', Amount = 1 },
	}
}

Shared.ItemList["glass"] = {
	['ItemName'] = "glass",
	['Label'] = "Glass",
	['Weight'] = 0.05,
	['Type'] = "Item",
	['Metal'] = true,
	['Image'] = "m_glass.png",
	['Unique'] = false,
	['Combinable'] = nil,
	['Description'] = "Its a material dude.",
	['DecayRate'] = 0.5,
	['RemoveWhenDecayed'] = true,
	['Price'] = 12,
	['Cost'] = {
		{ Item = 'recyclablematerial', Amount = 1 },
	}
}

Shared.ItemList["recyclablematerial"] = {
	['ItemName'] = "recyclablematerial",
	['Label'] = "Recyclable Material",
	['Weight'] = 1.0,
	['Type'] = "Item",
	['Metal'] = true,
	['Image'] = "m_recyclablematerial.png",
	['Unique'] = false,
	['Combinable'] = nil,
	['Description'] = "This could be a material..",
	['DecayRate'] = 0.3,
	['RemoveWhenDecayed'] = true,
	['Price'] = 20,
}

Shared.ItemList["casino-high"] = {
	['ItemName'] = "casino-high",
	['Label'] = "High Roller Card",
	['Weight'] = 1.0,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "m_casino_high.png",
	['Unique'] = false,
	['Combinable'] = nil,
	['Description'] = "Stacks on stacks on stacks. Diamond Casino.",
	['DecayRate'] = 0.025,
	['RemoveWhenDecayed'] = true,
	['Price'] = 1,
}

Shared.ItemList["casino-coin"] = {
	['ItemName'] = "casino-coin",
	['Label'] = "Diamond Hotel Krugerrand",
	['Weight'] = 1.0,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "m_casino_coin.png",
	['Unique'] = false,
	['Combinable'] = nil,
	['Description'] = "Useful for stuff.",
	['DecayRate'] = 0.25,
	['RemoveWhenDecayed'] = true,
	['Price'] = 1,
}

Shared.ItemList["wheelchair"] = {
	['ItemName'] = "wheelchair",
	['Label'] = "Wheelchair",
	['Weight'] = 20.0,
	['Type'] = "Item",
	['Metal'] = true,
	['Image'] = "m_wheelchair.png",
	['Unique'] = true,
	['Combinable'] = nil,
	['Description'] = "Look at these wheels men.",
	['DecayRate'] = 0.0,
	['RemoveWhenDecayed'] = false,
	['Price'] = 1,
}

Shared.ItemList["pdbadge"] = {
	['ItemName'] = "pdbadge",
	['Label'] = "Police Badge",
	['Weight'] = 1.0,
	['Type'] = "Item",
	['Metal'] = true,
	['Image'] = "m_badge.png",
	['Unique'] = true,
	['Combinable'] = nil,
	['Description'] = "Who is this ?!",
	['DecayRate'] = 0.0,
	['RemoveWhenDecayed'] = false,
	['Price'] = 1,
}

Shared.ItemList["fsbadge"] = {
	['ItemName'] = "fsbadge",
	['Label'] = "Pilot's License",
	['Weight'] = 1.0,
	['Type'] = "Item",
	['Metal'] = true,
	['Image'] = "m_flightschoolbadge.png",
	['Unique'] = true,
	['Combinable'] = nil,
	['Description'] = "You learned how to fly, and with this badge you can show it to all your friends! (If you have any)",
	['DecayRate'] = 0.0,
	['RemoveWhenDecayed'] = false,
	['Price'] = 1,
}

Shared.ItemList["clothing-pants"] = {
	['ItemName'] = "clothing-pants",
	['Label'] = "Pants",
	['Weight'] = 1.0,
	['Type'] = "Item",
	['Metal'] = true,
	['Image'] = "m_pants.png",
	['Unique'] = true,
	['Combinable'] = nil,
	['Description'] = "Because apparently, 'no pants' is not an acceptable dress code.",
	['DecayRate'] = 0.0,
	['RemoveWhenDecayed'] = false,
	['Price'] = 1,
}

Shared.ItemList["clothing-shirts"] = {
	['ItemName'] = "clothing-shirts",
	['Label'] = "Shirt",
	['Weight'] = 1.0,
	['Type'] = "Item",
	['Metal'] = true,
	['Image'] = "m_shirts.png",
	['Unique'] = true,
	['Combinable'] = nil,
	['Description'] = "It's a shirt, not a magic wand. I can only do so much.",
	['DecayRate'] = 0.0,
	['RemoveWhenDecayed'] = false,
	['Price'] = 1,
}

Shared.ItemList["clothing-undershirt"] = {
	['ItemName'] = "clothing-undershirt",
	['Label'] = "UnderShirt",
	['Weight'] = 1.0,
	['Type'] = "Item",
	['Metal'] = true,
	['Image'] = "m_undershirt.png",
	['Unique'] = true,
	['Combinable'] = nil,
	['Description'] = "The unsung hero of the wardrobe. Works hard, gets no credit.",
	['DecayRate'] = 0.0,
	['RemoveWhenDecayed'] = false,
	['Price'] = 1,
}

Shared.ItemList["clothing-shoes"] = {
	['ItemName'] = "clothing-shoes",
	['Label'] = "Shoes",
	['Weight'] = 1.0,
	['Type'] = "Item",
	['Metal'] = true,
	['Image'] = "m_shoes.png",
	['Unique'] = true,
	['Combinable'] = nil,
	['Description'] = "Because walking barefoot everywhere is frowned upon in modern society.",
	['DecayRate'] = 0.0,
	['RemoveWhenDecayed'] = false,
	['Price'] = 1,
}

Shared.ItemList["clothing-armorvest"] = {
	['ItemName'] = "clothing-armorvest",
	['Label'] = "Armor Vest",
	['Weight'] = 1.0,
	['Type'] = "Item",
	['Metal'] = true,
	['Image'] = "m_armorvest.png",
	['Unique'] = true,
	['Combinable'] = nil,
	['Description'] = "Perfect for those days when your to-do list includes dodging danger.",
	['DecayRate'] = 0.0,
	['RemoveWhenDecayed'] = false,
	['Price'] = 1,
}

Shared.ItemList["clothing-bag"] = {
	['ItemName'] = "clothing-bag",
	['Label'] = "Bag",
	['Weight'] = 1.0,
	['Type'] = "Item",
	['Metal'] = true,
	['Image'] = "m_bag.png",
	['Unique'] = true,
	['Combinable'] = nil,
	['Description'] = "Carry your emotional baggage and your actual baggage.",
	['DecayRate'] = 0.0,
	['RemoveWhenDecayed'] = false,
	['Price'] = 1,
}

Shared.ItemList["clothing-hat"] = {
	['ItemName'] = "clothing-hat",
	['Label'] = "Hat",
	['Weight'] = 1.0,
	['Type'] = "Item",
	['Metal'] = true,
	['Image'] = "m_hat.png",
	['Unique'] = true,
	['Combinable'] = nil,
	['Description'] = "Put a hat on that head!",
	['DecayRate'] = 0.0,
	['RemoveWhenDecayed'] = false,
	['Price'] = 1,
}

Shared.ItemList["clothing-mask"] = {
	['ItemName'] = "clothing-mask",
	['Label'] = "Mask",
	['Weight'] = 1.0,
	['Type'] = "Item",
	['Metal'] = true,
	['Image'] = "m_mask.png",
	['Unique'] = true,
	['Combinable'] = nil,
	['Description'] = "Can you see me?!",
	['DecayRate'] = 0.0,
	['RemoveWhenDecayed'] = false,
	['Price'] = 1,
}

Shared.ItemList["clothing-glasses"] = {
	['ItemName'] = "clothing-glasses",
	['Label'] = "Glasses",
	['Weight'] = 1.0,
	['Type'] = "Item",
	['Metal'] = true,
	['Image'] = "m_glasses.png",
	['Unique'] = true,
	['Combinable'] = nil,
	['Description'] = "The glasses are so dirty yeez?!",
	['DecayRate'] = 0.0,
	['RemoveWhenDecayed'] = false,
	['Price'] = 1,
}

Shared.ItemList["hairtie"] = {
	['ItemName'] = "hairtie",
	['Label'] = "Hairtie",
	['Weight'] = 1.0,
	['Type'] = "Item",
	['Metal'] = true,
	['Image'] = "m_hairtie.png",
	['Unique'] = true,
	['Combinable'] = nil,
	['Description'] = "Its so cute!",
	['DecayRate'] = 0.0,
	['RemoveWhenDecayed'] = false,
	['Price'] = 17,
}

Shared.ItemList["hairspray"] = {
	['ItemName'] = "hairspray",
	['Label'] = "Hair Spray",
	['Weight'] = 1.0,
	['Type'] = "Item",
	['Metal'] = true,
	['Image'] = "m_hairspray.png",
	['Unique'] = true,
	['Combinable'] = nil,
	['Description'] = "I hope i don\'t get a streamer hair color.",
	['DecayRate'] = 0.0,
	['RemoveWhenDecayed'] = false,
	['Price'] = 45,
}

Shared.ItemList["scavbox"] = {
	['ItemName'] = "scavbox",
	['Label'] = "Scav Box",
	['Weight'] = 200.0,
	['Type'] = "Item",
	['Metal'] = true,
	['Image'] = "m_scavbox.png",
	['Unique'] = true,
	['Combinable'] = nil,
	['Description'] = "Its sooooo big!!!",
	['DecayRate'] = 2.0,
	['RemoveWhenDecayed'] = false,
	['Price'] = 1,
}

Shared.ItemList["walkman"] = {
	['ItemName'] = "walkman",
	['Label'] = "Walkman",
	['Weight'] = 10.0,
	['Type'] = "Item",
	['Metal'] = true,
	['Image'] = "m_walkman.png",
	['Unique'] = false,
	['Combinable'] = nil,
	['Description'] = "Songs please!!",
	['DecayRate'] = 2.0,
	['RemoveWhenDecayed'] = false,
	['Price'] = 121,
	['Cost'] = {
		{Item = 'plastic', Amount = 40},
		{Item = 'scrapmetal', Amount = 10},
		{Item = 'electronics', Amount = 13},
	}
}

Shared.ItemList["dice"] = {
	['ItemName'] = "dice",
	['Label'] = "Dices",
	['Weight'] = 1.0,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "m_dice.png",
	['Unique'] = false,
	['Combinable'] = nil,
	['Description'] = "Lets play a game.",
	['DecayRate'] = 2.0,
	['RemoveWhenDecayed'] = false,
	['Price'] = 12,
}

Shared.ItemList["blood-sample"] = {
	['ItemName'] = "blood-sample",
	['Label'] = "Blood Sample",
	['Weight'] = 1.0,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "m_blood.png",
	['Unique'] = true,
	['Combinable'] = nil,
	['Description'] = "A tube filled with blood.",
	['DecayRate'] = 0.0,
	['RemoveWhenDecayed'] = false,
	['Price'] = 0,
}

-- [ Car Parts ] --

-- Axle

Shared.ItemList["axle-s"] = {
	['ItemName'] = "axle-s",
	['Label'] = "Car Axle (S)",
	['Weight'] = 5.0,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "m_axle-s.png",
	['Unique'] = false,
	['Combinable'] = nil,
	['Description'] = "A car part.",
	['DecayRate'] = 0.2,
	['RemoveWhenDecayed'] = false,
	['Price'] = 0,
	['Cost'] = {
		{Item = 'generic-mechanic-part-s', Amount = 3 },
	}
}

Shared.ItemList["axle-a"] = {
	['ItemName'] = "axle-a",
	['Label'] = "Car Axle (A)",
	['Weight'] = 5.0,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "m_axle-a.png",
	['Unique'] = false,
	['Combinable'] = nil,
	['Description'] = "A car part.",
	['DecayRate'] = 0.2,
	['RemoveWhenDecayed'] = false,
	['Price'] = 0,
	['Cost'] = {
		{Item = 'generic-mechanic-part-a', Amount = 2 },
	}
}

Shared.ItemList["axle-b"] = {
	['ItemName'] = "axle-b",
	['Label'] = "Car Axle (B)",
	['Weight'] = 5.0,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "m_axle-b.png",
	['Unique'] = false,
	['Combinable'] = nil,
	['Description'] = "A car part.",
	['DecayRate'] = 0.2,
	['RemoveWhenDecayed'] = false,
	['Price'] = 0,
	['Cost'] = {
		{Item = 'generic-mechanic-part-b', Amount = 4 },
	}
}

Shared.ItemList["axle-c"] = {
	['ItemName'] = "axle-c",
	['Label'] = "Car Axle (C)",
	['Weight'] = 5.0,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "m_axle-c.png",
	['Unique'] = false,
	['Combinable'] = nil,
	['Description'] = "A car part.",
	['DecayRate'] = 0.2,
	['RemoveWhenDecayed'] = false,
	['Price'] = 0,
	['Cost'] = {
		{Item = 'generic-mechanic-part-c', Amount = 3 },
	}
}

Shared.ItemList["axle-d"] = {
	['ItemName'] = "axle-d",
	['Label'] = "Car Axle (D)",
	['Weight'] = 5.0,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "m_axle-d.png",
	['Unique'] = false,
	['Combinable'] = nil,
	['Description'] = "A car part.",
	['DecayRate'] = 0.2,
	['RemoveWhenDecayed'] = false,
	['Price'] = 0,
	['Cost'] = {
		{Item = 'generic-mechanic-part-d', Amount = 2 },
	}
}

Shared.ItemList["axle-e"] = {
	['ItemName'] = "axle-e",
	['Label'] = "Car Axle (E)",
	['Weight'] = 5.0,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "m_axle-e.png",
	['Unique'] = false,
	['Combinable'] = nil,
	['Description'] = "A car part.",
	['DecayRate'] = 0.2,
	['RemoveWhenDecayed'] = false,
	['Price'] = 0,
	['Cost'] = {
		{Item = 'generic-mechanic-part-e', Amount = 3 },
	}
}

Shared.ItemList["axle-m"] = {
	['ItemName'] = "axle-m",
	['Label'] = "Car Axle (M)",
	['Weight'] = 5.0,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "m_axle-m.png",
	['Unique'] = false,
	['Combinable'] = nil,
	['Description'] = "A car part.",
	['DecayRate'] = 0.2,
	['RemoveWhenDecayed'] = false,
	['Price'] = 0,
	['Cost'] = {
		{Item = 'generic-mechanic-part-m', Amount = 4 },
	}
}

-- Brakes

Shared.ItemList["brakes-s"] = {
	['ItemName'] = "brakes-s",
	['Label'] = "Car Brakes (S)",
	['Weight'] = 5.0,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "m_brakes-s.png",
	['Unique'] = false,
	['Combinable'] = nil,
	['Description'] = "A car part.",
	['DecayRate'] = 0.2,
	['RemoveWhenDecayed'] = false,
	['Price'] = 0,
	['Cost'] = {
		{Item = 'generic-mechanic-part-s', Amount = 3 },
	}
}

Shared.ItemList["brakes-a"] = {
	['ItemName'] = "brakes-a",
	['Label'] = "Car Brakes (A)",
	['Weight'] = 5.0,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "m_brakes-a.png",
	['Unique'] = false,
	['Combinable'] = nil,
	['Description'] = "A car part.",
	['DecayRate'] = 0.2,
	['RemoveWhenDecayed'] = false,
	['Price'] = 0,
	['Cost'] = {
		{Item = 'generic-mechanic-part-a', Amount = 2 },
	}
}

Shared.ItemList["brakes-b"] = {
	['ItemName'] = "brakes-b",
	['Label'] = "Car Brakes (B)",
	['Weight'] = 5.0,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "m_brakes-b.png",
	['Unique'] = false,
	['Combinable'] = nil,
	['Description'] = "A car part.",
	['DecayRate'] = 0.2,
	['RemoveWhenDecayed'] = false,
	['Price'] = 0,
	['Cost'] = {
		{Item = 'generic-mechanic-part-b', Amount = 4 },
	}
}

Shared.ItemList["brakes-c"] = {
	['ItemName'] = "brakes-c",
	['Label'] = "Car Brakes (C)",
	['Weight'] = 5.0,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "m_brakes-c.png",
	['Unique'] = false,
	['Combinable'] = nil,
	['Description'] = "A car part.",
	['DecayRate'] = 0.2,
	['RemoveWhenDecayed'] = false,
	['Price'] = 0,
	['Cost'] = {
		{Item = 'generic-mechanic-part-c', Amount = 3 },
	}
}

Shared.ItemList["brakes-d"] = {
	['ItemName'] = "brakes-d",
	['Label'] = "Car Brakes (D)",
	['Weight'] = 5.0,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "m_brakes-d.png",
	['Unique'] = false,
	['Combinable'] = nil,
	['Description'] = "A car part.",
	['DecayRate'] = 0.2,
	['RemoveWhenDecayed'] = false,
	['Price'] = 0,
	['Cost'] = {
		{Item = 'generic-mechanic-part-d', Amount = 2 },
	}
}

Shared.ItemList["brakes-e"] = {
	['ItemName'] = "brakes-e",
	['Label'] = "Car Brakes (E)",
	['Weight'] = 5.0,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "m_brakes-e.png",
	['Unique'] = false,
	['Combinable'] = nil,
	['Description'] = "A car part.",
	['DecayRate'] = 0.2,
	['RemoveWhenDecayed'] = false,
	['Price'] = 0,
	['Cost'] = {
		{Item = 'generic-mechanic-part-e', Amount = 3 },
	}
}

Shared.ItemList["brakes-m"] = {
	['ItemName'] = "brakes-m",
	['Label'] = "Car Brakes (M)",
	['Weight'] = 5.0,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "m_brakes-m.png",
	['Unique'] = false,
	['Combinable'] = nil,
	['Description'] = "A car part.",
	['DecayRate'] = 0.2,
	['RemoveWhenDecayed'] = false,
	['Price'] = 0,
	['Cost'] = {
		{Item = 'generic-mechanic-part-m', Amount = 4 },
	}
}

-- Clutch

Shared.ItemList["clutch-s"] = {
	['ItemName'] = "clutch-s",
	['Label'] = "Car Clutch (S)",
	['Weight'] = 5.0,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "m_clutch-s.png",
	['Unique'] = false,
	['Combinable'] = nil,
	['Description'] = "A car part.",
	['DecayRate'] = 0.2,
	['RemoveWhenDecayed'] = false,
	['Price'] = 0,
	['Cost'] = {
		{Item = 'generic-mechanic-part-s', Amount = 3 },
	}
}

Shared.ItemList["clutch-a"] = {
	['ItemName'] = "clutch-a",
	['Label'] = "Car Clutch (A)",
	['Weight'] = 5.0,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "m_clutch-a.png",
	['Unique'] = false,
	['Combinable'] = nil,
	['Description'] = "A car part.",
	['DecayRate'] = 0.2,
	['RemoveWhenDecayed'] = false,
	['Price'] = 0,
	['Cost'] = {
		{Item = 'generic-mechanic-part-a', Amount = 2 },
	}
}

Shared.ItemList["clutch-b"] = {
	['ItemName'] = "clutch-b",
	['Label'] = "Car Clutch (B)",
	['Weight'] = 5.0,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "m_clutch-b.png",
	['Unique'] = false,
	['Combinable'] = nil,
	['Description'] = "A car part.",
	['DecayRate'] = 0.2,
	['RemoveWhenDecayed'] = false,
	['Price'] = 0,
	['Cost'] = {
		{Item = 'generic-mechanic-part-b', Amount = 4 },
	}
}

Shared.ItemList["clutch-c"] = {
	['ItemName'] = "clutch-c",
	['Label'] = "Car Clutch (C)",
	['Weight'] = 5.0,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "m_clutch-c.png",
	['Unique'] = false,
	['Combinable'] = nil,
	['Description'] = "A car part.",
	['DecayRate'] = 0.2,
	['RemoveWhenDecayed'] = false,
	['Price'] = 0,
	['Cost'] = {
		{Item = 'generic-mechanic-part-c', Amount = 3 },
	}
}

Shared.ItemList["clutch-d"] = {
	['ItemName'] = "clutch-d",
	['Label'] = "Car Clutch (D)",
	['Weight'] = 5.0,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "m_clutch-d.png",
	['Unique'] = false,
	['Combinable'] = nil,
	['Description'] = "A car part.",
	['DecayRate'] = 0.2,
	['RemoveWhenDecayed'] = false,
	['Price'] = 0,
	['Cost'] = {
		{Item = 'generic-mechanic-part-d', Amount = 2 },
	}
}

Shared.ItemList["clutch-e"] = {
	['ItemName'] = "clutch-e",
	['Label'] = "Car Clutch (E)",
	['Weight'] = 5.0,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "m_clutch-e.png",
	['Unique'] = false,
	['Combinable'] = nil,
	['Description'] = "A car part.",
	['DecayRate'] = 0.2,
	['RemoveWhenDecayed'] = false,
	['Price'] = 0,
	['Cost'] = {
		{Item = 'generic-mechanic-part-e', Amount = 3 },
	}
}

Shared.ItemList["clutch-m"] = {
	['ItemName'] = "clutch-m",
	['Label'] = "Car Clutch (M)",
	['Weight'] = 5.0,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "m_clutch-m.png",
	['Unique'] = false,
	['Combinable'] = nil,
	['Description'] = "A car part.",
	['DecayRate'] = 0.2,
	['RemoveWhenDecayed'] = false,
	['Price'] = 0,
	['Cost'] = {
		{Item = 'generic-mechanic-part-m', Amount = 4 },
	}
}

-- Engine

Shared.ItemList["engine-s"] = {
	['ItemName'] = "engine-s",
	['Label'] = "Car Engine (S)",
	['Weight'] = 5.0,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "m_engine-s.png",
	['Unique'] = false,
	['Combinable'] = nil,
	['Description'] = "A car part.",
	['DecayRate'] = 0.2,
	['RemoveWhenDecayed'] = false,
	['Price'] = 0,
	['Cost'] = {
		{Item = 'generic-mechanic-part-s', Amount = 3 },
	}
}

Shared.ItemList["engine-a"] = {
	['ItemName'] = "engine-a",
	['Label'] = "Car Engine (A)",
	['Weight'] = 5.0,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "m_engine-a.png",
	['Unique'] = false,
	['Combinable'] = nil,
	['Description'] = "A car part.",
	['DecayRate'] = 0.2,
	['RemoveWhenDecayed'] = false,
	['Price'] = 0,
	['Cost'] = {
		{Item = 'generic-mechanic-part-a', Amount = 2 },
	}
}

Shared.ItemList["engine-b"] = {
	['ItemName'] = "engine-b",
	['Label'] = "Car Engine (B)",
	['Weight'] = 5.0,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "m_engine-b.png",
	['Unique'] = false,
	['Combinable'] = nil,
	['Description'] = "A car part.",
	['DecayRate'] = 0.2,
	['RemoveWhenDecayed'] = false,
	['Price'] = 0,
	['Cost'] = {
		{Item = 'generic-mechanic-part-b', Amount = 4 },
	}
}

Shared.ItemList["engine-c"] = {
	['ItemName'] = "engine-c",
	['Label'] = "Car Engine (C)",
	['Weight'] = 5.0,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "m_engine-c.png",
	['Unique'] = false,
	['Combinable'] = nil,
	['Description'] = "A car part.",
	['DecayRate'] = 0.2,
	['RemoveWhenDecayed'] = false,
	['Price'] = 0,
	['Cost'] = {
		{Item = 'generic-mechanic-part-c', Amount = 3 },
	}
}

Shared.ItemList["engine-d"] = {
	['ItemName'] = "engine-d",
	['Label'] = "Car Engine (D)",
	['Weight'] = 5.0,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "m_engine-d.png",
	['Unique'] = false,
	['Combinable'] = nil,
	['Description'] = "A car part.",
	['DecayRate'] = 0.2,
	['RemoveWhenDecayed'] = false,
	['Price'] = 0,
	['Cost'] = {
		{Item = 'generic-mechanic-part-d', Amount = 2 },
	}
}

Shared.ItemList["engine-e"] = {
	['ItemName'] = "engine-e",
	['Label'] = "Car Engine (E)",
	['Weight'] = 5.0,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "m_engine-e.png",
	['Unique'] = false,
	['Combinable'] = nil,
	['Description'] = "A car part.",
	['DecayRate'] = 0.2,
	['RemoveWhenDecayed'] = false,
	['Price'] = 0,
	['Cost'] = {
		{Item = 'generic-mechanic-part-e', Amount = 3 },
	}
}

Shared.ItemList["engine-m"] = {
	['ItemName'] = "engine-m",
	['Label'] = "Car Engine (M)",
	['Weight'] = 5.0,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "m_engine-m.png",
	['Unique'] = false,
	['Combinable'] = nil,
	['Description'] = "A car part.",
	['DecayRate'] = 0.2,
	['RemoveWhenDecayed'] = false,
	['Price'] = 0,
	['Cost'] = {
		{Item = 'generic-mechanic-part-m', Amount = 4 },
	}
}

-- Injectors

Shared.ItemList["injectors-s"] = {
	['ItemName'] = "injectors-s",
	['Label'] = "Car Fuel Injectors (S)",
	['Weight'] = 5.0,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "m_injectors-s.png",
	['Unique'] = false,
	['Combinable'] = nil,
	['Description'] = "A car part.",
	['DecayRate'] = 0.2,
	['RemoveWhenDecayed'] = false,
	['Price'] = 0,
	['Cost'] = {
		{Item = 'generic-mechanic-part-s', Amount = 3 },
	}
}

Shared.ItemList["injectors-a"] = {
	['ItemName'] = "injectors-a",
	['Label'] = "Car Fuel Injectors (A)",
	['Weight'] = 5.0,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "m_injectors-a.png",
	['Unique'] = false,
	['Combinable'] = nil,
	['Description'] = "A car part.",
	['DecayRate'] = 0.2,
	['RemoveWhenDecayed'] = false,
	['Price'] = 0,
	['Cost'] = {
		{Item = 'generic-mechanic-part-a', Amount = 2 },
	}
}

Shared.ItemList["injectors-b"] = {
	['ItemName'] = "injectors-b",
	['Label'] = "Car Fuel Injectors (B)",
	['Weight'] = 5.0,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "m_injectors-b.png",
	['Unique'] = false,
	['Combinable'] = nil,
	['Description'] = "A car part.",
	['DecayRate'] = 0.2,
	['RemoveWhenDecayed'] = false,
	['Price'] = 0,
	['Cost'] = {
		{Item = 'generic-mechanic-part-b', Amount = 4 },
	}
}

Shared.ItemList["injectors-c"] = {
	['ItemName'] = "injectors-c",
	['Label'] = "Car Fuel Injectors (C)",
	['Weight'] = 5.0,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "m_injectors-c.png",
	['Unique'] = false,
	['Combinable'] = nil,
	['Description'] = "A car part.",
	['DecayRate'] = 0.2,
	['RemoveWhenDecayed'] = false,
	['Price'] = 0,
	['Cost'] = {
		{Item = 'generic-mechanic-part-c', Amount = 3 },
	}
}


Shared.ItemList["injectors-d"] = {
	['ItemName'] = "injectors-d",
	['Label'] = "Car Fuel Injectors (D)",
	['Weight'] = 5.0,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "m_injectors-d.png",
	['Unique'] = false,
	['Combinable'] = nil,
	['Description'] = "A car part.",
	['DecayRate'] = 0.2,
	['RemoveWhenDecayed'] = false,
	['Price'] = 0,
	['Cost'] = {
		{Item = 'generic-mechanic-part-d', Amount = 2 },
	}
}

Shared.ItemList["injectors-e"] = {
	['ItemName'] = "injectors-e",
	['Label'] = "Car Fuel Injectors (E)",
	['Weight'] = 5.0,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "m_injectors-e.png",
	['Unique'] = false,
	['Combinable'] = nil,
	['Description'] = "A car part.",
	['DecayRate'] = 0.2,
	['RemoveWhenDecayed'] = false,
	['Price'] = 0,
	['Cost'] = {
		{Item = 'generic-mechanic-part-e', Amount = 3 },
	}
}

Shared.ItemList["injectors-m"] = {
	['ItemName'] = "injectors-m",
	['Label'] = "Car Fuel Injectors (M)",
	['Weight'] = 5.0,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "m_injectors-m.png",
	['Unique'] = false,
	['Combinable'] = nil,
	['Description'] = "A car part.",
	['DecayRate'] = 0.2,
	['RemoveWhenDecayed'] = false,
	['Price'] = 0,
	['Cost'] = {
		{Item = 'generic-mechanic-part-m', Amount = 4 },
	}
}

-- Transmission

Shared.ItemList["transmission-s"] = {
	['ItemName'] = "transmission-s",
	['Label'] = "Car Transmission (S)",
	['Weight'] = 5.0,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "m_transmission-s.png",
	['Unique'] = false,
	['Combinable'] = nil,
	['Description'] = "A car part.",
	['DecayRate'] = 0.2,
	['RemoveWhenDecayed'] = false,
	['Price'] = 0,
	['Cost'] = {
		{Item = 'generic-mechanic-part-s', Amount = 3 },
	}
}

Shared.ItemList["transmission-a"] = {
	['ItemName'] = "transmission-a",
	['Label'] = "Car Transmission (A)",
	['Weight'] = 5.0,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "m_transmission-a.png",
	['Unique'] = false,
	['Combinable'] = nil,
	['Description'] = "A car part.",
	['DecayRate'] = 0.2,
	['RemoveWhenDecayed'] = false,
	['Price'] = 0,
	['Cost'] = {
		{Item = 'generic-mechanic-part-a', Amount = 2 },
	}
}

Shared.ItemList["transmission-b"] = {
	['ItemName'] = "transmission-b",
	['Label'] = "Car Transmission (B)",
	['Weight'] = 5.0,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "m_transmission-b.png",
	['Unique'] = false,
	['Combinable'] = nil,
	['Description'] = "A car part.",
	['DecayRate'] = 0.2,
	['RemoveWhenDecayed'] = false,
	['Price'] = 0,
	['Cost'] = {
		{Item = 'generic-mechanic-part-b', Amount = 4 },
	}
}

Shared.ItemList["transmission-c"] = {
	['ItemName'] = "transmission-c",
	['Label'] = "Car Transmission (C)",
	['Weight'] = 5.0,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "m_transmission-c.png",
	['Unique'] = false,
	['Combinable'] = nil,
	['Description'] = "A car part.",
	['DecayRate'] = 0.2,
	['RemoveWhenDecayed'] = false,
	['Price'] = 0,
	['Cost'] = {
		{Item = 'generic-mechanic-part-c', Amount = 3 },
	}
}

Shared.ItemList["transmission-d"] = {
	['ItemName'] = "transmission-d",
	['Label'] = "Car Transmission (D)",
	['Weight'] = 5.0,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "m_transmission-d.png",
	['Unique'] = false,
	['Combinable'] = nil,
	['Description'] = "A car part.",
	['DecayRate'] = 0.2,
	['RemoveWhenDecayed'] = false,
	['Price'] = 0,
	['Cost'] = {
		{Item = 'generic-mechanic-part-d', Amount = 2 },
	}
}

Shared.ItemList["transmission-e"] = {
	['ItemName'] = "transmission-e",
	['Label'] = "Car Transmission (E)",
	['Weight'] = 5.0,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "m_transmission-e.png",
	['Unique'] = false,
	['Combinable'] = nil,
	['Description'] = "A car part.",
	['DecayRate'] = 0.2,
	['RemoveWhenDecayed'] = false,
	['Price'] = 0,
	['Cost'] = {
		{Item = 'generic-mechanic-part-e', Amount = 3 },
	}
}

Shared.ItemList["transmission-m"] = {
	['ItemName'] = "transmission-m",
	['Label'] = "Car Transmission (M)",
	['Weight'] = 5.0,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "m_transmission-m.png",
	['Unique'] = false,
	['Combinable'] = nil,
	['Description'] = "A car part.",
	['DecayRate'] = 0.2,
	['RemoveWhenDecayed'] = false,
	['Price'] = 0,
	['Cost'] = {
		{Item = 'generic-mechanic-part-m', Amount = 4 },
	}
}

-- Mechanic Parts

Shared.ItemList["generic-mechanic-part-s"] = {
	['ItemName'] = "generic-mechanic-part-s",
	['Label'] = "Mechanic Part (S)",
	['Weight'] = 1.0,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "m_generic-mechanic-part-s.png",
	['Unique'] = false,
	['Combinable'] = nil,
	['Description'] = "A mechanical part.",
	['DecayRate'] = 2.0,
	['RemoveWhenDecayed'] = true,
	['Price'] = 0,
	['Cost'] = {
		{ Item = 'aluminum', Amount = 6 },
		{ Item = 'copper', Amount = 6 },
		{ Item = 'plastic', Amount = 6 },
		{ Item = 'rubber', Amount = 6 },
		{ Item = 'steel', Amount = 6 },
		{ Item = 'scrapmetal', Amount = 6 },
		{ Item = 'electronics', Amount = 6 },
	}
}

Shared.ItemList["generic-mechanic-part-a"] = {
	['ItemName'] = "generic-mechanic-part-a",
	['Label'] = "Mechanic Part (A)",
	['Weight'] = 1.0,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "m_generic-mechanic-part-a.png",
	['Unique'] = false,
	['Combinable'] = nil,
	['Description'] = "A mechanical part.",
	['DecayRate'] = 2.0,
	['RemoveWhenDecayed'] = true,
	['Price'] = 0,
	['Cost'] = {
		{ Item = 'aluminum', Amount = 3 },
		{ Item = 'copper', Amount = 3 },
		{ Item = 'plastic', Amount = 3 },
		{ Item = 'rubber', Amount = 3 },
		{ Item = 'steel', Amount = 3 },
		{ Item = 'scrapmetal', Amount = 3 },
		{ Item = 'electronics', Amount = 3 },
	}
}

Shared.ItemList["generic-mechanic-part-b"] = {
	['ItemName'] = "generic-mechanic-part-b",
	['Label'] = "Mechanic Part (B)",
	['Weight'] = 1.0,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "m_generic-mechanic-part-b.png",
	['Unique'] = false,
	['Combinable'] = nil,
	['Description'] = "A mechanical part.",
	['DecayRate'] = 2.0,
	['RemoveWhenDecayed'] = true,
	['Price'] = 0,
	['Cost'] = {
		{ Item = 'aluminum', Amount = 1 },
		{ Item = 'copper', Amount = 1 },
		{ Item = 'plastic', Amount = 1 },
		{ Item = 'rubber', Amount = 1 },
		{ Item = 'steel', Amount = 1 },
		{ Item = 'scrapmetal', Amount = 1 },
		{ Item = 'electronics', Amount = 1 },
	}
}

Shared.ItemList["generic-mechanic-part-c"] = {
	['ItemName'] = "generic-mechanic-part-c",
	['Label'] = "Mechanic Part (C)",
	['Weight'] = 1.0,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "m_generic-mechanic-part-c.png",
	['Unique'] = false,
	['Combinable'] = nil,
	['Description'] = "A mechanical part.",
	['DecayRate'] = 2.0,
	['RemoveWhenDecayed'] = true,
	['Price'] = 0,
	['Cost'] = {
		{ Item = 'aluminum', Amount = 1 },
		{ Item = 'copper', Amount = 1 },
		{ Item = 'plastic', Amount = 1 },
		{ Item = 'rubber', Amount = 1 },
		{ Item = 'steel', Amount = 1 },
		{ Item = 'scrapmetal', Amount = 1 },
		{ Item = 'electronics', Amount = 1 },
	}
}

Shared.ItemList["generic-mechanic-part-d"] = {
	['ItemName'] = "generic-mechanic-part-d",
	['Label'] = "Mechanic Part (D)",
	['Weight'] = 1.0,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "m_generic-mechanic-part-d.png",
	['Unique'] = false,
	['Combinable'] = nil,
	['Description'] = "A mechanical part.",
	['DecayRate'] = 2.0,
	['RemoveWhenDecayed'] = true,
	['Price'] = 0,
	['Cost'] = {
		{ Item = 'aluminum', Amount = 1 },
		{ Item = 'copper', Amount = 1 },
		{ Item = 'plastic', Amount = 1 },
		{ Item = 'rubber', Amount = 1 },
		{ Item = 'steel', Amount = 1 },
		{ Item = 'scrapmetal', Amount = 1 },
		{ Item = 'electronics', Amount = 1 },
	}
}

Shared.ItemList["generic-mechanic-part-e"] = {
	['ItemName'] = "generic-mechanic-part-e",
	['Label'] = "Mechanic Part (E)",
	['Weight'] = 1.0,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "m_generic-mechanic-part-e.png",
	['Unique'] = false,
	['Combinable'] = nil,
	['Description'] = "A mechanical part.",
	['DecayRate'] = 2.0,
	['RemoveWhenDecayed'] = true,
	['Price'] = 0,
	['Cost'] = {
		{ Item = 'aluminum', Amount = 1 },
		{ Item = 'copper', Amount = 1 },
		{ Item = 'plastic', Amount = 1 },
		{ Item = 'rubber', Amount = 1 },
		{ Item = 'steel', Amount = 1 },
		{ Item = 'scrapmetal', Amount = 1 },
		{ Item = 'electronics', Amount = 1 },
	}
}

Shared.ItemList["generic-mechanic-part-m"] = {
	['ItemName'] = "generic-mechanic-part-m",
	['Label'] = "Mechanic Part (M)",
	['Weight'] = 1.0,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "m_generic-mechanic-part-m.png",
	['Unique'] = false,
	['Combinable'] = nil,
	['Description'] = "A mechanical part.",
	['DecayRate'] = 2.0,
	['RemoveWhenDecayed'] = true,
	['Price'] = 0,
	['Cost'] = {
		{ Item = 'aluminum', Amount = 1 },
		{ Item = 'copper', Amount = 1 },
		{ Item = 'plastic', Amount = 1 },
		{ Item = 'rubber', Amount = 1 },
		{ Item = 'steel', Amount = 1 },
		{ Item = 'scrapmetal', Amount = 1 },
		{ Item = 'electronics', Amount = 1 },
	}
}

-- 

Shared.ItemList["receipt"] = {
	['ItemName'] = "receipt",
	['Label'] = "Work Receipt",
	['Weight'] = 0.1,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "m_receipt.png",
	['Unique'] = true,
	['Combinable'] = nil,
	['Description'] = "A receipt.",
	['DecayRate'] = 0.0,
	['RemoveWhenDecayed'] = false,
	['Price'] = 0,
}

Shared.ItemList["cerberus-chain"] = {
	['ItemName'] = "cerberus-chain",
	['Label'] = "Cerberus Chain",
	['Weight'] = 0.1,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "c_cerberus_chain.png",
	['Unique'] = true,
	['Combinable'] = nil,
	['Description'] = "Represent!",
	['DecayRate'] = 0.0,
	['RemoveWhenDecayed'] = false,
	['Price'] = 1,
}

Shared.ItemList["cg-chain"] = {
	['ItemName'] = "cg-chain",
	['Label'] = "Chang Gang Chain",
	['Weight'] = 0.1,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "c_cg_chain.png",
	['Unique'] = true,
	['Combinable'] = nil,
	['Description'] = "Represent!",
	['DecayRate'] = 0.0,
	['RemoveWhenDecayed'] = false,
	['Price'] = 1,
}

Shared.ItemList["cg2-chain"] = {
	['ItemName'] = "cg2-chain",
	['Label'] = "Chang Gang Chain",
	['Weight'] = 0.1,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "c_cg_chain2.png",
	['Unique'] = true,
	['Combinable'] = nil,
	['Description'] = "Represent!",
	['DecayRate'] = 0.0,
	['RemoveWhenDecayed'] = false,
	['Price'] = 1,
}

Shared.ItemList["esv-chain"] = {
	['ItemName'] = "esv-chain",
	['Label'] = "ESV Chain",
	['Weight'] = 0.1,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "c_esv_chain.png",
	['Unique'] = true,
	['Combinable'] = nil,
	['Description'] = "Represent!",
	['DecayRate'] = 0.0,
	['RemoveWhenDecayed'] = false,
	['Price'] = 1,
}

Shared.ItemList["gg-chain"] = {
	['ItemName'] = "gg-chain",
	['Label'] = "GG Chain",
	['Weight'] = 0.1,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "c_gg_chain.png",
	['Unique'] = true,
	['Combinable'] = nil,
	['Description'] = "Represent!",
	['DecayRate'] = 0.0,
	['RemoveWhenDecayed'] = false,
	['Price'] = 1,
}

Shared.ItemList["gsf-chain"] = {
	['ItemName'] = "gsf-chain",
	['Label'] = "GSF Chain",
	['Weight'] = 0.1,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "c_gsf_chain.png",
	['Unique'] = true,
	['Combinable'] = nil,
	['Description'] = "Represent!",
	['DecayRate'] = 0.0,
	['RemoveWhenDecayed'] = false,
	['Price'] = 1,
}

Shared.ItemList["koil-chain"] = {
	['ItemName'] = "koil-chain",
	['Label'] = "Sloth Chain",
	['Weight'] = 0.1,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "c_sloth_chain.png",
	['Unique'] = true,
	['Combinable'] = nil,
	['Description'] = "Represent!",
	['DecayRate'] = 0.0,
	['RemoveWhenDecayed'] = false,
	['Price'] = 1,
}

Shared.ItemList["mdm-chain"] = {
	['ItemName'] = "mdm-chain",
	['Label'] = "MandeM Chain",
	['Weight'] = 0.1,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "c_mdm_chain.png",
	['Unique'] = true,
	['Combinable'] = nil,
	['Description'] = "Represent!",
	['DecayRate'] = 0.0,
	['RemoveWhenDecayed'] = false,
	['Price'] = 1,
}

Shared.ItemList["nbc-chain"] = {
	['ItemName'] = "nbc-chain",
	['Label'] = "NBC Chain",
	['Weight'] = 0.1,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "c_nbc_chain.png",
	['Unique'] = true,
	['Combinable'] = nil,
	['Description'] = "Represent!",
	['DecayRate'] = 0.0,
	['RemoveWhenDecayed'] = false,
	['Price'] = 1,
}

Shared.ItemList["rl-chain"] = {
	['ItemName'] = "rl-chain",
	['Label'] = "Redline Chain",
	['Weight'] = 0.1,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "c_rl_chain.png",
	['Unique'] = true,
	['Combinable'] = nil,
	['Description'] = "Represent!",
	['DecayRate'] = 0.0,
	['RemoveWhenDecayed'] = false,
	['Price'] = 1,
}

Shared.ItemList["seaside-chain"] = {
	['ItemName'] = "seaside-chain",
	['Label'] = "Seaside Chain",
	['Weight'] = 0.1,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "c_seaside_chain.png",
	['Unique'] = true,
	['Combinable'] = nil,
	['Description'] = "Represent!",
	['DecayRate'] = 0.0,
	['RemoveWhenDecayed'] = false,
	['Price'] = 1,
}

Shared.ItemList["wingsuit"] = {
	['ItemName'] = "wingsuit",
	['Label'] = "Wingsuit",
	['Weight'] = 0.3,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "c_wingsuit.png",
	['Unique'] = true,
	['Combinable'] = nil,
	['Description'] = "Falling, with style!",
	['DecayRate'] = 0.0,
	['RemoveWhenDecayed'] = false,
	['Prop'] = true,
	['Price'] = 1,
}

Shared.ItemList["wingsuit_b"] = {
	['ItemName'] = "wingsuit_b",
	['Label'] = "Wingsuit (Black)",
	['Weight'] = 0.3,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "c_wingsuit.png",
	['Unique'] = true,
	['Combinable'] = nil,
	['Description'] = "Falling, with style!",
	['DecayRate'] = 0.0,
	['RemoveWhenDecayed'] = false,
	['Prop'] = true,
	['Price'] = 1,
}

Shared.ItemList["wingsuit_c"] = {
	['ItemName'] = "wingsuit_c",
	['Label'] = "Wingsuit (Custom)",
	['Weight'] = 0.3,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "c_wingsuit.png",
	['Unique'] = true,
	['Combinable'] = nil,
	['Description'] = "Falling, with style!",
	['DecayRate'] = 0.0,
	['RemoveWhenDecayed'] = false,
	['Prop'] = true,
	['Price'] = 1,
}

-- News

Shared.ItemList["newscamera"] = {
	['ItemName'] = "newscamera",
	['Label'] = "News Camera",
	['Weight'] = 11.0,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "c_newscamera.png",
	['Unique'] = true,
	['Combinable'] = nil,
	['Description'] = "A little dusty.",
	['DecayRate'] = 0.0,
	['RemoveWhenDecayed'] = false,
	['Price'] = 100,
}

Shared.ItemList["newsmic"] = {
	['ItemName'] = "newsmic",
	['Label'] = "News Microphone",
	['Weight'] = 1.0,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "c_newsmic.png",
	['Unique'] = true,
	['Combinable'] = nil,
	['Description'] = "Is this thing on?",
	['DecayRate'] = 0.0,
	['RemoveWhenDecayed'] = false,
	['Price'] = 100,
}

-- Goldpan

Shared.ItemList["goldpan-s"] = {
	['ItemName'] = "goldpan-s",
	['Label'] = "Goldpan Small",
	['Weight'] = 1.0,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "m_goldpan-small.png",
	['Unique'] = true,
	['Combinable'] = nil,
	['Description'] = "A small gold pan to go fish for gold fish.",
	['DecayRate'] = 0.1,
	['RemoveWhenDecayed'] = true,
	['Price'] = 6500,
	['Cost'] = {
		{ Item = 'plastic', Amount = 80 },
		{ Item = 'scrapmetal', Amount = 80 },
		{ Item = 'aluminum', Amount = 80 },
	}
}

Shared.ItemList["goldpan-m"] = {
	['ItemName'] = "goldpan-m",
	['Label'] = "Goldpan Medium",
	['Weight'] = 1.0,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "m_goldpan-medium.png",
	['Unique'] = true,
	['Combinable'] = nil,
	['Description'] = "A medium gold pan to go fish for gold fish.",
	['DecayRate'] = 0.1,
	['RemoveWhenDecayed'] = true,
	['Price'] = 17500,
	['Cost'] = {
		{ Item = 'plastic', Amount = 120 },
		{ Item = 'scrapmetal', Amount = 120 },
		{ Item = 'aluminum', Amount = 120 },
	}
}

Shared.ItemList["goldpan-l"] = {
	['ItemName'] = "goldpan-l",
	['Label'] = "Goldpan Large",
	['Weight'] = 1.0,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "m_goldpan-large.png",
	['Unique'] = true,
	['Combinable'] = nil,
	['Description'] = "A large gold pan to go fish for gold fish.",
	['DecayRate'] = 0.1,
	['RemoveWhenDecayed'] = true,
	['Price'] = 28500,
	['Cost'] = {
		{ Item = 'plastic', Amount = 180 },
		{ Item = 'scrapmetal', Amount = 180 },
		{ Item = 'aluminum', Amount = 180 },
	}
}

-- Sprays

Shared.ItemList["scrubbingcloth"] = {
	['ItemName'] = "scrubbingcloth",
	['Label'] = "Scrubbing Cloth",
	['Weight'] = 1.0,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "m_scrubbingcloth.png",
	['Unique'] = true,
	['Combinable'] = nil,
	['Description'] = "These seem to dry up fast...",
	['DecayRate'] = 0.001388,
	['RemoveWhenDecayed'] = true,
	['Price'] = 500,
	['Cost'] = {
		{ Item = 'plastic', Amount = 50 },
		{ Item = 'aluminum', Amount = 100 },
	}
}

Shared.ItemList["spray-angels"] = {
	['ItemName'] = "spray-angels",
	['Label'] = "Angels Spray",
	['Weight'] = 1.0,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "m_spraycan.png",
	['Unique'] = true,
	['Combinable'] = nil,
	['Description'] = "Art.",
	['DecayRate'] = 0.066,
	['RemoveWhenDecayed'] = true,
	['Price'] = 500,
	['Cost'] = {
		{ Item = 'plastic', Amount = 50 },
		{ Item = 'aluminum', Amount = 100 },
	}
}

Shared.ItemList["spray-ballas"] = {
	['ItemName'] = "spray-ballas",
	['Label'] = "Ballas Spray",
	['Weight'] = 1.0,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "spray_ballas.png",
	['Unique'] = true,
	['Combinable'] = nil,
	['Description'] = "Art.",
	['DecayRate'] = 0.066,
	['RemoveWhenDecayed'] = true,
	['Price'] = 500,
	['Cost'] = {
		{ Item = 'plastic', Amount = 50 },
		{ Item = 'aluminum', Amount = 100 },
	}
}

Shared.ItemList["spray-bbmc"] = {
	['ItemName'] = "spray-bbmc",
	['Label'] = "BBMC Spray",
	['Weight'] = 1.0,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "m_spraycan.png",
	['Unique'] = true,
	['Combinable'] = nil,
	['Description'] = "Art.",
	['DecayRate'] = 0.066,
	['RemoveWhenDecayed'] = true,
	['Price'] = 500,
	['Cost'] = {
		{ Item = 'plastic', Amount = 50 },
		{ Item = 'aluminum', Amount = 100 },
	}
}

Shared.ItemList["spray-bcf"] = {
	['ItemName'] = "spray-bcf",
	['Label'] = "BCF Spray",
	['Weight'] = 1.0,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "m_spraycan.png",
	['Unique'] = true,
	['Combinable'] = nil,
	['Description'] = "Art.",
	['DecayRate'] = 0.066,
	['RemoveWhenDecayed'] = true,
	['Price'] = 500,
	['Cost'] = {
		{ Item = 'plastic', Amount = 50 },
		{ Item = 'aluminum', Amount = 100 },
	}
}

Shared.ItemList["spray-bsk"] = {
	['ItemName'] = "spray-bsk",
	['Label'] = "BSK Spray",
	['Weight'] = 1.0,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "m_spraycan.png",
	['Unique'] = true,
	['Combinable'] = nil,
	['Description'] = "Art.",
	['DecayRate'] = 0.066,
	['RemoveWhenDecayed'] = true,
	['Price'] = 500,
	['Cost'] = {
		{ Item = 'plastic', Amount = 50 },
		{ Item = 'aluminum', Amount = 100 },
	}
}

Shared.ItemList["spray-cerberus"] = {
	['ItemName'] = "spray-cerberus",
	['Label'] = "Cerberus Spray",
	['Weight'] = 1.0,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "m_spraycan.png",
	['Unique'] = true,
	['Combinable'] = nil,
	['Description'] = "Art.",
	['DecayRate'] = 0.066,
	['RemoveWhenDecayed'] = true,
	['Price'] = 500,
	['Cost'] = {
		{ Item = 'plastic', Amount = 50 },
		{ Item = 'aluminum', Amount = 100 },
	}
}

Shared.ItemList["spray-cg"] = {
	['ItemName'] = "spray-cg",
	['Label'] = "CG Spray",
	['Weight'] = 1.0,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "spray_cg.png",
	['Unique'] = true,
	['Combinable'] = nil,
	['Description'] = "Art.",
	['DecayRate'] = 0.066,
	['RemoveWhenDecayed'] = true,
	['Price'] = 500,
	['Cost'] = {
		{ Item = 'plastic', Amount = 50 },
		{ Item = 'aluminum', Amount = 100 },
	}
}

Shared.ItemList["spray-gg"] = {
	['ItemName'] = "spray-gg",
	['Label'] = "GG Spray",
	['Weight'] = 1.0,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "m_spraycan.png",
	['Unique'] = true,
	['Combinable'] = nil,
	['Description'] = "Art.",
	['DecayRate'] = 0.066,
	['RemoveWhenDecayed'] = true,
	['Price'] = 500,
	['Cost'] = {
		{ Item = 'plastic', Amount = 50 },
		{ Item = 'aluminum', Amount = 100 },
	}
}

Shared.ItemList["spray-gsf"] = {
	['ItemName'] = "spray-gsf",
	['Label'] = "GSF Spray",
	['Weight'] = 1.0,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "spray_gsf.png",
	['Unique'] = true,
	['Combinable'] = nil,
	['Description'] = "Art.",
	['DecayRate'] = 0.066,
	['RemoveWhenDecayed'] = true,
	['Price'] = 500,
	['Cost'] = {
		{ Item = 'plastic', Amount = 50 },
		{ Item = 'aluminum', Amount = 100 },
	}
}

Shared.ItemList["spray-guild"] = {
	['ItemName'] = "spray-guild",
	['Label'] = "Guild Spray",
	['Weight'] = 1.0,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "m_spraycan.png",
	['Unique'] = true,
	['Combinable'] = nil,
	['Description'] = "Art.",
	['DecayRate'] = 0.066,
	['RemoveWhenDecayed'] = true,
	['Price'] = 500,
	['Cost'] = {
		{ Item = 'plastic', Amount = 50 },
		{ Item = 'aluminum', Amount = 100 },
	}
}

Shared.ItemList["spray-hoa"] = {
	['ItemName'] = "spray-hoa",
	['Label'] = "HOA Spray",
	['Weight'] = 1.0,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "m_spraycan.png",
	['Unique'] = true,
	['Combinable'] = nil,
	['Description'] = "Art.",
	['DecayRate'] = 0.066,
	['RemoveWhenDecayed'] = true,
	['Price'] = 500,
	['Cost'] = {
		{ Item = 'plastic', Amount = 50 },
		{ Item = 'aluminum', Amount = 100 },
	}
}

Shared.ItemList["spray-hydra"] = {
	['ItemName'] = "spray-hydra",
	['Label'] = "Hydra Spray",
	['Weight'] = 1.0,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "m_spraycan.png",
	['Unique'] = true,
	['Combinable'] = nil,
	['Description'] = "Art.",
	['DecayRate'] = 0.066,
	['RemoveWhenDecayed'] = true,
	['Price'] = 500,
	['Cost'] = {
		{ Item = 'plastic', Amount = 50 },
		{ Item = 'aluminum', Amount = 100 },
	}
}

Shared.ItemList["spray-kingz"] = {
	['ItemName'] = "spray-kingz",
	['Label'] = "KingZ Spray",
	['Weight'] = 1.0,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "spray_kingz.png",
	['Unique'] = true,
	['Combinable'] = nil,
	['Description'] = "Art.",
	['DecayRate'] = 0.066,
	['RemoveWhenDecayed'] = true,
	['Price'] = 500,
	['Cost'] = {
		{ Item = 'plastic', Amount = 50 },
		{ Item = 'aluminum', Amount = 100 },
	}
}

Shared.ItemList["spray-lost"] = {
	['ItemName'] = "spray-lost",
	['Label'] = "LostMC Spray",
	['Weight'] = 1.0,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "m_spraycan.png",
	['Unique'] = true,
	['Combinable'] = nil,
	['Description'] = "Art.",
	['DecayRate'] = 0.066,
	['RemoveWhenDecayed'] = true,
	['Price'] = 500,
	['Cost'] = {
		{ Item = 'plastic', Amount = 50 },
		{ Item = 'aluminum', Amount = 100 },
	}
}

Shared.ItemList["spray-mandem"] = {
	['ItemName'] = "spray-mandem",
	['Label'] = "Mandem Spray",
	['Weight'] = 1.0,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "spray_mandem.png",
	['Unique'] = true,
	['Combinable'] = nil,
	['Description'] = "Art.",
	['DecayRate'] = 0.066,
	['RemoveWhenDecayed'] = true,
	['Price'] = 500,
	['Cost'] = {
		{ Item = 'plastic', Amount = 50 },
		{ Item = 'aluminum', Amount = 100 },
	}
}

Shared.ItemList["spray-mayhem"] = {
	['ItemName'] = "spray-mayhem",
	['Label'] = "Mayhem Spray",
	['Weight'] = 1.0,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "m_spraycan.png",
	['Unique'] = true,
	['Combinable'] = nil,
	['Description'] = "Art.",
	['DecayRate'] = 0.066,
	['RemoveWhenDecayed'] = true,
	['Price'] = 500,
	['Cost'] = {
		{ Item = 'plastic', Amount = 50 },
		{ Item = 'aluminum', Amount = 100 },
	}
}

Shared.ItemList["spray-nbc"] = {
	['ItemName'] = "spray-nbc",
	['Label'] = "NBC Spray",
	['Weight'] = 1.0,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "m_spraycan.png",
	['Unique'] = true,
	['Combinable'] = nil,
	['Description'] = "Art.",
	['DecayRate'] = 0.066,
	['RemoveWhenDecayed'] = true,
	['Price'] = 500,
	['Cost'] = {
		{ Item = 'plastic', Amount = 50 },
		{ Item = 'aluminum', Amount = 100 },
	}
}

Shared.ItemList["spray-ramee"] = {
	['ItemName'] = "spray-ramee",
	['Label'] = "Ramee Spray",
	['Weight'] = 1.0,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "m_spraycan.png",
	['Unique'] = true,
	['Combinable'] = nil,
	['Description'] = "Art.",
	['DecayRate'] = 0.066,
	['RemoveWhenDecayed'] = true,
	['Price'] = 500,
	['Cost'] = {
		{ Item = 'plastic', Amount = 50 },
		{ Item = 'aluminum', Amount = 100 },
	}
}

Shared.ItemList["spray-ron"] = {
	['ItemName'] = "spray-ron",
	['Label'] = "Ron Spray",
	['Weight'] = 1.0,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "m_spraycan.png",
	['Unique'] = true,
	['Combinable'] = nil,
	['Description'] = "Art.",
	['DecayRate'] = 0.066,
	['RemoveWhenDecayed'] = true,
	['Price'] = 500,
	['Cost'] = {
		{ Item = 'plastic', Amount = 50 },
		{ Item = 'aluminum', Amount = 100 },
	}
}

Shared.ItemList["spray-rust"] = {
	['ItemName'] = "spray-rust",
	['Label'] = "Rust Spray",
	['Weight'] = 1.0,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "m_spraycan.png",
	['Unique'] = true,
	['Combinable'] = nil,
	['Description'] = "Art.",
	['DecayRate'] = 0.066,
	['RemoveWhenDecayed'] = true,
	['Price'] = 500,
	['Cost'] = {
		{ Item = 'plastic', Amount = 50 },
		{ Item = 'aluminum', Amount = 100 },
	}
}

Shared.ItemList["spray-scu"] = {
	['ItemName'] = "spray-scu",
	['Label'] = "SCU Spray",
	['Weight'] = 1.0,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "m_spraycan.png",
	['Unique'] = true,
	['Combinable'] = nil,
	['Description'] = "Art.",
	['DecayRate'] = 0.066,
	['RemoveWhenDecayed'] = true,
	['Price'] = 500,
	['Cost'] = {
		{ Item = 'plastic', Amount = 50 },
		{ Item = 'aluminum', Amount = 100 },
	}
}

Shared.ItemList["spray-seaside"] = {
	['ItemName'] = "spray-seaside",
	['Label'] = "Seaside Spray",
	['Weight'] = 1.0,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "m_spraycan.png",
	['Unique'] = true,
	['Combinable'] = nil,
	['Description'] = "Art.",
	['DecayRate'] = 0.066,
	['RemoveWhenDecayed'] = true,
	['Price'] = 500,
	['Cost'] = {
		{ Item = 'plastic', Amount = 50 },
		{ Item = 'aluminum', Amount = 100 },
	}
}

Shared.ItemList["spray-st"] = {
	['ItemName'] = "spray-st",
	['Label'] = "ST Spray",
	['Weight'] = 1.0,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "m_spraycan.png",
	['Unique'] = true,
	['Combinable'] = nil,
	['Description'] = "Art.",
	['DecayRate'] = 0.066,
	['RemoveWhenDecayed'] = true,
	['Price'] = 500,
	['Cost'] = {
		{ Item = 'plastic', Amount = 50 },
		{ Item = 'aluminum', Amount = 100 },
	}
}

Shared.ItemList["spray-vagos"] = {
	['ItemName'] = "spray-vagos",
	['Label'] = "Vagos Spray",
	['Weight'] = 1.0,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "spray_vagos.png",
	['Unique'] = true,
	['Combinable'] = nil,
	['Description'] = "Art.",
	['DecayRate'] = 0.066,
	['RemoveWhenDecayed'] = true,
	['Price'] = 500,
	['Cost'] = {
		{ Item = 'plastic', Amount = 50 },
		{ Item = 'aluminum', Amount = 100 },
	}
}

-- Heists

Shared.ItemList["security_hacking_device"] = {
	['ItemName'] = "security_hacking_device",
	['Label'] = "Security Hacking Device",
	['Weight'] = 0.0,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "security_hacking_device.png",
	['Unique'] = true,
	['Combinable'] = nil,
	['Description'] = "Marked for seizure.",
	['DecayRate'] = 1.0,
	['RemoveWhenDecayed'] = true,
	['Cost'] = {
        { Item = 'copper', Amount = 149 },
        { Item = 'rubber', Amount = 149 },
        { Item = 'plastic', Amount = 149 },
        { Item = 'aluminum', Amount = 149 },
	}
}

Shared.ItemList["heist-drill-basic"] = {
	['ItemName'] = "heist-drill-basic",
	['Label'] = "Basic Drill",
	['Weight'] = 5.0,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "h_drill_basic.png",
	['Unique'] = true,
	['Combinable'] = nil,
	['Description'] = "Basic drill..",
	['DecayRate'] = 2.0,
	['RemoveWhenDecayed'] = false,
	['Cost'] = {}
}

-- Boosting

Shared.ItemList["tracker-disabler"] = {
	['ItemName'] = "tracker-disabler",
	['Label'] = "Tracker Disabling Tool",
	['Weight'] = 5.0,
	['Type'] = "Item",
	['Metal'] = true,
	['Image'] = "m_trackerdisabler.png",
	['Unique'] = true,
	['Combinable'] = nil,
	['Description'] = "Tool to disable trackers?",
	['DecayRate'] = 0.0,
	['RemoveWhenDecayed'] = true,
	['Price'] = 500,
	['Cost'] = {
		{ Item = 'plastic', Amount = 50 },
		{ Item = 'aluminum', Amount = 100 },
	}
}

Shared.ItemList["racing-usb"] = {
	['ItemName'] = "racing-usb",
	['Label'] = "Racing Dongle",
	['Weight'] = 0.15,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "c_racing_usb_blue.png",
	['Unique'] = false,
	['Combinable'] = nil,
	['Description'] = "A normal usb?",
	['DecayRate'] = 0.1,
	['RemoveWhenDecayed'] = true,
	['Price'] = 1,
}

Shared.ItemList["boosting-usb"] = {
	['ItemName'] = "boosting-usb",
	['Label'] = "Boosting Dongle",
	['Weight'] = 0.15,
	['Type'] = "Item",
	['Metal'] = false,
	['Image'] = "c_racing_usb_blue.png",
	['Unique'] = false,
	['Combinable'] = nil,
	['Description'] = "A normal usb?",
	['DecayRate'] = 0.1,
	['RemoveWhenDecayed'] = true,
	['Price'] = 1,
}

-- Crime update

Shared.ItemList["methlab_stage_01"] = {
    ['ItemName'] = "methlab_stage_01",
    ['Label'] = "Materials",
    ['Weight'] = 5.0,
    ['Type'] = "Item",
    ['Metal'] = false,
    ['Image'] = "methlab_stage_01.png",
    ['Unique'] = false,
    ['Combinable'] = nil,
    ['Description'] = "You can build some serious shit with this!",
    ['DecayRate'] = 0.0,
    ['RemoveWhenDecayed'] = false,
    ['Price'] = 0
}

Shared.ItemList["methlab_stage_02"] = {
    ['ItemName'] = "methlab_stage_02",
    ['Label'] = "Materials",
    ['Weight'] = 5.0,
    ['Type'] = "Item",
    ['Metal'] = false,
    ['Image'] = "methlab_stage_02.png",
    ['Unique'] = false,
    ['Combinable'] = nil,
    ['Description'] = "You can build some serious shit with this!",
    ['DecayRate'] = 0.0,
    ['RemoveWhenDecayed'] = false,
    ['Price'] = 0
}

Shared.ItemList["methlab_stage_03"] = {
    ['ItemName'] = "methlab_stage_03",
    ['Label'] = "Materials",
    ['Weight'] = 5.0,
    ['Type'] = "Item",
    ['Metal'] = false,
    ['Image'] = "methlab_stage_03.png",
    ['Unique'] = false,
    ['Combinable'] = nil,
    ['Description'] = "You can build some serious shit with this!",
    ['DecayRate'] = 0.0,
    ['RemoveWhenDecayed'] = false,
    ['Price'] = 0
}

Shared.ItemList["methlab_stage_04"] = {
    ['ItemName'] = "methlab_stage_04",
    ['Label'] = "Materials",
    ['Weight'] = 5.0,
    ['Type'] = "Item",
    ['Metal'] = false,
    ['Image'] = "methlab_stage_04.png",
    ['Unique'] = false,
    ['Combinable'] = nil,
    ['Description'] = "You can build some serious shit with this!",
    ['DecayRate'] = 0.0,
    ['RemoveWhenDecayed'] = false,
    ['Price'] = 0
}

-- Polaroid

Shared.ItemList["mpolaroid"] = {
    ['ItemName'] = "mpolaroid",
    ['Label'] = "MPolaroid",
    ['Weight'] = 10.0,
    ['Type'] = "Item",
    ['Metal'] = true,
    ['Image'] = "polaroid_camera.png",
    ['Unique'] = true,
    ['Combinable'] = nil,
    ['Description'] = "Snap a picture!",
    ['DecayRate'] = 0.1,
    ['RemoveWhenDecayed'] = true,
    ['Price'] = 22500,
}

Shared.ItemList["mpolaroid-paper"] = {
    ['ItemName'] = "mpolaroid-paper",
    ['Label'] = "MPolaroid Film",
    ['Weight'] = 1.0,
    ['Type'] = "Item",
    ['Metal'] = false,
    ['Image'] = "polaroid_paper.png",
    ['Unique'] = false,
    ['Combinable'] = nil,
    ['Description'] = "Required to snap a picture!",
    ['DecayRate'] = 0.1,
    ['RemoveWhenDecayed'] = true,
    ['Price'] = 175,
}

Shared.ItemList["mpolaroid-photo"] = {
    ['ItemName'] = "mpolaroid-photo",
    ['Label'] = "MPolaroid Photo",
    ['Weight'] = 1.0,
    ['Type'] = "Item",
    ['Metal'] = false,
    ['Image'] = "polaroid_photo.png",
    ['Unique'] = true,
    ['Combinable'] = nil,
    ['Description'] = "A beautiful polaroid photo.",
    ['DecayRate'] = 0.1,
    ['RemoveWhenDecayed'] = false,
    ['Price'] = 100,
}

Shared.ItemList["mpolaroid-photobook"] = {
    ['ItemName'] = "mpolaroid-photobook",
    ['Label'] = "MPolaroid Photobook",
    ['Weight'] = 1.0,
    ['Type'] = "Item",
    ['Metal'] = false,
    ['Image'] = "polaroid_photobook.png",
    ['Unique'] = false,
    ['Combinable'] = nil,
    ['Description'] = "A photo book with polaroids.",
    ['DecayRate'] = 0.0,
    ['RemoveWhenDecayed'] = false,
    ['Price'] = 32500,
}
