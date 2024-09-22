detour zm_tomb<scripts\zm\zm_tomb.gsc>::tomb_random_perk_weights()
{
	temp_array = [];
	if (SRandomInt("wunderfizz", 4) == 0) {
		ArrayInsert(temp_array, "specialty_doubletap2", 0);
	}
	if (SRandomInt("wunderfizz", 4) == 0) {
		ArrayInsert(temp_array, "specialty_deadshot", 0);
	}
	if (SRandomInt("wunderfizz", 4) == 0) {
		ArrayInsert(temp_array, "specialty_additionalprimaryweapon", 0);
	}
	if (SRandomInt("wunderfizz", 4) == 0) {
		ArrayInsert(temp_array, "specialty_widowswine", 0);
	}
	if (SRandomInt("wunderfizz", 4) == 0) {
		ArrayInsert(temp_array, "specialty_electriccherry", 0);
	}
	temp_array = SArrayRandomize(temp_array, "wunderfizz");
	level._random_perk_machine_perk_list = SArrayRandomize(level._random_perk_machine_perk_list, "wunderfizz");
	level._random_perk_machine_perk_list = ArrayCombine(level._random_perk_machine_perk_list, temp_array, 1, 0);
	keys = GetArrayKeys(level._random_perk_machine_perk_list);
	return keys;
}

detour zm_tomb<scripts\zm\zm_tomb.gsc>::initcharacterstartindex()
{
	level.characterstartindex = SRandomInt("character", 4);
}

detour zm_tomb<scripts\zm\zm_tomb.gsc>::function_2d0e5eb6()
{
	var_cdb0f86b = getarraykeys(level.zombie_powerups);
	var_b4442b55 = array("shield_charge", "ww_grenade", "bonus_points_team");
	var_62e2eaf2 = [];
	for (i = 0; i < var_cdb0f86b.size; i++) {
		var_77917a61 = 0;
		foreach (var_68de493a in var_b4442b55) {
			if (var_cdb0f86b[i] == var_68de493a) {
				var_77917a61 = 1;
				break;
			}
		}
		if (var_77917a61) {
			continue;
		}
		if (!IsDefined(var_62e2eaf2)) {
			var_62e2eaf2 = [];
		}
		else if (!IsArray(var_62e2eaf2)) {
			var_62e2eaf2 = array(var_62e2eaf2);
		}
		var_62e2eaf2[var_62e2eaf2.size] = var_cdb0f86b[i];
	}
	str_powerup = SArrayRandom(var_62e2eaf2, "zm_tomb_feelin_lucky");
	return str_powerup;
}

detour zm_tomb<scripts\zm\zm_tomb.gsc>::function_df9f5719()
{
	var_6af221a2 = [];
	a_s_spots = SArrayRandomize(level.zm_loc_types["zombie_location"], "zm_tomb_custom_spawn");
	for (i = 0; i < a_s_spots.size; i++) {
		if (!IsDefined(a_s_spots[i].script_int)) {
			var_343b1937 = 1;
		}
		else {
			var_343b1937 = a_s_spots[i].script_int;
		}
		var_c15b2128 = [];
		foreach (sp_zombie in level.zombie_spawners) {
			if (sp_zombie.script_int == var_343b1937) {
				if (!IsDefined(var_c15b2128)) {
					var_c15b2128 = [];
				}
				else if (!IsArray(var_c15b2128)) {
					var_c15b2128 = array(var_c15b2128);
				}
				var_c15b2128[var_c15b2128.size] = sp_zombie;
			}
		}
		if (var_c15b2128.size) {
			sp_zombie = SArrayRandom(var_c15b2128, "zm_tomb_custom_spawn");
			return sp_zombie;
		}
	}
}

detour zm_tomb<scripts\zm\zm_tomb.gsc>::assign_lowest_unused_character_index()
{
	charindexarray = [];
	charindexarray[0] = 0;
	charindexarray[1] = 1;
	charindexarray[2] = 2;
	charindexarray[3] = 3;
	players = GetPlayers();
	if (players.size == 1) {
		charindexarray = SArrayRandomize(charindexarray, "character");
		if (charindexarray[0] == 2) {
			level.has_richtofen = 1;
		}
		return charindexarray[0];
	}
	n_characters_defined = 0;
	foreach (player in players) {
		if (IsDefined(player.characterindex)) {
			ArrayRemoveValue(charindexarray, player.characterindex, 0);
			n_characters_defined++;
		}
	}
	if (charindexarray.size > 0) {
		if (n_characters_defined == (players.size - 1)) {
			if (!IS_TRUE(level.has_richtofen)) {
				level.has_richtofen = 1;
				return 2;
			}
		}
		charindexarray = SArrayRandomize(charindexarray, "character");
		if (charindexarray[0] == 2) {
			level.has_richtofen = 1;
		}
		return charindexarray[0];
	}
	return 0;
}