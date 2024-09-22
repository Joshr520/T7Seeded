detour zm_zod<scripts\zm\zm_zod.gsc>::initcharacterstartindex()
{
	level.characterstartindex = SRandomInt("character", 4);
}

detour zm_zod<scripts\zm\zm_zod.gsc>::function_b05d27ad()
{
	if (!IsDefined(level.var_5b9dbdff)) {
		level.var_5b9dbdff = [];
		level.var_a7c80058 = [];
		foreach (e_spawner in level.zombie_spawners) {
			if (IsDefined(e_spawner.script_string) && e_spawner.script_string == "male") {
				if (!IsDefined(level.var_5b9dbdff)) {
					level.var_5b9dbdff = [];
				}
				else if (!IsArray(level.var_5b9dbdff)) {
					level.var_5b9dbdff = array(level.var_5b9dbdff);
				}
				level.var_5b9dbdff[level.var_5b9dbdff.size] = e_spawner;
				continue;
			}
			if (IsDefined(e_spawner.script_string) && e_spawner.script_string == "female") {
				if (!IsDefined(level.var_a7c80058)) {
					level.var_a7c80058 = [];
				}
				else if (!IsArray(level.var_a7c80058)) {
					level.var_a7c80058 = array(level.var_a7c80058);
				}
				level.var_a7c80058[level.var_a7c80058.size] = e_spawner;
			}
		}
		level.var_6b31b4b8 = 0;
		level.var_831a7edf = 0;
	}
	if (level.var_6b31b4b8 >= 1) {
		sp_zombie = SArrayRandom(level.var_a7c80058, "zm_zod_special_spawn");
		level.var_6b31b4b8 = 0;
		level.var_831a7edf = 1;
	}
	else if (level.var_831a7edf >= 1) {
        sp_zombie = SArrayRandom(level.var_5b9dbdff, "zm_zod_special_spawn");
        level.var_6b31b4b8 = 1;
        level.var_831a7edf = 0;
    }
    else {
        var_7970b66c = SRandomInt("zm_zod_special_spawn", 1000);
        if (var_7970b66c <= 600) {
            sp_zombie = SArrayRandom(level.var_5b9dbdff, "zm_zod_special_spawn");
            level.var_6b31b4b8++;
        }
        else {
            sp_zombie = SArrayRandom(level.var_a7c80058, "zm_zod_special_spawn");
            level.var_831a7edf++;
        }
    }
	return sp_zombie;
}

detour zm_zod<scripts\zm\zm_zod.gsc>::function_243d0df6()
{
	[[@zm_ai_wasp<scripts\zm\_zm_ai_wasp.gsc>::spawn_wasp]]();
	util::wait_network_frame();
	wait 2;
    if (level.zombie_total > 0) {
		[[@zm_ai_raps<scripts\zm\_zm_ai_raps.gsc>::spawn_raps]]();
		util::wait_network_frame();
		wait 2;
	}
	if (level.zombie_total > 0) {
		if (SRandomInt("zm_zod_wasp_spawn", 100) >= 50) {
			[[@zm_ai_wasp<scripts\zm\_zm_ai_wasp.gsc>::spawn_wasp]]();
		}
	}
}

detour zm_zod<scripts\zm\zm_zod.gsc>::function_612012aa()
{
	if (!IsDefined(level.var_1300aaeb)) {
		level.var_1300aaeb = level.next_wasp_round;
		if (level.n_next_raps_round > level.var_1300aaeb) {
			level.var_1300aaeb = level.n_next_raps_round;
		}
		level.var_1300aaeb = level.var_1300aaeb + 5;
	}
	else {
		level.var_1300aaeb = level.var_1300aaeb + SRandomIntRange("zm_zod_special_round", 5, 10);
	}
	return level.var_1300aaeb;
}

