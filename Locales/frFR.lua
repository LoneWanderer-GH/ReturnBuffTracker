local L = LibStub("AceLocale-3.0"):NewLocale("ReturnBuffTracker", "frFR")
if not L then return end
--L["Return Buff Tracker by Irpa\nDiscord: https://discord.gg/SZYAKFy\nGithub: https://github.com/zorkqz/ReturnBuffTracker\n"] = "Return Buff Tracker par Irpa\nDiscord: https://discord.gg/SZYAKFy\nGithub: https://github.com/zorkqz/ReturnBuffTracker\n"
--@localization(locale="frFR", format="lua_additive_table", same-key-is-true=true, handle-subnamespaces="concat")@

-- stats
L["STA"]                                              = "END"
L["SPI"]                                              = "ESP"
L["AGI"]                                              = "AGI"
L["INT"]                                              = "INT"
L["STR"]                                              = "FOR"

-- addon texts
L["Main Options"]                                     = "Options principages"
L["Global Settings"]                                  = "Paramètres globaux"
L["Hide when not in raid"]                            = "Cacher si pas en raid"
L["The buff tracker does not work outside of raids."] = "Ne fonctionne pas en dehors des raids"
L["Loot Method"]                                      = "Mode de butin"
L["Bars to show"]                                     = "Barres à afficher"
L["General Buffs"]                                    = "Buffs généraux"
L["Player buffs"]                                     = "Buffs joueurs"
L["World Buffs"]                                      = "Buffs mondiaux"
L["World"]                                            = "Monde"
L["Consumables"]                                      = "Consommables"
L["Consumable"]                                       = "Consommable"
L["Misc"]                                             = "Divers"

L["Report config"]                                    = "Configuration des rapports"
L["Addon logging level"]                              = "Seuil des logs"

L["Guild"]                                            = "Guilde"
L["Instance"]                                         = "Instance"
L["Officer"]                                          = "Officiers"
L["Party"]                                            = "Groupe"
L["Raid"]                                             = "Raid"
L["Raid Warning"]                                     = "Alerte Raid"
L["Say"]                                              = "Dire"

L["Alive"]                                            = "Vivant"
L["Useless unit"]                                     = "Boulets"
L["General"]                                          = "Général"
L["Healer Mana"]                                      = "Mana Soigneurs"
L["Healer"]                                           = "Soigneur"
L["DPS Mana"]                                         = "Mana DPS"
L["DPS"]                                              = "DPS"
L["In Combat"]                                        = "En combat"

L["Raid buffs data refresh rate"]                     = "Taux de rafraichissement des buffs de raid"

L["Soulstone Resurrection"]                           = "Résurrection Pierre d'Âme"

L["Soulstones"]                                       = "Pierres d'Âme"
L["Group"]                                            = "Groupe"
L["Dead"]                                             = "Mort"
--L["Dead:"]                                            = "Mort(s) :"
L["no one"]                                           = "personne"
--L["no one."]                                          = "personne."
L["Not in Combat"]                                    = "Hors combat"
--L["Not in Combat: "]                                  = "Hors combat : "
--L["Group %d:"]                                        = "Groupe %d:"
--L["Soulstones: "]                                     = "Pierres d'âme: "
--L["none."]                                            = "Aucun(e)."
L["none"]                                             = "aucun(e)"
--L["Missing %s"]                                       = "Manquant -- %s --"
L["Missing"]                                          = "Manquant"
L["class"]                                            = "classe"

L["Capitals"]                                         = "Capitales"
L["Dire Maul"]                                        = "Hache-Tripes"
L["DMF"]                                              = "Foire de Sombrelune"

