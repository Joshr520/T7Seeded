detour zm_genesis<scripts\zm\zm_genesis.gsc>::initcharacterstartindex()
{
	level.characterstartindex = SRandomInt("character", 4);
}

detour zm_genesis<scripts\zm\zm_genesis.gsc>::function_9160f4d3()
{
	var_6af221a2 = [];
	var_bbe5e3fe = [[@zm_genesis<scripts\zm\zm_genesis.gsc>::function_2352d916]](2);
	var_e632342f = [[@zm_genesis<scripts\zm\zm_genesis.gsc>::function_2352d916]](1);
	var_6b2d3150 = var_bbe5e3fe + var_e632342f;
	if (var_bbe5e3fe > 0) {
		foreach (var_4b4c3616 in level.var_727bd376) {
			array::add(var_6af221a2, var_4b4c3616, 0);
		}
	}
	if (var_e632342f > 0) {
		foreach (sp_zombie in level.zombie_spawners) {
			array::add(var_6af221a2, sp_zombie, 0);
		}
	}
	n_randy = SRandomInt("zm_genesis_zombie_spawn_selection", var_6b2d3150);
	if (var_bbe5e3fe > 0 && n_randy <= var_bbe5e3fe) {
		sp_zombie = SArrayRandom(level.var_727bd376, "zm_genesis_zombie_spawn_selection");
	}
	else {
		if (var_e632342f > 0) {
			sp_zombie = SArrayRandom(level.zombie_spawners, "zm_genesis_zombie_spawn_selection");
		}
	}
	return sp_zombie;
}

detour zm_genesis<scripts\zm\zm_genesis.gsc>::function_fc65af2e()
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
		ArrayInsert(temp_array, "specialty_electriccherry", 0);
	}
	temp_array = SArrayRandomize(temp_array, "wunderfizz");
	level._random_perk_machine_perk_list = SArrayRandomize(level._random_perk_machine_perk_list, "wunderfizz");
	level._random_perk_machine_perk_list = ArrayCombine(level._random_perk_machine_perk_list, temp_array, 1, 0);
	keys = GetArrayKeys(level._random_perk_machine_perk_list);
	return keys;
}

detour zm_genesis<scripts\zm\zm_genesis.gsc>::function_659c2324(a_keys)
{
	if (level.chest_moves > 0 && zm_weapons::limited_weapon_below_quota(level.idgun_weapons[0])) {
		if (level.var_f06c86b9 > 12) {
			if (!IsDefined(a_keys)) {
				a_keys = [];
			}
			else if (!IsArray(a_keys)) {
				a_keys = array(a_keys);
			}
			a_keys[a_keys.size] = level.idgun_weapons[0];
		}
		if (level.var_f06c86b9 > 6) {
			if (!IsDefined(a_keys)) {
				a_keys = [];
			}
			else if (!IsArray(a_keys)) {
				a_keys = array(a_keys);
			}
			a_keys[a_keys.size] = level.idgun_weapons[0];
			a_keys = SArrayRandomize(a_keys, "magicbox");
		}
	}
	return a_keys;
}

detour zm_genesis<scripts\zm\zm_genesis.gsc>::assign_lowest_unused_character_index()
{
	charindexarray = [];
	charindexarray[0] = 0;
	charindexarray[1] = 1;
	charindexarray[2] = 2;
	charindexarray[3] = 3;
	players = GetPlayers();
	if (players.size == 1) {
		charindexarray = SArrayRandomize(charindexarray, "character");
		return charindexarray[0];
	}
	if (![[@zm_genesis<scripts\zm\zm_genesis.gsc>::function_5c35365f]](players)) {
		return charindexarray[2];
	}
	foreach (player in players) {
		if (IsDefined(player.characterindex)) {
			ArrayRemoveValue(charindexarray, player.characterindex, 0);
		}
	}
	if (charindexarray.size > 0) {
		return charindexarray[0];
	}
	return 0;
}

detour zm_genesis<scripts\zm\zm_genesis.gsc>::genesis_custom_spawn_location_selection(a_spots)
{
	if (SCoinToss("zm_genesis_spawn_location"))
	{
		if (!IsDefined(level.n_player_spawn_selection_index)) {
			level.n_player_spawn_selection_index = 0;
		}
		e_player = level.players[level.n_player_spawn_selection_index];
		level.n_player_spawn_selection_index++;
		if (level.n_player_spawn_selection_index > (level.players.size - 1)) {
			level.n_player_spawn_selection_index = 0;
		}
		if (!zm_utility::is_player_valid(e_player)) {
			s_spot = SArrayRandom(a_spots, "zm_genesis_spawn_location");
			return s_spot;
		}
		var_e8c67fc0 = array::get_all_closest(e_player.origin, a_spots, undefined, 5);
		if (var_e8c67fc0.size) {
			s_spot = SArrayRandom(var_e8c67fc0, "zm_genesis_spawn_location");
		}
		else {
			s_spot = SArrayRandom(a_spots, "zm_genesis_spawn_location");
		}
	}
	else {
		s_spot = SArrayRandom(a_spots, "zm_genesis_spawn_location");
	}
	return s_spot;
}