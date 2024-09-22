detour zm_stalingrad_util<scripts\zm\zm_stalingrad_util.gsc>::function_adf4d1d0(a_ai_zombies)
{
	var_63baafec = !IsDefined(a_ai_zombies);
	if (var_63baafec) {
		a_ai_zombies = GetAITeamArray(level.zombie_team);
	}
	var_6b1085eb = [];
	foreach (ai_zombie in a_ai_zombies) {
		ai_zombie.no_powerups = 1;
		ai_zombie.deathpoints_already_given = 1;
		if (IS_TRUE(ai_zombie.var_81e263d5)) {
			continue;
		}
		if (IS_TRUE(ai_zombie.marked_for_death)) {
			continue;
		}
		if (IsDefined(ai_zombie.nuke_damage_func)) {
			ai_zombie thread [[ai_zombie.nuke_damage_func]]();
			continue;
		}
		if (zm_utility::is_magic_bullet_shield_enabled(ai_zombie)) {
			continue;
		}
		ai_zombie.marked_for_death = 1;
		ai_zombie.nuked = 1;
		var_6b1085eb[var_6b1085eb.size] = ai_zombie;
	}
	foreach (var_f92b3d80 in var_6b1085eb) {
		if (!IsDefined(var_f92b3d80)) {
			continue;
		}
		if (zm_utility::is_magic_bullet_shield_enabled(var_f92b3d80)) {
			continue;
		}
		if (IS_TRUE(var_f92b3d80.var_81e263d5)) {
			continue;
		}
		var_f92b3d80 DoDamage(var_f92b3d80.health, var_f92b3d80.origin);
		if (!IS_TRUE(var_f92b3d80.exclude_cleanup_adding_to_total) && !level flag::get("special_round")) {
			level.zombie_total++;
		}
		wait SRandomFloatRange("zm_stalingrad_util_cleanup", 0.05, 0.15);
	}
	if (var_63baafec) {
		var_89de5b91 = GetAIArchetypeArray("raz");
		foreach (var_1c963231 in var_89de5b91) {
			if (IS_TRUE(var_1c963231.var_81e263d5)) {
				continue;
			}
			if (!IS_TRUE(var_1c963231.exclude_cleanup_adding_to_total) && !level flag::get("special_round")) {
				level.zombie_total++;
			}
			var_1c963231.no_powerups = 1;
			var_1c963231 Kill();
		}
		var_1916d2ed = GetAIArchetypeArray("sentinel_drone");
		foreach (var_663b2442 in var_1916d2ed) {
			if (IS_TRUE(var_663b2442.var_81e263d5)) {
				continue;
			}
			if (!IS_TRUE(var_663b2442.exclude_cleanup_adding_to_total) && !level flag::get("special_round")) {
				level.zombie_total++;
			}
			var_663b2442.no_powerups = 1;
			var_663b2442 Kill();
		}
	}
}

detour zm_stalingrad_util<scripts\zm\zm_stalingrad_util.gsc>::function_f70dde0b(var_f328e82, a_s_spawnpoints, var_9c84987b, var_2494b61e = 24, var_dc7b7a0f = 0.05, n_max_zombies, str_notify, var_d965b1c7 = 0)
{
	return function_f70dde0b(var_f328e82, a_s_spawnpoints, var_9c84987b, var_2494b61e, var_dc7b7a0f, n_max_zombies, str_notify, var_d965b1c7);
}