detour zm_zod<scripts\zm\zm_zod.gsc>::function_33aa4940()
{
	if (level.round_number <= 11) {
		return 0;
	}
	if (IsDefined(level.a_zombie_respawn_health["parasite"]) && level.a_zombie_respawn_health["parasite"].size > 0) {
		zm_zod_special_wasp_spawn(1);
		level.zombie_total--;
		return 1;
	}
	if (IsDefined(level.a_zombie_respawn_health["raps"]) && level.a_zombie_respawn_health["raps"].size > 0) {
		[[@zm_ai_raps<scripts\zm\_zm_ai_raps.gsc>::special_raps_spawn]](1);
		level.zombie_total--;
		return 1;
	}
	var_c0692329 = 0;
	n_random = SRandomFloat("zm_zod_custom_spawn", 100);
	if (level.round_number > 30) {
		if (n_random < 5) {
			var_c0692329 = 1;
		}
	}
	else if (level.round_number > 25) {
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
	if (var_c0692329) {
		if (!flag::get("ritual_pap_complete")) {
			zm_zod_special_wasp_spawn(1);
		}
		else if (SCoinToss("zm_zod_custom_spawn")) {
			[[@zm_ai_raps<scripts\zm\_zm_ai_raps.gsc>::special_raps_spawn]](1);
		}
		else {
			zm_zod_special_wasp_spawn(1);
		}
		level.zombie_total--;
	}
	return var_c0692329;
}

detour zm_zod<scripts\zm\zm_zod.gsc>::function_35c958af()
{
	self endon("death");
	var_f1af2991 = 0;
	for (;;) {
		n_delay = SRandomFloatRange("zm_zod_wasp_despawn", 0.9, 1.4);
		wait n_delay;
		if (IS_TRUE(level.bzm_worldpaused)) {
			continue;
		}
		v_trace_end = (self.origin[0], self.origin[1], self.origin[2] - 500);
		trace = GroundTrace(self.origin, v_trace_end, 0, 0, 0, 0);
		var_ccacea03 = trace["position"] + VectorScale((0, 0, 1), 20);
		b_in_active_zone = zm_utility::check_point_in_enabled_zone(var_ccacea03, 1, level.active_zones);
		if (b_in_active_zone) {
			var_f1af2991 = 0;
		}
		else {
			var_f1af2991++;
			if (var_f1af2991 >= 5) {
				[[@zm_ai_wasp<scripts\zm\_zm_ai_wasp.gsc>::wasp_add_to_spawn_pool]](self.enemy);
				self Kill();
				return;
			}
		}
	}
}

detour zm_zod<scripts\zm\zm_zod.gsc>::function_2d0e5eb6()
{
	var_5cf494cb = GetArrayKeys(level.zombie_powerups);
	var_b4442b55 = array("bonus_points_team", "shield_charge", "ww_grenade");
	powerup_keys = [];
	for (i = 0; i < var_5cf494cb.size; i++) {
		var_77917a61 = 0;
		foreach (var_68de493a in var_b4442b55) {
			if (var_5cf494cb[i] == var_68de493a) {
				var_77917a61 = 1;
			}
		}
		if (var_77917a61) {
			continue;
		}
		powerup_keys[powerup_keys.size] = var_5cf494cb[i];
	}
	powerup_keys = SArrayRandomize(powerup_keys, "zm_zod_feelin_lucky");
	return powerup_keys[0];
}

detour zm_zod<scripts\zm\zm_zod.gsc>::function_533186ee()
{
	var_5f66b0c7 = level clientfield::get("ee_quest_state");
	if (var_5f66b0c7 == 1) {
		var_18bac0f0 = array((2544, -3432, -368), (2708, -3432, -368), (2544, -3624, -368), (2708, -3624, -368));
		v_spawn = SArrayRandom(var_18bac0f0, "zm_zod_abh");
		s_spawnpoint = SpawnStruct();
		s_spawnpoint.origin = v_spawn;
		return s_spawnpoint;
	}
	return self zm_bgb_anywhere_but_here::function_728dfe3();
}

detour zm_zod<scripts\zm\zm_zod.gsc>::placed_powerups()
{
	zm_powerups::powerup_round_start();
	a_bonus_types = [];
	array::add(a_bonus_types, "double_points");
	array::add(a_bonus_types, "insta_kill");
	array::add(a_bonus_types, "full_ammo");
	a_bonus = struct::get_array("placed_powerup", "targetname");
	foreach (s_bonus in a_bonus) {
		str_type = SArrayRandom(a_bonus_types, "zm_zod_infinite_powerup");
		[[@zm_zod<scripts\zm\zm_zod.gsc>::spawn_infinite_powerup_drop]](s_bonus.origin, str_type);
	}
}

detour zm_zod<scripts\zm\zm_zod.gsc>::assign_lowest_unused_character_index()
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
	foreach (player in players) {
		if (IsDefined(player.characterindex)) {
			ArrayRemoveValue(charindexarray, player.characterindex, 0);
		}
	}
	if (charindexarray.size > 0) {
		charindexarray = SArrayRandomize(charindexarray, "character");
		return charindexarray[0];
	}
	return 0;
}

