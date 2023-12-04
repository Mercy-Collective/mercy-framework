Config = Config or {}

Config.Debug = false
Config.UseTarget = false -- true = Target Eye (Requires: qb-target), false = Polyzones (Requires: PolyZone)
Config.TaxAmount = 1.15 -- 15% Tax on Clothing Purchases

Config.DOFSettings = {
    [1] = {
        ['Near'] = 0.4,
        ['Far'] = 1.4,
    },
    [2] = {
        ['Near'] = 0.4,
        ['Far'] = 1.4,
    },
    [3] = {
        ['Near'] = 0.8,
        ['Far'] = 1.8,
    },
    [4] = {
        ['Near'] = 0.6,
        ['Far'] = 1.4,
    }
}

Config.ClothesTypes = {
    ['Pants'] = 4,
    ['Shirts'] = 11,
    ['UnderShirt'] = 8,
    ['Mask'] = 1,
    ['Shoes'] = 6,
    ['ArmorVest'] = 9,
    ['Bag'] = 5,
}

Config.AccessoriesTypes = {
    ['Glasses'] = 1,
    ['Hat'] = 0,
}

Config.charItems = {
    ['Pants'] = { Using = true, },
    ['Shirts'] = { Using = true, },
    ['UnderShirt'] = { Using = true, },
    ['Mask'] = { Using = true, },
    ['Shoes'] = { Using = true, },
    ['ArmorVest'] = { Using = true, },
    ['Bag'] = { Using = true, },
    ['Glasses'] = { Using = true, },
    ['Hat'] = { Using = true, },
}

