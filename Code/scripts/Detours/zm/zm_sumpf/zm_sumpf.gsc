detour zm_sumpf<scripts\zm\zm_sumpf.gsc>::initcharacterstartindex()
{
	level.characterstartindex = SRandomInt("character", 4);
}

detour zm_sumpf<scripts\zm\zm_sumpf.gsc>::assign_lowest_unused_character_index()
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
		if (isdefined(player.characterindex)) {
			ArrayRemoveValue(charindexarray, player.characterindex, 0);
		}
	}
	if (charindexarray.size > 0) {
		return charindexarray[0];
	}
	return 0;
}

detour zm_sumpf<scripts\zm\zm_sumpf.gsc>::function_c027d01d()
{
	temp_array = [];
	temp_array = SArrayRandomize(temp_array, "wunderfizz");
	level._random_perk_machine_perk_list = SArrayRandomize(level._random_perk_machine_perk_list, "wunderfizz");
	level._random_perk_machine_perk_list = ArrayCombine(level._random_perk_machine_perk_list, temp_array, 1, 0);
	keys = GetArrayKeys(level._random_perk_machine_perk_list);
	return keys;
}