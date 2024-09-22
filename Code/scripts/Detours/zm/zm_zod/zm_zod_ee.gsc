detour zm_zod_ee<scripts\zm\zm_zod_ee.gsc>::function_5db6ba34(var_1a60ad71 = 1, var_75541524 = 0)
{
	if (var_1a60ad71) {
		level thread lui::screen_flash(0.2, 0.5, 1, 0.8, "white");
	}
	wait 0.5;
	a_ai_zombies = GetAITeamArray(level.zombie_team);
	var_6b1085eb = [];
	foreach (ai_zombie in a_ai_zombies) {
		ai_zombie.no_powerups = 1;
		ai_zombie.deathpoints_already_given = 1;
		if (IsDefined(var_75541524) && var_75541524 && ai_zombie.archetype == "margwa") {
			continue;
		}
		if (IS_TRUE(ai_zombie.ignore_nuke)) {
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
	foreach (i, var_f92b3d80 in var_6b1085eb) {
		wait SRandomFloatRange("zm_zod_ee_cleanup", 0.1, 0.2);
		if (!IsDefined(var_f92b3d80)) {
			continue;
		}
		if (zm_utility::is_magic_bullet_shield_enabled(var_f92b3d80)) {
			continue;
		}
		if (i < 5 && !IS_TRUE(var_f92b3d80.isdog)) {
			var_f92b3d80 thread zombie_death::flame_death_fx();
		}
		if (!IS_TRUE(var_f92b3d80.isdog)) {
			if (!IS_TRUE(var_f92b3d80.no_gib)) {
				var_f92b3d80 zombie_utility::zombie_head_gib();
			}
		}
		var_f92b3d80 DoDamage(var_f92b3d80.health, var_f92b3d80.origin);
		if (!level flag::get("special_round")) {
			if (var_f92b3d80.archetype == "margwa") {
				level.var_e0191376++;
				continue;
			}
			level.zombie_total++;
		}
	}
}

detour zm_zod_ee<scripts\zm\zm_zod_ee.gsc>::function_6b57b2d3()
{
	foreach (player in level.activeplayers) {
		if (IsDefined(player.var_11104075)) {
			return player;
		}
	}
	return SArrayRandom(level.activeplayers, "zm_zod_ee_favorite_enemy");
}

detour zm_zod_ee<scripts\zm\zm_zod_ee.gsc>::function_877ea350()
{
	level endon("ee_keeper_resurrected");
	level endon("ee_keeper_resurrection_failed");
	level endon("ee_boss_defeated");
	zombie_utility::ai_calculate_health(level.round_number);
	for (;;) {
		var_565450eb = zombie_utility::get_current_zombie_count();
		while (var_565450eb >= 10 || var_565450eb >= (level.players.size * 5)) {
			wait SRandomFloatRange("zm_zod_ee_boss_zombies", 2, 4);
			var_565450eb = zombie_utility::get_current_zombie_count();
		}
		while (zombie_utility::get_current_actor_count() >= level.zombie_actor_limit) {
			zombie_utility::clear_all_corpses();
			wait 0.1;
		}
		zm::run_custom_ai_spawn_checks();
		if (IsDefined(level.zombie_spawners)) {
			if (IS_TRUE(level.use_multiple_spawns)) {
				if (IsDefined(level.spawner_int) && (IsDefined(level.zombie_spawn[level.spawner_int].size) && level.zombie_spawn[level.spawner_int].size)) {
					spawner = SArrayRandom(level.zombie_spawn[level.spawner_int], "zm_zod_ee_boss_zombies");
				}
				else {
					spawner = SArrayRandom(level.zombie_spawners, "zm_zod_ee_boss_zombies");
				}
			}
			else {
				spawner = SArrayRandom(level.zombie_spawners, "zm_zod_ee_boss_zombies");
			}
			ai = zombie_utility::spawn_zombie(spawner, spawner.targetname);
		}
		if (IsDefined(ai)) {
			ai.no_powerups = 1;
			ai.deathpoints_already_given = 1;
			ai.exclude_distance_cleanup_adding_to_total = 1;
			ai.exclude_cleanup_adding_to_total = 1;
			ai.targetname = "ee_zombie";
			if (ai.zombie_move_speed === "walk") {
				ai zombie_utility::set_zombie_run_cycle("run");
			}
			find_flesh_struct_string = "find_flesh";
			ai notify("zombie_custom_think_done", find_flesh_struct_string);
			ai ai::set_behavior_attribute("can_juke", 0);
			if (level.zombie_respawns > 0 && level.zombie_vars["zombie_spawn_delay"] > 1) {
				wait 1;
			}
			else {
				wait level.zombie_vars["zombie_spawn_delay"];
			}
		}
		util::wait_network_frame();
	}
}