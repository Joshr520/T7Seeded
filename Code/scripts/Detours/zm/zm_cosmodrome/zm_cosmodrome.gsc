detour zm_cosmodrome<scripts\zm\zm_cosmodrome.gsc>::initcharacterstartindex()
{
	level.characterstartindex = SRandomInt("character", 4);
}

detour zm_cosmodrome<scripts\zm\zm_cosmodrome.gsc>::function_54da140a()
{
	var_6af221a2 = [];
	a_s_spots = SArrayRandomize(level.zm_loc_types["zombie_location"], "zm_cosmodrome_custom_spawn");
	for ( i = 0; i < a_s_spots.size; i++) {
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
			sp_zombie = SArrayRandom(var_c15b2128, "zm_cosmodrome_custom_spawn");
			return sp_zombie;
		}
	}
}

detour zm_cosmodrome<scripts\zm\zm_cosmodrome.gsc>::assign_lowest_unused_character_index()
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

detour zm_cosmodrome<scripts\zm\zm_cosmodrome.gsc>::function_c027d01d()
{
	temp_array = [];
	temp_array = SArrayRandomize(temp_array, "wunderfizz");
	level._random_perk_machine_perk_list = SArrayRandomize(level._random_perk_machine_perk_list, "wunderfizz");
	level._random_perk_machine_perk_list = ArrayCombine(level._random_perk_machine_perk_list, temp_array, 1, 0);
	keys = GetArrayKeys(level._random_perk_machine_perk_list);
	return keys;
}