local _;
local S = SMARTBUFF_GLOBALS;

SMARTBUFF_PLAYERCLASS = nil;
SMARTBUFF_BUFFLIST = nil;

-- Buff types
SMARTBUFF_CONST_ALL       = "ALL";
SMARTBUFF_CONST_GROUP     = "GROUP";
SMARTBUFF_CONST_GROUPALL  = "GROUPALL";
SMARTBUFF_CONST_SELF      = "SELF";
SMARTBUFF_CONST_FORCESELF = "FORCESELF";
SMARTBUFF_CONST_TRACK     = "TRACK";
SMARTBUFF_CONST_WEAPON    = "WEAPON";
SMARTBUFF_CONST_INV       = "INVENTORY";
SMARTBUFF_CONST_FOOD      = "FOOD";
SMARTBUFF_CONST_SCROLL    = "SCROLL";
SMARTBUFF_CONST_POTION    = "POTION";
SMARTBUFF_CONST_STANCE    = "STANCE";
SMARTBUFF_CONST_ITEM      = "ITEM";
SMARTBUFF_CONST_ITEMGROUP = "ITEMGROUP";
SMARTBUFF_CONST_TOY       = "TOY";

S.CheckPet = "CHECKPET";
S.CheckPetNeeded = "CHECKPETNEEDED";
S.CheckFishingPole = "CHECKFISHINGPOLE";
S.NIL = "x";
S.Toybox = { };

local function GetItems(items)
  local t = { };
  for _, id in pairs(items) do
    local name = GetItemInfo(id);
    if (name) then
      --print("Item found: "..id..", "..name);
      tinsert(t, name);
    end
  end
  return t;
end

local function InsertItem(t, type, itemId, spellId, duration, link)
  local item = GetItemInfo(itemId);
  local spell = GetSpellInfo(spellId);
  if (item and spell) then
    --print("Item found: "..item..", "..spell);
    tinsert(t, {item, duration, type, nil, spell, link});
  end
end

local function AddItem(itemId, spellId, duration, link)
  InsertItem(SMARTBUFF_SCROLL, SMARTBUFF_CONST_SCROLL, itemId, spellId, duration, link);
end

--[[local function LoadToys()
  C_ToyBox.SetCollectedShown(true)
  C_ToyBox.SetAllSourceTypeFilters(true)
  C_ToyBox.SetFilterString("")
  
  local nTotal = C_ToyBox.GetNumTotalDisplayedToys();
  local nLearned = C_ToyBox.GetNumLearnedDisplayedToys() or 0;
  if (nLearned <= 0) then
    return;
  end
  
  for i = 1, nTotal do
    local num = C_ToyBox.GetToyFromIndex(i);
    local id, name, icon = C_ToyBox.GetToyInfo(num);
    if (id) then
      if (PlayerHasToy(id)) then
        S.Toybox[tostring(name)] = {id, icon};
      end
    end
  end

  SMARTBUFF_AddMsgD("Toys initialized");
end
--]]

