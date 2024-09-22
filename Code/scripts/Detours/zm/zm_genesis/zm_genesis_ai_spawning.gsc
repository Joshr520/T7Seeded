detour zm_genesis_ai_spawning<scripts\zm\zm_genesis_ai_spawning.gsc>::spawn_zombie()
{
	e_spawner = SArrayRandom(level.zombie_spawners, "zm_genesis_ai_spawning_zombie_spawn");
	ai_zombie = zombie_utility::spawn_zombie(e_spawner, e_spawner.targetname);
	n_random = SRandomInt("zm_genesis_ai_spawning_zombie_spawn", 100);
	if (n_random < 3) {
		ai_zombie [[@zm_elemental_zombie<scripts\zm\_zm_elemental_zombies.gsc>::function_1b1bb1b]]();
	}
	else if (n_random < 6) {
		ai_zombie [[@zm_genesis_util<scripts\zm\zm_genesis_util.gsc>::function_c8040935]](1);
	}
	if (n_random < 9) {
		ai_zombie [[@zm_shadow_zombie<scripts\zm\_zm_shadow_zombie.gsc>::function_1b2b62b]]();
	}
	else {
		if (n_random < 12) {
			ai_zombie [[@zm_light_zombie<scripts\zm\_zm_light_zombie.gsc>::function_a35db70f]]();
		}
		else if (n_random < 35) {
			ai_zombie zm_utility::make_supersprinter();
		}
	}
	return ai_zombie;
}

detour zm_genesis_ai_spawning<scripts\zm\zm_genesis_ai_spawning.gsc>::function_fd8b24f5()
{
	return function_fd8b24f5();
}

function_fd8b24f5()
{
	if (level.round_number < 13) {
		return 0;
	}
	if (level.zombie_total <= 10) {
		return 0;
	}
	var_c0692329 = 0;
	n_random = SRandomFloat("zm_genesis_ai_spawning_special", 100);
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
	if (var_c0692329) {
		n_roll = SRandomInt("zm_genesis_ai_spawning_special", 100);
		if (n_roll < 50) {
			[[@zm_genesis_ai_spawning<scripts\zm\zm_genesis_ai_spawning.gsc>::function_21bbe70d]]();
		}
		else {
			ai_zombie = function_f55d851b();
		}
	}
	return var_c0692329;
}

detour zm_genesis_ai_spawning<scripts\zm\zm_genesis_ai_spawning.gsc>::function_a70ab4c3()
{
	level.var_783db6ab = SRandomIntRange("zm_genesis_ai_spawning_chaos_rounds", 5, 7);
	for (;;) {
		level waittill("between_round_over");
		if (level.round_number > level.var_783db6ab) {
			level.var_783db6ab = level.round_number + SRandomIntRange("zm_genesis_ai_spawning_chaos_rounds", 2, 4);
		}
		if (level.round_number == level.var_783db6ab) {
			if (IS_TRUE(level.var_256b19d4)) {
				level.var_783db6ab++;
				continue;
			}
			level.sndmusicspecialround = 1;
			level thread zm_audio::sndmusicsystem_playstate("chaos_start");
			[[@zm_genesis_ai_spawning<scripts\zm\zm_genesis_ai_spawning.gsc>::function_c87827a3]]();
			level.var_783db6ab = level.round_number + SRandomIntRange("zm_genesis_ai_spawning_chaos_rounds", 9, 11);
			if (level.var_783db6ab == level.var_ba0d6d40) {
				level.var_783db6ab = level.var_783db6ab + 2;
			}
		}
	}
}

detour zm_genesis_ai_spawning<scripts\zm\zm_genesis_ai_spawning.gsc>::function_3cf05b99()
{
	var_f09dee4f = [];
	foreach (str_index, var_2bbee316 in level.var_c4336559) {
		if (var_2bbee316 > 0) {
			var_f09dee4f[var_f09dee4f.size] = str_index;
		}
	}
	if (var_f09dee4f.size) {
		var_f09dee4f = SArrayRandomize(var_f09dee4f, "zm_genesis_ai_spawning_special_spawn");
		var_64b0a5ef = var_f09dee4f[0];
	}
	else {
		var_64b0a5ef = "parasite";
	}
	switch (var_64b0a5ef) {
		case "apothicon_fury": {
			level thread [[@zm_genesis_ai_spawning<scripts\zm\zm_genesis_ai_spawning.gsc>::function_21bbe70d]]();
			level notify("chaos_round_spawn_apothicon");
			break;
		}
		case "keeper": {
			ai_zombie = function_f55d851b();
			level notify("chaos_round_spawn_keeper");
			break;
		}
		case "parasite":
		default: {
			if ([[@zm_genesis_wasp<scripts\zm\zm_genesis_wasp.gsc>::ready_to_spawn_wasp]]()) {
				[[@zm_genesis_wasp<scripts\zm\zm_genesis_wasp.gsc>::spawn_wasp]](1, 1);
				level notify("chaos_round_spawn_parasite");
				level.var_c4336559["parasite"]--;
			}
			break;
		}
	}
}