-- player buffs
L["Arcane Intellect"]                                 = "Intelligence des Arcanes"
L["Intellect"]                                        = "Intelligence"
L["Arcane Brilliance"]                                = "Illumination des Arcanes"
L["Carrot on a stick"]                                = "Carrote et bâton"
L["Possible carrot on a stick: "]                     = "Carrotes potentielles: "
L["Mark of the Wild"]                                 = "Marque du Fauve"
L["Gift of the Wild"]                                 = "Don du Fauve"
L["MotW"]                                             = "Papatte"
L["Power Word: Fortitude"]                            = "Mot de Pouvoir : Robustesse"
L["Fortitude"]                                        = "Endurance"
L["Prayer of Fortitude"]                              = "Prière de Robustesse"
L["Spirit"]                                           = "Esprit"
L["Divine Spirit"]                                    = "Esprit Divin"
L["Prayer of Spirit"]                                 = "Prière d'Esprit"
L["Shadow Protection"]                                = "Protection contre l'Ombre"
L["Shadow Prot."]                                     = "Buff RO"
L["Prayer of Shadow Protection"]                      = "Prière de Protection contre l'Ombre"
L["Blessing of Kings"]                                = "Bénédiction des Rois"
L["Kings"]                                            = "Bén. Rois"
L["Greater Blessing of Kings"]                        = "Bénédiction des Rois Supérieure"
L["class"]                                            = "classe"
L["Blessing of Salvation"]                            = "Bénédiction de Salut"
L["Salvation"]                                        = "Bén. Salut"
L["Greater Blessing of Salvation"]                    = "Bénédiction de Salut Supérieure"
L["Blessing of Wisdom"]                               = "Bénédiction de Sagesse"
L["Wisdom"]                                           = "Bén. Sagesse"
L["Greater Blessing of Wisdom"]                       = "Bénédiction de Sagesse Supérieure"
L["Blessing of Might"]                                = "Bénédiction de Puissance"
L["Might"]                                            = "Bén. Puissance"
L["Greater Blessing of Might"]                        = "Bénédiction de Puissance Supérieure"
L["Blessing of Light"]                                = "Bénédiction de Lumière"
L["Light"]                                            = "Bén. Lumière"
L["Greater Blessing of Light"]                        = "Bénédiction de Lumière Supérieure"
L["Blessing of Sanctuary"]                            = "Bénédiction de Sanctuaire"
L["Sanctuary"]                                        = "Bén. Sanctuaire"
L["Greater Blessing of Sanctuary"]                    = "Bénédiction de Sanctuaire"

-- world buffs
L["Warchief's Blessing"]                              = "Bénédiction du chef de guerre"
L["Rend"]                                             = true
L["Rallying Cry of the Dragonslayer"]                 = "Cri de ralliement du tueur de dragon"
L["Dragonslayer"]                                     = "Buff Ony/Nef"
L["Spirit of Zandalar"]                               = "Esprit des Zandalar"
L["ZG"]                                               = "Buff ZG"

-- felwood
L["Songflower"]                                       = "Fleur de Chant"
L["Songflower Serenade"]                              = "Sérénade de Fleur-de-chant"

-- DM
L["Fengus' Ferocity"]                                 = "Férocité de Fengus"
L["DMT AP"]                                           = "Buff HTN T PA"
L["Slip'kik's Savvy"]                                 = "La sagacité de Slip'kik"
L["DMT Crit"]                                         = "Buff HTN T Crit"
L["Mol'dar's Moxie"]                                  = "Mol'dar's Moxie"
L["DMT Stamina"]                                      = "Buff HTN T Endu"

-- Winterfell
L["Juju Power"]                                       = "Pouvoir de Juju"
L["Juju Might"]                                       = "Puissance de Juju"
L["Juju Chill"]                                       = "Frisson de Juju"
L["Juju Ember"]                                       = "Braise de Juju"
L["Winterfall Firewater"]                             = "Eau de feu des Tombe-Hiver"
L["Firewater"]                                        = "Eau de feu"


-- Potions and exilirs
L["Greater Arcane Elixir"]                            = "Elixir des Arcanes Supérieur"
L["+30dmg"]                                           = "+30dmg"
L["+20dmg OR +30dmg"]                                 = "+20dmg OU +30dmg"
L["+40 fire dmg"]                                     = "+40 dmg feu"

L["Arcane Elixir"]                                    = "Elixir des Arcanes"
L["+20dmg"]                                           = "+20dmg"

L["Elixir of Shadow Power"]                           = "Elixir de Puissance de l'Ombre"
L["+40 shadow dmg"]                                   = "+40 dmg ombre"