function SMARTBUFF_InitItemList()
  -- Reagents
  SMARTBUFF_WILDBERRIES         = GetItemInfo(17021); --"Wild Berries"
  SMARTBUFF_WILDTHORNROOT       = GetItemInfo(17026); --"Wild Thornroot"
  SMARTBUFF_WILDQUILLVINE       = GetItemInfo(22148); --"Wild Quillvine"
  SMARTBUFF_WILDSPINELEAF       = GetItemInfo(44605); --"Wild Spineleaf"
  SMARTBUFF_ARCANEPOWDER        = GetItemInfo(17020); --"Arcane Powder"
  SMARTBUFF_HOLYCANDLE          = GetItemInfo(17028); --"Holy Candle"
  SMARTBUFF_SACREDCANDLE        = GetItemInfo(17029); --"Sacred Candle"
  SMARTBUFF_DEVOUTCANDLE        = GetItemInfo(44615); --"Devout Candle"
  SMARTBUFF_SYMBOLOFKINGS       = GetItemInfo(21177); --"Symbol of Kings"
  
  -- Stones and oils
  SMARTBUFF_SOULSTONEGEM        = GetItemInfo(16893); --"Soulstone"
  SMARTBUFF_HEALTHSTONEGEM      = GetItemInfo(5509);  --"Healthstone"
  SMARTBUFF_MANAGEM             = GetItemInfo(36799); --"Mana Gem"
  SMARTBUFF_BRILLIANTMANAGEM    = GetItemInfo(81901); --"Brilliant Mana Gem"
  SMARTBUFF_SSROUGH             = GetItemInfo(2862);  --"Rough Sharpening Stone"
  SMARTBUFF_SSCOARSE            = GetItemInfo(2863);  --"Coarse Sharpening Stone"
  SMARTBUFF_SSHEAVY             = GetItemInfo(2871);  --"Heavy Sharpening Stone"
  SMARTBUFF_SSSOLID             = GetItemInfo(7964);  --"Solid Sharpening Stone"
  SMARTBUFF_SSDENSE             = GetItemInfo(12404); --"Dense Sharpening Stone"
  SMARTBUFF_SSELEMENTAL         = GetItemInfo(18262); --"Elemental Sharpening Stone"
  SMARTBUFF_SSFEL               = GetItemInfo(23528); --"Fel Sharpening Stone"
  SMARTBUFF_SSADAMANTITE        = GetItemInfo(23529); --"Adamantite Sharpening Stone"
  SMARTBUFF_WSROUGH             = GetItemInfo(3239);  --"Rough Weightstone"
  SMARTBUFF_WSCOARSE            = GetItemInfo(3240);  --"Coarse Weightstone"
  SMARTBUFF_WSHEAVY             = GetItemInfo(3241);  --"Heavy Weightstone"
  SMARTBUFF_WSSOLID             = GetItemInfo(7965);  --"Solid Weightstone"
  SMARTBUFF_WSDENSE             = GetItemInfo(12643); --"Dense Weightstone"
  SMARTBUFF_WSFEL               = GetItemInfo(28420); --"Fel Weightstone"
  SMARTBUFF_WSADAMANTITE        = GetItemInfo(28421); --"Adamantite Weightstone"
  SMARTBUFF_SHADOWOIL           = GetItemInfo(3824);  --"Shadow Oil"
  SMARTBUFF_FROSTOIL            = GetItemInfo(3829);  --"Frost Oil"
  SMARTBUFF_MANAOIL1            = GetItemInfo(20745); --"Minor Mana Oil"
  SMARTBUFF_MANAOIL2            = GetItemInfo(20747); --"Lesser Mana Oil"
  SMARTBUFF_MANAOIL3            = GetItemInfo(20748); --"Brilliant Mana Oil"
  SMARTBUFF_MANAOIL4            = GetItemInfo(22521); --"Superior Mana Oil"
  --SMARTBUFF_MANAOIL5            = GetItemInfo(36899); --"Exceptional Mana Oil"
  SMARTBUFF_WIZARDOIL1          = GetItemInfo(20744); --"Minor Wizard Oil"
  SMARTBUFF_WIZARDOIL2          = GetItemInfo(20746); --"Lesser Wizard Oil"
  SMARTBUFF_WIZARDOIL3          = GetItemInfo(20750); --"Wizard Oil"
  SMARTBUFF_WIZARDOIL4          = GetItemInfo(20749); --"Brilliant Wizard Oil"
  SMARTBUFF_WIZARDOIL5          = GetItemInfo(22522); --"Superior Wizard Oil"
  --SMARTBUFF_WIZARDOIL6          = GetItemInfo(36900); --"Exceptional Wizard Oil"
  SMARTBUFF_SPELLSTONE1         = GetItemInfo(41191); --"Spellstone"
  SMARTBUFF_SPELLSTONE2         = GetItemInfo(41192); --"Greater Spellstone"
  SMARTBUFF_SPELLSTONE3         = GetItemInfo(41193); --"Major Spellstone"
  SMARTBUFF_SPELLSTONE4         = GetItemInfo(41194); --"Master Spellstone"
  SMARTBUFF_SPELLSTONE5         = GetItemInfo(41195); --"Demonic Spellstone"
  SMARTBUFF_SPELLSTONE6         = GetItemInfo(41196); --"Grand Spellstone"
  SMARTBUFF_FIRESTONE1          = GetItemInfo(41170); --"Lesser Firestone"
  SMARTBUFF_FIRESTONE2          = GetItemInfo(41169); --"Firestone"
  SMARTBUFF_FIRESTONE3          = GetItemInfo(41171); --"Greater Firestone"
  SMARTBUFF_FIRESTONE4          = GetItemInfo(41172); --"Major Firestone"
  SMARTBUFF_FIRESTONE5          = GetItemInfo(40773); --"Master Firestone"
  SMARTBUFF_FIRESTONE6          = GetItemInfo(41173); --"Fel Firestone"
  SMARTBUFF_FIRESTONE7          = GetItemInfo(41174); --"Grand Firestone"
  
  -- Poisons
  SMARTBUFF_INSTANTPOISON1      = GetItemInfo(6947);  --"Instant Poison"
  SMARTBUFF_INSTANTPOISON2      = GetItemInfo(6949);  --"Instant Poison II"
  SMARTBUFF_INSTANTPOISON3      = GetItemInfo(6950);  --"Instant Poison III"
  SMARTBUFF_INSTANTPOISON4      = GetItemInfo(8926);  --"Instant Poison IV"
  SMARTBUFF_INSTANTPOISON5      = GetItemInfo(8927);  --"Instant Poison V"
  SMARTBUFF_INSTANTPOISON6      = GetItemInfo(8928);  --"Instant Poison VI"
  SMARTBUFF_INSTANTPOISON7      = GetItemInfo(21927); --"Instant Poison VII"
  SMARTBUFF_INSTANTPOISON8      = GetItemInfo(43230); --"Instant Poison VIII"
  SMARTBUFF_INSTANTPOISON9      = GetItemInfo(43231); --"Instant Poison IX"
  SMARTBUFF_WOUNDPOISON1        = GetItemInfo(10918); --"Wound Poison"
  SMARTBUFF_WOUNDPOISON2        = GetItemInfo(10920); --"Wound Poison II"
  SMARTBUFF_WOUNDPOISON3        = GetItemInfo(10921); --"Wound Poison III"
  SMARTBUFF_WOUNDPOISON4        = GetItemInfo(10922); --"Wound Poison IV"
  SMARTBUFF_WOUNDPOISON5        = GetItemInfo(22055); --"Wound Poison V"
  SMARTBUFF_WOUNDPOISON6        = GetItemInfo(43234); --"Wound Poison VI"
  SMARTBUFF_WOUNDPOISON7        = GetItemInfo(43235); --"Wound Poison VII"
  SMARTBUFF_MINDPOISON1         = GetItemInfo(5237);  --"Mind-numbing Poison"
  SMARTBUFF_DEADLYPOISON1       = GetItemInfo(2892);  --"Deadly Poison"
  SMARTBUFF_DEADLYPOISON2       = GetItemInfo(2893);  --"Deadly Poison II"
  SMARTBUFF_DEADLYPOISON3       = GetItemInfo(8984);  --"Deadly Poison III"
  SMARTBUFF_DEADLYPOISON4       = GetItemInfo(8985);  --"Deadly Poison IV"
  SMARTBUFF_DEADLYPOISON5       = GetItemInfo(20844); --"Deadly Poison V"
  SMARTBUFF_DEADLYPOISON6       = GetItemInfo(22053); --"Deadly Poison VI"
  SMARTBUFF_DEADLYPOISON7       = GetItemInfo(22054); --"Deadly Poison VII"
  SMARTBUFF_DEADLYPOISON8       = GetItemInfo(43232); --"Deadly Poison VIII"
  SMARTBUFF_DEADLYPOISON9       = GetItemInfo(43233); --"Deadly Poison IX"
  SMARTBUFF_CRIPPLINGPOISON1    = GetItemInfo(3775);  --"Crippling Poison"
  SMARTBUFF_ANESTHETICPOISON1   = GetItemInfo(21835); --"Anesthetic Poison"
  SMARTBUFF_ANESTHETICPOISON2   = GetItemInfo(43237); --"Anesthetic Poison II"
  
  -- Food
  SMARTBUFF_KALDOREISPIDERKABOB = GetItemInfo(5472); --"Kaldorei Spider Kabob"
  SMARTBUFF_CRISPYBATWING = GetItemInfo(12224); --"Crispy Bat Wing"
  SMARTBUFF_HERBBAKEDEGG = GetItemInfo(6888); --"Herb Baked Egg"
  SMARTBUFF_GINGERBREADCOOKIE = GetItemInfo(17197); --"Gingerbread Cookie"
  SMARTBUFF_BEERBASTEDBOARRIBS  = GetItemInfo(2888); --"Beer Basted Boar Ribs"
  SMARTBUFF_ROASTEDKODOMEAT = GetItemInfo(5474); --"Roasted Kodo Meat"
  SMARTBUFF_EGGNOG = GetItemInfo(17198); --"Egg Nog"
  SMARTBUFF_BLOODSAUSAGE = GetItemInfo(3220);   --"Blood Sausage"
  SMARTBUFF_STRIDERSTEW = GetItemInfo(5477); --"Strider Stew"
  SMARTBUFF_CROCOLISKSTEAK  = GetItemInfo(3662); --"Crocolisk Steak"
  SMARTBUFF_SMOKEDSAGEFISH = GetItemInfo(21072); --"Smoked Sagefish"
  SMARTBUFF_FILLETOFFRENZY = GetItemInfo(5476); --"Fillet of Frenzy"
  SMARTBUFF_GORETUSKLIVERPIE = GetItemInfo(724); --"Goretusk Liver Pie"
  SMARTBUFF_REDRIDGEGOULASH  = GetItemInfo(1082); --"Redridge Goulash"
  SMARTBUFF_CRISPYLIZARDTAIL = GetItemInfo(5479); --"Crispy Lizard Tail"
  SMARTBUFF_BIGBEARSTEAK = GetItemInfo(3726); --"Big Bear Steak"
  SMARTBUFF_LEANWOLFSTEAK = GetItemInfo(12209); --"Lean Wolf Steak"
  SMARTBUFF_GOOEYSPIDERCAKE = GetItemInfo(3666); --"Gooey Spider Cake"
  SMARTBUFF_MURLOCFINSOUP = GetItemInfo(3663); --"Murloc Fin Soup"
  SMARTBUFF_GOBLINDEVILEDCLAMS = GetItemInfo(5527); --"Goblin Deviled Clams"
  SMARTBUFF_CURIOUSLYTASTYOMELET = GetItemInfo(3665); --"Curiously Tasty Omelet"
  SMARTBUFF_LEANVENISON = GetItemInfo(5480); --"Lean Venison"
  SMARTBUFF_HOTLIONCHOPS = GetItemInfo(3727); --"Hot Lion Chops"
  SMARTBUFF_SEASONEDWOLFKABOB = GetItemInfo(1017); --"Seasoned Wolf Kabob"
  SMARTBUFF_CROCOLISKGUMBO = GetItemInfo(3664); --"Crocolisk Gumbo"
  SMARTBUFF_SOOTHINGTURTLEBISQUE  = GetItemInfo(3729); --"Soothing Turtle Bisque"
  SMARTBUFF_HEAVYCROCOLISKSTEW = GetItemInfo(20074); --"Heavy Crocolisk Stew"
  SMARTBUFF_TASTYLIONSTEAK  = GetItemInfo(3728); --"Tasty Lion Steak"
  SMARTBUFF_SAGEFISHDELIGHT = GetItemInfo(21217); --"Sagefish Delight"
  SMARTBUFF_HOTWOLFRIBS = GetItemInfo(13851); --"Hot Wolf Ribs"
  SMARTBUFF_JUNGLESTEW = GetItemInfo(12212); --"Jungle Stew"
  SMARTBUFF_CARRIONSURPRISE  = GetItemInfo(12213); --"Carrion Surprise"
  SMARTBUFF_ROASTRAPTOR = GetItemInfo(12210); --"Roast Raptor"
  SMARTBUFF_GIANTCLAMSCORCHO = GetItemInfo(6038); --"Giant Clam Scorcho"
  SMARTBUFF_MYSTERYSTEW  = GetItemInfo(12214); --"Mystery Stew"
  SMARTBUFF_BARBECUEDBUZZARDWING = GetItemInfo(4457); --"Barbecued Buzzard Wing"
  SMARTBUFF_HEAVYKODOSTEW = GetItemInfo(12215); --"Heavy Kodo Stew"
  SMARTBUFF_TENDERWOLFSTEAK = GetItemInfo(18045); --"Tender Wolf Steak"
  SMARTBUFF_MONSTEROMELET = GetItemInfo(12218); --"Monster Omelet"
  SMARTBUFF_SPICEDCHILICRAB = GetItemInfo(12216); --"Spiced Chili Crab"
  SMARTBUFF_COOKEDGLOSSYMIGHTFISH = GetItemInfo(13927); --"Cooked Glossy Mightfish"
  SMARTBUFF_GRILLEDSQUID = GetItemInfo(13928); --"Grilled Squid"
  SMARTBUFF_HOTSMOKEDBASS = GetItemInfo(13929); --"Hot Smoked Bass"
  SMARTBUFF_NIGHTFINSOUP = GetItemInfo(13931); --"Nightfin Soup"
  SMARTBUFF_POACHEDSUNSCALESALMON = GetItemInfo(13932); --"Poached Sunscale Salmon"
  SMARTBUFF_RUNNTUMTUBERSURPRISE = GetItemInfo(18254); --"Runn Tum Tuber Surprise"
  SMARTBUFF_MIGHTFISHSTEAK = GetItemInfo(13934); --"Mightfish Steak"
  SMARTBUFF_DIRGESKICKINCHIMAEROKCHOPS = GetItemInfo(21023); --"Dirge's Kickin' Chimaerok Chops"
  
  -- Conjured mage food IDs
  SMARTBUFF_CONJUREDMANA        = GetItemInfo(113509); --"Conjured Mana Buns"
  S.FoodMage = GetItems({113509, 80618, 80610, 65499, 43523, 43518, 34062, 65517, 65516, 65515, 65500, 42955});
  
  -- Scrolls
  SMARTBUFF_SOAGILITY1          = GetItemInfo(3012);  --"Scroll of Agility I"
  SMARTBUFF_SOAGILITY2          = GetItemInfo(1477);  --"Scroll of Agility II"
  SMARTBUFF_SOAGILITY3          = GetItemInfo(4425);  --"Scroll of Agility III"
  SMARTBUFF_SOAGILITY4          = GetItemInfo(10309); --"Scroll of Agility IV"
  --SMARTBUFF_SOAGILITY5          = GetItemInfo(27498); --"Scroll of Agility V"
  --SMARTBUFF_SOAGILITY6          = GetItemInfo(33457); --"Scroll of Agility VI"
  --SMARTBUFF_SOAGILITY7          = GetItemInfo(43463); --"Scroll of Agility VII"
  --SMARTBUFF_SOAGILITY8          = GetItemInfo(43464); --"Scroll of Agility VIII"
  SMARTBUFF_SOINTELLECT1        = GetItemInfo(955);   --"Scroll of Intellect I"
  SMARTBUFF_SOINTELLECT2        = GetItemInfo(2290);  --"Scroll of Intellect II"
  SMARTBUFF_SOINTELLECT3        = GetItemInfo(4419);  --"Scroll of Intellect III"
  SMARTBUFF_SOINTELLECT4        = GetItemInfo(10308); --"Scroll of Intellect IV"
  --SMARTBUFF_SOINTELLECT5        = GetItemInfo(27499); --"Scroll of Intellect V"
  --SMARTBUFF_SOINTELLECT6        = GetItemInfo(33458); --"Scroll of Intellect VI"
  --SMARTBUFF_SOINTELLECT7        = GetItemInfo(37091); --"Scroll of Intellect VII"
  --SMARTBUFF_SOINTELLECT8        = GetItemInfo(37092); --"Scroll of Intellect VIII"
  SMARTBUFF_SOSTAMINA1          = GetItemInfo(1180);  --"Scroll of Stamina I"
  SMARTBUFF_SOSTAMINA2          = GetItemInfo(1711);  --"Scroll of Stamina II"
  SMARTBUFF_SOSTAMINA3          = GetItemInfo(4422);  --"Scroll of Stamina III"
  SMARTBUFF_SOSTAMINA4          = GetItemInfo(10307); --"Scroll of Stamina IV"
  --SMARTBUFF_SOSTAMINA5          = GetItemInfo(27502); --"Scroll of Stamina V"
  --SMARTBUFF_SOSTAMINA6          = GetItemInfo(33461); --"Scroll of Stamina VI"
  --SMARTBUFF_SOSTAMINA7          = GetItemInfo(37093); --"Scroll of Stamina VII"
  --SMARTBUFF_SOSTAMINA8          = GetItemInfo(37094); --"Scroll of Stamina VIII"
  SMARTBUFF_SOSPIRIT1           = GetItemInfo(1181);  --"Scroll of Spirit I"
  SMARTBUFF_SOSPIRIT2           = GetItemInfo(1712);  --"Scroll of Spirit II"
  SMARTBUFF_SOSPIRIT3           = GetItemInfo(4424);  --"Scroll of Spirit III"
  SMARTBUFF_SOSPIRIT4           = GetItemInfo(10306); --"Scroll of Spirit IV"
  --SMARTBUFF_SOSPIRIT5           = GetItemInfo(27501); --"Scroll of Spirit V"
  --SMARTBUFF_SOSPIRIT6           = GetItemInfo(33460); --"Scroll of Spirit VI"
  --SMARTBUFF_SOSPIRIT7           = GetItemInfo(37097); --"Scroll of Spirit VII"
  --SMARTBUFF_SOSPIRIT8           = GetItemInfo(37098); --"Scroll of Spirit VIII"
  SMARTBUFF_SOSTRENGHT1         = GetItemInfo(954);   --"Scroll of Strength I"
  SMARTBUFF_SOSTRENGHT2         = GetItemInfo(2289);  --"Scroll of Strength II"
  SMARTBUFF_SOSTRENGHT3         = GetItemInfo(4426);  --"Scroll of Strength III"
  SMARTBUFF_SOSTRENGHT4         = GetItemInfo(10310); --"Scroll of Strength IV"
  --SMARTBUFF_SOSTRENGHT5         = GetItemInfo(27503); --"Scroll of Strength V"
  --SMARTBUFF_SOSTRENGHT6         = GetItemInfo(33462); --"Scroll of Strength VI"
  --SMARTBUFF_SOSTRENGHT7         = GetItemInfo(43465); --"Scroll of Strength VII"
  --SMARTBUFF_SOSTRENGHT8         = GetItemInfo(43466); --"Scroll of Strength VIII"
  SMARTBUFF_SOPROTECTION1       = GetItemInfo(3013); --"Scroll of Protection I"
  SMARTBUFF_SOPROTECTION2       = GetItemInfo(1478); --"Scroll of Protection II"
  SMARTBUFF_SOPROTECTION3       = GetItemInfo(4421); --"Scroll of Protection III"
  SMARTBUFF_SOPROTECTION4       = GetItemInfo(10305); --"Scroll of Protection IV"

  SMARTBUFF_MiscItem1           = GetItemInfo(71134);  --"Celebration Package"
  SMARTBUFF_MiscItem2           = GetItemInfo(44986);  --"Warts-B-Gone Lip Balm"
  SMARTBUFF_MiscItem3           = GetItemInfo(69775);  --"Vrykul Drinking Horn"
  SMARTBUFF_MiscItem4           = GetItemInfo(86569);  --"Crystal of Insanity"
  SMARTBUFF_MiscItem5           = GetItemInfo(85500);  --"Anglers Fishing Raft"
  SMARTBUFF_MiscItem6           = GetItemInfo(85973);  --"Ancient Pandaren Fishing Charm"
  SMARTBUFF_MiscItem7           = GetItemInfo(94604);  --"Burning Seed"
  SMARTBUFF_MiscItem8           = GetItemInfo(35275);  --"Orb of the Sin'dorei"
  SMARTBUFF_MiscItem9           = GetItemInfo(92738);  --"Safari Hat"
  SMARTBUFF_MiscItem10          = GetItemInfo(110424); --"Savage Safari Hat"
  SMARTBUFF_MiscItem11          = GetItemInfo(118922); --"Oralius' Whispering Crystal"
  SMARTBUFF_MiscItem12          = GetItemInfo(129192); --"Inquisitor's Menacing Eye"
  SMARTBUFF_MiscItem13          = GetItemInfo(129210); --"Fel Crystal Fragments"
  SMARTBUFF_MiscItem14          = GetItemInfo(128475); --"Empowered Augment Rune"
  SMARTBUFF_MiscItem15          = GetItemInfo(128482); --"Empowered Augment Rune"
  SMARTBUFF_MiscItem16          = GetItemInfo(122298); --"Bodyguard Miniaturization Device"
  SMARTBUFF_MiscItem17          = GetItemInfo(147707); --"Repurposed Fel Focuser"

  SMARTBUFF_FLASK1              = GetItemInfo(46377);  --"Flask of Endless Rage"
  SMARTBUFF_FLASK2              = GetItemInfo(46376);  --"Flask of the Frost Wyrm"
  SMARTBUFF_FLASK3              = GetItemInfo(46379);  --"Flask of Stoneblood"
  SMARTBUFF_FLASK4              = GetItemInfo(46378);  --"Flask of Pure Mojo"
  SMARTBUFF_FLASKCT1            = GetItemInfo(58087);  --"Flask of the Winds"
  SMARTBUFF_FLASKCT2            = GetItemInfo(58088);  --"Flask of Titanic Strength"
  SMARTBUFF_FLASKCT3            = GetItemInfo(58086);  --"Flask of the Draconic Mind"
  SMARTBUFF_FLASKCT4            = GetItemInfo(58085);  --"Flask of Steelskin"
  SMARTBUFF_FLASKCT5            = GetItemInfo(67438);  --"Flask of Flowing Water"
  SMARTBUFF_FLASKCT7            = GetItemInfo(65455);  --"Flask of Battle"
  SMARTBUFF_FLASKMOP1           = GetItemInfo(75525);  --"Alchemist's Flask"
  SMARTBUFF_FLASKMOP2           = GetItemInfo(76087);  --"Flask of the Earth"
  SMARTBUFF_FLASKMOP3           = GetItemInfo(76086);  --"Flask of Falling Leaves"
  SMARTBUFF_FLASKMOP4           = GetItemInfo(76084);  --"Flask of Spring Blossoms"
  SMARTBUFF_FLASKMOP5           = GetItemInfo(76085);  --"Flask of the Warm Sun"
  SMARTBUFF_FLASKMOP6           = GetItemInfo(76088);  --"Flask of Winter's Bite"
  SMARTBUFF_FLASKWOD1           = GetItemInfo(109152); --"Draenic Stamina Flask"
  SMARTBUFF_FLASKWOD2           = GetItemInfo(109148); --"Draenic Strength Flask"
  SMARTBUFF_FLASKWOD3           = GetItemInfo(109147); --"Draenic Intellect Flask"
  SMARTBUFF_FLASKWOD4           = GetItemInfo(109145); --"Draenic Agility Flask"        
  SMARTBUFF_GRFLASKWOD1         = GetItemInfo(109160); --"Greater Draenic Stamina Flask"
  SMARTBUFF_GRFLASKWOD2         = GetItemInfo(109156); --"Greater Draenic Strength Flask"
  SMARTBUFF_GRFLASKWOD3         = GetItemInfo(109155); --"Greater Draenic Intellect Flask"
  SMARTBUFF_GRFLASKWOD4         = GetItemInfo(109153); --"Greater Draenic Agility Flask"  
  SMARTBUFF_FLASKLEG1           = GetItemInfo(127850); --"Flask of Ten Thousand Scars"
  SMARTBUFF_FLASKLEG2           = GetItemInfo(127849); --"Flask of the Countless Armies"
  SMARTBUFF_FLASKLEG3           = GetItemInfo(127847); --"Flask of the Whispered Pact"
  SMARTBUFF_FLASKLEG4           = GetItemInfo(127848); --"Flask of the Seventh Demon"

  SMARTBUFF_ELIXIR1             = GetItemInfo(39666);  --"Elixir of Mighty Agility"
  SMARTBUFF_ELIXIR2             = GetItemInfo(44332);  --"Elixir of Mighty Thoughts"
  SMARTBUFF_ELIXIR3             = GetItemInfo(40078);  --"Elixir of Mighty Fortitude"
  SMARTBUFF_ELIXIR4             = GetItemInfo(40073);  --"Elixir of Mighty Strength"
  SMARTBUFF_ELIXIR5             = GetItemInfo(40072);  --"Elixir of Spirit"
  SMARTBUFF_ELIXIR6             = GetItemInfo(40097);  --"Elixir of Protection"
  SMARTBUFF_ELIXIR7             = GetItemInfo(44328);  --"Elixir of Mighty Defense"
  SMARTBUFF_ELIXIR8             = GetItemInfo(44331);  --"Elixir of Lightning Speed"
  SMARTBUFF_ELIXIR9             = GetItemInfo(44329);  --"Elixir of Expertise"
  SMARTBUFF_ELIXIR10            = GetItemInfo(44327);  --"Elixir of Deadly Strikes"
  SMARTBUFF_ELIXIR11            = GetItemInfo(44330);  --"Elixir of Armor Piercing"
  SMARTBUFF_ELIXIR12            = GetItemInfo(44325);  --"Elixir of Accuracy"
  SMARTBUFF_ELIXIR13            = GetItemInfo(40076);  --"Guru's Elixir"
  SMARTBUFF_ELIXIR14            = GetItemInfo(9187);   --"Elixir of Greater Agility"
  SMARTBUFF_ELIXIR15            = GetItemInfo(28103);  --"Adept's Elixir"
  SMARTBUFF_ELIXIR16            = GetItemInfo(40070);  --"Spellpower Elixir"  
  SMARTBUFF_ELIXIRCT1           = GetItemInfo(58148);  --"Elixir of the Master"
  SMARTBUFF_ELIXIRCT2           = GetItemInfo(58144);  --"Elixir of Mighty Speed"
  SMARTBUFF_ELIXIRCT3           = GetItemInfo(58094);  --"Elixir of Impossible Accuracy"
  SMARTBUFF_ELIXIRCT4           = GetItemInfo(58143);  --"Prismatic Elixir"
  SMARTBUFF_ELIXIRCT5           = GetItemInfo(58093);  --"Elixir of Deep Earth"
  SMARTBUFF_ELIXIRCT6           = GetItemInfo(58092);  --"Elixir of the Cobra"
  SMARTBUFF_ELIXIRCT7           = GetItemInfo(58089);  --"Elixir of the Naga"
  SMARTBUFF_ELIXIRCT8           = GetItemInfo(58084);  --"Ghost Elixir"
  SMARTBUFF_ELIXIRMOP1          = GetItemInfo(76081);  --"Elixir of Mirrors"
  SMARTBUFF_ELIXIRMOP2          = GetItemInfo(76079);  --"Elixir of Peace"
  SMARTBUFF_ELIXIRMOP3          = GetItemInfo(76080);  --"Elixir of Perfection"
  SMARTBUFF_ELIXIRMOP4          = GetItemInfo(76078);  --"Elixir of the Rapids"
  SMARTBUFF_ELIXIRMOP5          = GetItemInfo(76077);  --"Elixir of Weaponry"
  SMARTBUFF_ELIXIRMOP6          = GetItemInfo(76076);  --"Mad Hozen Elixir"
  SMARTBUFF_ELIXIRMOP7          = GetItemInfo(76075);  --"Mantid Elixir"
  SMARTBUFF_ELIXIRMOP8          = GetItemInfo(76083);  --"Monk's Elixir"
  
  _, _, _, _, _, _, S.FishingPole = GetItemInfo(6256);  --"Fishing Pole"
    
  SMARTBUFF_AddMsgD("Item list initialized");
  
