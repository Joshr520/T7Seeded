detour zm_castle_mechz<scripts\zm\zm_castle_mechz.gsc>::mechz_round_tracker()
{
	level.var_b20dd348 = SRandomIntRange("zm_castle_mechz_round", 12, 13);
	level.var_2f0a5661 = 0;
	for (;;) {
		while (level.round_number < level.var_b20dd348) {
			level waittill("between_round_over");
		}
		if (level flag::get("dog_round") && level.dog_round_count == 1) {
			level.var_b20dd348++;
		}
		else if (level.var_b20dd348 >= level.round_number) {
			function_6592b947();
		}
		level waittill("start_of_round");
	}
}

function_6592b947()
{
	var_b29defde = [[@zm_castle_mechz<scripts\zm\zm_castle_mechz.gsc>::function_c7730c11]]();
	wait 5;
	while (var_b29defde > 0) {
		while (![[@zm_castle_mechz<scripts\zm\zm_castle_mechz.gsc>::function_b1a145c4]]()) {
			wait 1;
		}
		ai_mechz = function_314d744b(1);
		if (IsDefined(ai_mechz)) {
			var_b29defde--;
			ai_mechz thread [[@zm_castle_vo<scripts\zm\zm_castle_vo.gsc>::function_5e426b67]]();
			ai_mechz thread [[@zm_castle_vo<scripts\zm\zm_castle_vo.gsc>::function_e8a09e6e]]();
		}
		if (var_b29defde > 0) {
			wait SRandomFloatRange("zm_castle_mechz_round", 5, 10);
		}
	}
	level.var_b20dd348 = level.round_number + SRandomIntRange("zm_castle_mechz_round", 5, 7);
	level.mechz_round_count++;
}

detour zm_castle_mechz<scripts\zm\zm_castle_mechz.gsc>::function_314d744b(var_2533389a, s_loc, var_4211ee1f = 1)
{
	return function_314d744b(var_2533389a, s_loc, var_4211ee1f);
}

function_314d744b(var_2533389a, s_loc, var_4211ee1f = 1)
{
	if (!IsDefined(s_loc)) {
		if (level.zm_loc_types["mechz_location"].size == 0) {
			var_79ed5347 = struct::get_array("mechz_location", "script_noteworthy");
			foreach (var_6000fab5 in var_79ed5347) {
				if (var_6000fab5.targetname == "zone_start_spawners") {
					s_loc = var_6000fab5;
				}
			}
		}
		else {
			s_loc = SArrayRandom(level.zm_loc_types["mechz_location"], "zm_castle_mechz_spawn");
		}
	}
	level thread [[@zm_castle_vo<scripts\zm\zm_castle_vo.gsc>::function_894d806e]](s_loc);
	[[@zm_castle_mechz<scripts\zm\zm_castle_mechz.gsc>::mechz_health_increases]]();
	ai_mechz = [[@zm_ai_mechz<scripts\zm\_zm_ai_mechz.gsc>::spawn_mechz]](s_loc, var_4211ee1f);
	level.var_9618f5be = ai_mechz;
	level notify(#"hash_b4c3cb33");
	if (IsDefined(ai_mechz)) {
		ai_mechz.b_ignore_cleanup = 1;
	}
	if (!IS_TRUE(var_2533389a)) {
		level.var_b20dd348 = level.round_number + SRandomIntRange("zm_castle_mechz_round", 4, 6);
	}
	return ai_mechz;
}

detour zm_castle_mechz<scripts\zm\zm_castle_mechz.gsc>::function_2a2bfc25()
{
	self waittill(#"hash_46c1e51d");
	if (level flag::get("gravityspike_part_body_found")) {
		if (level flag::get("zombie_drop_powerups") && !IS_TRUE(self.no_powerups)) {
			a_bonus_types = array("double_points", "insta_kill", "full_ammo", "nuke");
			str_type = SArrayRandom(a_bonus_types, "zm_castle_mechz_powerup");
			zm_powerups::specific_powerup_drop(str_type, self.origin);
		}
	}
	else {
		level notify(#"hash_b650259c", self.origin);
	}
}