L["Elixir of Fire Mastery"]                           = "Elixir de Maîtrise du feu Supérieure"
L["E. Fire Mast."]                                    = "E. de M. Feu sup."

L["Elixir of Greater Agility"]                        = "Elixir d'agilité supérieure"
L["Elixir of the Mongoose"]                           = "Elixir de la Mangouste"
L["Mongoose"]                                         = "Mangouste"

L["Giant Elixir"]                                     = "Elixir des géants"
L["Strength Buff"]                                    = "Buff Force"

L["AP Buff"]                                          = "Buff PA"

L["Elixir of Fortitude"]                              = "Elixir de Robustesse"
L["E. Fortitude"]                                     = "E. de Robu."

L["Fire Protection Potions"]                          = "Potions RF"
L["Fire Protection"]                                  = "Protection contre le Feu"
L["Fire Pot."]                                        = "Pot. Feu"

L["Nature Protection Potions"]                        = "Potions RN"
L["Nature Protection"]                                = "Protection contre la Nature"
L["Nature Pot."]                                      = "Pot. Nat"

L["Shadow Protection Potions"]                        = "Potions RO"
L["Shadow Protection"]                                = "Protection contre l'ombre"
L["Shadow Pot."]                                      = "Pot. Ombre"

L["Arcane Protection"]                                = "Protection des arcanes"
L["Arcane Pot."]                                      = "Pot. Arc."
L["Arcane Protection Potions"]                        = "Potions RA"

L["Frost Protection Potions"]                         = "Potions RG"
L["Frost Protection"]                                 = "Protection contre le Givre"
L["Frost Pot."]                                       = "Pot. Givre"
L["Arthas 10 RO"]                                     = "Arthas 10 RO"
L["Gift of Arthas"]                                   = "Don d'Arthas"

-- DMF
L["DMF buffs"]                                        = "Buffs Foire"
L["Chronolol"]                                        = "Chronolol"
L["Sayge's Dark Fortune of Damage"]                   = "Sombre prédiction de dégâts de Sayge"
L["DMF Damage"]                                       = "Foire +10% Damage"
L["Sayge's Dark Fortune of Stamina"]                  = "Sombre prédiction d'Endurance de Sayge"
L["DMF Sta."]                                         = "Foire +10% Endu"
L["Sayge's Dark Fortune of Intelligence"]             = "Sombre prédiction d'Intelligence de Sayge"
L["DMF Int."]                                         = "Foire +10% Int"
L["Sayge's Dark Fortune of Spirit"]                   = "Sombre prédiction d'Esprit de Sayge"
L["DMF Spi."]                                         = "Foire +10% Esp"
L["Sayge's Dark Fortune of Armor"]                    = "Sombre prédiction d'Armure de Sayge"
L["DMF Armor"]                                        = "Foire +10% Armure"

--
L["+40 fire OR shadow dmg"]                           = "+40 dmg feu OU ombre"
L["+25 AGI"]                                          = "+25 AGI"
--L["+25 AGI OR Mongoose"]                              = format("%s %s %s", L["+25 AGI"], "OU", L["Mongoose"]) -- "+25 AGI OU Mangouste"
L["+25 AGI OR Mongoose"]                              = "+25 AGI OU Mangouste" -- "+25 AGI OU Mangouste"
--L["Juju Power OR Giant Elixir"]                       = format("%s %s %s", L["Juju Power"], "OU", L["Giant Elixir"])
--L["Juju Power OR Giant Elixir"]                       = "Pouvoir de Juju OU Elixir des Géants"
L["Juju Power OR Giant Elixir"]                       = "Pouvoir de Juju  OU  Elixir de Géant"

--L["Juju Might OR Firewater"]                          = format("%s %s %s", L["Juju Might"], "OU", L["Firewater"])
L["Juju Might OR Firewater"]                          = "Puissance de Juju OU Eau de feu"

L["Elixir of Superior Defense"]                       = "Elixir de défense supérieure"
L["+450 armor"]                                       = "+450 armure"

