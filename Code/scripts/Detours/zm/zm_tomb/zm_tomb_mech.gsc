detour zm_tomb_mech<scripts\zm\zm_tomb_mech.gsc>::get_best_mechz_spawn_pos(ignore_used_positions = 0)
{
	best_dist = -1;
	best_pos = undefined;
	for (i = 0; i < level.mechz_locations.size; i++) {
		str_zone = zm_zonemgr::get_zone_from_position(level.mechz_locations[i].origin, 0);
		if (!IsDefined(str_zone)) {
			continue;
		}
		if (!ignore_used_positions && IS_TRUE(level.mechz_locations[i].has_been_used)) {
			continue;
		}
		if (ignore_used_positions == 1 && IS_TRUE(level.mechz_locations[i].used_cooldown)) {
			continue;
		}
		for (j = 0; j < level.players.size; j++) {
			if (zombie_utility::is_player_valid(level.players[j], 1, 1)) {
				dist = DistanceSquared(level.mechz_locations[i].origin, level.players[j].origin);
				if (dist < best_dist || best_dist < 0) {
					best_dist = dist;
					best_pos = level.mechz_locations[i];
				}
			}
		}
	}
	if (ignore_used_positions && IsDefined(best_pos)) {
		best_pos thread [[@zm_tomb_mech<scripts\zm\zm_tomb_mech.gsc>::jump_pos_used_cooldown]]();
	}
	if (IsDefined(best_pos)) {
		best_pos.has_been_used = 1;
	}
	else if (level.mechz_locations.size > 0) {
		var_634f9cbb = SArrayRandomize(level.mechz_locations, "zm_tomb_mech_spawn");
		foreach (location in var_634f9cbb) {
			str_zone = zm_zonemgr::get_zone_from_position(location.origin, 0);
			if (IsDefined(str_zone)) {
				return location;
			}
		}
		return level.mechz_locations[SRandomInt("zm_tomb_mech_spawn", level.mechz_locations.size)];
	}
	return best_pos;
}

detour zm_tomb_mech<scripts\zm\zm_tomb_mech.gsc>::mechz_round_tracker()
{
	level.num_mechz_spawned = 0;
	old_spawn_func = level.round_spawn_func;
	old_wait_func = level.round_wait_func;
	level flag::wait_till("activate_zone_nml");
	mech_start_round_num = 8;
	if (IS_TRUE(level.is_forever_solo_game)) {
		mech_start_round_num = 8;
	}
	while (level.round_number < mech_start_round_num) {
		level waittill("between_round_over");
	}
	level.next_mechz_round = level.round_number;
	for (;;) {
		if (level.num_mechz_spawned > 0) {
			level.mechz_should_drop_powerup = 1;
		}
		if (level.next_mechz_round <= level.round_number) {
			a_zombies = GetAISpeciesArray(level.zombie_team, "all");
			foreach (zombie in a_zombies) {
				if (IS_TRUE(zombie.is_mechz) && IsAlive(zombie)) {
					level.next_mechz_round++;
					break;
				}
			}
		}
		if (level.mechz_left_to_spawn == 0 && level.next_mechz_round <= level.round_number) {
			[[@zm_tomb_mech<scripts\zm\zm_tomb_mech.gsc>::mechz_health_increases]]();
			if (level.players.size == 1) {
				level.mechz_zombie_per_round = 1;
			}
			else if (level.mechz_round_count < 2) {
				level.mechz_zombie_per_round = 1;
			}
			else if (level.mechz_round_count < 5) {
				level.mechz_zombie_per_round = 2;
			}
			else {
				level.mechz_zombie_per_round = 3;
			}
			level.mechz_left_to_spawn = level.mechz_zombie_per_round;
			mechz_spawning = level.mechz_left_to_spawn;
			wait SRandomFloatRange("zm_tomb_mech_tracker", 10, 15);
			level notify("spawn_mechz");
			if (IS_TRUE(level.is_forever_solo_game)) {
				n_round_gap = SRandomIntRange("zm_tomb_mech_tracker", level.mechz_min_round_fq_solo, level.mechz_max_round_fq_solo);
			}
			else {
				n_round_gap = SRandomIntRange("zm_tomb_mech_tracker", level.mechz_min_round_fq, level.mechz_max_round_fq);
			}
			level.next_mechz_round = level.round_number + n_round_gap;
			level.mechz_round_count++;
			level.num_mechz_spawned = level.num_mechz_spawned + mechz_spawning;
		}
		level waittill("between_round_over");
	}
}

