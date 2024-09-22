detour namespace_2e6e7fce<scripts\zm\zm_stalingrad_drop_pods.gsc>::function_aa168b7a()
{
	var_f31bd832 = level.powerup_drop_count;
	var_f1c825f6 = self.origin;
	var_988bbfc2 = IS_TRUE(self.completed_emerging_into_playable_area);
	wait 0.5;
	if (var_f31bd832 != level.powerup_drop_count || level.var_583e4a97.var_a622ee25) {
		return false;
	}
	n_rate = level.var_583e4a97.var_a43689b5;
	n_roll = SRandomInt("zm_stalingrad_drop_pods_cylinder_chance", 100);
	if (n_roll <= n_rate && var_988bbfc2) {
		var_10fdad27 = function_a9d4f2ec();
		s_powerup = zm_powerups::specific_powerup_drop("code_cylinder_" + var_10fdad27, var_f1c825f6);
		level.var_583e4a97.var_a622ee25 = 1;
		level.var_583e4a97.var_a43689b5 = 10;
		s_powerup thread [[@namespace_2e6e7fce<scripts\zm\zm_stalingrad_drop_pods.gsc>::function_9411a0ff]]();
	}
	else {
		level.var_583e4a97.var_a43689b5 = level.var_583e4a97.var_a43689b5 + 2;
	}
}

detour namespace_2e6e7fce<scripts\zm\zm_stalingrad_drop_pods.gsc>::function_a9d4f2ec()
{
	return function_a9d4f2ec();
}

function_a9d4f2ec()
{
	if (level flag::get("dragonride_crafted")) {
		var_446e72fb = SRandomInt("zm_stalingrad_drop_pods_cylinder_color", 2);
		switch (var_446e72fb) {
			case 1: {
				return "blue";
			}
			case 2: {
				return "yellow";
			}
			case 0: {
				return "red";
			}
		}
	}
	else {
		return level.var_583e4a97.var_4bf647dc;
	}
}

detour namespace_2e6e7fce<scripts\zm\zm_stalingrad_drop_pods.gsc>::function_306f40e1(str_location)
{
	level endon(#"hash_94bb84a1");
	if (IS_TRUE(level.var_8cc024f2.var_c5718719)) {
		var_a42f2fa9 = 2 + (4 * zm_utility::get_number_of_valid_players());
	}
	else {
		var_a42f2fa9 = 3 + (1 * zm_utility::get_number_of_valid_players());
	}
	var_14799ce0 = SArrayRandom(level.zombie_spawners, "zm_stalingrad_drop_pods_spawn_location");
	var_d41655e8 = struct::get_array("drop_pod_harraser_" + str_location, "targetname");
	if (IsDefined(level.var_583e4a97.s_radio) || IS_TRUE(level.var_8cc024f2.var_c5718719)) {
		var_8da17f38 = [[@namespace_2e6e7fce<scripts\zm\zm_stalingrad_drop_pods.gsc>::function_5cf8b853]](str_location);
		wait(var_8da17f38);
	}
	level.var_8cc024f2.n_round_zombies = (zombie_utility::get_current_zombie_count() + level.zombie_total) + level.zombie_respawns;
	for (;;) {
		if (level.var_8cc024f2.var_d2e1ce53 < var_a42f2fa9) {
			if (IS_TRUE(level.var_8cc024f2.var_c5718719)) {
				level flag::wait_till("spawn_ee_harassers");
			}
			else {
				level flag::wait_till("spawn_zombies");
			}
			s_spawn = SArrayRandom(var_d41655e8, "zm_stalingrad_drop_pods_spawn_location");
			ai = zombie_utility::spawn_zombie(var_14799ce0, "drop_pod_harraser", s_spawn);
			if (IsDefined(ai)) {
				level.zombie_total--;
				if (level.zombie_respawns > 0){
					level.zombie_respawns--;
				}
				level.var_8cc024f2.var_d2e1ce53++;
				ai thread [[@namespace_2e6e7fce<scripts\zm\zm_stalingrad_drop_pods.gsc>::function_51837de8]]();
			}
		}
		wait 0.3;
	}
}