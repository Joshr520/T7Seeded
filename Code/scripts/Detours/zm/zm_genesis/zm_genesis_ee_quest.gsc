detour zm_genesis_ee_quest<scripts\zm\zm_genesis_ee_quest.gsc>::function_5db6ba34(var_1a60ad71 = 1)
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
		wait SRandomFloatRange("zm_genesis_ee_quest_cleanup", 0.1, 0.2);
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
			level.zombie_total++;
		}
	}
	var_6cbdc65 = [];
	var_c94c86a8 = GetEntArray("mechz", "targetname");
	foreach (ai_mechz in var_c94c86a8) {
		var_63b71acf = 0;
		if (IS_TRUE(ai_mechz.no_damage_points)) {
			var_63b71acf = 1;
		}
		if (!IsDefined(var_6cbdc65)) {
			var_6cbdc65 = [];
		}
		else if (!IsArray(var_6cbdc65)) {
			var_6cbdc65 = array(var_6cbdc65);
		}
		var_6cbdc65[var_6cbdc65.size] = var_63b71acf;
		ai_mechz.no_powerups = 1;
		ai_mechz Kill();
	}
	level thread [[@zm_genesis_ee_quest<scripts\zm\zm_genesis_ee_quest.gsc>::function_3fade785]](var_6cbdc65);
}

detour zm_genesis_ee_quest<scripts\zm\zm_genesis_ee_quest.gsc>::function_be26578d(var_f5e9fb6c)
{
	var_3a557c26 = struct::get_array("audio1_start", "targetname");
	var_4d544c7f = SArrayRandom(var_3a557c26, "zm_genesis_ee_quest_rock");
	v_offset = VectorScale((0, 0, 1), 20);
	var_b44af04e = util::spawn_model("p7_zm_gen_horror_shards_kit_03_h", var_4d544c7f.origin - v_offset, var_4d544c7f.angles);
	util::wait_network_frame();
	var_b44af04e MoveTo(var_4d544c7f.origin, 15);
	var_b44af04e waittill("movedone");
	for (;;) {
		if (IsDefined(level.ai_companion) && IsAlive(level.var_bfd9ed83)) {
			if (level.ai_companion.reviving_a_player === 1 || level.ai_companion.b_teleporting === 1 || IsDefined(level.ai_companion.traversestartnode)) {
				wait 0.1;
				continue;
			}
			if (DistanceSquared(level.var_bfd9ed83.origin, var_b44af04e.origin) < 2500 && DistanceSquared(level.ai_companion.origin, var_b44af04e.origin) < 40000) {
				b_success = level.ai_companion [[@zm_genesis_ee_quest<scripts\zm\zm_genesis_ee_quest.gsc>::function_3877f225]](var_b44af04e);
				if (b_success) {
					break;
				}
			}
		}
		wait 0.5;
	}
	var_bbd61432 = struct::get(var_4d544c7f.target, "targetname");
	var_bbd61432 thread [[@zm_genesis_ee_quest<scripts\zm\zm_genesis_ee_quest.gsc>::function_bde2ec4]](var_f5e9fb6c);
	var_b44af04e Delete();
	level flag::wait_till("placed_audio" + var_f5e9fb6c);
	foreach (var_4d544c7f in var_3a557c26) {
		var_4d544c7f struct::delete();
	}
}

detour zm_genesis_ee_quest<scripts\zm\zm_genesis_ee_quest.gsc>::function_66b6f0e2(n_wave)
{
	level thread [[@zm_genesis_ee_quest<scripts\zm\zm_genesis_ee_quest.gsc>::function_78469e71]]();
	switch (n_wave) {
		case 1: {
			str_type = "plain";
			break;
		}
		case 2: {
			str_type = "fire";
			break;
		}
		case 3: {
			str_type = "shadow";
		}
	}
	for (i = 0; i < 3; i++) {
		s_spawn = SArrayRandom(level.zones["apothicon_interior_zone"].a_loc_types["margwa_location"], "zm_genesis_ee_quest_margwa_location");
		s_spawn thread [[@zm_genesis_apothican<scripts\zm\zm_genesis_apothican.gsc>::function_cc6165b0]](str_type, 1);
		wait 1;
	}
}

detour zm_genesis_ee_quest<scripts\zm\zm_genesis_ee_quest.gsc>::function_69f6c616()
{
	if (!IsDefined(level.var_6000c357)) {
		level.var_6000c357 = array(0, 1, 2, 3);
	}
	level.var_6000c357 = SArrayRandomize(level.var_6000c357, "zm_genesis_ee_quest_symbols");
}

detour zm_genesis_ee_quest<scripts\zm\zm_genesis_ee_quest.gsc>::ee_book_runes_in_summoning_circle(var_7b98b639)
{
	level endon("book_runes_failed");
	level endon("book_runes_success");
	level.var_be50c24f = 0;
	level.var_5da45153 = array(0, 1, 2, 3, 4, 5);
	var_cad0573e = SArrayRandomize(level.var_5da45153, "zm_genesis_ee_quest_symbols");
	self thread [[@zm_genesis_ee_quest<scripts\zm\zm_genesis_ee_quest.gsc>::function_3d57dcdd]]();
	for (;;) {
		level.var_63fa69fd = SArrayRandom(var_cad0573e, "zm_genesis_ee_quest_symbols");
		var_cad0573e = array::exclude(var_cad0573e, level.var_63fa69fd);
		if (!var_cad0573e.size) {
			var_cad0573e = SArrayRandomize(level.var_5da45153, "zm_genesis_ee_quest_symbols");
		}
		if (IsDefined(level.var_63fa69fd)) {
			var_7b98b639 SetModel(("p7_zm_gen_rune_" + (level.var_63fa69fd + 1)) + "_purple");
			var_7b98b639 PlaySound("zmb_main_bookish_rune_show");
			var_7b98b639 PlayLoopSound("zmb_main_bookish_rune_lp", 1);
			[[@zm_genesis_ee_quest<scripts\zm\zm_genesis_ee_quest.gsc>::function_fde3e99f]](3.6);
			level.var_63fa69fd = undefined;
			var_7b98b639 SetModel("tag_origin");
			var_7b98b639 StopLoopSound(0.5);
			var_7b98b639 PlaySound("zmb_main_bookish_rune_disappear");
		}
		wait 0.8;
	}
}

detour zm_genesis_ee_quest<scripts\zm\zm_genesis_ee_quest.gsc>::function_54e04357()
{
	var_edface0 = 3;
	var_5420f48f = array("castle", "sheffield", "prison", "verrucht");
	foreach (e_player in level.activeplayers) {
		var_7685fe6c = SArrayRandom(var_5420f48f, "zm_genesis_ee_quest_exit");
		var_5420f48f = array::exclude(var_5420f48f, var_7685fe6c);
		var_6a5f0a7f = struct::get_array(("apothican_exit_" + var_7685fe6c) + "_pos", "targetname");
		PlayFX(level._effect["portal_3p"], e_player.origin);
		e_player PlayLocalSound("zmb_teleporter_teleport_2d");
		PlaySoundAtPosition("zmb_teleporter_teleport_out", e_player.origin);
		level thread [[@zm_genesis_arena<scripts\zm\zm_genesis_arena.gsc>::function_14c1c18d]](e_player, var_6a5f0a7f, var_edface0);
	}
	level flag::clear("arena_occupied_by_player");
}