detour zm_tomb_mech<scripts\zm\zm_tomb_mech.gsc>::mechz_spawning_logic()
{
	level thread [[@zm_tomb_mech<scripts\zm\zm_tomb_mech.gsc>::enable_mechz_rounds]]();
	for (;;) {
		level waittill("spawn_mechz");
		while (level.mechz_left_to_spawn) {
			s_loc = function_27b9fdd3();
			if (!IsDefined(s_loc)) {
				continue;
			}
			ai = [[@zm_ai_mechz<scripts\zm\_zm_ai_mechz.gsc>::spawn_mechz]](s_loc, 1);
			waittillframeend;
			ai clientfield::set("tomb_mech_eye", 1);
			ai thread mechz_death();
			ai.no_widows_wine = 1;
			level.mechz_left_to_spawn--;
			if (level.mechz_left_to_spawn == 0) {
				level thread [[@zm_tomb_mech<scripts\zm\zm_tomb_mech.gsc>::response_to_air_raid_siren_vo]]();
			}
			ai thread [[@zm_tomb_mech<scripts\zm\zm_tomb_mech.gsc>::mechz_hint_vo]]();
			wait SRandomFloatRange("zm_tomb_mech_spawn", 3, 6);
		}
	}
}

detour zm_tomb_mech<scripts\zm\zm_tomb_mech.gsc>::mechz_death()
{
	return mechz_death();
}

mechz_death()
{
	self waittill(#"hash_46c1e51d");
	self clientfield::set("tomb_mech_eye", 0);
	level notify("mechz_killed", self.origin);
	if (level flag::get("zombie_drop_powerups") && !IS_TRUE(self.no_powerups)) {
		a_bonus_types = array("double_points", "insta_kill", "full_ammo", "nuke");
		str_type = SArrayRandom(a_bonus_types, "zm_tomb_mech_powerup");
		zm_powerups::specific_powerup_drop(str_type, self.origin);
	}
}

detour zm_tomb_mech<scripts\zm\zm_tomb_mech.gsc>::function_27b9fdd3()
{
	return function_27b9fdd3();
}

function_27b9fdd3()
{
	var_fffe05f0 = SArrayRandomize(level.mechz_locations, "zm_tomb_mech_spawn_location");
	a_spawn_locs = [];
	for (i = 0; i < var_fffe05f0.size; i++) {
		s_loc = var_fffe05f0[i];
		str_zone = zm_zonemgr::get_zone_from_position(s_loc.origin, 1);
		if (IsDefined(str_zone) && level.zones[str_zone].is_occupied) {
			a_spawn_locs[a_spawn_locs.size] = s_loc;
		}
	}
	if (a_spawn_locs.size == 0) {
		for (i = 0; i < var_fffe05f0.size; i++) {
			s_loc = var_fffe05f0[i];
			str_zone = zm_zonemgr::get_zone_from_position(s_loc.origin, 1);
			if (IsDefined(str_zone) && level.zones[str_zone].is_active) {
				a_spawn_locs[a_spawn_locs.size] = s_loc;
			}
		}
	}
	if (a_spawn_locs.size > 0) {
		return a_spawn_locs[0];
	}
	foreach (s_loc in var_fffe05f0) {
		str_zone = zm_zonemgr::get_zone_from_position(s_loc.origin, 0);
		if (IsDefined(str_zone)) {
			return s_loc;
		}
	}
	return var_fffe05f0[0];
}