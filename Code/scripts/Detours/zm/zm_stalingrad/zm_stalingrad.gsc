detour zm_stalingrad<scripts\zm\zm_stalingrad.gsc>::initcharacterstartindex()
{
	level.characterstartindex = SRandomInt("character", 4);
}

detour zm_stalingrad<scripts\zm\zm_stalingrad.gsc>::function_659c2324(a_keys)
{
	var_b45fbf8c = zm_pap_util::get_triggers();
	if (a_keys[0] === level.w_raygun_mark3) {
		level.var_12d3a848 = 0;
		return a_keys;
	}
	n_chance = 0;
	if (zm_weapons::limited_weapon_below_quota(level.w_raygun_mark3)) {
		level.var_12d3a848++;
		if (level.var_12d3a848 <= 12) {
			n_chance = 5;
		}
		else if (level.var_12d3a848 > 12 && level.var_12d3a848 <= 17) {
            n_chance = 8;
        }
        else if (level.var_12d3a848 > 17) {
            n_chance = 12;
        }
	}
	else {
		level.var_12d3a848 = 0;
	}
	if (SRandomInt("zm_magicbox", 100) <= n_chance && zm_magicbox::treasure_chest_canplayerreceiveweapon(self, level.w_raygun_mark3, var_b45fbf8c) && !self HasWeapon(level.w_raygun_mark3_upgraded)) {
		ArrayInsert(a_keys, level.w_raygun_mark3, 0);
		level.var_12d3a848 = 0;
	}
	return a_keys;
}

detour zm_stalingrad<scripts\zm\zm_stalingrad.gsc>::function_dded17b1()
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

detour zm_stalingrad<scripts\zm\zm_stalingrad.gsc>::function_33aa4940()
{
	if (level.players.size == 1) {
		if (level.round_number < 9) {
			return false;
		}
	}
	else if (level.round_number < 6) {
		return false;
	}
	if (ISDefined(level.a_zombie_respawn_health["raz"]) && level.a_zombie_respawn_health["raz"].size > 0) {
		if (function_7ed6c714(1) == 1) {
			level.zombie_total--;
			return true;
		}
	}
	else if (ISDefined(level.a_zombie_respawn_health["sentinel_drone"]) && level.a_zombie_respawn_health["sentinel_drone"].size > 0) {
		if ([[@zm_ai_sentinel_drone<scripts\zm\_zm_ai_sentinel_drone.gsc>::function_19d0b055]](1) == 1) {
			level.zombie_total--;
			return true;
		}
	}
	if (level.zombie_total <= 10) {
		return false;
	}
	var_c0692329 = 0;
	n_random = SRandomFloat("zm_stalingrad_special_spawn", 100);
	if (level.round_number > 25) {
		if (n_random < 5) {
			var_c0692329 = 1;
		}
	}
	else if (level.round_number > 20) {
        if (n_random < 4) {
            var_c0692329 = 1;
        }
    }
    else if (level.round_number > 15) {
        if (n_random < 3) {
            var_c0692329 = 1;
        }
    }
    else if (n_random < 2) {
        var_c0692329 = 1;
    }
	if (var_c0692329)
	{
		n_roll = SRandomInt("zm_stalingrad_special_spawn", 100);
		if (level.round_number < 11 || n_roll < 50) {
			if ([[@zm_ai_raz<scripts\zm\_zm_ai_raz.gsc>::function_ea911683]]() && level.var_88fe7b16 < level.var_d60a655e && function_7ed6c714(1) == 1) {
				level.var_88fe7b16++;
				level.zombie_total--;
				return true;
			}
			return false;
		}
        if ([[@zm_ai_sentinel_drone<scripts\zm\_zm_ai_sentinel_drone.gsc>::function_74ab7484]]() && level.var_bd1e3d02 < level.var_b23e9e3a && [[@zm_ai_sentinel_drone<scripts\zm\_zm_ai_sentinel_drone.gsc>::function_19d0b055]](1) == 1) {
			level.var_bd1e3d02++;
			level.zombie_total--;
			return true;
		}
		return false;
	}
	return false;
}

