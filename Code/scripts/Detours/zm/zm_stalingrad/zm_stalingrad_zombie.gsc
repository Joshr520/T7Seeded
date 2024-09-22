detour zm_stalingrad_zombie<scripts\zm\zm_stalingrad_zombie.gsc>::function_cec23cbf()
{
	level waittill("start_of_round");
	n_current_time = GetTime();
	var_36eeba73 = 0;
	var_c48f3f8a = 0;
	var_b8e747cf = 1;
	var_c9b19c0c = [];
	var_bb6abcd9 = [];
	var_bcfa504e = struct::get_array("pavlovs_B_spawn", "targetname");
	foreach (s_spawn in var_bcfa504e) {
		if (s_spawn.script_noteworthy == "raz_location") {
			if (!IsDefined(var_c9b19c0c)) {
				var_c9b19c0c = [];
			}
			else if (!IsArray(var_c9b19c0c)) {
				var_c9b19c0c = array(var_c9b19c0c);
			}
			var_c9b19c0c[var_c9b19c0c.size] = s_spawn;
		}
		if (s_spawn.script_noteworthy == "sentinel_location") {
			if (!IsDefined(var_bb6abcd9)) {
				var_bb6abcd9 = [];
			}
			else if (!IsArray(var_bb6abcd9)) {
				var_bb6abcd9 = array(var_bb6abcd9);
			}
			var_bb6abcd9[var_bb6abcd9.size] = s_spawn;
		}
	}
	for (;;) {
		if (level flag::get("special_round")) {
			level flag::wait_till_clear("special_round");
			continue;
		}
		if (flag::exists("world_is_paused")) {
			level flag::wait_till_clear("world_is_paused");
		}
		if (!level flag::get("spawn_zombies")) {
			level waittill("spawn_zombies");
		}
		n_current_time = GetTime();
		var_a62c1873 = 0;
		foreach (e_player in level.players) {
			if (zm_utility::is_player_valid(e_player)) {
				var_54bcb829 = zm_zonemgr::get_zone_from_position(e_player.origin + vectorscale((0, 0, 1), 32), 0);
				if (var_54bcb829 === "pavlovs_A_zone" || var_54bcb829 === "pavlovs_B_zone" || var_54bcb829 === "pavlovs_C_zone") {
					var_a62c1873++;
				}
			}
		}
		if (var_a62c1873 > 0) {
			if (var_b8e747cf) {
				n_current_time = GetTime();
				var_36eeba73 = [[@zm_stalingrad_zombie<scripts\zm\zm_stalingrad_zombie.gsc>::function_8caf1f25]](var_a62c1873);
				var_c48f3f8a = n_current_time + 15000;
				var_b8e747cf = 0;
			}
			if (var_36eeba73 <= n_current_time) {
				if ((zombie_utility::get_current_zombie_count() + level.zombie_total) > 5) {
					s_spawn_loc = SArrayRandom(var_c9b19c0c, "zm_stalingrad_zombie_spawn_location");
					if (function_7ed6c714(1, undefined, 1, s_spawn_loc)) {
						level.zombie_total--;
						var_36eeba73 = [[@zm_stalingrad_zombie<scripts\zm\zm_stalingrad_zombie.gsc>::function_8caf1f25]](var_a62c1873);
					}
				}
			}
			else if (level.var_f73b438a > 1 && var_c48f3f8a <= n_current_time) {
				if ([[@zm_ai_sentinel_drone<scripts\zm\_zm_ai_sentinel_drone.gsc>::function_74ab7484]]() && (zombie_utility::get_current_zombie_count() + level.zombie_total) > 5) {
					s_spawn_loc = SArrayRandom(var_bb6abcd9, "zm_stalingrad_zombie_spawn_location");
					if ([[@zm_ai_sentinel_drone<scripts\zm\_zm_ai_sentinel_drone.gsc>::function_19d0b055]](1, undefined, 1, s_spawn_loc)) {
						level.zombie_total--;
						level.var_bd1e3d02++;
						var_c48f3f8a = [[@zm_stalingrad_zombie<scripts\zm\zm_stalingrad_zombie.gsc>::function_c7a940c4]](var_a62c1873);
					}
				}
			}
		}
		else {
			level waittill(#"hash_9a634383");
			wait 5;
			var_b8e747cf = 1;
			continue;
		}
		wait 5;
	}
}

detour zm_stalingrad_zombie<scripts\zm\zm_stalingrad_zombie.gsc>::function_8b981aa0()
{
	var_eb1ae81f = [[@zm_stalingrad_zombie<scripts\zm\zm_stalingrad_zombie.gsc>::function_3de9d297]]();
	if (var_eb1ae81f == 0) {
		a_s_spawn_locs = struct::get_array("pavlovs_A_spawn", "targetname");
		return SArrayRandom(a_s_spawn_locs, "zm_stalingrad_zombie_sentinel_spawn");
	}
	return function_f9c9e7e0();
}