end


function SMARTBUFF_InitSpellIDs()
  SMARTBUFF_TESTSPELL       = GetSpellInfo(774);
  
  -- Druid  
  SMARTBUFF_DRUID_CAT       = GetSpellInfo(768);   --"Cat Form"
  SMARTBUFF_DRUID_TREE      = GetSpellInfo(33891); --"Tree of Life"
  SMARTBUFF_DRUID_MOONKIN   = GetSpellInfo(24858); --"Moonkin Form"
  SMARTBUFF_DRUID_TRACK     = GetSpellInfo(5225);  --"Track Humanoids"
  SMARTBUFF_MOTW            = GetSpellInfo(1126);  --"Mark of the Wild"
  SMARTBUFF_GOTW            = GetSpellInfo(21849); --"Gift of the Wild"
  SMARTBUFF_THORNS          = GetSpellInfo(467);   --"Thorns"
  SMARTBUFF_IMPTHORNS       = GetSpellInfo(16836); --"Improved Thorns"
  SMARTBUFF_BARKSKIN        = GetSpellInfo(22812); --"Barkskin"
  SMARTBUFF_NATURESGRASP    = GetSpellInfo(16689); --"Nature's Grasp"
  SMARTBUFF_TIGERSFURY      = GetSpellInfo(5217);  --"Tiger's Fury"
  SMARTBUFF_SAVAGEROAR      = GetSpellInfo(52610); --"Savage Roar"  
  SMARTBUFF_OMENOFCLARITY   = GetSpellInfo(16864); --"Omen of Clarity"  

  -- Druid linked
  S.LinkDruidThorns = { SMARTBUFF_THORNS, SMARTBUFF_IMPTHORNS };

  
  -- Priest
  SMARTBUFF_PWF             = GetSpellInfo(1243);  --"Power Word: Fortitude"
  SMARTBUFF_POF             = GetSpellInfo(21562); --"Prayer of Fortitude"
  SMARTBUFF_SP              = GetSpellInfo(976);   --"Shadow Protection"
  SMARTBUFF_POSP            = GetSpellInfo(27683); --"Prayer of Shadow Protection"
  SMARTBUFF_INNERFIRE       = GetSpellInfo(588);   --"Inner Fire"
  SMARTBUFF_DS              = GetSpellInfo(14752); --"Divine Spirit"
  SMARTBUFF_POS             = GetSpellInfo(27681); --"Prayer of Spirit"
  SMARTBUFF_PWS             = GetSpellInfo(17);    --"Power Word: Shield"
  SMARTBUFF_SHADOWFORM      = GetSpellInfo(15473); --"Shadowform"
  SMARTBUFF_FEARWARD        = GetSpellInfo(6346);  --"Fear Ward"
  SMARTBUFF_ELUNESGRACE     = GetSpellInfo(2651);  --"Elune's Grace"
  SMARTBUFF_FEEDBACK        = GetSpellInfo(13896); --"Feedback"
  SMARTBUFF_SHADOWGUARD     = GetSpellInfo(18137); --"Shadowguard"
  SMARTBUFF_TOUCHOFWEAKNESS = GetSpellInfo(2652);  --"Touch of Weakness"
  SMARTBUFF_INNERFOCUS      = GetSpellInfo(14751); --"Inner Focus"
  SMARTBUFF_RENEW           = GetSpellInfo(139);   --"Renew"

  
  -- Mage
  SMARTBUFF_AI              = GetSpellInfo(1459);  --"Arcane Intellect"
  SMARTBUFF_AB              = GetSpellInfo(23028); --"Arcane Brilliance"
  SMARTBUFF_ICEARMOR        = GetSpellInfo(7302);  --"Ice Armor"
  SMARTBUFF_FROSTARMOR      = GetSpellInfo(168);   --"Frost Armor"
  SMARTBUFF_MAGEARMOR       = GetSpellInfo(6117);  --"Mage Armor"
  SMARTBUFF_MOLTENARMOR     = GetSpellInfo(30482); --"Molten Armor"
  SMARTBUFF_DAMPENMAGIC     = GetSpellInfo(604);   --"Dampen Magic"
  SMARTBUFF_AMPLIFYMAGIC    = GetSpellInfo(1008);  --"Amplify Magic"
  SMARTBUFF_MANASHIELD      = GetSpellInfo(1463);  --"Mana Shield"
  SMARTBUFF_FIREWARD        = GetSpellInfo(543);   --"Fire Ward"
  SMARTBUFF_FROSTWARD       = GetSpellInfo(6143);  --"Frost Ward"
  SMARTBUFF_ICEBARRIER      = GetSpellInfo(11426); --"Ice Barrier"
  SMARTBUFF_COMBUSTION      = GetSpellInfo(11129); --"Combustion"
  SMARTBUFF_ARCANEPOWER     = GetSpellInfo(12042); --"Arcane Power"
  SMARTBUFF_PRESENCEOFMIND  = GetSpellInfo(12043); --"Presence of Mind"
  SMARTBUFF_ICYVEINS        = GetSpellInfo(12472); --"Icy Veins"
  SMARTBUFF_SUMMONWATERELE  = GetSpellInfo(31687); --"Summon Water Elemental"
  SMARTBUFF_FOCUSMAGIC      = GetSpellInfo(54646); --"Focus Magic"
  
  -- Mage chained
  S.ChainMageArmor = { SMARTBUFF_ICEARMOR, SMARTBUFF_FROSTARMOR, SMARTBUFF_MAGEARMOR, SMARTBUFF_MOLTENARMOR };
  
  
  -- Warlock
  SMARTBUFF_FELARMOR        = GetSpellInfo(28176); --"Fel Armor"
  SMARTBUFF_DEMONARMOR      = GetSpellInfo(706);   --"Demon Armor"
  SMARTBUFF_DEMONSKIN       = GetSpellInfo(687);   --"Demon Skin"
  SMARTBUFF_UNENDINGBREATH  = GetSpellInfo(5697);  --"Unending Breath"
  SMARTBUFF_DINVISIBILITY   = GetSpellInfo(132);   --"Detect Invisibility"
  SMARTBUFF_SOULLINK        = GetSpellInfo(19028); --"Soul Link"
  SMARTBUFF_SHADOWWARD      = GetSpellInfo(6229);  --"Shadow Ward"
  SMARTBUFF_DARKPACT        = GetSpellInfo(18220); --"Dark Pact"
  SMARTBUFF_LIFETAP         = GetSpellInfo(1454);  --"Life Tap"
  SMARTBUFF_CREATEHSMIN     = GetSpellInfo(6201);  --"Create Healthstone (Minor)"
  SMARTBUFF_CREATEHSLES     = GetSpellInfo(6202);  --"Create Healthstone (Lesser)"
  SMARTBUFF_CREATEHS        = GetSpellInfo(5699);  --"Create Healthstone"
  SMARTBUFF_CREATEHSGRE     = GetSpellInfo(11729); --"Create Healthstone (Greater)"
  SMARTBUFF_CREATEHSMAJ     = GetSpellInfo(11730); --"Create Healthstone (Major)"
  SMARTBUFF_SOULSTONE       = GetSpellInfo(20707); --"Soulstone"
  SMARTBUFF_CREATESSMIN     = GetSpellInfo(693);   --"Create Soulstone (Minor)"
  SMARTBUFF_CREATESSLES     = GetSpellInfo(20752); --"Create Soulstone (Lesser)"
  SMARTBUFF_CREATESS        = GetSpellInfo(20755); --"Create Soulstone"
  SMARTBUFF_CREATESSGRE     = GetSpellInfo(20756); --"Create Soulstone (Greater)"
  SMARTBUFF_CREATESSMAJ     = GetSpellInfo(20757); --"Create Soulstone (Major)"
  
  -- Warlock chained
  S.ChainWarlockArmor = { SMARTBUFF_DEMONSKIN, SMARTBUFF_DEMONARMOR, SMARTBUFF_FELARMOR };

  
  -- Hunter
    -- Hunter
  SMARTBUFF_TRUESHOTAURA    = GetSpellInfo(19506); --"Trueshot Aura"
  SMARTBUFF_RAPIDFIRE       = GetSpellInfo(3045);  --"Rapid Fire"
  SMARTBUFF_AOTH            = GetSpellInfo(13165); --"Aspect of the Hawk"
  SMARTBUFF_AOTM            = GetSpellInfo(13163); --"Aspect of the Monkey"
  SMARTBUFF_AOTW            = GetSpellInfo(20043); --"Aspect of the Wild"
  SMARTBUFF_AOTB            = GetSpellInfo(13161); --"Aspect of the Beast"
  SMARTBUFF_AOTC            = GetSpellInfo(5118);  --"Aspect of the Cheetah"
  SMARTBUFF_AOTP            = GetSpellInfo(13159); --"Aspect of the Pack"
  SMARTBUFF_AOTV            = GetSpellInfo(34074); --"Aspect of the Viper"
  SMARTBUFF_AOTDH           = GetSpellInfo(61846); --"Aspect of the Dragonhawk"
  
  -- Hunter chained
  S.ChainAspects  = { SMARTBUFF_AOTH,SMARTBUFF_AOTM,SMARTBUFF_AOTW,SMARTBUFF_AOTB,SMARTBUFF_AOTC,SMARTBUFF_AOTP,SMARTBUFF_AOTV,SMARTBUFF_AOTDH };

  
  -- Shaman
  SMARTBUFF_LIGHTNINGSHIELD = GetSpellInfo(324);   --"Lightning Shield"
  SMARTBUFF_WATERSHIELD     = GetSpellInfo(24398); --"Water Shield"
  SMARTBUFF_EARTHSHIELD     = GetSpellInfo(974);   --"Earth Shield"
  SMARTBUFF_ROCKBITERW      = GetSpellInfo(8017);  --"Rockbiter Weapon"
  SMARTBUFF_FROSTBRANDW     = GetSpellInfo(8033);  --"Frostbrand Weapon"
  SMARTBUFF_FLAMETONGUEW    = GetSpellInfo(8024);  --"Flametongue Weapon"
  SMARTBUFF_WINDFURYW       = GetSpellInfo(8232);  --"Windfury Weapon"
  SMARTBUFF_EARTHLIVINGW    = GetSpellInfo(51730); --"Earthliving Weapon"
  SMARTBUFF_WATERBREATHING  = GetSpellInfo(131);   --"Water Breathing"
  SMARTBUFF_WATERWALKING    = GetSpellInfo(546);   --"Water Walking"
  
  -- Shaman chained
  S.ChainShamanShield = { SMARTBUFF_LIGHTNINGSHIELD, SMARTBUFF_WATERSHIELD, SMARTBUFF_EARTHSHIELD };
  

  -- Warrior
  SMARTBUFF_BATTLESHOUT     = GetSpellInfo(6673);  --"Battle Shout"
  SMARTBUFF_COMMANDINGSHOUT = GetSpellInfo(469);   --"Commanding Shout"
  SMARTBUFF_BERSERKERRAGE   = GetSpellInfo(18499); --"Berserker Rage"
  SMARTBUFF_BLOODRAGE       = GetSpellInfo(2687);  --"Bloodrage"
  SMARTBUFF_RAMPAGE         = GetSpellInfo(29801); --"Rampage"
  SMARTBUFF_VIGILANCE       = GetSpellInfo(50720); --"Vigilance"
  SMARTBUFF_SHIELDBLOCK     = GetSpellInfo(2565);  --"Shield Block"
  
  -- Warrior chained
  S.ChainWarriorShout  = { SMARTBUFF_BATTLESHOUT, SMARTBUFF_COMMANDINGSHOUT };

  
  -- Rogue
  SMARTBUFF_BLADEFLURRY     = GetSpellInfo(13877); --"Blade Flurry"
  SMARTBUFF_SAD             = GetSpellInfo(5171);  --"Slice and Dice"
  SMARTBUFF_EVASION         = GetSpellInfo(5277);  --"Evasion"
  SMARTBUFF_HUNGERFORBLOOD  = GetSpellInfo(51662); --"Hunger For Blood"
  SMARTBUFF_STEALTH         = GetSpellInfo(1784);  --"Stealth"

  
  -- Paladin
  SMARTBUFF_RIGHTEOUSFURY         = GetSpellInfo(25780); --"Righteous Fury"
  SMARTBUFF_HOLYSHIELD            = GetSpellInfo(20925); --"Holy Shield"
  SMARTBUFF_BOM                   = GetSpellInfo(19740); --"Blessing of Might"
  SMARTBUFF_GBOM                  = GetSpellInfo(25782); --"Greater Blessing of Might"
  SMARTBUFF_BOW                   = GetSpellInfo(19742); --"Blessing of Wisdom"
  SMARTBUFF_GBOW                  = GetSpellInfo(25894); --"Greater Blessing of Wisdom"
  SMARTBUFF_BOSAL                 = GetSpellInfo(1038);  --"Blessing of Salvation"
  SMARTBUFF_BOK                   = GetSpellInfo(20217); --"Blessing of Kings"
  SMARTBUFF_GBOK                  = GetSpellInfo(25898); --"Greater Blessing of Kings"
  SMARTBUFF_BOSAN                 = GetSpellInfo(20911); --"Blessing of Sanctuary"
  SMARTBUFF_GBOSAN                = GetSpellInfo(25899); --"Greater Blessing of Sanctuary"
  SMARTBUFF_BOL                   = GetSpellInfo(19977); --"Blessing of Light"
  SMARTBUFF_GBOL                  = GetSpellInfo(25890); --"Greater Blessing of Light"  
  SMARTBUFF_BOF                   = GetSpellInfo(1044);  --"Blessing of Freedom"
  SMARTBUFF_BOP                   = GetSpellInfo(1022);  --"Blessing of Protection"
  SMARTBUFF_SOCOMMAND             = GetSpellInfo(20375); --"Seal of Command"
  SMARTBUFF_SOJUSTICE             = GetSpellInfo(20164); --"Seal of Justice"
  SMARTBUFF_SOLIGHT               = GetSpellInfo(20165); --"Seal of Light"
  SMARTBUFF_SORIGHTEOUSNESS       = GetSpellInfo(21084); --"Seal of Righteousness"
  SMARTBUFF_SOWISDOM              = GetSpellInfo(20166); --"Seal of Wisdom"
  SMARTBUFF_SOTCRUSADER           = GetSpellInfo(21082); --"Seal of the Crusader"
  SMARTBUFF_SOVENGEANCE           = GetSpellInfo(31801); --"Seal of Vengeance"
  SMARTBUFF_SOBLOOD               = GetSpellInfo(31892); --"Seal of Blood"
  SMARTBUFF_SOCORRUPTION          = GetSpellInfo(53736); --"Seal of Corruption"
  SMARTBUFF_SOMARTYR              = GetSpellInfo(53720); --"Seal of the Martyr"
  SMARTBUFF_DEVOTIONAURA          = GetSpellInfo(465);   --"Devotion Aura"
  SMARTBUFF_RETRIBUTIONAURA       = GetSpellInfo(7294);  --"Retribution Aura"
  SMARTBUFF_CONCENTRATIONAURA     = GetSpellInfo(19746); --"Concentration Aura"
  SMARTBUFF_SHADOWRESISTANCEAURA  = GetSpellInfo(19876); --"Shadow Resistance Aura"
  SMARTBUFF_FROSTRESISTANCEAURA   = GetSpellInfo(19888); --"Frost Resistance Aura"
  SMARTBUFF_FIRERESISTANCEAURA    = GetSpellInfo(19891); --"Fire Resistance Aura"
  SMARTBUFF_SANCTITYAURA          = GetSpellInfo(20218); --"Sanctity Aura"
  SMARTBUFF_CRUSADERAURA          = GetSpellInfo(32223); --"Crusader Aura"  

  -- Paladin chained
  S.ChainPaladinBlessing = { SMARTBUFF_BOK, SMARTBUFF_GBOK, SMARTBUFF_BOM, SMARTBUFF_GBOM, SMARTBUFF_BOW, SMARTBUFF_GBOW, SMARTBUFF_BOL, SMARTBUFF_GBOL, SMARTBUFF_BOSAL, SMARTBUFF_BOSAN, SMARTBUFF_GBOSAN, SMARTBUFF_BOF, SMARTBUFF_BOP };
  S.ChainPaladinSeal     = { SMARTBUFF_SOCOMMAND, SMARTBUFF_SOJUSTICE, SMARTBUFF_SOLIGHT, SMARTBUFF_SORIGHTEOUSNESS, SMARTBUFF_SOWISDOM, SMARTBUFF_SOTCRUSADER, SMARTBUFF_SOVENGEANCE, SMARTBUFF_SOBLOOD, SMARTBUFF_SOCORRUPTION, SMARTBUFF_SOMARTYR };
  S.ChainPaladinAura     = { SMARTBUFF_DEVOTIONAURA, SMARTBUFF_RETRIBUTIONAURA, SMARTBUFF_CONCENTRATIONAURA, SMARTBUFF_SHADOWRESISTANCEAURA, SMARTBUFF_FROSTRESISTANCEAURA, SMARTBUFF_FIRERESISTANCEAURA, SMARTBUFF_SANCTITYAURA, SMARTBUFF_CRUSADERAURA };
  
  
  -- Tracking
  SMARTBUFF_FINDMINERALS    = GetSpellInfo(2580);  --"Find Minerals"
  SMARTBUFF_FINDHERBS       = GetSpellInfo(2383);  --"Find Herbs"
  SMARTBUFF_FINDTREASURE    = GetSpellInfo(2481);  --"Find Treasure"
  SMARTBUFF_TRACKHUMANOIDS  = GetSpellInfo(19883); --"Track Humanoids"
  SMARTBUFF_TRACKBEASTS     = GetSpellInfo(1494);  --"Track Beasts"
  SMARTBUFF_TRACKUNDEAD     = GetSpellInfo(19884); --"Track Undead"
  SMARTBUFF_TRACKHIDDEN     = GetSpellInfo(19885); --"Track Hidden"
  SMARTBUFF_TRACKELEMENTALS = GetSpellInfo(19880); --"Track Elementals"
  SMARTBUFF_TRACKDEMONS     = GetSpellInfo(19878); --"Track Demons"
  SMARTBUFF_TRACKGIANTS     = GetSpellInfo(19882); --"Track Giants"
  SMARTBUFF_TRACKDRAGONKIN  = GetSpellInfo(19879); --"Track Dragonkin"
  SMARTBUFF_SENSEDEMONS     = GetSpellInfo(5500);  --"Sense Demons"
  SMARTBUFF_SENSEUNDEAD     = GetSpellInfo(5502);  --"Sense Undead"

  -- Racial
  SMARTBUFF_STONEFORM       = GetSpellInfo(20594); --"Stoneform"
  SMARTBUFF_BLOODFURY       = GetSpellInfo(20572); --"Blood Fury" 33697, 33702
  SMARTBUFF_BERSERKING      = GetSpellInfo(26297); --"Berserking"
  SMARTBUFF_WOTFORSAKEN     = GetSpellInfo(7744);  --"Will of the Forsaken"
  SMARTBUFF_WarStomp        = GetSpellInfo(20549); --"War Stomp"
  
  -- Food
  SMARTBUFF_FOOD_AURA       = GetSpellInfo(19705); --"Well Fed"
  SMARTBUFF_FOOD_SPELL      = GetSpellInfo(433);   --"Food"
  SMARTBUFF_DRINK_SPELL     = GetSpellInfo(430);   --"Drink"
  
  -- Misc
  SMARTBUFF_KIRUSSOV        = GetSpellInfo(46302); --"K'iru's Song of Victory"
  SMARTBUFF_FISHING         = GetSpellInfo(7620) or GetSpellInfo(111541); --"Fishing"
  
  -- Scroll
  SMARTBUFF_SBAGILITY       = GetSpellInfo(8115);   --"Scroll buff: Agility"
  SMARTBUFF_SBINTELLECT     = GetSpellInfo(8096);   --"Scroll buff: Intellect"
  SMARTBUFF_SBSTAMINA       = GetSpellInfo(8099);   --"Scroll buff: Stamina"
  SMARTBUFF_SBSPIRIT        = GetSpellInfo(8112);   --"Scroll buff: Spirit"
  SMARTBUFF_SBSTRENGHT      = GetSpellInfo(8118);   --"Scroll buff: Strength"
  SMARTBUFF_SBPROTECTION    = GetSpellInfo(89344);  --"Scroll buff: Armor"
  SMARTBUFF_BMiscItem1      = GetSpellInfo(150986); --"WoW's 10th Anniversary"
  SMARTBUFF_BMiscItem2      = GetSpellInfo(62574);  --"Warts-B-Gone Lip Balm"
  SMARTBUFF_BMiscItem3      = GetSpellInfo(98444);  --"Vrykul Drinking Horn"
  SMARTBUFF_BMiscItem4      = GetSpellInfo(127230); --"Visions of Insanity"
  SMARTBUFF_BMiscItem5      = GetSpellInfo(124036); --"Anglers Fishing Raft"
  SMARTBUFF_BMiscItem6      = GetSpellInfo(125167); --"Ancient Pandaren Fishing Charm"
  SMARTBUFF_BMiscItem7      = GetSpellInfo(138927); --"Burning Essence"
  SMARTBUFF_BMiscItem8      = GetSpellInfo(160331); --"Blood Elf Illusion"
  SMARTBUFF_BMiscItem9      = GetSpellInfo(158486); --"Safari Hat"
  SMARTBUFF_BMiscItem10     = GetSpellInfo(158474); --"Savage Safari Hat"
  SMARTBUFF_BMiscItem11     = GetSpellInfo(176151); --"Whispers of Insanity"
  SMARTBUFF_BMiscItem12     = GetSpellInfo(193456); --"Gaze of the Legion"
  SMARTBUFF_BMiscItem13     = GetSpellInfo(193547); --"Fel Crystal Infusion"
  SMARTBUFF_BMiscItem14     = GetSpellInfo(190668); --"Empower"
  SMARTBUFF_BMiscItem14_1   = GetSpellInfo(175457); --"Focus Augmentation"
  SMARTBUFF_BMiscItem14_2   = GetSpellInfo(175456); --"Hyper Augmentation"
  SMARTBUFF_BMiscItem14_3   = GetSpellInfo(175439); --"Stout Augmentation
  SMARTBUFF_BMiscItem16     = GetSpellInfo(181642); --"Bodyguard Miniaturization Device"
  SMARTBUFF_BMiscItem17     = GetSpellInfo(242551); --"Fel Focus"
  
  S.LinkSafariHat           = { SMARTBUFF_BMiscItem9, SMARTBUFF_BMiscItem10 };
  S.LinkAugment             = { SMARTBUFF_BMiscItem14, SMARTBUFF_BMiscItem14_1, SMARTBUFF_BMiscItem14_2, SMARTBUFF_BMiscItem14_3 };
  
  -- Flasks & Elixirs
  SMARTBUFF_BFLASK1         = GetSpellInfo(53760);  --"Flask of Endless Rage"
  SMARTBUFF_BFLASK2         = GetSpellInfo(53755);  --"Flask of the Frost Wyrm"
  SMARTBUFF_BFLASK3         = GetSpellInfo(53758);  --"Flask of Stoneblood"
  SMARTBUFF_BFLASK4         = GetSpellInfo(54212);  --"Flask of Pure Mojo"
  SMARTBUFF_BFLASKCT1       = GetSpellInfo(79471);  --"Flask of the Winds"
  SMARTBUFF_BFLASKCT2       = GetSpellInfo(79472);  --"Flask of Titanic Strength"
  SMARTBUFF_BFLASKCT3       = GetSpellInfo(79470);  --"Flask of the Draconic Mind"
  SMARTBUFF_BFLASKCT4       = GetSpellInfo(79469);  --"Flask of Steelskin"
  SMARTBUFF_BFLASKCT5       = GetSpellInfo(94160);  --"Flask of Flowing Water"
  SMARTBUFF_BFLASKCT7       = GetSpellInfo(92679);  --"Flask of Battle"
  SMARTBUFF_BFLASKMOP1      = GetSpellInfo(105617); --"Alchemist's Flask"
  SMARTBUFF_BFLASKMOP2      = GetSpellInfo(105694); --"Flask of the Earth"
  SMARTBUFF_BFLASKMOP3      = GetSpellInfo(105693); --"Flask of Falling Leaves"
  SMARTBUFF_BFLASKMOP4      = GetSpellInfo(105689); --"Flask of Spring Blossoms"
  SMARTBUFF_BFLASKMOP5      = GetSpellInfo(105691); --"Flask of the Warm Sun"
  SMARTBUFF_BFLASKMOP6      = GetSpellInfo(105696); --"Flask of Winter's Bite"
  SMARTBUFF_BFLASKCT61      = GetSpellInfo(79640);  --"Enhanced Intellect"
  SMARTBUFF_BFLASKCT62      = GetSpellInfo(79639);  --"Enhanced Agility"
  SMARTBUFF_BFLASKCT63      = GetSpellInfo(79638);  --"Enhanced Strength"
  SMARTBUFF_BFLASKWOD1      = GetSpellInfo(156077); --"Draenic Stamina Flask"
  SMARTBUFF_BFLASKWOD2      = GetSpellInfo(156071); --"Draenic Strength Flask"
  SMARTBUFF_BFLASKWOD3      = GetSpellInfo(156070); --"Draenic Intellect Flask"
  SMARTBUFF_BFLASKWOD4      = GetSpellInfo(156073); --"Draenic Agility Flask"
  SMARTBUFF_BGRFLASKWOD1    = GetSpellInfo(156084); --"Greater Draenic Stamina Flask"
  SMARTBUFF_BGRFLASKWOD2    = GetSpellInfo(156080); --"Greater Draenic Strength Flask"
  SMARTBUFF_BGRFLASKWOD3    = GetSpellInfo(156079); --"Greater Draenic Intellect Flask"
  SMARTBUFF_BGRFLASKWOD4    = GetSpellInfo(156064); --"Greater Draenic Agility Flask"  
  SMARTBUFF_BFLASKLEG1      = GetSpellInfo(188035); --"Flask of Ten Thousand Scars"
  SMARTBUFF_BFLASKLEG2      = GetSpellInfo(188034); --"Flask of the Countless Armies"
  SMARTBUFF_BFLASKLEG3      = GetSpellInfo(188031); --"Flask of the Whispered Pact"
  SMARTBUFF_BFLASKLEG4      = GetSpellInfo(188033); --"Flask of the Seventh Demon"
  
  S.LinkFlaskCT7            = { SMARTBUFF_BFLASKCT1, SMARTBUFF_BFLASKCT2, SMARTBUFF_BFLASKCT3, SMARTBUFF_BFLASKCT4, SMARTBUFF_BFLASKCT5 };
  S.LinkFlaskMoP            = { SMARTBUFF_BFLASKCT61, SMARTBUFF_BFLASKCT62, SMARTBUFF_BFLASKCT63, SMARTBUFF_BFLASKMOP2, SMARTBUFF_BFLASKMOP3, SMARTBUFF_BFLASKMOP4, SMARTBUFF_BFLASKMOP5, SMARTBUFF_BFLASKMOP6 };
  S.LinkFlaskWoD            = { SMARTBUFF_BFLASKWOD1, SMARTBUFF_BFLASKWOD2, SMARTBUFF_BFLASKWOD3, SMARTBUFF_BFLASKWOD4, SMARTBUFF_BGRFLASKWOD1, SMARTBUFF_BGRFLASKWOD2, SMARTBUFF_BGRFLASKWOD3, SMARTBUFF_BGRFLASKWOD4 };
  S.LinkFlaskLeg            = { SMARTBUFF_BFLASKLEG1, SMARTBUFF_BFLASKLEG2, SMARTBUFF_BFLASKLEG3, SMARTBUFF_BFLASKLEG4 };
  
  SMARTBUFF_BELIXIR1        = GetSpellInfo(28497);  --"Mighty Agility" B
  SMARTBUFF_BELIXIR2        = GetSpellInfo(60347);  --"Mighty Thoughts" G
  SMARTBUFF_BELIXIR3        = GetSpellInfo(53751);  --"Elixir of Mighty Fortitude" G
  SMARTBUFF_BELIXIR4        = GetSpellInfo(53748);  --"Mighty Strength" B
  SMARTBUFF_BELIXIR5        = GetSpellInfo(53747);  --"Elixir of Spirit" B
  SMARTBUFF_BELIXIR6        = GetSpellInfo(53763);  --"Protection" G
  SMARTBUFF_BELIXIR7        = GetSpellInfo(60343);  --"Mighty Defense" G
  SMARTBUFF_BELIXIR8        = GetSpellInfo(60346);  --"Lightning Speed" B
  SMARTBUFF_BELIXIR9        = GetSpellInfo(60344);  --"Expertise" B
  SMARTBUFF_BELIXIR10       = GetSpellInfo(60341);  --"Deadly Strikes" B
  SMARTBUFF_BELIXIR11       = GetSpellInfo(80532);  --"Armor Piercing"
  SMARTBUFF_BELIXIR12       = GetSpellInfo(60340);  --"Accuracy" B
  SMARTBUFF_BELIXIR13       = GetSpellInfo(53749);  --"Guru's Elixir" B
  SMARTBUFF_BELIXIR14       = GetSpellInfo(11334);  --"Elixir of Greater Agility" B
  SMARTBUFF_BELIXIR15       = GetSpellInfo(54452);  --"Adept's Elixir" B
  SMARTBUFF_BELIXIR16       = GetSpellInfo(33721);  --"Spellpower Elixir" B
  SMARTBUFF_BELIXIRCT1      = GetSpellInfo(79635);  --"Elixir of the Master" B
  SMARTBUFF_BELIXIRCT2      = GetSpellInfo(79632);  --"Elixir of Mighty Speed" B
  SMARTBUFF_BELIXIRCT3      = GetSpellInfo(79481);  --"Elixir of Impossible Accuracy" B
  SMARTBUFF_BELIXIRCT4      = GetSpellInfo(79631);  --"Prismatic Elixir" G
  SMARTBUFF_BELIXIRCT5      = GetSpellInfo(79480);  --"Elixir of Deep Earth" G
  SMARTBUFF_BELIXIRCT6      = GetSpellInfo(79477);  --"Elixir of the Cobra" B
  SMARTBUFF_BELIXIRCT7      = GetSpellInfo(79474);  --"Elixir of the Naga" B
  SMARTBUFF_BELIXIRCT8      = GetSpellInfo(79468);  --"Ghost Elixir" B
  SMARTBUFF_BELIXIRMOP1     = GetSpellInfo(105687); --"Elixir of Mirrors" G
  SMARTBUFF_BELIXIRMOP2     = GetSpellInfo(105685); --"Elixir of Peace" B
  SMARTBUFF_BELIXIRMOP3     = GetSpellInfo(105686); --"Elixir of Perfection" B
  SMARTBUFF_BELIXIRMOP4     = GetSpellInfo(105684); --"Elixir of the Rapids" B
  SMARTBUFF_BELIXIRMOP5     = GetSpellInfo(105683); --"Elixir of Weaponry" B
  SMARTBUFF_BELIXIRMOP6     = GetSpellInfo(105682); --"Mad Hozen Elixir" B
  SMARTBUFF_BELIXIRMOP7     = GetSpellInfo(105681); --"Mantid Elixir" G
  SMARTBUFF_BELIXIRMOP8     = GetSpellInfo(105688); --"Monk's Elixir" B
  
  --if (SMARTBUFF_GOTW) then
  --  SMARTBUFF_AddMsgD(SMARTBUFF_GOTW.." found");
  --end
  
  -- Buff map
  S.LinkStats = { SMARTBUFF_BOK, SMARTBUFF_MOTW, SMARTBUFF_LOTE, SMARTBUFF_LOTWT, SMARTBUFF_MOTWR1, SMARTBUFF_MOTWR2, SMARTBUFF_MOTWR3,
                  SMARTBUFF_MOTWR4, SMARTBUFF_MOTWR5, SMARTBUFF_MOTWR6, SMARTBUFF_MOTWR7, SMARTBUFF_GOTWR1, SMARTBUFF_GOTWR2,
                  GetSpellInfo(159988), -- Bark of the Wild
                  GetSpellInfo(203538), -- Greater Blessing of Kings
                  GetSpellInfo(90363),  -- Embrace of the Shale Spider
                  GetSpellInfo(160077),  -- Strength of the Earth
                  SMARTBUFF_DSR1, SMARTBUFF_DSR2, SMARTBUFF_DSR3, SMARTBUFF_DSR4, SMARTBUFF_SWPR1, SMARTBUFF_SWPR2, SMARTBUFF_SWPR3,
                  SMARTBUFF_PSWPR1, SMARTBUFF_POSR1,
                };
  
  S.LinkSta   = { SMARTBUFF_PWF, SMARTBUFF_COMMANDINGSHOUT, SMARTBUFF_BLOODPACT,
                  GetSpellInfo(50256),  -- Invigorating Roar
                  GetSpellInfo(90364),  -- Qiraji Fortitude
                  GetSpellInfo(160014), -- Sturdiness
                  GetSpellInfo(160003),  -- Savage Vigor
                  SMARTBUFF_PWFR1, SMARTBUFF_PWFR2, SMARTBUFF_PWFR3,SMARTBUFF_PWFR4, SMARTBUFF_PWFR5, SMARTBUFF_PWFR6,
                  SMARTBUFF_IPWFR1, SMARTBUFF_IPWFR2, SMARTBUFF_POFR1, SMARTBUFF_POFR2,
                };
  
  S.LinkAp    = { SMARTBUFF_HORNOFWINTER, SMARTBUFF_BATTLESHOUT, SMARTBUFF_TRUESHOTAURA };
  
  S.LinkMa    = { SMARTBUFF_BOM, SMARTBUFF_DRUID_MKAURA, SMARTBUFF_GRACEOFAIR, SMARTBUFF_POTGRAVE,
                  GetSpellInfo(93435),  -- Roar of Courage
                  GetSpellInfo(160039), -- Keen Senses
                  GetSpellInfo(128997), -- Spirit Beast Blessing
                  GetSpellInfo(160073)  -- Plainswalking
                };
  
  S.LinkInt   = { SMARTBUFF_BOW, SMARTBUFF_AB, SMARTBUFF_ABR1, SMARTBUFF_AIR1, SMARTBUFF_AIR2, SMARTBUFF_AIR3, SMARTBUFF_AIR4, SMARTBUFF_AIR5, SMARTBUFF_DALARANB };
  
  --S.LinkSp    = { SMARTBUFF_DARKINTENT, SMARTBUFF_AB, SMARTBUFF_DALARANB, SMARTBUFF_STILLWATER };
  
  --SMARTBUFF_AddMsgD("Spell IDs initialized");