-- ['Width'], ['Length'], are for the size of the PolyZone
Config.Stores = {
    {
        ['Type'] = 'clothing',
        ['Coords'] = vector3(1693.32, 4823.48, 41.06),
        ['Width'] = 5,
        ['Length'] = 5,
        ['BlipSettings'] = {
            ['Sprite'] = 366,
            ['Color'] = 47,
            ['Label'] = 'Clothing Store',
        }
    },
    {
        ['Type'] = 'clothing',
        ['Coords'] = vector3(-712.215881, -155.352982, 37.4151268),
        ['Width'] = 5,
        ['Length'] = 5,
        ['BlipSettings'] = {
            ['Sprite'] = 366,
            ['Color'] = 47,
            ['Label'] = 'Clothing Store',
        }
    },
    {
        ['Type'] = 'clothing',
        ['Coords'] = vector3(-1192.94495, -772.688965, 17.3255997),
        ['Width'] = 5,
        ['Length'] = 5,
        ['BlipSettings'] = {
            ['Sprite'] = 366,
            ['Color'] = 47,
            ['Label'] = 'Clothing Store',
        }
    },
    {
        ['Type'] = 'clothing',
        ['Coords'] = vector3(425.236, -806.008, 28.491),
        ['Width'] = 5,
        ['Length'] = 5,
        ['BlipSettings'] = {
            ['Sprite'] = 366,
            ['Color'] = 47,
            ['Label'] = 'Clothing Store',
        }
    },
    {
        ['Type'] = 'clothing',
        ['Coords'] = vector3(-162.658, -303.397, 38.733),
        ['Width'] = 5,
        ['Length'] = 5,
        ['BlipSettings'] = {
            ['Sprite'] = 366,
            ['Color'] = 47,
            ['Label'] = 'Clothing Store',
        }
    },
    {
        ['Type'] = 'clothing',
        ['Coords'] = vector3(75.950, -1392.891, 28.376),
        ['Width'] = 5,
        ['Length'] = 5,
        ['BlipSettings'] = {
            ['Sprite'] = 366,
            ['Color'] = 47,
            ['Label'] = 'Clothing Store',
        }
    },
    {
        ['Type'] = 'clothing',
        ['Coords'] = vector3(-822.194, -1074.134, 10.328),
        ['Width'] = 5,
        ['Length'] = 5,
        ['BlipSettings'] = {
            ['Sprite'] = 366,
            ['Color'] = 47,
            ['Label'] = 'Clothing Store',
        }
    },
    {
        ['Type'] = 'clothing',
        ['Coords'] = vector3(-1450.711, -236.83, 48.809),
        ['Width'] = 5,
        ['Length'] = 5,
        ['BlipSettings'] = {
            ['Sprite'] = 366,
            ['Color'] = 47,
            ['Label'] = 'Clothing Store',
        }
    },
    {
        ['Type'] = 'clothing',
        ['Coords'] = vector3(4.254, 6512.813, 30.877),
        ['Width'] = 5,
        ['Length'] = 5,
        ['BlipSettings'] = {
            ['Sprite'] = 366,
            ['Color'] = 47,
            ['Label'] = 'Clothing Store',
        }
    },
    {
        ['Type'] = 'clothing',
        ['Coords'] = vector3(615.180, 2762.933, 41.088),
        ['Width'] = 5,
        ['Length'] = 5,
        ['BlipSettings'] = {
            ['Sprite'] = 366,
            ['Color'] = 47,
            ['Label'] = 'Clothing Store',
        }
    },
    {
        ['Type'] = 'clothing',
        ['Coords'] = vector3(1196.785, 2709.558, 37.222),
        ['Width'] = 5,
        ['Length'] = 5,
        ['BlipSettings'] = {
            ['Sprite'] = 366,
            ['Color'] = 47,
            ['Label'] = 'Clothing Store',
        }
    },
    {
        ['Type'] = 'clothing',
        ['Coords'] = vector3(-3171.453, 1043.857, 19.863),
        ['Width'] = 5,
        ['Length'] = 5,
        ['BlipSettings'] = {
            ['Sprite'] = 366,
            ['Color'] = 47,
            ['Label'] = 'Clothing Store',
        }
    },
    {
        ['Type'] = 'clothing',
        ['Coords'] = vector3(-1100.959, 2710.211, 18.107),
        ['Width'] = 5,
        ['Length'] = 5,
        ['BlipSettings'] = {
            ['Sprite'] = 366,
            ['Color'] = 47,
            ['Label'] = 'Clothing Store',
        }
    },
    {
        ['Type'] = 'clothing',
        ['Coords'] = vector3(-1207.65, -1456.88, 4.3784737586975),
        ['Width'] = 5,
        ['Length'] = 5,
        ['BlipSettings'] = {
            ['Sprite'] = 366,
            ['Color'] = 47,
            ['Label'] = 'Clothing Store',
        }
    },
    {
        ['Type'] = 'clothing',
        ['Coords'] = vector3(121.76, -224.6, 53.56),
        ['Width'] = 5,
        ['Length'] = 5,
        ['BlipSettings'] = {
            ['Sprite'] = 366,
            ['Color'] = 47,
            ['Label'] = 'Clothing Store',
        }
    },
    {
        ['Type'] = 'barber',
        ['Coords'] = vector3(-814.3, -183.8, 36.6),
        ['Width'] = 5,
        ['Length'] = 5,
        ['BlipSettings'] = {
            ['Sprite'] = 71,
            ['Color'] = 68,
            ['Label'] = 'Barber',
        }
    },
    {
        ['Type'] = 'barber',
        ['Coords'] = vector3(136.8, -1708.4, 28.3),
        ['Width'] = 5,
        ['Length'] = 5,
        ['BlipSettings'] = {
            ['Sprite'] = 71,
            ['Color'] = 68,
            ['Label'] = 'Barber',
        }
    },
    {
        ['Type'] = 'barber',
        ['Coords'] = vector3(-1282.6, -1116.8, 6.0),
        ['Width'] = 5,
        ['Length'] = 5,
        ['BlipSettings'] = {
            ['Sprite'] = 71,
            ['Color'] = 68,
            ['Label'] = 'Barber',
        }
    },
    {
        ['Type'] = 'barber',
        ['Coords'] = vector3(1931.5, 3729.7, 31.8),
        ['Width'] = 5,
        ['Length'] = 5,
        ['BlipSettings'] = {
            ['Sprite'] = 71,
            ['Color'] = 68,
            ['Label'] = 'Barber',
        }
    },
    {
        ['Type'] = 'barber',
        ['Coords'] = vector3(1212.8, -472.9, 65.2),
        ['Width'] = 5,
        ['Length'] = 5,
        ['BlipSettings'] = {
            ['Sprite'] = 71,
            ['Color'] = 68,
            ['Label'] = 'Barber',
        }
    },
    {
        ['Type'] = 'barber',
        ['Coords'] = vector3(-32.9, -152.3, 56.1),
        ['Width'] = 5,
        ['Length'] = 5,
        ['BlipSettings'] = {
            ['Sprite'] = 71,
            ['Color'] = 68,
            ['Label'] = 'Barber',
        }
    },
    {
        ['Type'] = 'barber',
        ['Coords'] = vector3(-278.1, 6228.5, 30.7),
        ['Width'] = 5,
        ['Length'] = 5,
        ['BlipSettings'] = {
            ['Sprite'] = 71,
            ['Color'] = 68,
            ['Label'] = 'Barber',
        }
    },
    {
        ['Type'] = 'tattoos',
        ['Coords'] = vector3(1322.6, -1651.9, 51.2),
        ['Width'] = 3,
        ['Length'] = 3,
        ['BlipSettings'] = {
            ['Sprite'] = 75,
            ['Color'] = 6,
            ['Label'] = 'Tattoos',
        }
    },
    {
        ['Type'] = 'tattoos',
        ['Coords'] = vector3(-1153.6, -1425.6, 4.9),
        ['Width'] = 3,
        ['Length'] = 3,
        ['BlipSettings'] = {
            ['Sprite'] = 75,
            ['Color'] = 6,
            ['Label'] = 'Tattoos',
        }
    },
    {
        ['Type'] = 'tattoos',
        ['Coords'] = vector3(322.1, 180.4, 103.5),
        ['Width'] = 5,
        ['Length'] = 3,
        ['BlipSettings'] = {
            ['Sprite'] = 75,
            ['Color'] = 6,
            ['Label'] = 'Tattoos',
        }
    },
    {
        ['Type'] = 'tattoos',
        ['Coords'] = vector3(-3170.0, 1075.0, 20.8),
        ['Width'] = 3,
        ['Length'] = 3,
        ['BlipSettings'] = {
            ['Sprite'] = 75,
            ['Color'] = 6,
            ['Label'] = 'Tattoos',
        }
    },
    {
        ['Type'] = 'tattoos',
        ['Coords'] = vector3(1864.6, 3747.7, 33.0),
        ['Width'] = 3,
        ['Length'] = 3,
        ['BlipSettings'] = {
            ['Sprite'] = 75,
            ['Color'] = 6,
            ['Label'] = 'Tattoos',
        }
    },
    {
        ['Type'] = 'tattoos',
        ['Coords'] = vector3(-293.7, 6200.0, 31.4),
        ['Width'] = 3,
        ['Length'] = 3,
        ['BlipSettings'] = {
            ['Sprite'] = 75,
            ['Color'] = 6,
            ['Label'] = 'Tattoos',
        }
    },
}

Config.ClothingRooms = {
    { 
        ['Job'] = 'police', 
        ['Coords'] = vector3(462.06, -999.09, 30.69), 
        ['Width'] = 5,
        ['Length'] = 2,
    },
    { 
        ['Job'] = 'ems', 
        ['Coords'] = vector3(-825.06, -1237.81, 7.34),
        ['Heading'] = 141.22,
        ['Width'] = 4,
        ['Length'] = 3.5,
    },
    { 
        ['Job'] = 'police', 
        ['Coords'] = vector3(314.76, 671.78, 14.73), 
        ['Width'] = 2,
        ['Length'] = 2,
    },
    { 
        ['Job'] = 'ems', 
        ['Coords'] = vector3(338.70, 659.61, 14.71), 
        ['Width'] = 2,
        ['Length'] = 2,
    },
    { 
        ['Job'] = 'ems', 
        ['Coords'] = vector3(-1098.45, 1751.71, 23.35), 
        ['Width'] = 2,
        ['Length'] = 2,
    },
    { 
        ['Job'] = 'police', 
        ['IsGang'] = false, 
        ['Coords'] = vector3(-77.59, -129.17, 5.03), 
        ['Width'] = 2,
        ['Length'] = 2,
    },
    { 
        ['Job'] = "realestate", 
        ['Coords'] = vector3(-131.45, -633.74, 168.82), 
        ['Width'] = 2,
        ['Length'] = 2,
    },
}

