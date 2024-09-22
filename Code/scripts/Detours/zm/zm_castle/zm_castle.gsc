detour zm_castle<scripts\zm\zm_castle.gsc>::function_798c5d1a()
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

detour zm_castle<scripts\zm\zm_castle.gsc>::check_player_available()
{
	self endon("death");
	while (IS_TRUE(self.b_zombie_path_bad)) {
		wait SRandomFloatRange("zm_castle_bad_path", 0.2, 0.5);
		if (self [[@zm_castle<scripts\zm\zm_castle.gsc>::can_zombie_see_any_player]]()) {
			self.b_zombie_path_bad = undefined;
			self notify("reaquire_player");
			return;
		}
	}
}

detour zm_castle<scripts\zm\zm_castle.gsc>::function_4353b980()
{
	if (!IsDefined(level.var_2c78e44c)) {
		level.var_a70b4aef = [];
		level.var_2c78e44c = [];
		foreach (e_spawner in level.zombie_spawners) {
			if (e_spawner.targetname === "skeleton_spawner") {
				if (!IsDefined(level.var_2c78e44c)) {
					level.var_2c78e44c = [];
				}
				else if (!IsArray(level.var_2c78e44c)) {
					level.var_2c78e44c = array(level.var_2c78e44c);
				}
				level.var_2c78e44c[level.var_2c78e44c.size] = e_spawner;
				continue;
			}
			if (!IsDefined(level.var_a70b4aef)) {
				level.var_a70b4aef = [];
			}
			else if (!IsArray(level.var_a70b4aef)) {
				level.var_a70b4aef = array(level.var_a70b4aef);
			}
			level.var_a70b4aef[level.var_a70b4aef.size] = e_spawner;
		}
	}
	if (level.var_9bf9e084 === 1) {
		sp_zombie = SArrayRandom(level.var_2c78e44c, "zm_castle_custom_spawn_location");
	}
	else {
		sp_zombie = SArrayRandom(level.var_a70b4aef, "zm_castle_custom_spawn_location");
	}
	return sp_zombie;
}

detour zm_castle<scripts\zm\zm_castle.gsc>::function_8921895f()
{
	var_cdb0f86b = GetArrayKeys(level.zombie_powerups);
	var_b4442b55 = array("bonus_points_team", "shield_charge", "ww_grenade", "demonic_rune_lor", "demonic_rune_mar", "demonic_rune_oth", "demonic_rune_uja", "demonic_rune_ulla", "demonic_rune_zor");
	var_d7a75a6e = [];
	for (i = 0; i < var_cdb0f86b.size; i++) {
		var_77917a61 = 0;
		foreach (var_68de493a in var_b4442b55) {
			if (var_cdb0f86b[i] == var_68de493a) {
				var_77917a61 = 1;
			}
		}
		if (var_77917a61) {
			continue;
		}
		var_d7a75a6e[var_d7a75a6e.size] = var_cdb0f86b[i];
	}
	var_d7a75a6e = SArrayRandomize(var_d7a75a6e, "zm_castle_feelin_lucky");
	return var_d7a75a6e[0];
}

detour zm_castle<scripts\zm\zm_castle.gsc>::function_c624f0b2(a_spots)
{
	if (SCoinToss("zm_castle_spawn_location")) {
		if (!IsDefined(level.n_player_spawn_selection_index)) {
			level.n_player_spawn_selection_index = 0;
		}
		e_player = level.players[level.n_player_spawn_selection_index];
		level.n_player_spawn_selection_index++;
		if (level.n_player_spawn_selection_index > (level.players.size - 1)) {
			level.n_player_spawn_selection_index = 0;
		}
		if (!zm_utility::is_player_valid(e_player)) {
			s_spot = SArrayRandom(a_spots, "zm_castle_spawn_location");
			return s_spot;
		}
		var_e8c67fc0 = array::get_all_closest(e_player.origin, a_spots, undefined, 5);
		if (var_e8c67fc0.size) {
			s_spot = SArrayRandom(var_e8c67fc0, "zm_castle_spawn_location");
		}
		else {
			s_spot = SArrayRandom(a_spots, "zm_castle_spawn_location");
		}
	}
	else {
		s_spot = SArrayRandom(a_spots, "zm_castle_spawn_location");
	}
	return s_spot;
}