end


function SMARTBUFF_InitSpellList()
  if (SMARTBUFF_PLAYERCLASS == nil) then return; end
  
  --if (SMARTBUFF_GOTW) then
  --  SMARTBUFF_AddMsgD(SMARTBUFF_GOTW.." found");
  --end
  
  -- Druid
  if (SMARTBUFF_PLAYERCLASS == "DRUID") then
    SMARTBUFF_BUFFLIST = {
      {SMARTBUFF_MOTW, 30, SMARTBUFF_CONST_GROUP, {1,10,20,30,40,50,60}, "WPET;DKPET", nil, nil, SMARTBUFF_GOTW, 60, {50,60}, {SMARTBUFF_WILDBERRIES,SMARTBUFF_WILDTHORNROOT}},
      {SMARTBUFF_IMPTHORNS, 10, SMARTBUFF_CONST_GROUP, {6,14}, "HUNTER;ROGUE;MAGE;PRIEST;PALADIN;WARLOCK;WPET;DKPET", S.LinkDruidThorns},
      {SMARTBUFF_THORNS, 10, SMARTBUFF_CONST_GROUP, {6,14,24,34,44,54}, "HUNTER;ROGUE;MAGE;PRIEST;PALADIN;WARLOCK;WPET;DKPET", S.LinkDruidThorns},
      {SMARTBUFF_OMENOFCLARITY, 10, SMARTBUFF_CONST_SELF},
      {SMARTBUFF_BARKSKIN, 0.25, SMARTBUFF_CONST_SELF},
      {SMARTBUFF_NATURESGRASP, 0.75, SMARTBUFF_CONST_FORCESELF},
      {SMARTBUFF_TIGERSFURY, 0.1, SMARTBUFF_CONST_SELF, nil, SMARTBUFF_DRUID_CAT},
      {SMARTBUFF_SAVAGEROAR, 0.15, SMARTBUFF_CONST_SELF, nil, SMARTBUFF_DRUID_CAT},
      {SMARTBUFF_DRUID_MOONKIN, -1, SMARTBUFF_CONST_SELF},
      {SMARTBUFF_DRUID_TREE, -1, SMARTBUFF_CONST_SELF}, 
      {SMARTBUFF_CENARIONWARD, 0.5, SMARTBUFF_CONST_GROUP, {1}, "WARRIOR;DRUID;SHAMAN;HUNTER;ROGUE;MAGE;PRIEST;PALADIN;WARLOCK;DEATHKNIGHT;MONK;DEMONHUNTER"},
    };
  end
  
  -- Priest
  if (SMARTBUFF_PLAYERCLASS == "PRIEST") then
    SMARTBUFF_BUFFLIST = {
      {SMARTBUFF_PWF, 30, SMARTBUFF_CONST_GROUP, {1,12,24,36,48,60}, "WPET", nil, nil, SMARTBUFF_POF, 60, {48,60}, {SMARTBUFF_HOLYCANDLE,SMARTBUFF_SACREDCANDLE}},
      {SMARTBUFF_SP, 10, SMARTBUFF_CONST_GROUP, {30,42,56}, "WPET", nil, nil, SMARTBUFF_POSP, 20, {56}, {SMARTBUFF_SACREDCANDLE}},
      {SMARTBUFF_INNERFIRE, 10, SMARTBUFF_CONST_SELF},
      {SMARTBUFF_DS, 30, SMARTBUFF_CONST_GROUP, {40,42,54,60}, "ROGUE;WARRIOR;HPET;WPET", nil, nil, SMARTBUFF_POS, 60, {60}, {SMARTBUFF_SACREDCANDLE}},
      {SMARTBUFF_PWS, 0.5, SMARTBUFF_CONST_GROUP, {6,12,18,24,30,36,42,48,54,60}, "MAGE;WARLOCK;ROGUE;PALADIN;WARRIOR;DRUID;HUNTER;SHAMAN;HPET;WPET"},
      {SMARTBUFF_SHADOWFORM, -1, SMARTBUFF_CONST_SELF},
      {SMARTBUFF_FEARWARD, 10, SMARTBUFF_CONST_GROUP, {20}},
      {SMARTBUFF_ELUNESGRACE, 0.25, SMARTBUFF_CONST_SELF},
      {SMARTBUFF_FEEDBACK, 0.25, SMARTBUFF_CONST_SELF},
      {SMARTBUFF_SHADOWGUARD, 10, SMARTBUFF_CONST_SELF},
      {SMARTBUFF_TOUCHOFWEAKNESS, 10, SMARTBUFF_CONST_SELF},
      {SMARTBUFF_INNERFOCUS, -1, SMARTBUFF_CONST_SELF}  
    };
  end
  
  -- Mage
  if (SMARTBUFF_PLAYERCLASS == "MAGE") then
    SMARTBUFF_BUFFLIST = {
      {SMARTBUFF_AI, 30, SMARTBUFF_CONST_GROUP, {1,14,28,42,56}, "ROGUE;WARRIOR;HPET;WPET", nil, nil, SMARTBUFF_AB, 60, {56}, {SMARTBUFF_ARCANEPOWDER}},
      {SMARTBUFF_FOCUSMAGIC, 30, SMARTBUFF_CONST_GROUP, {20}, "WARRIOR;DRUID;SHAMAN;HUNTER;ROGUE;MAGE;PRIEST;PALADIN;WARLOCK;DEATHKNIGHT;HPET;WPET"},
      {SMARTBUFF_ICEARMOR, 30, SMARTBUFF_CONST_SELF, nil, nil, nil, S.ChainMageArmor},
      {SMARTBUFF_FROSTARMOR, 30, SMARTBUFF_CONST_SELF, nil, nil, nil, S.ChainMageArmor},
      {SMARTBUFF_MAGEARMOR, 30, SMARTBUFF_CONST_SELF, nil, nil, nil, S.ChainMageArmor},
      {SMARTBUFF_MOLTENARMOR, 30, SMARTBUFF_CONST_SELF, nil, nil, nil, S.ChainMageArmor},
      {SMARTBUFF_DAMPENMAGIC, 10, SMARTBUFF_CONST_GROUP, {12,24,36,48,60}, "HPET;WPET"},
      {SMARTBUFF_AMPLIFYMAGIC, 10, SMARTBUFF_CONST_GROUP, {18,30,42,54}, "HPET;WPET"},
      {SMARTBUFF_MANASHIELD, 1, SMARTBUFF_CONST_SELF},
      {SMARTBUFF_FIREWARD, 0.5, SMARTBUFF_CONST_SELF},
      {SMARTBUFF_FROSTWARD, 0.5, SMARTBUFF_CONST_SELF},
      {SMARTBUFF_ICEBARRIER, 1, SMARTBUFF_CONST_SELF},
      {SMARTBUFF_COMBUSTION, -1, SMARTBUFF_CONST_SELF},
      {SMARTBUFF_ICYVEINS, 0.33, SMARTBUFF_CONST_SELF},
      {SMARTBUFF_ARCANEPOWER, 0.25, SMARTBUFF_CONST_SELF},
      {SMARTBUFF_PRESENCEOFMIND, 0.165, SMARTBUFF_CONST_SELF}
    };
  end
  
  -- Warlock
  if (SMARTBUFF_PLAYERCLASS == "WARLOCK") then
    SMARTBUFF_BUFFLIST = {
      {SMARTBUFF_FELARMOR, 30, SMARTBUFF_CONST_SELF, nil, nil, nil, S.ChainWarlockArmor},
      {SMARTBUFF_DEMONARMOR, 30, SMARTBUFF_CONST_SELF, nil, nil, nil, S.ChainWarlockArmor},
      {SMARTBUFF_DEMONSKIN, 30, SMARTBUFF_CONST_SELF, nil, nil, nil, S.ChainWarlockArmor},
      {SMARTBUFF_SOULLINK, 0, SMARTBUFF_CONST_SELF, nil, S.CheckPetNeeded},
      {SMARTBUFF_DINVISIBILITY, 10, SMARTBUFF_CONST_GROUP, {26}, "HPET;WPET"},
      {SMARTBUFF_UNENDINGBREATH, 10, SMARTBUFF_CONST_GROUP, {16}, "HPET;WPET"},
      {SMARTBUFF_LIFETAP, 0.025, SMARTBUFF_CONST_SELF},
      {SMARTBUFF_SHADOWWARD, 0.5, SMARTBUFF_CONST_SELF},
      {SMARTBUFF_DARKPACT, 0.5, SMARTBUFF_CONST_SELF},
      {SMARTBUFF_SOULSTONE, 15, SMARTBUFF_CONST_GROUP, {18}, "WARRIOR;DRUID;SHAMAN;HUNTER;ROGUE;MAGE;PRIEST;PALADIN;WARLOCK;DEATHKNIGHT;MONK;DEMONHUNTER;HPET;WPET;DKPET"},
      {SMARTBUFF_CREATEHSMAJ, 0.03, SMARTBUFF_CONST_ITEM, nil, SMARTBUFF_HEALTHSTONEGEM},
      {SMARTBUFF_CREATEHSGRE, 0.03, SMARTBUFF_CONST_ITEM, nil, SMARTBUFF_HEALTHSTONEGEM},
      {SMARTBUFF_CREATEHS, 0.03, SMARTBUFF_CONST_ITEM, nil, SMARTBUFF_HEALTHSTONEGEM},
      {SMARTBUFF_CREATEHSLES, 0.03, SMARTBUFF_CONST_ITEM, nil, SMARTBUFF_HEALTHSTONEGEM},
      {SMARTBUFF_CREATEHSMIN, 0.03, SMARTBUFF_CONST_ITEM, nil, SMARTBUFF_HEALTHSTONEGEM},
      {SMARTBUFF_CREATESSMAJ, 0.03, SMARTBUFF_CONST_ITEM, nil, SMARTBUFF_SOULSTONEGEM},
      {SMARTBUFF_CREATESSGRE, 0.03, SMARTBUFF_CONST_ITEM, nil, SMARTBUFF_SOULSTONEGEM},
      {SMARTBUFF_CREATESS, 0.03, SMARTBUFF_CONST_ITEM, nil, SMARTBUFF_SOULSTONEGEM},
      {SMARTBUFF_CREATESSLES, 0.03, SMARTBUFF_CONST_ITEM, nil, SMARTBUFF_SOULSTONEGEM},
      {SMARTBUFF_CREATESSMIN, 0.03, SMARTBUFF_CONST_ITEM, nil, SMARTBUFF_SOULSTONEGEM},
      {SMARTBUFF_SPELLSTONE6, 60, SMARTBUFF_CONST_INV},
      {SMARTBUFF_SPELLSTONE5, 60, SMARTBUFF_CONST_INV},
      {SMARTBUFF_SPELLSTONE4, 60, SMARTBUFF_CONST_INV},
      {SMARTBUFF_SPELLSTONE3, 60, SMARTBUFF_CONST_INV},
      {SMARTBUFF_SPELLSTONE2, 60, SMARTBUFF_CONST_INV},
      {SMARTBUFF_SPELLSTONE1, 60, SMARTBUFF_CONST_INV},
      {SMARTBUFF_FIRESTONE7, 60, SMARTBUFF_CONST_INV},
      {SMARTBUFF_FIRESTONE6, 60, SMARTBUFF_CONST_INV},
      {SMARTBUFF_FIRESTONE5, 60, SMARTBUFF_CONST_INV},
      {SMARTBUFF_FIRESTONE4, 60, SMARTBUFF_CONST_INV},
      {SMARTBUFF_FIRESTONE3, 60, SMARTBUFF_CONST_INV},
      {SMARTBUFF_FIRESTONE2, 60, SMARTBUFF_CONST_INV},
      {SMARTBUFF_FIRESTONE1, 60, SMARTBUFF_CONST_INV}
    };
  end

  -- Hunter
  if (SMARTBUFF_PLAYERCLASS == "HUNTER") then
    SMARTBUFF_BUFFLIST = {
      {SMARTBUFF_TRUESHOTAURA, -1, SMARTBUFF_CONST_SELF},
      {SMARTBUFF_RAPIDFIRE, 0.2, SMARTBUFF_CONST_SELF},
      {SMARTBUFF_AOTDH, -1, SMARTBUFF_CONST_SELF, nil, nil, nil, S.ChainAspects},
      {SMARTBUFF_AOTH, -1, SMARTBUFF_CONST_SELF, nil, nil, nil, S.ChainAspects},
      {SMARTBUFF_AOTM, -1, SMARTBUFF_CONST_SELF, nil, nil, nil, S.ChainAspects},
      {SMARTBUFF_AOTV, -1, SMARTBUFF_CONST_SELF, nil, nil, nil, S.ChainAspects},
      {SMARTBUFF_AOTW, -1, SMARTBUFF_CONST_SELF, nil, nil, nil, S.ChainAspects},
      {SMARTBUFF_AOTB, -1, SMARTBUFF_CONST_SELF, nil, nil, nil, S.ChainAspects},
      {SMARTBUFF_AOTC, -1, SMARTBUFF_CONST_SELF, nil, nil, nil, S.ChainAspects},
      {SMARTBUFF_AOTP, -1, SMARTBUFF_CONST_SELF, nil, nil, nil, S.ChainAspects}
    };
  end

  -- Shaman
  if (SMARTBUFF_PLAYERCLASS == "SHAMAN") then
    SMARTBUFF_BUFFLIST = {
      {SMARTBUFF_LIGHTNINGSHIELD, 10, SMARTBUFF_CONST_SELF, nil, nil, nil, S.ChainShamanShield},
      {SMARTBUFF_WATERSHIELD, 10, SMARTBUFF_CONST_SELF, nil, nil, nil, S.ChainShamanShield},
      {SMARTBUFF_EARTHSHIELD, 10, SMARTBUFF_CONST_GROUP, {50,60}, "WARRIOR;DRUID;SHAMAN;HUNTER;ROGUE;MAGE;PRIEST;PALADIN;WARLOCK;HPET;WPET", nil, S.ChainShamanShield},
      {SMARTBUFF_WINDFURYW, 30, SMARTBUFF_CONST_WEAPON},
      {SMARTBUFF_FLAMETONGUEW, 30, SMARTBUFF_CONST_WEAPON},
      {SMARTBUFF_FROSTBRANDW, 30, SMARTBUFF_CONST_WEAPON},
      {SMARTBUFF_ROCKBITERW, 30, SMARTBUFF_CONST_WEAPON},
      {SMARTBUFF_EARTHLIVINGW, 30, SMARTBUFF_CONST_WEAPON},
      {SMARTBUFF_WATERBREATHING, 10, SMARTBUFF_CONST_GROUP, {22}},
      {SMARTBUFF_WATERWALKING, 10, SMARTBUFF_CONST_GROUP, {28}}
    };
  end

  -- Warrior
  if (SMARTBUFF_PLAYERCLASS == "WARRIOR") then
    SMARTBUFF_BUFFLIST = {
      {SMARTBUFF_BATTLESHOUT, 2, SMARTBUFF_CONST_SELF, nil, nil, nil, S.ChainWarriorShout},
      {SMARTBUFF_COMMANDINGSHOUT, 2, SMARTBUFF_CONST_SELF, nil, nil, nil, S.ChainWarriorShout},
      {SMARTBUFF_BERSERKERRAGE, 0.165, SMARTBUFF_CONST_SELF},
      {SMARTBUFF_SHIELDBLOCK, 0.1666, SMARTBUFF_CONST_SELF},
      {SMARTBUFF_BLOODRAGE, 0.165, SMARTBUFF_CONST_SELF},
      {SMARTBUFF_RAMPAGE, 0.5, SMARTBUFF_CONST_SELF},
      {SMARTBUFF_VIGILANCE, 30, SMARTBUFF_CONST_GROUP, {40}, "WARRIOR;DRUID;SHAMAN;HUNTER;ROGUE;MAGE;PRIEST;PALADIN;WARLOCK;DEATHKNIGHT;HPET;WPET"}
    };
  end
  
  -- Rogue
  if (SMARTBUFF_PLAYERCLASS == "ROGUE") then
    SMARTBUFF_BUFFLIST = {
      {SMARTBUFF_STEALTH, -1, SMARTBUFF_CONST_SELF},
      {SMARTBUFF_BLADEFLURRY, 0.165, SMARTBUFF_CONST_SELF},
      {SMARTBUFF_SAD, 0.2, SMARTBUFF_CONST_SELF},
      {SMARTBUFF_HUNGERFORBLOOD, 0.5, SMARTBUFF_CONST_SELF},
      {SMARTBUFF_EVASION, 0.2, SMARTBUFF_CONST_SELF},
      {SMARTBUFF_INSTANTPOISON9, 60, SMARTBUFF_CONST_INV},
      {SMARTBUFF_INSTANTPOISON8, 60, SMARTBUFF_CONST_INV},
      {SMARTBUFF_INSTANTPOISON7, 60, SMARTBUFF_CONST_INV},
      {SMARTBUFF_INSTANTPOISON6, 60, SMARTBUFF_CONST_INV},
      {SMARTBUFF_INSTANTPOISON5, 60, SMARTBUFF_CONST_INV},
      {SMARTBUFF_INSTANTPOISON4, 60, SMARTBUFF_CONST_INV},
      {SMARTBUFF_INSTANTPOISON3, 60, SMARTBUFF_CONST_INV},
      {SMARTBUFF_INSTANTPOISON2, 60, SMARTBUFF_CONST_INV},
      {SMARTBUFF_INSTANTPOISON1, 60, SMARTBUFF_CONST_INV},
      {SMARTBUFF_WOUNDPOISON7, 60, SMARTBUFF_CONST_INV},
      {SMARTBUFF_WOUNDPOISON6, 60, SMARTBUFF_CONST_INV},
      {SMARTBUFF_WOUNDPOISON5, 60, SMARTBUFF_CONST_INV},
      {SMARTBUFF_WOUNDPOISON4, 60, SMARTBUFF_CONST_INV},
      {SMARTBUFF_WOUNDPOISON3, 60, SMARTBUFF_CONST_INV},
      {SMARTBUFF_WOUNDPOISON2, 60, SMARTBUFF_CONST_INV},
      {SMARTBUFF_WOUNDPOISON1, 60, SMARTBUFF_CONST_INV},
      {SMARTBUFF_MINDPOISON1, 60, SMARTBUFF_CONST_INV},
      {SMARTBUFF_DEADLYPOISON9, 60, SMARTBUFF_CONST_INV},
      {SMARTBUFF_DEADLYPOISON8, 60, SMARTBUFF_CONST_INV},
      {SMARTBUFF_DEADLYPOISON7, 60, SMARTBUFF_CONST_INV},
      {SMARTBUFF_DEADLYPOISON6, 60, SMARTBUFF_CONST_INV},
      {SMARTBUFF_DEADLYPOISON5, 60, SMARTBUFF_CONST_INV},
      {SMARTBUFF_DEADLYPOISON4, 60, SMARTBUFF_CONST_INV},
      {SMARTBUFF_DEADLYPOISON3, 60, SMARTBUFF_CONST_INV},
      {SMARTBUFF_DEADLYPOISON2, 60, SMARTBUFF_CONST_INV},
      {SMARTBUFF_DEADLYPOISON1, 60, SMARTBUFF_CONST_INV},
      {SMARTBUFF_CRIPPLINGPOISON1, 60, SMARTBUFF_CONST_INV},
      {SMARTBUFF_ANESTHETICPOISON2, 60, SMARTBUFF_CONST_INV},
      {SMARTBUFF_ANESTHETICPOISON1, 60, SMARTBUFF_CONST_INV}
    };
  end

  -- Paladin
  if (SMARTBUFF_PLAYERCLASS == "PALADIN") then
    SMARTBUFF_BUFFLIST = {
      {SMARTBUFF_RIGHTEOUSFURY, 30, SMARTBUFF_CONST_SELF},
      {SMARTBUFF_HOLYSHIELD, 0.165, SMARTBUFF_CONST_SELF},
      {SMARTBUFF_BOM, 10, SMARTBUFF_CONST_GROUP, {4,12,22,32,42,52,60}, "DRUID;MAGE;PRIEST;SHAMAN;WARLOCK;WPET", nil, ChainPaladinBlessing, SMARTBUFF_GBOM, 30, {52,60}, {SMARTBUFF_SYMBOLOFKINGS,SMARTBUFF_SYMBOLOFKINGS}},
      {SMARTBUFF_BOW, 10, SMARTBUFF_CONST_GROUP, {14,24,34,44,54,60,65,71,77}, "ROGUE;WARRIOR;HPET;WPET", nil, ChainPaladinBlessing,  SMARTBUFF_GBOW, 30, {54,60}, {SMARTBUFF_SYMBOLOFKINGS,SMARTBUFF_SYMBOLOFKINGS}},
      {SMARTBUFF_BOK, 10, SMARTBUFF_CONST_GROUP, {20}, "WPET", nil, ChainPaladinBlessing, SMARTBUFF_GBOK, 30, {60}, {SMARTBUFF_SYMBOLOFKINGS}},
      {SMARTBUFF_BOL, 10, SMARTBUFF_CONST_GROUP, {40,50,60}, "WPET", SMARTBUFF_GBOL, 30, {60}, {SMARTBUFF_SYMBOLOFKINGS} },
      {SMARTBUFF_BOSAN, 10, SMARTBUFF_CONST_GROUP, {30}, "DRUID;HUNTER;MAGE;PRIEST;ROGUE;SHAMAN;WARLOCK;HPET;WPET", nil, ChainPaladinBlessing, SMARTBUFF_GBOSAN, 30, {60}, {SMARTBUFF_SYMBOLOFKINGS}},
      {SMARTBUFF_BOSAL, 10, SMARTBUFF_CONST_GROUP, {26}, "WARRIOR;HPET;WPET", nil, ChainPaladinBlessing},
      {SMARTBUFF_BOF, 0.165, SMARTBUFF_CONST_GROUP, {18}, "WPET", nil, ChainPaladinBlessing},
      {SMARTBUFF_BOP, 1, SMARTBUFF_CONST_GROUP, {10,24,38}, "WPET", nil, ChainPaladinBlessing},
      {SMARTBUFF_SOCOMMAND, 2, SMARTBUFF_CONST_SELF, nil, nil, nil, S.ChainPaladinSeal},
      {SMARTBUFF_SOFURY, 2, SMARTBUFF_CONST_SELF, nil, nil, nil, S.ChainPaladinSeal},
      {SMARTBUFF_SOJUSTICE, 2, SMARTBUFF_CONST_SELF, nil, nil, nil, S.ChainPaladinSeal},
      {SMARTBUFF_SOLIGHT, 2, SMARTBUFF_CONST_SELF, nil, nil, nil, S.ChainPaladinSeal},
      {SMARTBUFF_SORIGHTEOUSNESS, 2, SMARTBUFF_CONST_SELF, nil, nil, nil, S.ChainPaladinSeal},
      {SMARTBUFF_SOWISDOM, 2, SMARTBUFF_CONST_SELF, nil, nil, nil, S.ChainPaladinSeal},
      {SMARTBUFF_SOTCRUSADER, 2, SMARTBUFF_CONST_SELF, nil, nil, nil, S.ChainPaladinSeal},
      {SMARTBUFF_SOVENGEANCE, 2, SMARTBUFF_CONST_SELF, nil, nil, nil, S.ChainPaladinSeal},
      {SMARTBUFF_SOBLOOD, 2, SMARTBUFF_CONST_SELF, nil, nil, nil, S.ChainPaladinSeal},
      {SMARTBUFF_SOCORRUPTION, 2, SMARTBUFF_CONST_SELF, nil, nil, nil, S.ChainPaladinSeal},
      {SMARTBUFF_SOMARTYR, 2, SMARTBUFF_CONST_SELF, nil, nil, nil, S.ChainPaladinSeal},
      {SMARTBUFF_DEVOTIONAURA, -1, SMARTBUFF_CONST_SELF, nil, nil, nil, S.ChainPaladinAura},
      {SMARTBUFF_RETRIBUTIONAURA, -1, SMARTBUFF_CONST_SELF, nil, nil, nil, S.ChainPaladinAura},
      {SMARTBUFF_CONCENTRATIONAURA, -1, SMARTBUFF_CONST_SELF, nil, nil, nil, S.ChainPaladinAura},
      {SMARTBUFF_SHADOWRESISTANCEAURA, -1, SMARTBUFF_CONST_SELF, nil, nil, nil, S.ChainPaladinAura},
      {SMARTBUFF_FROSTRESISTANCEAURA, -1, SMARTBUFF_CONST_SELF, nil, nil, nil, S.ChainPaladinAura},
      {SMARTBUFF_FIRERESISTANCEAURA, -1, SMARTBUFF_CONST_SELF, nil, nil, nil, S.ChainPaladinAura},
      {SMARTBUFF_SANCTITYAURA, -1, SMARTBUFF_CONST_SELF, nil, nil, nil, S.ChainPaladinAura},
      {SMARTBUFF_CRUSADERAURA, -1, SMARTBUFF_CONST_SELF, nil, nil, nil, S.ChainPaladinAura}    
    };
  end
  
  --[[
  -- Deathknight
  if (SMARTBUFF_PLAYERCLASS == "DEATHKNIGHT") then
    SMARTBUFF_BUFFLIST = {
      {SMARTBUFF_DANCINGRW, 0.2, SMARTBUFF_CONST_SELF},
      {SMARTBUFF_BLOODPRESENCE, -1, SMARTBUFF_CONST_STANCE, nil, nil, nil, S.ChainDKPresence},
      {SMARTBUFF_FROSTPRESENCE, -1, SMARTBUFF_CONST_STANCE, nil, nil, nil, S.ChainDKPresence},
      {SMARTBUFF_UNHOLYPRESENCE, -1, SMARTBUFF_CONST_STANCE, nil, nil, nil, S.ChainDKPresence},
      {SMARTBUFF_HORNOFWINTER, 60, SMARTBUFF_CONST_SELF, nil, nil, S.LinkAp},
      {SMARTBUFF_BONESHIELD, 5, SMARTBUFF_CONST_SELF},
      {SMARTBUFF_RAISEDEAD, 1, SMARTBUFF_CONST_SELF, nil, S.CheckPet},
      {SMARTBUFF_PATHOFFROST, -1, SMARTBUFF_CONST_SELF}
    };
  end
  ]]--
  
  --[[
  -- Monk
  if (SMARTBUFF_PLAYERCLASS == "MONK") then
    SMARTBUFF_BUFFLIST = {
      {SMARTBUFF_LOTWT, 60, SMARTBUFF_CONST_GROUP, {81}},
      {SMARTBUFF_LOTE, 60, SMARTBUFF_CONST_GROUP, {22}, nil, S.LinkStats},
      {SMARTBUFF_SOTFIERCETIGER, -1, SMARTBUFF_CONST_STANCE, nil, nil, nil, S.ChainMonkStance},
      {SMARTBUFF_SOTSTURDYOX, -1, SMARTBUFF_CONST_STANCE, nil, nil, nil, S.ChainMonkStance},
      {SMARTBUFF_SOTWISESERPENT, -1, SMARTBUFF_CONST_STANCE, nil, nil, nil, S.ChainMonkStance},
      {SMARTBUFF_SOTSPIRITEDCRANE, -1, SMARTBUFF_CONST_STANCE, nil, nil, nil, S.ChainMonkStance},
      {SMARTBUFF_BLACKOX, 15, SMARTBUFF_CONST_SELF, nil, nil, nil, S.ChainMonkStatue},
      {SMARTBUFF_SMARTBUFF_JADESERPENT, 15, SMARTBUFF_CONST_SELF, nil, nil, nil, S.ChainMonkStatue}
    };
  end
  ]]--

  --[[
  -- Demon Hunter
  if (SMARTBUFF_PLAYERCLASS == "DEMONHUNTER") then
    SMARTBUFF_BUFFLIST = {
    };
  end
  ]]--

  -- Stones and oils
  SMARTBUFF_WEAPON = {
    {SMARTBUFF_SSROUGH, 60, SMARTBUFF_CONST_INV},
    {SMARTBUFF_SSCOARSE, 60, SMARTBUFF_CONST_INV},
    {SMARTBUFF_SSHEAVY, 60, SMARTBUFF_CONST_INV},
    {SMARTBUFF_SSSOLID, 60, SMARTBUFF_CONST_INV},
    {SMARTBUFF_SSDENSE, 60, SMARTBUFF_CONST_INV},
    {SMARTBUFF_SSELEMENTAL, 60, SMARTBUFF_CONST_INV},
    {SMARTBUFF_SSFEL, 60, SMARTBUFF_CONST_INV},
    {SMARTBUFF_SSADAMANTITE, 60, SMARTBUFF_CONST_INV},
    {SMARTBUFF_WSROUGH, 60, SMARTBUFF_CONST_INV},
    {SMARTBUFF_WSCOARSE, 60, SMARTBUFF_CONST_INV},
    {SMARTBUFF_WSHEAVY, 60, SMARTBUFF_CONST_INV},
    {SMARTBUFF_WSSOLID, 60, SMARTBUFF_CONST_INV},
    {SMARTBUFF_WSDENSE, 60, SMARTBUFF_CONST_INV},
    {SMARTBUFF_WSFEL, 60, SMARTBUFF_CONST_INV},
    {SMARTBUFF_WSADAMANTITE, 60, SMARTBUFF_CONST_INV},
    {SMARTBUFF_SHADOWOIL, 60, SMARTBUFF_CONST_INV},
    {SMARTBUFF_FROSTOIL, 60, SMARTBUFF_CONST_INV},
    --{SMARTBUFF_MANAOIL5, 60, SMARTBUFF_CONST_INV},
    {SMARTBUFF_MANAOIL4, 60, SMARTBUFF_CONST_INV},
    {SMARTBUFF_MANAOIL3, 60, SMARTBUFF_CONST_INV},
    {SMARTBUFF_MANAOIL2, 60, SMARTBUFF_CONST_INV},
    {SMARTBUFF_MANAOIL1, 60, SMARTBUFF_CONST_INV},
    --{SMARTBUFF_WIZARDOIL6, 60, SMARTBUFF_CONST_INV},
    {SMARTBUFF_WIZARDOIL5, 60, SMARTBUFF_CONST_INV},
    {SMARTBUFF_WIZARDOIL4, 60, SMARTBUFF_CONST_INV},
    {SMARTBUFF_WIZARDOIL3, 60, SMARTBUFF_CONST_INV},
    {SMARTBUFF_WIZARDOIL2, 60, SMARTBUFF_CONST_INV},
    {SMARTBUFF_WIZARDOIL1, 60, SMARTBUFF_CONST_INV}  
  };

  -- Tracking
  SMARTBUFF_TRACKING = {
    {SMARTBUFF_FINDMINERALS, -1, SMARTBUFF_CONST_TRACK},
    {SMARTBUFF_FINDHERBS, -1, SMARTBUFF_CONST_TRACK},
    {SMARTBUFF_FINDTREASURE, -1, SMARTBUFF_CONST_TRACK},
    {SMARTBUFF_TRACKHUMANOIDS, -1, SMARTBUFF_CONST_TRACK},
    {SMARTBUFF_TRACKBEASTS, -1, SMARTBUFF_CONST_TRACK},
    {SMARTBUFF_TRACKUNDEAD, -1, SMARTBUFF_CONST_TRACK},
    {SMARTBUFF_TRACKHIDDEN, -1, SMARTBUFF_CONST_TRACK},
    {SMARTBUFF_TRACKELEMENTALS, -1, SMARTBUFF_CONST_TRACK},
    {SMARTBUFF_TRACKDEMONS, -1, SMARTBUFF_CONST_TRACK},
    {SMARTBUFF_TRACKGIANTS, -1, SMARTBUFF_CONST_TRACK},
    {SMARTBUFF_TRACKDRAGONKIN, -1, SMARTBUFF_CONST_TRACK},
    {SMARTBUFF_SENSEDEMONS, -1, SMARTBUFF_CONST_TRACK},
    {SMARTBUFF_SENSEUNDEAD, -1, SMARTBUFF_CONST_TRACK}
  };

  -- Racial
  SMARTBUFF_RACIAL = {
    {SMARTBUFF_STONEFORM, 0.133, SMARTBUFF_CONST_SELF},  -- Dwarv
    --{SMARTBUFF_PRECEPTION, 0.333, SMARTBUFF_CONST_SELF}, -- Human
    {SMARTBUFF_BLOODFURY, 0.416, SMARTBUFF_CONST_SELF},  -- Orc
    {SMARTBUFF_BERSERKING, 0.166, SMARTBUFF_CONST_SELF}, -- Troll
    {SMARTBUFF_WOTFORSAKEN, 0.083, SMARTBUFF_CONST_SELF}, -- Undead
    {SMARTBUFF_WarStomp, 0.033, SMARTBUFF_CONST_SELF} -- Tauer
  };

  -- FOOD
 SMARTBUFF_FOOD = {
    {SMARTBUFF_KALDOREISPIDERKABOB, 15, SMARTBUFF_CONST_FOOD},
    {SMARTBUFF_CRISPYBATWING, 15, SMARTBUFF_CONST_FOOD},
    {SMARTBUFF_HERBBAKEDEGG, 15, SMARTBUFF_CONST_FOOD},
    {SMARTBUFF_GINGERBREADCOOKIE, 15, SMARTBUFF_CONST_FOOD},
    {SMARTBUFF_BEERBASTEDBOARRIBS, 15, SMARTBUFF_CONST_FOOD},
    {SMARTBUFF_ROASTEDKODOMEAT, 15, SMARTBUFF_CONST_FOOD},
    {SMARTBUFF_EGGNOG, 15, SMARTBUFF_CONST_FOOD},
    {SMARTBUFF_BLOODSAUSAGE, 15, SMARTBUFF_CONST_FOOD},
    {SMARTBUFF_STRIDERSTEW, 15, SMARTBUFF_CONST_FOOD},
    {SMARTBUFF_CROCOLISKSTEAK, 15, SMARTBUFF_CONST_FOOD},
    {SMARTBUFF_SMOKEDSAGEFISH, 15, SMARTBUFF_CONST_FOOD},
    {SMARTBUFF_FILLETOFFRENZY, 15, SMARTBUFF_CONST_FOOD},
    {SMARTBUFF_GORETUSKLIVERPIE, 15, SMARTBUFF_CONST_FOOD},
    {SMARTBUFF_REDRIDGEGOULASH, 15, SMARTBUFF_CONST_FOOD},
    {SMARTBUFF_CRISPYLIZARDTAIL, 15, SMARTBUFF_CONST_FOOD},    
    {SMARTBUFF_BIGBEARSTEAK, 15, SMARTBUFF_CONST_FOOD},
    {SMARTBUFF_LEANWOLFSTEAK, 15, SMARTBUFF_CONST_FOOD},
    {SMARTBUFF_GOOEYSPIDERCAKE, 15, SMARTBUFF_CONST_FOOD},
    {SMARTBUFF_MURLOCFINSOUP, 15, SMARTBUFF_CONST_FOOD},
    {SMARTBUFF_CURIOUSLYTASTYOMELET, 15, SMARTBUFF_CONST_FOOD},
    {SMARTBUFF_LEANVENISON, 15, SMARTBUFF_CONST_FOOD},
    {SMARTBUFF_HOTLIONCHOPS, 15, SMARTBUFF_CONST_FOOD},
    {SMARTBUFF_SEASONEDWOLFKABOB, 15, SMARTBUFF_CONST_FOOD},    
    {SMARTBUFF_CROCOLISKGUMBO, 15, SMARTBUFF_CONST_FOOD},
    {SMARTBUFF_SOOTHINGTURTLEBISQUE, 15, SMARTBUFF_CONST_FOOD},
    {SMARTBUFF_HEAVYCROCOLISKSTEW, 15, SMARTBUFF_CONST_FOOD},
    {SMARTBUFF_JUNGLESTEW, 15, SMARTBUFF_CONST_FOOD},
    {SMARTBUFF_GOBLINDEVILEDCLAMS, 15, SMARTBUFF_CONST_FOOD},
    {SMARTBUFF_TASTYLIONSTEAK, 15, SMARTBUFF_CONST_FOOD},
    {SMARTBUFF_SAGEFISHDELIGHT, 15, SMARTBUFF_CONST_FOOD},
    {SMARTBUFF_HOTWOLFRIBS, 15, SMARTBUFF_CONST_FOOD},
    {SMARTBUFF_CARRIONSURPRISE, 15, SMARTBUFF_CONST_FOOD},
    {SMARTBUFF_ROASTRAPTOR, 15, SMARTBUFF_CONST_FOOD},
    {SMARTBUFF_GIANTCLAMSCORCHO, 15, SMARTBUFF_CONST_FOOD},
    {SMARTBUFF_MYSTERYSTEW, 15, SMARTBUFF_CONST_FOOD},
    {SMARTBUFF_BARBECUEDBUZZARDWING, 15, SMARTBUFF_CONST_FOOD},    
    {SMARTBUFF_HEAVYKODOSTEW, 15, SMARTBUFF_CONST_FOOD},
    {SMARTBUFF_TENDERWOLFSTEAK, 15, SMARTBUFF_CONST_FOOD},
    {SMARTBUFF_MONSTEROMELET, 15, SMARTBUFF_CONST_FOOD},
    {SMARTBUFF_SPICEDCHILICRAB, 15, SMARTBUFF_CONST_FOOD},
    {SMARTBUFF_COOKEDGLOSSYMIGHTFISH, 10, SMARTBUFF_CONST_FOOD},
    {SMARTBUFF_GRILLEDSQUID, 10, SMARTBUFF_CONST_FOOD},
    {SMARTBUFF_HOTSMOKEDBASS, 10, SMARTBUFF_CONST_FOOD},
    {SMARTBUFF_NIGHTFINSOUP, 10, SMARTBUFF_CONST_FOOD},
    {SMARTBUFF_POACHEDSUNSCALESALMON, 10, SMARTBUFF_CONST_FOOD},
    {SMARTBUFF_RUNNTUMTUBERSURPRISE, 10, SMARTBUFF_CONST_FOOD},
    {SMARTBUFF_MIGHTFISHSTEAK, 10, SMARTBUFF_CONST_FOOD},
    {SMARTBUFF_DIRGESKICKINCHIMAEROKCHOPS, 1, SMARTBUFF_CONST_FOOD},
  };

  -- Scrolls
  SMARTBUFF_SCROLL = {
    {SMARTBUFF_SOAGILITY4, 30, SMARTBUFF_CONST_SCROLL, nil, SMARTBUFF_SBAGILITY},
    {SMARTBUFF_SOAGILITY3, 30, SMARTBUFF_CONST_SCROLL, nil, SMARTBUFF_SBAGILITY},
    {SMARTBUFF_SOAGILITY2, 30, SMARTBUFF_CONST_SCROLL, nil, SMARTBUFF_SBAGILITY},
    {SMARTBUFF_SOAGILITY1, 30, SMARTBUFF_CONST_SCROLL, nil, SMARTBUFF_SBAGILITY},
    
    {SMARTBUFF_SOINTELLECT4, 30, SMARTBUFF_CONST_SCROLL, nil, SMARTBUFF_SBINTELLECT},
    {SMARTBUFF_SOINTELLECT3, 30, SMARTBUFF_CONST_SCROLL, nil, SMARTBUFF_SBINTELLECT},
    {SMARTBUFF_SOINTELLECT2, 30, SMARTBUFF_CONST_SCROLL, nil, SMARTBUFF_SBINTELLECT},
    {SMARTBUFF_SOINTELLECT1, 30, SMARTBUFF_CONST_SCROLL, nil, SMARTBUFF_SBINTELLECT},
    
    {SMARTBUFF_SOSTAMINA4, 30, SMARTBUFF_CONST_SCROLL, nil, SMARTBUFF_SBSTAMINA},
    {SMARTBUFF_SOSTAMINA3, 30, SMARTBUFF_CONST_SCROLL, nil, SMARTBUFF_SBSTAMINA},
    {SMARTBUFF_SOSTAMINA2, 30, SMARTBUFF_CONST_SCROLL, nil, SMARTBUFF_SBSTAMINA},
    {SMARTBUFF_SOSTAMINA1, 30, SMARTBUFF_CONST_SCROLL, nil, SMARTBUFF_SBSTAMINA},
    
    {SMARTBUFF_SOSPIRIT4, 30, SMARTBUFF_CONST_SCROLL, nil, SMARTBUFF_SBSPIRIT},
    {SMARTBUFF_SOSPIRIT3, 30, SMARTBUFF_CONST_SCROLL, nil, SMARTBUFF_SBSPIRIT},
    {SMARTBUFF_SOSPIRIT2, 30, SMARTBUFF_CONST_SCROLL, nil, SMARTBUFF_SBSPIRIT},
    {SMARTBUFF_SOSPIRIT1, 30, SMARTBUFF_CONST_SCROLL, nil, SMARTBUFF_SBSPIRIT},
    
    {SMARTBUFF_SOSTRENGHT4, 30, SMARTBUFF_CONST_SCROLL, nil, SMARTBUFF_SBSTRENGHT},
    {SMARTBUFF_SOSTRENGHT3, 30, SMARTBUFF_CONST_SCROLL, nil, SMARTBUFF_SBSTRENGHT},
    {SMARTBUFF_SOSTRENGHT2, 30, SMARTBUFF_CONST_SCROLL, nil, SMARTBUFF_SBSTRENGHT},
    {SMARTBUFF_SOSTRENGHT1, 30, SMARTBUFF_CONST_SCROLL, nil, SMARTBUFF_SBSTRENGHT},
  
    {SMARTBUFF_SOPROTECTION4, 30, SMARTBUFF_CONST_SCROLL, nil, SMARTBUFF_SBPROTECTION},
    {SMARTBUFF_SOPROTECTION3, 30, SMARTBUFF_CONST_SCROLL, nil, SMARTBUFF_SBPROTECTION},
    {SMARTBUFF_SOPROTECTION2, 30, SMARTBUFF_CONST_SCROLL, nil, SMARTBUFF_SBPROTECTION},
    {SMARTBUFF_SOPROTECTION1, 30, SMARTBUFF_CONST_SCROLL, nil, SMARTBUFF_SBPROTECTION},
  };
  
  --      ItemId, SpellId, Duration [min]
  AddItem(102463, 148429,  10); -- Fire-Watcher's Oath
  AddItem(116115, 170869,  60); -- Blazing Wings
  AddItem( 43499,  58501,  10); -- Iron Boot Flask
  AddItem( 54653,  75532,  30); -- Darkspear Pride
  AddItem( 54651,  75531,  30); -- Gnomeregan Pride
  AddItem(128807, 192225,  60); -- Coin of Many Faces
  AddItem( 68806,  96312,  30); -- Kalytha's Haunted Locket
  AddItem(153023, 224001,  60); -- Lightforged Augment Rune
  AddItem(129149, 193333,  60); -- Helheim Spirit Memory
  AddItem(122304, 138927,  10); -- Fandral's Seed Pouch
  
  -- Potions
  SMARTBUFF_POTION = {
    {SMARTBUFF_FLASKLEG1, 60, SMARTBUFF_CONST_POTION, nil, SMARTBUFF_BFLASKLEG1, S.LinkFlaskLeg},
    {SMARTBUFF_FLASKLEG2, 60, SMARTBUFF_CONST_POTION, nil, SMARTBUFF_BFLASKLEG2},
    {SMARTBUFF_FLASKLEG3, 60, SMARTBUFF_CONST_POTION, nil, SMARTBUFF_BFLASKLEG3},
    {SMARTBUFF_FLASKLEG4, 60, SMARTBUFF_CONST_POTION, nil, SMARTBUFF_BFLASKLEG4},
    {SMARTBUFF_FLASKWOD1, 60, SMARTBUFF_CONST_POTION, nil, SMARTBUFF_BFLASKWOD1, S.LinkFlaskWoD},
    {SMARTBUFF_FLASKWOD2, 60, SMARTBUFF_CONST_POTION, nil, SMARTBUFF_BFLASKWOD2},
    {SMARTBUFF_FLASKWOD3, 60, SMARTBUFF_CONST_POTION, nil, SMARTBUFF_BFLASKWOD3},
    {SMARTBUFF_FLASKWOD4, 60, SMARTBUFF_CONST_POTION, nil, SMARTBUFF_BFLASKWOD4},
    {SMARTBUFF_GRFLASKWOD1, 60, SMARTBUFF_CONST_POTION, nil, SMARTBUFF_BGRFLASKWOD1},
    {SMARTBUFF_GRFLASKWOD2, 60, SMARTBUFF_CONST_POTION, nil, SMARTBUFF_BGRFLASKWOD2},
    {SMARTBUFF_GRFLASKWOD3, 60, SMARTBUFF_CONST_POTION, nil, SMARTBUFF_BGRFLASKWOD3},
    {SMARTBUFF_GRFLASKWOD4, 60, SMARTBUFF_CONST_POTION, nil, SMARTBUFF_BGRFLASKWOD4},
    {SMARTBUFF_FLASKMOP1, 60, SMARTBUFF_CONST_POTION, nil, SMARTBUFF_BFLASKMOP1, S.LinkFlaskMoP},
    {SMARTBUFF_FLASKMOP2, 60, SMARTBUFF_CONST_POTION, nil, SMARTBUFF_BFLASKMOP2},
    {SMARTBUFF_FLASKMOP3, 60, SMARTBUFF_CONST_POTION, nil, SMARTBUFF_BFLASKMOP3},
    {SMARTBUFF_FLASKMOP4, 60, SMARTBUFF_CONST_POTION, nil, SMARTBUFF_BFLASKMOP4},
    {SMARTBUFF_FLASKMOP5, 60, SMARTBUFF_CONST_POTION, nil, SMARTBUFF_BFLASKMOP5},
    {SMARTBUFF_FLASKMOP6, 60, SMARTBUFF_CONST_POTION, nil, SMARTBUFF_BFLASKMOP6},
    {SMARTBUFF_ELIXIRMOP1, 60, SMARTBUFF_CONST_POTION, nil, SMARTBUFF_BELIXIRMOP1},
    {SMARTBUFF_ELIXIRMOP2, 60, SMARTBUFF_CONST_POTION, nil, SMARTBUFF_BELIXIRMOP2},
    {SMARTBUFF_ELIXIRMOP3, 60, SMARTBUFF_CONST_POTION, nil, SMARTBUFF_BELIXIRMOP3},
    {SMARTBUFF_ELIXIRMOP4, 60, SMARTBUFF_CONST_POTION, nil, SMARTBUFF_BELIXIRMOP4},
    {SMARTBUFF_ELIXIRMOP5, 60, SMARTBUFF_CONST_POTION, nil, SMARTBUFF_BELIXIRMOP5},
    {SMARTBUFF_ELIXIRMOP6, 60, SMARTBUFF_CONST_POTION, nil, SMARTBUFF_BELIXIRMOP6},
    {SMARTBUFF_ELIXIRMOP7, 60, SMARTBUFF_CONST_POTION, nil, SMARTBUFF_BELIXIRMOP7},
    {SMARTBUFF_ELIXIRMOP8, 60, SMARTBUFF_CONST_POTION, nil, SMARTBUFF_BELIXIRMOP8},
    {SMARTBUFF_FLASKCT1, 60, SMARTBUFF_CONST_POTION, nil, SMARTBUFF_BFLASKCT1},
    {SMARTBUFF_FLASKCT2, 60, SMARTBUFF_CONST_POTION, nil, SMARTBUFF_BFLASKCT2},
    {SMARTBUFF_FLASKCT3, 60, SMARTBUFF_CONST_POTION, nil, SMARTBUFF_BFLASKCT3},
    {SMARTBUFF_FLASKCT4, 60, SMARTBUFF_CONST_POTION, nil, SMARTBUFF_BFLASKCT4},
    {SMARTBUFF_FLASKCT5, 60, SMARTBUFF_CONST_POTION, nil, SMARTBUFF_BFLASKCT5},
    {SMARTBUFF_FLASKCT7, 60, SMARTBUFF_CONST_POTION, nil, SMARTBUFF_BFLASKCT7, S.LinkFlaskCT7},
    {SMARTBUFF_ELIXIRCT1, 60, SMARTBUFF_CONST_POTION, nil, SMARTBUFF_BELIXIRCT1},
    {SMARTBUFF_ELIXIRCT2, 60, SMARTBUFF_CONST_POTION, nil, SMARTBUFF_BELIXIRCT2},
    {SMARTBUFF_ELIXIRCT3, 60, SMARTBUFF_CONST_POTION, nil, SMARTBUFF_BELIXIRCT3},
    {SMARTBUFF_ELIXIRCT4, 60, SMARTBUFF_CONST_POTION, nil, SMARTBUFF_BELIXIRCT4},
    {SMARTBUFF_ELIXIRCT5, 60, SMARTBUFF_CONST_POTION, nil, SMARTBUFF_BELIXIRCT5},
    {SMARTBUFF_ELIXIRCT6, 60, SMARTBUFF_CONST_POTION, nil, SMARTBUFF_BELIXIRCT6},
    {SMARTBUFF_ELIXIRCT7, 60, SMARTBUFF_CONST_POTION, nil, SMARTBUFF_BELIXIRCT7},
    {SMARTBUFF_ELIXIRCT8, 60, SMARTBUFF_CONST_POTION, nil, SMARTBUFF_BELIXIRCT8},
    {SMARTBUFF_FLASK1, 60, SMARTBUFF_CONST_POTION, nil, SMARTBUFF_BFLASK1},
    {SMARTBUFF_FLASK2, 60, SMARTBUFF_CONST_POTION, nil, SMARTBUFF_BFLASK2},
    {SMARTBUFF_FLASK3, 60, SMARTBUFF_CONST_POTION, nil, SMARTBUFF_BFLASK3},
    {SMARTBUFF_FLASK4, 60, SMARTBUFF_CONST_POTION, nil, SMARTBUFF_BFLASK4},
    {SMARTBUFF_ELIXIR1,  60, SMARTBUFF_CONST_POTION, nil, SMARTBUFF_BELIXIR1},
    {SMARTBUFF_ELIXIR2,  60, SMARTBUFF_CONST_POTION, nil, SMARTBUFF_BELIXIR2},
    {SMARTBUFF_ELIXIR3,  60, SMARTBUFF_CONST_POTION, nil, SMARTBUFF_BELIXIR3},
    {SMARTBUFF_ELIXIR4,  60, SMARTBUFF_CONST_POTION, nil, SMARTBUFF_BELIXIR4},
    {SMARTBUFF_ELIXIR5,  60, SMARTBUFF_CONST_POTION, nil, SMARTBUFF_BELIXIR5},
    {SMARTBUFF_ELIXIR6,  60, SMARTBUFF_CONST_POTION, nil, SMARTBUFF_BELIXIR6},
    {SMARTBUFF_ELIXIR7,  60, SMARTBUFF_CONST_POTION, nil, SMARTBUFF_BELIXIR7},
    {SMARTBUFF_ELIXIR8,  60, SMARTBUFF_CONST_POTION, nil, SMARTBUFF_BELIXIR8},
    {SMARTBUFF_ELIXIR9,  60, SMARTBUFF_CONST_POTION, nil, SMARTBUFF_BELIXIR9},
    {SMARTBUFF_ELIXIR10, 60, SMARTBUFF_CONST_POTION, nil, SMARTBUFF_BELIXIR10},
    {SMARTBUFF_ELIXIR11, 60, SMARTBUFF_CONST_POTION, nil, SMARTBUFF_BELIXIR11},
    {SMARTBUFF_ELIXIR12, 60, SMARTBUFF_CONST_POTION, nil, SMARTBUFF_BELIXIR12},
    {SMARTBUFF_ELIXIR13, 60, SMARTBUFF_CONST_POTION, nil, SMARTBUFF_BELIXIR13},
    {SMARTBUFF_ELIXIR14, 60, SMARTBUFF_CONST_POTION, nil, SMARTBUFF_BELIXIR14},
    {SMARTBUFF_ELIXIR15, 60, SMARTBUFF_CONST_POTION, nil, SMARTBUFF_BELIXIR15},
    {SMARTBUFF_ELIXIR16, 60, SMARTBUFF_CONST_POTION, nil, SMARTBUFF_BELIXIR16}
  }
  
  SMARTBUFF_AddMsgD("Spell list initialized");
end
