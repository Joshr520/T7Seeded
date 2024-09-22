detour zm_prototype<scripts\zm\zm_prototype.gsc>::initcharacterstartindex()
{
	level.characterstartindex = SRandomInt("character", 4);
}

detour zm_prototype<scripts\zm\zm_prototype.gsc>::assign_lowest_unused_character_index()
{
	charindexarray = [];
	charindexarray[0] = 0;
	charindexarray[1] = 1;
	charindexarray[2] = 2;
	charindexarray[3] = 3;
	if (level.players.size == 1) {
		charindexarray = SArrayRandomize(charindexarray, "character");
		return charindexarray[0];
	}
	foreach (player in level.players) {
		if (IsDefined(player.characterindex)) {
			ArrayRemoveValue(charindexarray, player.characterindex, 0);
		}
	}
	if (charindexarray.size > 0) {
		return charindexarray[0];
	}
	return 0;
}

detour zm_prototype<scripts\zm\zm_prototype.gsc>::function_54da140a()
{
	var_6af221a2 = [];
	a_s_spots = SArrayRandomize(level.zm_loc_types["zombie_location"], "zm_prototype_spawn_location");
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
			sp_zombie = SArrayRandom(var_c15b2128, "zm_prototype_spawn_location");
			return sp_zombie;
		}
	}
}

detour zm_prototype<scripts\zm\zm_prototype.gsc>::function_c027d01d()
{
	temp_array = [];
	temp_array = SArrayRandomize(temp_array, "wunderfizz");
	level._random_perk_machine_perk_list = SArrayRandomize(level._random_perk_machine_perk_list, "wunderfizz");
	level._random_perk_machine_perk_list = ArrayCombine(level._random_perk_machine_perk_list, temp_array, 1, 0);
	keys = GetArrayKeys(level._random_perk_machine_perk_list);
	return keys;
}