detour zm_stalingrad<scripts\zm\zm_stalingrad.gsc>::check_player_available()
{
	self endon("death");
	while (IS_TRUE(self.b_zombie_path_bad)) {
		wait SRandomFloatRange("zm_stalingrad_bad_path", 0.2, 0.5);
		if (self [[@zm_stalingrad<scripts\zm\zm_stalingrad.gsc>::can_zombie_see_any_player]]()) {
			self.b_zombie_path_bad = undefined;
			self notify("reaquire_player");
			return;
		}
	}
}

detour zm_stalingrad<scripts\zm\zm_stalingrad.gsc>::function_be9932bc()
{
	var_9b100591 = [];
	var_9b100591[0] = 0;
	var_9b100591[1] = 1;
	var_9b100591[2] = 2;
	var_9b100591[3] = 3;
	a_e_players = GetPlayers();
	if (a_e_players.size == 1) {
		var_9b100591 = SArrayRandomize(var_9b100591, "character");
		if (var_9b100591[0] == 2) {
			level.has_richtofen = 1;
		}
		return var_9b100591[0];
	}
	n_characters_defined = 0;
	foreach (e_player in a_e_players) {
		if (ISDefined(e_player.characterindex)) {
			ArrayRemoveValue(var_9b100591, e_player.characterindex, 0);
			n_characters_defined++;
		}
	}
	if (var_9b100591.size > 0) {
		if (n_characters_defined == (a_e_players.size - 1)) {
			if (!IS_TRUE(level.has_richtofen)) {
				level.has_richtofen = 1;
				return 2;
			}
		}
		var_9b100591 = SArrayRandomize(var_9b100591, "character");
		if (var_9b100591[0] == 2) {
			level.has_richtofen = 1;
		}
		return var_9b100591[0];
	}
	return 0;
}

detour zm_stalingrad<scripts\zm\zm_stalingrad.gsc>::function_2d0e5eb6()
{
	var_cdb0f86b = GetArrayKeys(level.zombie_powerups);
	var_b4442b55 = array("shield_charge", "ww_grenade", "bonus_points_team", "code_cylinder_red", "code_cylinder_yellow", "code_cylinder_blue");
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
		if (!ISDefined(var_62e2eaf2)) {
			var_62e2eaf2 = [];
		}
		else if (!IsArray(var_62e2eaf2)) {
			var_62e2eaf2 = array(var_62e2eaf2);
		}
		var_62e2eaf2[var_62e2eaf2.size] = var_cdb0f86b[i];
	}
	str_powerup = SArrayRandom(var_62e2eaf2, "zm_stalingrad_feelin_lucky");
	return str_powerup;
}

detour zm_stalingrad<scripts\zm\zm_stalingrad.gsc>::function_ff18dfdd(a_spots)
{
	if (SCoinToss("zm_stalingrad_spawn_location") && level.players.size > 1) {
		if (!ISDefined(level.n_player_spawn_selection_index)) {
			level.n_player_spawn_selection_index = 0;
		}
		e_player = level.players[level.n_player_spawn_selection_index];
		level.n_player_spawn_selection_index++;
		if (level.n_player_spawn_selection_index > (level.players.size - 1)) {
			level.n_player_spawn_selection_index = 0;
		}
		if (!zm_utility::is_player_valid(e_player)) {
			s_spot = SArrayRandom(a_spots, "zm_stalingrad_spawn_location");
			return s_spot;
		}
		var_e8c67fc0 = array::get_all_closest(e_player.origin, a_spots, undefined, 5);
		if (var_e8c67fc0.size) {
			s_spot = SArrayRandom(var_e8c67fc0, "zm_stalingrad_spawn_location");
		}
		else {
			s_spot = SArrayRandom(a_spots, "zm_stalingrad_spawn_location");
		}
	}
	else {
		s_spot = SArrayRandom(a_spots, "zm_stalingrad_spawn_location");
	}
	return s_spot;
}