function_f70dde0b(var_f328e82, a_s_spawnpoints, var_9c84987b, var_2494b61e = 24, var_dc7b7a0f = 0.05, n_max_zombies, str_notify, var_d965b1c7 = 0)
{
	level notify(#"hash_91fef4b1");
	level endon(#"hash_91fef4b1");
	level flag::clear("wave_event_zombies_complete");
	if (IsDefined(str_notify)) {
		level endon(str_notify);
	}
	if (!IsDefined(n_max_zombies)) {
		var_54939bf3 = 1;
	}
	var_9a8fc4a4 = [];
	var_613bb82b = 0;
	if (IsDefined(level.var_c3c3ffc5)) {
		level.var_c3c3ffc5 = array::filter(level.var_c3c3ffc5, 0, @zm_stalingrad_util<scripts\zm\zm_stalingrad_util.gsc>::function_91d64824);
		var_9a8fc4a4 = ArrayCopy(level.var_c3c3ffc5);
		var_9a8fc4a4 = array::filter(var_9a8fc4a4, 0, @zm_stalingrad_util<scripts\zm\zm_stalingrad_util.gsc>::function_46cd1314);
		level.var_b1d4e9a1 = var_9a8fc4a4.size;
	}
	else {
		level.var_c3c3ffc5 = [];
		level.var_b1d4e9a1 = 0;
	}
	level.var_258441ba = 0;
	if (IsArray(var_f328e82)) {
		e_spawner = SArrayRandom(var_f328e82, "zm_stalingrad_util_wave_spawn");
	}
	else {
		e_spawner = var_f328e82;
	}
	while (IS_TRUE(var_54939bf3) || var_613bb82b < n_max_zombies) {
		var_9a8fc4a4 = array::filter(var_9a8fc4a4, 0, @zm_stalingrad_util<scripts\zm\zm_stalingrad_util.gsc>::function_91d64824);
		while (var_9a8fc4a4.size < var_2494b61e && (IS_TRUE(var_54939bf3) || var_613bb82b < n_max_zombies)) {
			var_9a8fc4a4 = array::filter(var_9a8fc4a4, 0, @zm_stalingrad_util<scripts\zm\zm_stalingrad_util.gsc>::function_91d64824);
			level [[@zm_stalingrad_util<scripts\zm\zm_stalingrad_util.gsc>::function_58cdc394]]();
			level [[@zm_stalingrad_util<scripts\zm\zm_stalingrad_util.gsc>::function_9b76f612]]("zombie");
			s_spawn_point = get_unused_spawn_point(a_s_spawnpoints);
			ai = zombie_utility::spawn_zombie(e_spawner, var_9c84987b, s_spawn_point);
			if (IsDefined(ai)) {
				if (!IsDefined(var_9a8fc4a4)) {
					var_9a8fc4a4 = [];
				}
				else if (!IsArray(var_9a8fc4a4)) {
					var_9a8fc4a4 = array(var_9a8fc4a4);
				}
				var_9a8fc4a4[var_9a8fc4a4.size] = ai;
				if (!IsDefined(level.var_c3c3ffc5)) {
					level.var_c3c3ffc5 = [];
				}
				else if (!IsArray(level.var_c3c3ffc5)) {
					level.var_c3c3ffc5 = array(level.var_c3c3ffc5);
				}
				level.var_c3c3ffc5[level.var_c3c3ffc5.size] = ai;
				var_613bb82b++;
				ai thread [[@zm_stalingrad_util<scripts\zm\zm_stalingrad_util.gsc>::function_ff194e31]](var_d965b1c7);
			}
			wait var_dc7b7a0f;
		}
		wait 0.05;
	}
	while (var_9a8fc4a4.size > 0) {
		var_9a8fc4a4 = array::filter(var_9a8fc4a4, 0, @zm_stalingrad_util<scripts\zm\zm_stalingrad_util.gsc>::function_91d64824);
		wait 0.5;
	}
	level flag::set("wave_event_zombies_complete");
}

detour zm_stalingrad_util<scripts\zm\zm_stalingrad_util.gsc>::get_unused_spawn_point(a_s_spawnpoints)
{
	return get_unused_spawn_point(a_s_spawnpoints);
}

get_unused_spawn_point(a_s_spawnpoints)
{
	b_all_points_used = 0;
	a_valid_spawn_points = [];
	while (!a_valid_spawn_points.size) {
		foreach (s_spawn_point in a_s_spawnpoints) {
			if (!IsDefined(s_spawn_point.spawned_zombie) || b_all_points_used) {
				s_spawn_point.spawned_zombie = 0;
			}
			if (!s_spawn_point.spawned_zombie) {
				array::add(a_valid_spawn_points, s_spawn_point, 0);
			}
		}
		if (!a_valid_spawn_points.size) {
			b_all_points_used = 1;
		}
		wait 0.05;
	}
	s_spawn_point = SArrayRandom(a_valid_spawn_points, "zm_stalingrad_util_unused_spawn");
	s_spawn_point.spawned_zombie = 1;
	return s_spawn_point;
}

detour zm_stalingrad_util<scripts\zm\zm_stalingrad_util.gsc>::function_432cdad9(a_spawnpoints, var_e41e673a)
{
	players = GetPlayers();
	var_19764360 = [[@zm_ai_raz<scripts\zm\_zm_ai_raz.gsc>::get_favorite_enemy]]();
	if (IsDefined(level.var_a3559c05)) {
		s_spawn_loc = [[level.var_a3559c05]](level.var_6bca5baa, var_19764360);
	}
	else if (IsDefined(a_spawnpoints)) {
		s_spawn_loc = function_77b29938(a_spawnpoints);
	}
	else if (level.zm_loc_types["raz_location"].size > 0) {
		s_spawn_loc = SArrayRandom(level.zm_loc_types["raz_location"], "zm_stalingrad_util_raz_spawn");
	}
	if (!IsDefined(s_spawn_loc)) {
		return undefined;
	}
	ai = [[@zm_ai_raz<scripts\zm\_zm_ai_raz.gsc>::function_665a13cd]](level.var_6bca5baa[0]);
	if (IsDefined(ai)) {
		ai ForceTeleport(s_spawn_loc.origin, s_spawn_loc.angles);
		ai.script_string = s_spawn_loc.script_string;
		ai.find_flesh_struct_string = ai.script_string;
		ai.sword_kill_power = 4;
		ai.heroweapon_kill_power = 4;
		if (IsDefined(var_19764360)) {
			ai.favoriteenemy = var_19764360;
			ai.favoriteenemy.hunted_by++;
		}
		if (IsDefined(var_e41e673a)) {
			ai thread [[var_e41e673a]]();
		}
		PlaySoundAtPosition("zmb_raz_spawn", s_spawn_loc.origin);
		return ai;
	}
	return undefined;
}

detour zm_stalingrad_util<scripts\zm\zm_stalingrad_util.gsc>::function_77b29938(a_spawners, var_19764360)
{
	return function_77b29938(a_spawners, var_19764360);
}

function_77b29938(a_spawners, var_19764360)
{
	b_all_points_used = 0;
	if (IsDefined(a_spawners)) {
		a_spawnpoints = ArrayCopy(a_spawners);
	}
	else {
		a_spawnpoints = ArrayCopy(level.zm_loc_types["raz_location"]);
	}
	a_valid_spawn_points = [];
	while (!a_valid_spawn_points.size) {
		foreach (s_spawn_point in a_spawnpoints) {
			if (!IsDefined(s_spawn_point.spawned_zombie) || b_all_points_used) {
				s_spawn_point.spawned_zombie = 0;
			}
			if (!s_spawn_point.spawned_zombie) {
				array::add(a_valid_spawn_points, s_spawn_point, 0);
			}
		}
		if (!a_valid_spawn_points.size) {
			b_all_points_used = 1;
		}
		wait 0.05;
	}
	s_spawn_point = SArrayRandom(a_valid_spawn_points, "zm_stalingrad_util_raz_spawn");
	s_spawn_point.spawned_zombie = 1;
	return s_spawn_point;
}

detour zm_stalingrad_util<scripts\zm\zm_stalingrad_util.gsc>::function_383b110b(a_spawners)
{
	b_all_points_used = 0;
	if (IsDefined(a_spawners)) {
		a_spawnpoints = ArrayCopy(a_spawners);
	}
	else {
		a_spawnpoints = ArrayCopy(level.zm_loc_types["sentinel_location"]);
	}
	a_valid_spawn_points = [];
	while (!a_valid_spawn_points.size)
	{
		foreach (s_spawn_point in a_spawnpoints) {
			if (!IsDefined(s_spawn_point.var_1565f394) || b_all_points_used) {
				s_spawn_point.var_1565f394 = 0;
			}
			if (!s_spawn_point.var_1565f394) {
				array::add(a_valid_spawn_points, s_spawn_point, 0);
			}
		}
		if (!a_valid_spawn_points.size) {
			b_all_points_used = 1;
		}
		wait 0.05;
	}
	s_spawn_point = SArrayRandom(a_valid_spawn_points, "zm_stalingrad_util_sentinel_spawn");
	s_spawn_point.var_1565f394 = 1;
	return s_spawn_point;
}

detour zm_stalingrad_util<scripts\zm\zm_stalingrad_util.gsc>::function_d48ad6b4()
{
	level.var_c3c3ffc5 = array::remove_dead(level.var_c3c3ffc5, 0);
	if (IsDefined(level.var_5fe02c5a)) {
		var_456e8c26 = level.var_5fe02c5a;
	}
	else {
		var_456e8c26 = level.zombie_ai_limit;
	}
	if (level.var_c3c3ffc5.size > var_456e8c26) {
		n_to_kill = level.var_c3c3ffc5.size - var_456e8c26;
		if (IsVehicle(self)) {
			n_to_kill++;
		}
		for (i = 0; i < n_to_kill; i++) {
			ai_target = SArrayRandom(level.var_c3c3ffc5, "zm_stalingrad_util_kill_zombies");
			wait 0.05;
			while (!level [[@zm_stalingrad_util<scripts\zm\zm_stalingrad_util.gsc>::function_4614e0e9]](ai_target)) {
				ai_target = SArrayRandom(level.var_c3c3ffc5, "zm_stalingrad_util_kill_zombies");
				wait 0.05;
			}
			ai_target.var_1d3a1f9e = 1;
			wait 0.05;
			if ([[@zm_stalingrad_util<scripts\zm\zm_stalingrad_util.gsc>::function_4614e0e9]](ai_target)) {
				ai_target Kill();
			}
			level.var_c3c3ffc5 = array::remove_dead(level.var_c3c3ffc5, 0);
			if (level.var_c3c3ffc5.size <= var_456e8c26) {
				break;
			}
		}
		return true;
	}
	return false;
}