detour zm_zod<scripts\zm\zm_zod.gsc>::no_target_override(zombie)
{
	if (IsDefined(zombie.has_exit_point)) {
		return;
	}
	players = level.players;
	dist_zombie = 0;
	dist_player = 0;
	dest = 0;
	if (IsDefined(level.zm_loc_types["wait_location"])) {
		locs = SArrayRandomize(level.zm_loc_types["wait_location"], "zm_zod_no_target");
		for (i = 0; i < locs.size; i++) {
			found_point = 0;
			foreach (player in players) {
				if (player laststand::player_is_in_laststand()) {
					continue;
				}
				away = VectorNormalize(self.origin - player.origin);
				endpos = self.origin + VectorScale(away, 600);
				dist_zombie = DistanceSquared(locs[i].origin, endpos);
				dist_player = DistanceSquared(locs[i].origin, player.origin);
				if (dist_zombie < dist_player) {
					dest = i;
					found_point = 1;
					continue;
				}
				found_point = 0;
			}
			if (found_point) {
				if (zombie [[@zm_zod<scripts\zm\zm_zod.gsc>::validate_and_set_no_target_position]](locs[i])) {
					return;
				}
			}
		}
	}
	escape_position = zombie [[@zod_cleanup<scripts\zm\zm_zod_cleanup_mgr.gsc>::get_escape_position_in_current_zone]]();
	if (zombie [[@zm_zod<scripts\zm\zm_zod.gsc>::validate_and_set_no_target_position]](escape_position)) {
		return;
	}
	escape_position = zombie [[@zod_cleanup<scripts\zm\zm_zod_cleanup_mgr.gsc>::get_escape_position]]();
	if (zombie [[@zm_zod<scripts\zm\zm_zod.gsc>::validate_and_set_no_target_position]](escape_position)) {
		return;
	}
	zombie.has_exit_point = 1;
	zombie SetGoal(zombie.origin);
}

detour zm_zod<scripts\zm\zm_zod.gsc>::zm_override_ai_aftermath_powerup_drop(e_enemy, v_pos)
{
	if (IsDefined(e_enemy) && IsDefined(e_enemy.archetype) && e_enemy.archetype == "parasite") {
		e_ent = e_enemy.favoriteenemy;
		if (!IsDefined(e_ent)) {
			e_ent = SArrayRandom(level.players, "zm_zod_powerup_override");
		}
		e_ent [[@zm_ai_wasp<scripts\zm\_zm_ai_wasp.gsc>::parasite_drop_item]](v_pos);
	}
	else {
		power_up_origin = v_pos;
		trace = GroundTrace(power_up_origin + VectorScale((0, 0, 1), 100), power_up_origin + (VectorScale((0, 0, -1), 1000)), 0, undefined);
		power_up_origin = trace["position"];
		if (IsDefined(power_up_origin)) {
			level thread zm_powerups::specific_powerup_drop("full_ammo", power_up_origin);
		}
	}
}

detour zm_zod<scripts\zm\zm_zod.gsc>::function_2c092767(a_spots)
{
	if (level.zombie_respawns > 0) {
		if (!IsDefined(level.n_player_spawn_selection_index)) {
			level.n_player_spawn_selection_index = 0;
		}
		a_players = GetPlayers();
		level.n_player_spawn_selection_index++;
		if (level.n_player_spawn_selection_index >= a_players.size) {
			level.n_player_spawn_selection_index = 0;
		}
		e_player = a_players[level.n_player_spawn_selection_index];
		ArraySortClosest(a_spots, e_player.origin);
		a_candidates = [];
		v_player_dir = AnglesToForward(e_player.angles);
		for (i = 0; i < a_spots.size; i++) {
			v_dir = a_spots[i].origin - e_player.origin;
			dp = VectorDot(v_player_dir, v_dir);
			if (dp >= 0) {
				a_candidates[a_candidates.size] = a_spots[i];
				if (a_candidates.size > 10) {
					break;
				}
			}
		}
		if (a_candidates.size) {
			s_spot = SArrayRandom(a_candidates, "zm_zod_respawn_location");
		}
		else {
			s_spot = SArrayRandom(a_spots, "zm_zod_respawn_location");
		}
	}
	else {
		s_spot = SArrayRandom(a_spots, "zm_zod_respawn_location");
	}
	return s_spot;
}