Config.Outfits = {
    ['police'] = {
        -- Job
        ['Male'] = {
            -- Grade Level
            [1] = {
                -- Outfits
                OutfitLabel = 'Short Sleeve',
                OutfitData = {
                    ['Pants'] = { Item = 24, Texture = 0 }, -- Pants
                    ['Arms'] = { Item = 19, Texture = 0 }, -- Arms
                    ['UnderShirt'] = { Item = 58, Texture = 0 }, -- T Shirt
                    ['ArmorVest'] = { Item = 0, Texture = 0 }, -- Body Vest
                    ['Shirts'] = { Item = 55, Texture = 0 }, -- Jacket
                    ['Shoes'] = { Item = 51, Texture = 0 }, -- Shoes
                    ['Necklace'] = { Item = 0, Texture = 0 }, -- Neck Accessory
                    ['Bag'] = { Item = 0, Texture = 0 }, -- Bag
                    ['Hat'] = { Item = -1, Texture = -1 }, -- Hat
                    ['Glasses'] = { Item = 0, Texture = 0 }, -- Glasses
                    ['Mask'] = { Item = 0, Texture = 0 } -- Mask
                }
            },
            [2] = {
                OutfitLabel = 'Long Sleeve',
                OutfitData = {
                    ['Pants'] = { Item = 24, Texture = 0 }, -- Pants
                    ['Arms'] = { Item = 20, Texture = 0 }, -- Arms
                    ['UnderShirt'] = { Item = 58, Texture = 0 }, -- T Shirt
                    ['ArmorVest'] = { Item = 0, Texture = 0 }, -- Body Vest
                    ['Shirts'] = { Item = 317, Texture = 0 }, -- Jacket
                    ['Shoes'] = { Item = 51, Texture = 0 }, -- Shoes
                    ['Necklace'] = { Item = 0, Texture = 0 }, -- Neck Accessory
                    ['Bag'] = { Item = 0, Texture = 0 }, -- Bag
                    ['Hat'] = { Item = -1, Texture = -1 }, -- Hat
                    ['Glasses'] = { Item = 0, Texture = 0 }, -- Glasses
                    ['Mask'] = { Item = 0, Texture = 0 } -- Mask
                }
            },
            [3] = {
                OutfitLabel = 'Trooper Tan',
                OutfitData = {
                    ['Pants'] = { Item = 24, Texture = 0 }, -- Pants
                    ['Arms'] = { Item = 20, Texture = 0 }, -- Arms
                    ['UnderShirt'] = { Item = 58, Texture = 0 }, -- T Shirt
                    ['ArmorVest'] = { Item = 0, Texture = 0 }, -- Body Vest
                    ['Shirts'] = { Item = 317, Texture = 3 }, -- Jacket
                    ['Shoes'] = { Item = 51, Texture = 0 }, -- Shoes
                    ['Necklace'] = { Item = 0, Texture = 0 }, -- Neck Accessory
                    ['Bag'] = { Item = 0, Texture = 0 }, -- Bag
                    ['Hat'] = { Item = 58, Texture = 0 }, -- Hat
                    ['Glasses'] = { Item = 0, Texture = 0 }, -- Glasses
                    ['Mask'] = { Item = 0, Texture = 0 } -- Mask
                }
            },
            [4] = {
                OutfitLabel = 'Trooper Black',
                OutfitData = {
                    ['Pants'] = { Item = 24, Texture = 0 }, -- Pants
                    ['Arms'] = { Item = 20, Texture = 0 }, -- Arms
                    ['UnderShirt'] = { Item = 58, Texture = 0 }, -- T Shirt
                    ['ArmorVest'] = { Item = 0, Texture = 0 }, -- Body Vest
                    ['Shirts'] = { Item = 317, Texture = 8 }, -- Jacket
                    ['Shoes'] = { Item = 51, Texture = 0 }, -- Shoes
                    ['Necklace'] = { Item = 0, Texture = 0 }, -- Neck Accessory
                    ['Bag'] = { Item = 0, Texture = 0 }, -- Bag
                    ['Hat'] = { Item = 58, Texture = 3 }, -- Hat
                    ['Glasses'] = { Item = 0, Texture = 0 }, -- Glasses
                    ['Mask'] = { Item = 0, Texture = 0 } -- Mask
                }
            },
            [5] = {
                OutfitLabel = 'SWAT',
                OutfitData = {
                    ['Pants'] = { Item = 130, Texture = 1 }, -- Pants
                    ['Arms'] = { Item = 172, Texture = 0 }, -- Arms
                    ['UnderShirt'] = { Item = 15, Texture = 0 }, -- T Shirt
                    ['ArmorVest'] = { Item = 15, Texture = 2 }, -- Body Vest
                    ['Shirts'] = { Item = 336, Texture = 3 }, -- Jacket
                    ['Shoes'] = { Item = 24, Texture = 0 }, -- Shoes
                    ['Necklace'] = { Item = 133, Texture = 0 }, -- Neck Accessory
                    ['Hat'] = { Item = 150, Texture = 0 }, -- Hat
                    ['Glasses'] = { Item = 0, Texture = 0 }, -- Glasses
                    ['Mask'] = { Item = 52, Texture = 0 } -- Mask
                }
            }
        },
        ['Female'] = {
            -- Grade Level
            [1] = {
                OutfitLabel = 'Short Sleeve',
                OutfitData = {
                    ['Pants'] = { Item = 133, Texture = 0 }, -- Pants
                    ['Arms'] = { Item = 31, Texture = 0 }, -- Arms
                    ['UnderShirt'] = { Item = 35, Texture = 0 }, -- T Shirt
                    ['ArmorVest'] = { Item = 34, Texture = 0 }, -- Body Vest
                    ['Shirts'] = { Item = 48, Texture = 0 }, -- Jacket
                    ['Shoes'] = { Item = 52, Texture = 0 }, -- Shoes
                    ['Necklace'] = { Item = 0, Texture = 0 }, -- Neck Accessory
                    ['Bag'] = { Item = 0, Texture = 0 }, -- Bag
                    ['Hat'] = { Item = 0, Texture = 0 }, -- Hat
                    ['Glasses'] = { Item = 0, Texture = 0 }, -- Glasses
                    ['Mask'] = { Item = 0, Texture = 0 } -- Mask
                }
            },
            [2] = {
                OutfitLabel = 'Long Sleeve',
                OutfitData = {
                    ['Pants'] = { Item = 133, Texture = 0 }, -- Pants
                    ['Arms'] = { Item = 31, Texture = 0 }, -- Arms
                    ['UnderShirt'] = { Item = 35, Texture = 0 }, -- T Shirt
                    ['ArmorVest'] = { Item = 34, Texture = 0 }, -- Body Vest
                    ['Shirts'] = { Item = 327, Texture = 0 }, -- Jacket
                    ['Shoes'] = { Item = 52, Texture = 0 }, -- Shoes
                    ['Necklace'] = { Item = 0, Texture = 0 }, -- Neck Accessory
                    ['Bag'] = { Item = 0, Texture = 0 }, -- Bag
                    ['Hat'] = { Item = 0, Texture = 0 }, -- Hat
                    ['Glasses'] = { Item = 0, Texture = 0 }, -- Glasses
                    ['Mask'] = { Item = 0, Texture = 0 } -- Mask
                }
            },
            [3] = {
                OutfitLabel = 'Trooper Tan',
                OutfitData = {
                    ['Pants'] = { Item = 133, Texture = 0 }, -- Pants
                    ['Arms'] = { Item = 31, Texture = 0 }, -- Arms
                    ['UnderShirt'] = { Item = 35, Texture = 0 }, -- T Shirt
                    ['ArmorVest'] = { Item = 34, Texture = 0 }, -- Body Vest
                    ['Shirts'] = { Item = 327, Texture = 3 }, -- Jacket
                    ['Shoes'] = { Item = 52, Texture = 0 }, -- Shoes
                    ['Necklace'] = { Item = 0, Texture = 0 }, -- Neck Accessory
                    ['Bag'] = { Item = 0, Texture = 0 }, -- Bag
                    ['Hat'] = { Item = 0, Texture = 0 }, -- Hat
                    ['Glasses'] = { Item = 0, Texture = 0 }, -- Glasses
                    ['Mask'] = { Item = 0, Texture = 0 } -- Mask
                }
            },
            [4] = {
                OutfitLabel = 'Trooper Black',
                OutfitData = {
                    ['Pants'] = { Item = 133, Texture = 0 }, -- Pants
                    ['Arms'] = { Item = 31, Texture = 0 }, -- Arms
                    ['UnderShirt'] = { Item = 35, Texture = 0 }, -- T Shirt
                    ['ArmorVest'] = { Item = 34, Texture = 0 }, -- Body Vest
                    ['Shirts'] = { Item = 327, Texture = 8 }, -- Jacket
                    ['Shoes'] = { Item = 52, Texture = 0 }, -- Shoes
                    ['Necklace'] = { Item = 0, Texture = 0 }, -- Neck Accessory
                    ['Bag'] = { Item = 0, Texture = 0 }, -- Bag
                    ['Hat'] = { Item = 0, Texture = 0 }, -- Hat
                    ['Glasses'] = { Item = 0, Texture = 0 }, -- Glasses
                    ['Mask'] = { Item = 0, Texture = 0 } -- Mask
                }
            },
            [5] = {
                OutfitLabel = 'Swat',
                OutfitData = {
                    ['Pants'] = { Item = 135, Texture = 1 }, -- Pants
                    ['Arms'] = { Item = 213, Texture = 0 }, -- Arms
                    ['UnderShirt'] = { Item = 0, Texture = 0 }, -- T Shirt
                    ['ArmorVest'] = { Item = 17, Texture = 2 }, -- Body Vest
                    ['Shirts'] = { Item = 327, Texture = 8 }, -- Jacket
                    ['Shoes'] = { Item = 52, Texture = 0 }, -- Shoes
                    ['Necklace'] = { Item = 102, Texture = 0 }, -- Neck Accessory
                    ['Bag'] = { Item = 0, Texture = 0 }, -- Bag
                    ['Hat'] = { Item = 149, Texture = 0 }, -- Hat
                    ['Glasses'] = { Item = 0, Texture = 0 }, -- Glasses
                    ['Mask'] = { Item = 35, Texture = 0 } -- Mask
                }
            }
        }
    },
    ['realestate'] = {
        -- Job
        ['Male'] = {
            [1] = {
                -- Outfits
                OutfitLabel = 'Worker',
                OutfitData = {
                    ["Pants"]     = { Item = 28, Texture = 0 }, -- Pants
                    ["Arms"]      = { Item = 1, Texture = 0 }, -- Arms
                    ["UnderShirt"]   = { Item = 31, Texture = 0 }, -- T Shirt
                    ["ArmorVest"]      = { Item = 0, Texture = 0 }, -- Body Vest
                    ["Shirts"]    = { Item = 294, Texture = 0 }, -- Jacket
                    ["Shoes"]     = { Item = 10, Texture = 0 }, -- Shoes
                    ["Necklace"] = { Item = 0, Texture = 0 }, -- Neck Accessory
                    ["Bag"]       = { Item = 0, Texture = 0 }, -- Bag
                    ["Hat"]       = { Item = 12, Texture = -1 }, -- Hat
                    ["Glasses"]     = { Item = 0, Texture = 0 }, -- Glasses
                    ["Mask"]      = { Item = 0, Texture = 0 }, -- Mask
                }
            }
        },
        ['Female'] = {
            -- Grade Level
            [1] = {
                OutfitLabel = 'Worker',
                OutfitData = {
                    ["Pants"]     = { Item = 57, Texture = 2 }, -- Pants
                    ["Arms"]      = { Item = 0, Texture = 0 }, -- Arms
                    ["UnderShirt"]   = { Item = 34, Texture = 0 }, -- T Shirt
                    ["ArmorVest"]      = { Item = 0, Texture = 0 }, -- Body Vest
                    ["Shirts"]    = { Item = 105, Texture = 7 }, -- Jacket
                    ["Shoes"]     = { Item = 8, Texture = 5 }, -- Shoes
                    ["Necklace"] = { Item = 11, Texture = 3 }, -- Neck Accessory
                    ["Bag"]       = { Item = 0, Texture = 0 }, -- Bag
                    ["Hat"]       = { Item = -1, Texture = -1 }, -- Hat
                    ["Glasses"]     = { Item = 0, Texture = 0 }, -- Glasses
                    ["Mask"]      = { Item = 0, Texture = 0 }, -- Mask
                }
            }
        }
    },
    ['ems'] = {
        -- Job
        ['Male'] = {
            [1] = {
                OutfitLabel = 'T-Shirt',
                OutfitData = {
                    ['Arms'] = { Item = 85, Texture = 0 }, -- Arms
                    ['UnderShirt'] = { Item = 129, Texture = 0 }, -- T-Shirt
                    ['Shirts'] = { Item = 250, Texture = 0 }, -- Jackets
                    ['ArmorVest'] = { Item = 0, Texture = 0 }, -- Vest
                    ['Decals'] = { Item = 58, Texture = 0 }, -- Decals
                    ['Necklace'] = { Item = 127, Texture = 0 }, -- Neck
                    ['Bag'] = { Item = 0, Texture = 0 }, -- Bag
                    ['Pants'] = { Item = 96, Texture = 0 }, -- Pants
                    ['Shoes'] = { Item = 54, Texture = 0 }, -- Shoes
                    ['Mask'] = { Item = 121, Texture = 0 }, -- Mask
                    ['Hat'] = { Item = 122, Texture = 0 }, -- Hat
                    ['Glasses'] = { Item = 0, Texture = 0 }, -- Glasses
                    ['Earpiece'] = { Item = 0, Texture = 0 } -- Ear accessories
                }
            },
            [2] = {
                OutfitLabel = 'Polo',
                OutfitData = {
                    ['Arms'] = { Item = 90, Texture = 0 }, -- Arms
                    ['UnderShirt'] = { Item = 15, Texture = 0 }, -- T-Shirt
                    ['Shirts'] = { Item = 249, Texture = 0 }, -- Jackets
                    ['ArmorVest'] = { Item = 0, Texture = 0 }, -- Vest
                    ['Decals'] = { Item = 57, Texture = 0 }, -- Decals
                    ['Necklace'] = { Item = 126, Texture = 0 }, -- Neck
                    ['Bag'] = { Item = 0, Texture = 0 }, -- Bag
                    ['Pants'] = { Item = 96, Texture = 0 }, -- Pants
                    ['Shoes'] = { Item = 54, Texture = 0 }, -- Shoes
                    ['Mask'] = { Item = 121, Texture = 0 }, -- Mask
                    ['Hat'] = { Item = 122, Texture = 0 }, -- Hat
                    ['Glasses'] = { Item = 0, Texture = 0 }, -- Glasses
                    ['Earpiece'] = { Item = 0, Texture = 0 } -- Ear accessories
                }
            },
            [3] = {
                OutfitLabel = 'Doctor',
                OutfitData = {
                    ['Arms'] = { Item = 93, Texture = 0 }, -- Arms
                    ['UnderShirt'] = { Item = 32, Texture = 3 }, -- T-Shirt
                    ['Shirts'] = { Item = 31, Texture = 7 }, -- Jackets
                    ['ArmorVest'] = { Item = 0, Texture = 0 }, -- Vest
                    ['Decals'] = { Item = 0, Texture = 0 }, -- Decals
                    ['Necklace'] = { Item = 126, Texture = 0 }, -- Neck
                    ['Bag'] = { Item = 0, Texture = 0 }, -- Bag
                    ['Pants'] = { Item = 28, Texture = 0 }, -- Pants
                    ['Shoes'] = { Item = 10, Texture = 0 }, -- Shoes
                    ['Mask'] = { Item = 0, Texture = 0 }, -- Mask
                    ['Hat'] = { Item = -1, Texture = 0 }, -- Hat
                    ['Glasses'] = { Item = 0, Texture = 0 }, -- Glasses
                    ['Earpiece'] = { Item = 0, Texture = 0 } -- Ear accessories
                }
            }
        },
        ['Female'] = {
            [1] = {
                OutfitLabel = 'T-Shirt',
                OutfitData = {
                    ['Arms'] = { Item = 109, Texture = 0 }, -- Arms
                    ['UnderShirt'] = { Item = 159, Texture = 0 }, -- T-Shirt
                    ['Shirts'] = { Item = 258, Texture = 0 }, -- Jackets
                    ['ArmorVest'] = { Item = 0, Texture = 0 }, -- Vest
                    ['Decals'] = { Item = 66, Texture = 0 }, -- Decals
                    ['Necklace'] = { Item = 97, Texture = 0 }, -- Neck
                    ['Bag'] = { Item = 0, Texture = 0 }, -- Bag
                    ['Pants'] = { Item = 99, Texture = 0 }, -- Pants
                    ['Shoes'] = { Item = 55, Texture = 0 }, -- Shoes
                    ['Mask'] = { Item = 121, Texture = 0 }, -- Mask
                    ['Hat'] = { Item = 121, Texture = 0 }, -- Hat
                    ['Glasses'] = { Item = 0, Texture = 0 }, -- Glasses
                    ['Earpiece'] = { Item = 0, Texture = 0 } -- Ear accessories
                }
            },
            [2] = {
                OutfitLabel = 'Polo',
                OutfitData = {
                    ['Arms'] = { Item = 105, Texture = 0 }, -- Arms
                    ['UnderShirt'] = { Item = 13, Texture = 0 }, -- T-Shirt
                    ['Shirts'] = { Item = 257, Texture = 0 }, -- Jackets
                    ['ArmorVest'] = { Item = 0, Texture = 0 }, -- Vest
                    ['Decals'] = { Item = 65, Texture = 0 }, -- Decals
                    ['Necklace'] = { Item = 96, Texture = 0 }, -- Neck
                    ['Bag'] = { Item = 0, Texture = 0 }, -- Bag
                    ['Pants'] = { Item = 99, Texture = 0 }, -- Pants
                    ['Shoes'] = { Item = 55, Texture = 0 }, -- Shoes
                    ['Mask'] = { Item = 121, Texture = 0 }, -- Mask
                    ['Hat'] = { Item = 121, Texture = 0 }, -- Hat
                    ['Glasses'] = { Item = 0, Texture = 0 }, -- Glasses
                    ['Earpiece'] = { Item = 0, Texture = 0 } -- Ear accessories
                }
            },
            [3] = {
                OutfitLabel = 'Doctor',
                OutfitData = {
                    ['Arms'] = { Item = 105, Texture = 0 }, -- Arms
                    ['UnderShirt'] = { Item = 39, Texture = 3 }, -- T-Shirt
                    ['Shirts'] = { Item = 7, Texture = 1 }, -- Jackets
                    ['ArmorVest'] = { Item = 0, Texture = 0 }, -- Vest
                    ['Decals'] = { Item = 0, Texture = 0 }, -- Decals
                    ['Necklace'] = { Item = 96, Texture = 0 }, -- Neck
                    ['Bag'] = { Item = 0, Texture = 0 }, -- Bag
                    ['Pants'] = { Item = 34, Texture = 0 }, -- Pants
                    ['Shoes'] = { Item = 29, Texture = 0 }, -- Shoes
                    ['Mask'] = { Item = 0, Texture = 0 }, -- Mask
                    ['Hat'] = { Item = -1, Texture = 0 }, -- Hat
                    ['Glasses'] = { Item = 0, Texture = 0 }, -- Glasses
                    ['Earpiece'] = { Item = 0, Texture = 0 } -- Ear accessories
                }
            }
        }
    }
}