detour zm_genesis_ai_spawning<scripts\zm\zm_genesis_ai_spawning.gsc>::function_f55d851b()
{
	return function_f55d851b();
}

function_f55d851b()
{
	a_players = GetPlayers();
	e_player = [[@zm_genesis_ai_spawning<scripts\zm\zm_genesis_ai_spawning.gsc>::function_25a4a7d4]]();
	queryresult = PositionQuery_Source_Navigation(e_player.origin, 600, 900, 128, 20);
	if (IsDefined(queryresult) && queryresult.data.size > 0) {
		a_spots = SArrayRandomize(queryresult.data, "zm_genesis_ai_spawning_keeper_spawn");
		for (i = 0; i < a_spots.size; i++) {
			v_origin = a_spots[i].origin;
			v_angles = [[@zm_genesis_util<scripts\zm\zm_genesis_util.gsc>::get_lookat_angles]](v_origin, e_player.origin);
			str_zone = zm_zonemgr::get_zone_from_position(v_origin, 1);
			if (IsDefined(str_zone) && level.zones[str_zone].is_active) {
				var_d88e6f5f = SpawnActor("spawner_zm_genesis_keeper", v_origin, v_angles, undefined, 1, 1);
				if (IsDefined(var_d88e6f5f)) {
					level.zombie_total--;
					level.var_c4336559["keeper"]--;
					var_d88e6f5f endon("death");
					var_d88e6f5f.spawn_time = GetTime();
					var_d88e6f5f.var_b8385ee5 = 1;
					var_d88e6f5f.health = level.zombie_health;
					var_d88e6f5f.heroweapon_kill_power = 2;
					level thread zm_spawner::zombie_death_event(var_d88e6f5f);
					level thread [[@zm_genesis_ai_spawning<scripts\zm\zm_genesis_ai_spawning.gsc>::function_6cc52664]](var_d88e6f5f.origin);
					var_d88e6f5f.voiceprefix = "keeper";
					var_d88e6f5f.animname = "keeper";
					var_d88e6f5f thread zm_spawner::play_ambient_zombie_vocals();
					var_d88e6f5f thread zm_audio::zmbaivox_notifyconvert();
					wait 1.3;
					var_d88e6f5f.zombie_think_done = 1;
					var_d88e6f5f thread zombie_utility::round_spawn_failsafe();
					var_d88e6f5f thread [[@zm_genesis_ai_spawning<scripts\zm\zm_genesis_ai_spawning.gsc>::function_77d3a18d]]();
					return var_d88e6f5f;
				}
			}
		}
	}
	return undefined;
}

detour zm_genesis_ai_spawning<scripts\zm\zm_genesis_ai_spawning.gsc>::function_21bbe70d()
{
	return function_21bbe70d();
}

function_21bbe70d()
{
	a_players = GetPlayers();
	e_player = [[@zm_genesis_ai_spawning<scripts\zm\zm_genesis_ai_spawning.gsc>::function_25a4a7d4]]();
	queryresult = PositionQuery_Source_Navigation(e_player.origin, 600, 800, 128, 20);
	if (IsDefined(queryresult) && queryresult.data.size > 0) {
		a_spots = SArrayRandomize(queryresult.data, "zm_genesis_ai_spawning_fury_spawn");
		for (i = 0; i < a_spots.size; i++) {
			v_origin = a_spots[i].origin;
			v_angles = [[@zm_genesis_util<scripts\zm\zm_genesis_util.gsc>::get_lookat_angles]](v_origin, e_player.origin);
			str_zone = zm_zonemgr::get_zone_from_position(v_origin, 1);
			if (IsDefined(str_zone) && level.zones[str_zone].is_active) {
				[[@zm_genesis_ai_spawning<scripts\zm\zm_genesis_ai_spawning.gsc>::function_1f0a0b52]](v_origin);
				var_ecb2c615 = [[@zm_genesis_apothicon_fury<scripts\zm\zm_genesis_apothicon_fury.gsc>::function_21bbe70d]](v_origin, v_angles, 0);
				if (IsDefined(var_ecb2c615)) {
					level.zombie_total--;
					level.var_c4336559["apothicon_fury"]--;
					var_ecb2c615 endon("death");
					var_ecb2c615.health = level.zombie_health;
					wait 1;
					var_ecb2c615.zombie_think_done = 1;
					var_ecb2c615.heroweapon_kill_power = 2;
					var_ecb2c615 ai::set_behavior_attribute("move_speed", "run");
					var_ecb2c615 thread zombie_utility::round_spawn_failsafe();
					return var_ecb2c615;
				}
			}
		}
	}
	return undefined;
}