-- Regen pot.
L["Troll's Blood Potions"]                            = "Potions sang de troll"
L["+12/20 HP5"]                                       = true
L["Major Troll's Blood Potion"]                       = "Potion de sang de troll majeure"
L["+20 MP5"]                                          = true
L["Mighty Troll's Blood Potion"]                      = "Potion de sang de troll forte"
L["+12 HP5"]                                          = true
L["Mageblood Potion"]                                 = "Potion de Magesang"
L["+12 MP5"]                                          = true

L["Potions"]                                          = true
L["Protection Potions"]                               = "Potions de protection"
L["Physical mitig."]                                  = "Reduction dégats physiques"
-- Flacons
L["Flasks"]                                           = "Flacons"
L["+Mana Flask"]                                      = "Flacon Mana"
L["+dmg Flask"]                                       = "Flacon +dmg"
L["+HP Flask"]                                        = "Flacon +hp"

L["Flask of Distilled Wisdom"]                        = "Flacon de sagesse distillée"
L["Flask of Supreme Power"]                           = "Flacon de pouvoir suprême"
L["Flask of the Titans"]                              = "Flacon des titans"

-- ZG
L["Spirit of Zanza"]                                  = "Esrit de Zanza"
L["+50 STA/SPI"]                                      = "+50 END/ESP"

-- Terres foudroyées
--L["+25 stat (Blasted Lands)"]                         = format("+25 stat (%s)", L["Blasted Lands"])
--L["+25 stat (BL)"]                                    = format("+25 %s (%s)", L["stat"], L["BL"])
--
--L["+25 STR (R.O.I.D.S)"]                              = format("+25 %s (R.O.I.D.S)", L["STR"])
--L["+25 STR (BL)"]                                     = format("+25 %s (%s)", L["STR"], L["BL"])
--
--L["+25 AGI (Ground Scorpok Assay)"]                   = format("+25 %s (Ground Scorpok Assay)", L["AGI"])
--L["+25 AGI (BL)"]                                     = format("+25 %s (%s)", L["AGI"], L["BL"])
--
--L["+25 STA (Lung Juice Cocktail)"]                    = format("+25 %s (Lung Juice Cocktail)", L["STA"])
--L["+25 STA (BL)"]                                     = format("+25 %s (%s)", L["STA"], L["BL"])
--
--L["+25 INT (Cerebral Cortex Compound)"]               = format("+25 %s (Cerebral Cortex Compound)", L["INT"])
--L["+25 INT (BL)"]                                     = format("+25 %s (%s)", L["INT"], L["BL"])
--
--L["+25 SPI (Gizzard Gum)"]                            = format("+25 %s (Gizzard Gum)", L["SPI"])
--L["+25 SPI (BL)"]                                     = format("+25 %s (%s)", L["SPI"], L["BL"])

L["+25 stat (Blasted Lands)"]                         = "+25 stat (Terres Foudroyées)"
L["+25 stat (BL)"]                                    = "+25 stat (TF)"

L["+25 STR (R.O.I.D.S)"]                              = "+25 FOR (R.O.I.D.S)"
L["+25 STR (BL)"]                                     = "+25 FOR (TF)"

L["+25 AGI (Ground Scorpok Assay)"]                   = "+25 AGI (Ground Scorpok Assay)"
L["+25 AGI (BL)"]                                     = "+25 AGI (TF)"

L["+25 STA (Lung Juice Cocktail)"]                    = "+25 END (Lung Juice Cocktail)"
L["+25 STA (BL)"]                                     = "+25 END (TF)"

L["+25 INT (Cerebral Cortex Compound)"]               = "+25 INT (Cerebral Cortex Compound)"
L["+25 INT (BL)"]                                     = "+25 INT (TF)"

L["+25 SPI (Gizzard Gum)"]                            = "+25 SPI (Gizzard Gum)"
L["+25 SPI (BL)"]                                     = "+25 SPI (TF)"





-- Zones
L["Winterfell"]                                       = "Berceau-de-l'Hiver"
L["Blasted Lands"]                                    = "Terres Foudroyées"
L["BL"]                                               = "TF"
L["Zul'Gurub"]                                        = true
L["Felwood"]                                          = "Gangrebois"