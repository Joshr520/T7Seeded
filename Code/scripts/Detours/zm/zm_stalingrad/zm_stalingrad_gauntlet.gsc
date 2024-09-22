detour zm_stalingrad_gauntlet<scripts\zm\zm_stalingrad_gauntlet.gsc>::function_fd19472b()
{
	var_d98b610d = level.zombie_spawners[0];
	var_d9a44c63 = struct::get_array("basement_lockdown_spawn", "targetname");
	for (i = 0; i < var_d9a44c63.size; i++) {
		if (!IsDefined(level.var_c2c83bb6.var_b372c418)) {
			level.var_c2c83bb6.var_b372c418 = [];
		}
		else if (!IsArray(level.var_c2c83bb6.var_b372c418)) {
			level.var_c2c83bb6.var_b372c418 = array(level.var_c2c83bb6.var_b372c418);
		}
		level.var_c2c83bb6.var_b372c418[level.var_c2c83bb6.var_b372c418.size] = var_d9a44c63[i];
	}
	var_73844a4a = struct::get_array("pavlovs_A_spawn");
	for (i = 0; i < var_73844a4a.size; i++) {
		if (var_73844a4a[i].script_noteworthy == "sentinel_location") {
			if (!IsDefined(level.var_c2c83bb6.var_73844a4a)) {
				level.var_c2c83bb6.var_73844a4a = [];
			}
			else if (!IsArray(level.var_c2c83bb6.var_73844a4a)) {
				level.var_c2c83bb6.var_73844a4a = array(level.var_c2c83bb6.var_73844a4a);
			}
			level.var_c2c83bb6.var_73844a4a[level.var_c2c83bb6.var_73844a4a.size] = var_73844a4a[i];
		}
	}
	var_19494298 = [];
	for (i = 0; i < level.var_c2c83bb6.var_b372c418.size; i++) {
		if (level.var_c2c83bb6.var_b372c418[i].script_noteworthy == "spawn_location" || level.var_c2c83bb6.var_b372c418[i].script_noteworthy == "riser_location") {
			if (!IsDefined(var_19494298)) {
				var_19494298 = [];
			}
			else if (!IsArray(var_19494298)) {
				var_19494298 = array(var_19494298);
			}
			var_19494298[var_19494298.size] = level.var_c2c83bb6.var_b372c418[i];
		}
	}
	level.var_c2c83bb6.var_4eb67098 = 0;
	level.var_c2c83bb6.var_d5abe4af = 1;
	var_5c17f194 = level.zombie_vars["zombie_spawn_delay"];
	level thread [[@zm_stalingrad_gauntlet<scripts\zm\zm_stalingrad_gauntlet.gsc>::function_f4ceb3f8]]();
	level thread [[@zm_stalingrad_gauntlet<scripts\zm\zm_stalingrad_gauntlet.gsc>::function_1a7c9b89]]("basement");
	var_389695f2 = 1;
	while (var_389695f2) {
		a_ai_zombies = GetAITeamArray(level.zombie_team);
		if (a_ai_zombies.size >= level.zombie_ai_limit) {
			wait 0.1;
			continue;
		}
		s_spawn_point = SArrayRandom(var_19494298, "zm_stalingrad_gauntlet_spawn_location");
		ai = zombie_utility::spawn_zombie(var_d98b610d, "lockdown_zombie", s_spawn_point);
		if (IsDefined(ai)) {
			ai thread [[@zm_stalingrad_gauntlet<scripts\zm\zm_stalingrad_gauntlet.gsc>::function_91191904]]();
		}
		if ([[@zm_ai_sentinel_drone<scripts\zm\_zm_ai_sentinel_drone.gsc>::function_41375d48]]() < level.var_c2c83bb6.var_d5abe4af && !level flag::get("basement_sentinel_wait")) {
			wait var_5c17f194;
			var_4bf80f4b = SArrayRandom(level.var_c2c83bb6.var_73844a4a, "zm_stalingrad_gauntlet_spawn_location");
			level [[@zm_ai_sentinel_drone<scripts\zm\_zm_ai_sentinel_drone.gsc>::function_19d0b055]](undefined, undefined, 1, var_4bf80f4b);
			level thread [[@zm_stalingrad_gauntlet<scripts\zm\zm_stalingrad_gauntlet.gsc>::function_f621bb41]]();
		}
		wait var_5c17f194;
		if (level.var_de98e3ce.var_179b5b71 >= level.var_de98e3ce.var_a6563820) {
			var_389695f2 = 0;
		}
	}
	level notify(#"hash_917b3ab2");
	[[@zm_stalingrad_util<scripts\zm\zm_stalingrad_util.gsc>::function_adf4d1d0]]();
}