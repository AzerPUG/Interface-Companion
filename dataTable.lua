if AZP == nil then AZP = {} end
if AZP.InterfaceCompanion == nil then AZP.InterfaceCompanion = {} end

--[[

    Mounts:
        - Load by ModelID.
        - WoW Tools >> Mount >> Name_lang: Name.
            - Click ID >> View MountXDisplay.
            - Click Creature Display Info >> Model ID >> Use File Data ID.

]]

AZP.InterfaceCompanion.PepeInfo =
{
    StandardPath = "World\\Expansion05\\doodads\\orc\\doodads\\",
    Active = {17, 18, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 31, 32, 33, 34, 35, 36},
     [1] = {Name =      "Standard Pepe",    ModelID = 1041861,},
     [2] = {Name =        "Knight Pepe",    ModelID = 1131783,},
     [3] = {Name =        "Pirate Pepe",    ModelID = 1131795,},
     [4] = {Name =         "Ninja Pepe",    ModelID = 1131797,},
     [5] = {Name =        "Viking Pepe",    ModelID = 1131798,},
     [6] = {Name =         "Witch Pepe",    ModelID = 1246563,},
     [7] = {Name =      "Traveler Pepe",    ModelID = 1386540,},
     [8] = {Name =  "Demon Hunter Pepe",    ModelID = 1534076,},
     [9] = {Name =     "Kul Tiran Pepe",    ModelID = 1859375,},
    [10] = {Name =    "Zan'Dalari Pepe",    ModelID = 1861550,},
    [11] = {Name =   "Mecha Gnome Pepe",    ModelID = 3011956,},
    [12] = {Name =         "Santa Pepe",    ModelID = 3209343,},
    [13] = {Name =    "Necro Lord Pepe",    ModelID = 3855982,},
    [14] = {Name =        "Kyrian Pepe",    ModelID = 3866273,},
    [15] = {Name =       "Venthyr Pepe",    ModelID = 3866274,},
    [16] = {Name =     "Night Fae Pepe",    ModelID = 3866275,},
    [17] = {Name =            "Pocopoc", CreatureID =  181059,},
    [18] = {Name =               "Argi", CreatureID =   88807,},
    [19] = {Name =          "Brightpaw", CreatureID =   85283,},
    [20] = {Name =       "Baby Winston", CreatureID =  103159,},
    [21] = {Name =           "Mischief", CreatureID =  113527,},
    [22] = {Name =             "Tottle", CreatureID =  129049,},
    [23] = {Name =            "Ash'Ana", CreatureID =   17254,},
    [24] = {Name =              "Gizmo", CreatureID =  179166,},
    [25] = {Name =     "Lost Netherpup", CreatureID =   93142,},
    [26] = {Name =           "Twilight", CreatureID =  122033,},
    [27] = {Name =             "Purity", CreatureID =  171697,},
    [28] = {Name =             "Shadow", CreatureID =  123650,},
    [29] = {Name =      "Elekk Plushie", CreatureID =   82464,},
    [30] = {Name =      "Ghostly Skull", CreatureID =   29147,},
    [31] = {Name = "Kirin Tor Familiar", CreatureID =   32643,},
    [32] = {Name =        "Murkstrasza", CreatureID =  181535,},
    [33] = {Name =             "Drakks", CreatureID =  181575,},
    [34] = {Name =           "Murkidan", CreatureID =   85009,},
    [35] = {Name =              "Lurky", CreatureID =   15358,},
    [36] = {Name =           "SlimeCat",    ModelID = 4215863,},
}