Config.WomanPlayerModels = {
    'mp_f_freemode_01',
    'a_f_m_beach_01',
    'a_f_m_bevhills_01',
    'a_f_m_bevhills_02',
    'a_f_m_bodybuild_01',
    'a_f_m_business_02',
    'a_f_m_downtown_01',
    'a_f_m_eastsa_01',
    'a_f_m_eastsa_02',
    'a_f_m_fatbla_01',
    'a_f_m_fatcult_01',
    'a_f_m_fatwhite_01',
    'a_f_m_ktown_01',
    'a_f_m_ktown_02',
    'a_f_m_prolhost_01',
    'a_f_m_salton_01',
    'a_f_m_skidrow_01',
    'a_f_m_soucentmc_01',
    'a_f_m_soucent_01',
    'a_f_m_soucent_02',
    'a_f_m_tourist_01',
    'a_f_m_trampbeac_01',
    'a_f_m_tramp_01',
    'a_f_o_genstreet_01',
    'a_f_o_indian_01',
    'a_f_o_ktown_01',
    'a_f_o_salton_01',
    'a_f_o_soucent_01',
    'a_f_o_soucent_02',
    'a_f_y_beach_01',
    'a_f_y_bevhills_01',
    'a_f_y_bevhills_02',
    'a_f_y_bevhills_03',
    'a_f_y_bevhills_04',
    'a_f_y_business_01',
    'a_f_y_business_02',
    'a_f_y_business_03',
    'a_f_y_business_04',
    'a_f_y_eastsa_01',
    'a_f_y_eastsa_02',
    'a_f_y_eastsa_03',
    'a_f_y_epsilon_01',
    'a_f_y_fitness_01',
    'a_f_y_fitness_02',
    'a_f_y_genhot_01',
    'a_f_y_golfer_01',
    'a_f_y_hiker_01',
    'a_f_y_hipster_01',
    'a_f_y_hipster_02',
    'a_f_y_hipster_03',
    'a_f_y_hipster_04',
    'a_f_y_indian_01',
    'a_f_y_juggalo_01',
    'a_f_y_runner_01',
    'a_f_y_rurmeth_01',
    'a_f_y_scdressy_01',
    'a_f_y_skater_01',
    'a_f_y_soucent_01',
    'a_f_y_soucent_02',
    'a_f_y_soucent_03',
    'a_f_y_tennis_01',
    'a_f_y_tourist_01',
    'a_f_y_tourist_02',
    'a_f_y_vinewood_01',
    'a_f_y_vinewood_02',
    'a_f_y_vinewood_03',
    'a_f_y_vinewood_04',
    'a_f_y_yoga_01',
    'g_f_y_ballas_01',
    'g_f_y_families_01',
    'g_f_y_lost_01',
    'g_f_y_vagos_01',
    'mp_f_deadhooker',
    'mp_f_freemode_01',
    'mp_f_misty_01',
    'mp_s_m_armoured_01',
    's_f_m_fembarber',
    's_f_m_maid_01',
    's_f_m_shop_high',
    's_f_m_sweatshop_01',
    's_f_y_airhostess_01',
    's_f_y_bartender_01',
    's_f_y_baywatch_01',
    's_f_y_cop_01',
    's_f_y_factory_01',
    's_f_y_hooker_01',
    's_f_y_hooker_02',
    's_f_y_hooker_03',
    's_f_y_migrant_01',
    's_f_y_movprem_01',
    'ig_kerrymcintosh',
    'ig_janet',
    'ig_jewelass',
    'ig_magenta',
    'ig_marnie',
    'ig_patricia',
    'ig_screen_writer',
    'ig_tanisha',
    'ig_tonya',
    'ig_tracydisanto',
    'u_f_m_corpse_01',
    'u_f_m_miranda',
    'u_f_m_promourn_01',
    'u_f_o_moviestar',
    'u_f_o_prolhost_01',
    'u_f_y_bikerchic',
    'u_f_y_comjane',
    'u_f_y_corpse_01',
    'u_f_y_corpse_02',
    'u_f_y_hotposh_01',
    'u_f_y_jewelass_01',
    'u_f_y_mistress',
    'u_f_y_poppymich',
    'u_f_y_princess',
    'u_f_y_spyactress',
    'ig_amandatownley',
    'ig_ashley',
    'ig_andreas',
    'ig_ballasog',
    'ig_maryannn',
    'ig_maude',
    'ig_michelle',
    'ig_mrs_thornhill',
    'ig_natalia',
    's_f_y_scrubs_01',
    's_f_y_sheriff_01',
    's_f_y_shop_low',
    's_f_y_shop_mid',
    's_f_y_stripperlite',
    's_f_y_stripper_01',
    's_f_y_stripper_02',
    'ig_mrsphillips',
    'ig_mrs_thornhill',
    'ig_molly',
    'ig_natalia',
    's_f_y_sweatshop_01',
    'ig_paige',
    'a_f_y_femaleagent',
    'a_f_y_hippie_01'
}

Config.ManPlayerModels = {
    'mp_m_freemode_01',
    'ig_martybanks',
    'ig_trafficwarden',
    'ig_bankman',
    'ig_barry',
    'ig_bestmen',
    'ig_beverly',
    'ig_car3guy1',
    'ig_car3guy2',
    'ig_casey',
    'ig_chef',
    'ig_chengsr',
    'ig_chrisformage',
    'ig_clay',
    'ig_claypain',
    'ig_cletus',
    'ig_dale',
    'ig_dreyfuss',
    'ig_fbisuit_01',
    'ig_floyd',
    'ig_groom',
    'ig_hao',
    'ig_hunter',
    'csb_prolsec',
    'ig_jimmydisanto',
    'ig_joeminuteman',
    'ig_josef',
    'ig_josh',
    'ig_lamardavis',
    'ig_lazlow',
    'ig_lestercrest',
    'ig_lifeinvad_01',
    'ig_lifeinvad_02',
    'ig_manuel',
    'ig_milton',
    'ig_mrk',
    'ig_nervousron',
    'ig_nigel',
    'ig_old_man1a',
    'ig_old_man2',
    'ig_oneil',
    'ig_ortega',
    'ig_paper',
    'ig_priest',
    'ig_prolsec_02',
    'ig_ramp_gang',
    'ig_ramp_hic',
    'ig_ramp_hipster',
    'ig_ramp_mex',
    'ig_roccopelosi',
    'ig_russiandrunk',
    'ig_siemonyetarian',
    'ig_solomon',
    'ig_stevehains',
    'ig_stretch',
    'ig_talina',
    'ig_taocheng',
    'ig_taostranslator',
    'ig_tenniscoach',
    'ig_terry',
    'ig_tomepsilon',
    'ig_tylerdix',
    'ig_wade',
    'ig_zimbor',
    's_m_m_paramedic_01',
    'a_m_m_afriamer_01',
    'a_m_m_beach_01',
    'a_m_m_beach_02',
    'a_m_m_bevhills_01',
    'a_m_m_bevhills_02',
    'a_m_m_business_01',
    'a_m_m_eastsa_01',
    'a_m_m_eastsa_02',
    'a_m_m_farmer_01',
    'a_m_m_fatlatin_01',
    'a_m_m_genfat_01',
    'a_m_m_genfat_02',
    'a_m_m_golfer_01',
    'a_m_m_hasjew_01',
    'a_m_m_hillbilly_01',
    'a_m_m_hillbilly_02',
    'a_m_m_indian_01',
    'a_m_m_ktown_01',
    'a_m_m_malibu_01',
    'a_m_m_mexcntry_01',
    'a_m_m_mexlabor_01',
    'a_m_m_og_boss_01',
    'a_m_m_paparazzi_01',
    'a_m_m_polynesian_01',
    'a_m_m_prolhost_01',
    'a_m_m_rurmeth_01',
    'a_m_m_salton_01',
    'a_m_m_salton_02',
    'a_m_m_salton_03',
    'a_m_m_salton_04',
    'a_m_m_skater_01',
    'a_m_m_skidrow_01',
    'a_m_m_socenlat_01',
    'a_m_m_soucent_01',
    'a_m_m_soucent_02',
    'a_m_m_soucent_03',
    'a_m_m_soucent_04',
    'a_m_m_stlat_02',
    'a_m_m_tennis_01',
    'a_m_m_tourist_01',
    'a_m_m_trampbeac_01',
    'a_m_m_tramp_01',
    'a_m_m_tranvest_01',
    'a_m_m_tranvest_02',
    'a_m_o_beach_01',
    'a_m_o_genstreet_01',
    'a_m_o_ktown_01',
    'a_m_o_salton_01',
    'a_m_o_soucent_01',
    'a_m_o_soucent_02',
    'a_m_o_soucent_03',
    'a_m_o_tramp_01',
    'a_m_y_beachvesp_01',
    'a_m_y_beachvesp_02',
    'a_m_y_beach_01',
    'a_m_y_beach_02',
    'a_m_y_beach_03',
    'a_m_y_bevhills_01',
    'a_m_y_bevhills_02',
    'a_m_y_breakdance_01',
    'a_m_y_busicas_01',
    'a_m_y_business_01',
    'a_m_y_business_02',
    'a_m_y_business_03',
    'a_m_y_cyclist_01',
    'a_m_y_dhill_01',
    'a_m_y_downtown_01',
    'a_m_y_eastsa_01',
    'a_m_y_eastsa_02',
    'a_m_y_epsilon_01',
    'a_m_y_epsilon_02',
    'a_m_y_gay_01',
    'a_m_y_gay_02',
    'a_m_y_genstreet_01',
    'a_m_y_genstreet_02',
    'a_m_y_golfer_01',
    'a_m_y_hasjew_01',
    'a_m_y_hiker_01',
    'a_m_y_hipster_01',
    'a_m_y_hipster_02',
    'a_m_y_hipster_03',
    'a_m_y_indian_01',
    'a_m_y_jetski_01',
    'a_m_y_juggalo_01',
    'a_m_y_ktown_01',
    'a_m_y_ktown_02',
    'a_m_y_latino_01',
    'a_m_y_methhead_01',
    'a_m_y_mexthug_01',
    'a_m_y_motox_01',
    'a_m_y_motox_02',
    'a_m_y_musclbeac_01',
    'a_m_y_musclbeac_02',
    'a_m_y_polynesian_01',
    'a_m_y_roadcyc_01',
    'a_m_y_runner_01',
    'a_m_y_runner_02',
    'a_m_y_salton_01',
    'a_m_y_skater_01',
    'a_m_y_skater_02',
    'a_m_y_soucent_01',
    'a_m_y_soucent_02',
    'a_m_y_soucent_03',
    'a_m_y_soucent_04',
    'a_m_y_stbla_01',
    'a_m_y_stbla_02',
    'a_m_y_stlat_01',
    'a_m_y_stwhi_01',
    'a_m_y_stwhi_02',
    'a_m_y_sunbathe_01',
    'a_m_y_surfer_01',
    'a_m_y_vindouche_01',
    'a_m_y_vinewood_01',
    'a_m_y_vinewood_02',
    'a_m_y_vinewood_03',
    'a_m_y_vinewood_04',
    'a_m_y_yoga_01',
    'g_m_m_armboss_01',
    'g_m_m_armgoon_01',
    'g_m_m_armlieut_01',
    'g_m_m_chemwork_01',
    'g_m_m_chiboss_01',
    'g_m_m_chicold_01',
    'g_m_m_chigoon_01',
    'g_m_m_chigoon_02',
    'g_m_m_korboss_01',
    'g_m_m_mexboss_01',
    'g_m_m_mexboss_02',
    'g_m_y_armgoon_02',
    'g_m_y_azteca_01',
    'g_m_y_ballaeast_01',
    'g_m_y_ballaorig_01',
    'g_m_y_ballasout_01',
    'g_m_y_famca_01',
    'g_m_y_famdnf_01',
    'g_m_y_famfor_01',
    'g_m_y_korean_01',
    'g_m_y_korean_02',
    'g_m_y_korlieut_01',
    'g_m_y_lost_01',
    'g_m_y_lost_02',
    'g_m_y_lost_03',
    'g_m_y_mexgang_01',
    'g_m_y_mexgoon_01',
    'g_m_y_mexgoon_02',
    'g_m_y_mexgoon_03',
    'g_m_y_pologoon_01',
    'g_m_y_pologoon_02',
    'g_m_y_salvaboss_01',
    'g_m_y_salvagoon_01',
    'g_m_y_salvagoon_02',
    'g_m_y_salvagoon_03',
    'g_m_y_strpunk_01',
    'g_m_y_strpunk_02',
    'mp_m_claude_01',
    'mp_m_exarmy_01',
    'mp_m_shopkeep_01',
    's_m_m_ammucountry',
    's_m_m_autoshop_01',
    's_m_m_autoshop_02',
    's_m_m_bouncer_01',
    's_m_m_chemsec_01',
    's_m_m_cntrybar_01',
    's_m_m_dockwork_01',
    's_m_m_doctor_01',
    's_m_m_fiboffice_01',
    's_m_m_fiboffice_02',
    's_m_m_gaffer_01',
    's_m_m_gardener_01',
    's_m_m_gentransport',
    's_m_m_hairdress_01',
    's_m_m_highsec_01',
    's_m_m_highsec_02',
    's_m_m_janitor',
    's_m_m_lathandy_01',
    's_m_m_lifeinvad_01',
    's_m_m_linecook',
    's_m_m_lsmetro_01',
    's_m_m_mariachi_01',
    's_m_m_marine_01',
    's_m_m_marine_02',
    's_m_m_migrant_01',
    's_m_m_movalien_01',
    's_m_m_movprem_01',
    's_m_m_movspace_01',
    's_m_m_pilot_01',
    's_m_m_pilot_02',
    's_m_m_postal_01',
    's_m_m_postal_02',
    's_m_m_scientist_01',
    's_m_m_security_01',
    's_m_m_strperf_01',
    's_m_m_strpreach_01',
    's_m_m_strvend_01',
    's_m_m_trucker_01',
    's_m_m_ups_01',
    's_m_m_ups_02',
    's_m_o_busker_01',
    's_m_y_airworker',
    's_m_y_ammucity_01',
    's_m_y_armymech_01',
    's_m_y_autopsy_01',
    's_m_y_barman_01',
    's_m_y_baywatch_01',
    's_m_y_blackops_01',
    's_m_y_blackops_02',
    's_m_y_busboy_01',
    's_m_y_chef_01',
    's_m_y_clown_01',
    's_m_y_construct_01',
    's_m_y_construct_02',
    's_m_y_cop_01',
    's_m_y_dealer_01',
    's_m_y_devinsec_01',
    's_m_y_dockwork_01',
    's_m_y_doorman_01',
    's_m_y_dwservice_01',
    's_m_y_dwservice_02',
    's_m_y_factory_01',
    's_m_y_garbage',
    's_m_y_grip_01',
    's_m_y_marine_01',
    's_m_y_marine_02',
    's_m_y_marine_03',
    's_m_y_mime',
    's_m_y_pestcont_01',
    's_m_y_pilot_01',
    's_m_y_prismuscl_01',
    's_m_y_prisoner_01',
    's_m_y_robber_01',
    's_m_y_shop_mask',
    's_m_y_strvend_01',
    's_m_y_uscg_01',
    's_m_y_valet_01',
    's_m_y_waiter_01',
    's_m_y_winclean_01',
    's_m_y_xmech_01',
    's_m_y_xmech_02',
    'u_m_m_aldinapoli',
    'u_m_m_bankman',
    'u_m_m_bikehire_01',
    'u_m_m_fibarchitect',
    'u_m_m_filmdirector',
    'u_m_m_glenstank_01',
    'u_m_m_griff_01',
    'u_m_m_jesus_01',
    'u_m_m_jewelsec_01',
    'u_m_m_jewelthief',
    'u_m_m_markfost',
    'u_m_m_partytarget',
    'u_m_m_prolsec_01',
    'u_m_m_promourn_01',
    'u_m_m_rivalpap',
    'u_m_m_spyactor',
    'u_m_m_willyfist',
    'u_m_o_finguru_01',
    'u_m_o_taphillbilly',
    'u_m_o_tramp_01',
    'u_m_y_abner',
    'u_m_y_antonb',
    'u_m_y_babyd',
    'u_m_y_baygor',
    'u_m_y_burgerdrug_01',
    'u_m_y_chip',
    'u_m_y_cyclist_01',
    'u_m_y_fibmugger_01',
    'u_m_y_guido_01',
    'u_m_y_gunvend_01',
    'u_m_y_imporage',
    'u_m_y_mani',
    'u_m_y_militarybum',
    'u_m_y_paparazzi',
    'u_m_y_party_01',
    'u_m_y_pogo_01',
    'u_m_y_prisoner_01',
    'u_m_y_proldriver_01',
    'u_m_y_rsranger_01',
    'u_m_y_sbike',
    'u_m_y_staggrm_01',
    'u_m_y_tattoo_01',
    'u_m_y_zombie_01',
    'u_m_y_hippie_01',
    'a_m_y_hippy_01',
    'a_m_y_stbla_m',
    'ig_terry_m',
    'a_m_m_ktown_m',
    'a_m_y_skater_m',
    'u_m_y_coop',
    'ig_car3guy1_m',
    'tony',
    'g_m_m_chigoon_02_m',
    'a_m_o_acult_01'
}
