detour zm_castle_ee<scripts\zm\zm_castle_ee.gsc>::function_2c1aa78f()
{
	if (!IsDefined(level.var_ab58bca7)) {
		level.var_ab58bca7 = array(0, 0, 0);
	}
	if (!level flag::get("ee_safe_open")) {
		for (i = 0; i < 3; i++) {
			level.var_ab58bca7[i] = SRandomInt("zm_castle_ee_safe", 4);
		}
	}
	if (!level flag::get("dimension_set")) {
		a_safe_clean = GetEntArray("safe_uc_clean", "targetname");
		foreach (m_safe_clean in a_safe_clean) {
			m_safe_clean Hide();
		}
		s_scriptbundle = struct::get("cin_zm_castle_drgroph_easteregg", "scriptbundlename");
		s_scriptbundle.scene_played = 0;
		level thread scene::init("cin_zm_castle_drgroph_easteregg");
		level [[@zm_castle_vo<scripts\zm\zm_castle_vo.gsc>::function_8ac5430]](1, s_scriptbundle.origin);
		level waittill(#"hash_59b7ed");
		level thread scene::play("cin_zm_castle_drgroph_easteregg");
		m_safe_display = GetEnt("safe_code_past", "targetname");
		for (i = 0; i < 3; i++) {
			if (!level flag::get("dimension_set")) {
				level waittill("ee_button_" + (i + 1));
			}
			m_safe_display ShowPart((("tag_scn" + i) + "_sym") + (level.var_ab58bca7[i] + 1));
		}
	}
}

detour zm_castle_ee<scripts\zm\zm_castle_ee.gsc>::function_5db6ba34(var_1a60ad71 = 1)
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
		wait SRandomFloatRange("zm_castle_ee_cleanup", 0.1, 0.2);
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
	level thread function_3fade785(var_6cbdc65);
}

detour zm_castle_ee<scripts\zm\zm_castle_ee.gsc>::function_ee0ff0d1(a_targets, e_target_current)
{
	var_4573b5e6 = undefined;
	if (!IsDefined(e_target_current)) {
		var_4573b5e6 = SArrayRandom(a_targets, "zm_castle_ee_wisp_location");
	}
	else {
		var_8717daa1 = [];
		foreach (e_target in a_targets) {
			if (!IS_TRUE(e_target.var_25a8b5d5)) {
				if (!IsDefined(var_8717daa1)) {
					var_8717daa1 = [];
				}
				else if (!IsArray(var_8717daa1)) {
					var_8717daa1 = array(var_8717daa1);
				}
				var_8717daa1[var_8717daa1.size] = e_target;
			}
		}
		if (var_8717daa1.size > level.activeplayers.size) {
			var_8717daa1 = ArraySort(var_8717daa1, e_target_current.origin);
			var_fd3f8bfd = [];
			n_targets = level.activeplayers.size + 1;
			for (i = 0; i < n_targets; i++) {
				if (!IsDefined(var_fd3f8bfd)) {
					var_fd3f8bfd = [];
				}
				else if (!IsArray(var_fd3f8bfd)) {
					var_fd3f8bfd = array(var_fd3f8bfd);
				}
				var_fd3f8bfd[var_fd3f8bfd.size] = var_8717daa1[i];
			}
			var_4573b5e6 = SArrayRandom(var_fd3f8bfd, "zm_castle_ee_wisp_location");
		}
		else {
			var_4573b5e6 = SArrayRandom(var_8717daa1, "zm_castle_ee_wisp_location");
		}
	}
	return var_4573b5e6;
}

detour zm_castle_ee<scripts\zm\zm_castle_ee.gsc>::function_3faf6b59(var_747532f4)
{
	a_zones = array(1, 2, 3, 4);
	[[@zm_castle_ee<scripts\zm\zm_castle_ee.gsc>::function_a760f135]]();
	level.a_elements = SArrayRandomize(level.a_elements, "zm_castle_ee_keeper_order");
	a_zones = SArrayRandomize(a_zones, "zm_castle_ee_keeper_order");
	for (i = 0; i < a_zones.size; i++) {
		foreach (player in level.players) {
			player thread [[@zm_castle_ee<scripts\zm\zm_castle_ee.gsc>::function_812faaaf]]();
		}
		level.var_f1b0baba = a_zones[i];
		level.var_8bdb0713 = 0;
		s_stone = struct::get("cs_keeper_pos_" + level.var_f1b0baba);
		var_747532f4 SetGoal(s_stone.origin);
		var_747532f4 waittill("goal");
		var_747532f4 thread [[@zm_castle_ee<scripts\zm\zm_castle_ee.gsc>::function_37fb253]](s_stone);
		var_747532f4 PlaySound("zmb_ee_resurrect_start_circle");
		level.var_1f18338d = [[@zm_castle_ee<scripts\zm\zm_castle_ee.gsc>::function_4ce3eea5]](i);
		level thread [[@zm_castle_ee<scripts\zm\zm_castle_ee.gsc>::function_99ac27a]]();
		if (i > 1) {
			if (!level flag::get("solo_game") || i > 2) {
				var_747532f4 thread [[@zm_castle_ee<scripts\zm\zm_castle_ee.gsc>::function_88e260d]]();
			}
		}
		[[@zm_castle_ee<scripts\zm\zm_castle_ee.gsc>::function_4f8445d7]](a_zones[i]);
		PlaySoundAtPosition("zmb_ee_resurrect_circle_complete", (0, 0, 0));
		level flag::clear("next_channeling_stone");
		var_747532f4 scene::stop("cin_zm_dlc1_corrupted_keeper_charge_stone_loop");
		var_747532f4 scene::play("cin_zm_dlc1_corrupted_keeper_charge_stone_outro", var_747532f4);
		var_747532f4 PlaySound("zmb_ee_resurrect_power_complete");
		wait 0.15;
	}
	zm_spawner::deregister_zombie_death_event_callback(@zm_castle_ee<scripts\zm\zm_castle_ee.gsc>::function_e8de9974);
	var_82a4f07b = struct::get("keeper_end_loc");
	var_82a4f07b fx::play("mpd_fx", var_82a4f07b.origin, var_82a4f07b.angles, "delete_fx", 0, undefined, 1);
	level.var_8ef26cd9 = 1;
	foreach (player in level.players) {
		player thread [[@zm_castle_util<scripts\zm\zm_castle_util.gsc>::function_fa7da172]]();
	}
	callback::on_connect(@zm_castle_util<scripts\zm\zm_castle_util.gsc>::function_fa7da172);
	var_57615f80 = GetEntArray("pyramid", "targetname");
	foreach (var_27fd0c6f in var_57615f80) {
		var_54a70b81 = (var_27fd0c6f.origin[0], var_27fd0c6f.origin[1], var_27fd0c6f.origin[2] - 96);
		var_27fd0c6f NotSolid();
		var_27fd0c6f ConnectPaths();
		var_27fd0c6f MoveTo(var_54a70b81, 3);
	}
	var_747532f4 clientfield::set("ghost_actor", 0);
	var_747532f4 notify("ghost_torso");
	var_747532f4 notify("ghost_trail");
	var_747532f4 PlaySound("zmb_ee_resurrect_keeper_notghost");
	var_747532f4 PlayLoopSound("zmb_ee_resurrect_keeper_notghost_lp");
	var_747532f4 fx::play("keeper_torso", var_747532f4.origin, var_747532f4.angles, "keeper_torso", 1, "j_spineupper", 1);
	var_747532f4 fx::play("keeper_mouth", var_747532f4.origin, var_747532f4.angles, "keeper_torso", 1, "j_head", 1);
	var_747532f4 fx::play("keeper_trail", var_747532f4.origin, var_747532f4.angles, "keeper_trail", 1, "j_robe_front_03", 1);
	wait 3;
	level.var_cc2ea6e8 = undefined;
	var_747532f4 notify("start_moving");
	s_stone = struct::get("keeper_end_loc");
	var_747532f4 SetGoal(s_stone.origin);
	var_747532f4 waittill("goal");
	var_747532f4 PlaySound("zmb_ee_resurrect_end_warpaway");
	var_747532f4 fx::play("keeper_beam", var_747532f4.origin, var_747532f4.angles, undefined, 1, "j_mainroot", 1);
	exploder::exploder("fxexp_601");
	exploder::exploder("fxexp_602");
	exploder::exploder("fxexp_603");
	exploder::exploder("fxexp_604");
	foreach (player in level.players) {
		player thread [[@zm_castle_ee<scripts\zm\zm_castle_ee.gsc>::function_6ff05666]]();
	}
	callback::on_connect(@zm_castle_ee<scripts\zm\zm_castle_ee.gsc>::function_6ff05666);
	level flag::wait_till("see_keeper");
	callback::remove_on_connect(@zm_castle_ee<scripts\zm\zm_castle_ee.gsc>::function_6ff05666);
	[[@zm_castle_ee<scripts\zm\zm_castle_ee.gsc>::function_1c4bd669]](1);
	var_747532f4 scene::play("cin_zm_dlc1_corrupted_keeper_float_emerge", var_747532f4);
	exploder::kill_exploder("fxexp_601");
	exploder::kill_exploder("fxexp_602");
	exploder::kill_exploder("fxexp_603");
	exploder::kill_exploder("fxexp_604");
	var_747532f4 Delete();
	var_82a4f07b notify("delete_fx");
	callback::remove_on_connect(@zm_castle_util<scripts\zm\zm_castle_util.gsc>::function_fa7da172);
	level.var_8ef26cd9 = undefined;
	[[@zm_castle_vo<scripts\zm\zm_castle_vo.gsc>::function_70721c81]]();
	[[@zm_castle_ee<scripts\zm\zm_castle_ee.gsc>::function_1c4bd669]](0);
	level flag::set("boss_fight_ready");
}

detour zm_castle_ee<scripts\zm\zm_castle_ee.gsc>::function_15752140(var_b5aa6f14)
{
	level.var_e3162591 = 0;
	level flag::wait_till("simon_terminal_activated");
	var_d733da61 = 1;
	if (level.var_cf5a713.script_noteworthy == "launch_platform") {
		var_d733da61 = 2;
	}
	var_e131c06 = util::spawn_model("p7_zm_ctl_keycard_ee", level.var_cf5a713.origin, level.var_cf5a713.angles);
	var_4d74106b = GetEnt("symbols_" + level.var_cf5a713.script_noteworthy, "targetname");
	var_4d74106b PlaySound("zmb_ee_simonsays_insertcard");
	var_c5ea7ad8 = array("1", "2", "3", "4");
	var_c5ea7ad8 = SArrayRandomize(var_c5ea7ad8, "zm_castle_ee_simon");
	var_a6116854 = [];
	for (i = 0; i < 4; i++) {
		var_a6116854[var_c5ea7ad8[i]] = struct::get((("monitor_" + level.var_cf5a713.script_noteworthy) + "_") + (i + 1));
		var_a6116854[var_c5ea7ad8[i]].var_73527aa3 = undefined;
		var_a6116854[var_c5ea7ad8[i]] [[@zm_castle_util<scripts\zm\zm_castle_util.gsc>::create_unitrigger]](undefined, 16);
		var_4d74106b ShowPart((("tag_scn" + (i + 1)) + "_sym") + var_c5ea7ad8[i]);
		level thread [[@zm_castle_ee<scripts\zm\zm_castle_ee.gsc>::function_b76d0c45]](var_a6116854[var_c5ea7ad8[i]], (("tag_scn" + (i + 1)) + "_sym") + var_c5ea7ad8[i], (("lgt_EE_consol" + var_d733da61) + "_monitor_") + (i + 1));
	}
	level waittill(#"hash_706f7f9a");
	level thread [[@zm_castle_ee<scripts\zm\zm_castle_ee.gsc>::function_fb090902]](1);
	var_1a972685 = SpawnStruct();
	level.var_521b0bd1 = 0;
	while (!level flag::get("end_simon")) {
		var_2fe972c1 = SArrayRandom(var_c5ea7ad8, "zm_castle_ee_simon");
		var_a6116854[var_2fe972c1].var_73527aa3 = 1;
		var_1a972685.var_94287343 = "tag_scn0_sym" + var_2fe972c1;
		var_4d74106b ShowPart("tag_scn0_sym" + var_2fe972c1);
		var_4d74106b PlaySound("zmb_ee_simonsays_show");
		exploder::exploder(("lgt_EE_consol" + var_d733da61) + "_monitor_main");
		level thread [[@zm_castle_ee<scripts\zm\zm_castle_ee.gsc>::simon_timed_out]](var_4d74106b, var_d733da61);
		a_flags = array("simon_timed_out", "simon_press_check");
		level flag::wait_till_any(a_flags);
		exploder::exploder(("lgt_EE_consol" + var_d733da61) + "_monitor_main");
		if (level flag::get("simon_timed_out")) {
			level flag::set("end_simon");
			level flag::clear("simon_timed_out");
			var_4d74106b PlaySound("zmb_ee_simonsays_nay");
		}
		else {
			level waittill(#"hash_b7f06cd9");
			level flag::clear("simon_press_check");
		}
		exploder::kill_exploder(("lgt_EE_consol" + var_d733da61) + "_monitor_main");
		var_4d74106b HidePart(var_1a972685.var_94287343);
		var_a6116854[var_2fe972c1].var_73527aa3 = undefined;
		if (level.var_521b0bd1 >= var_b5aa6f14) {
			level flag::set("end_simon");
			level.var_cf5a713.b_done = 1;
			level.var_e3162591 = 1;
			var_4d74106b PlaySound("zmb_ee_simonsays_complete");
			if (level.var_cf5a713.script_noteworthy == "lower_tower") {
				exploder::exploder("fxexp_730");
			}
			else if (level.var_cf5a713.script_noteworthy == "launch_platform") {
				exploder::exploder("fxexp_731");
			}
		}
		wait 0.25;
	}
	level notify(#"hash_b0b992fb");
	[[@zm_castle_ee<scripts\zm\zm_castle_ee.gsc>::function_2925fac8]]();
	foreach (var_901d8fb2 in var_a6116854) {
		zm_unitrigger::unregister_unitrigger(var_901d8fb2.s_unitrigger);
	}
	level.var_cc2ea6e8 = undefined;
	var_e131c06 Delete();
	level flag::clear("simon_press_check");
	level flag::clear("simon_timed_out");
	level flag::clear("end_simon");
}

detour zm_castle_ee<scripts\zm\zm_castle_ee.gsc>::function_d2c78092()
{
	var_c5ea7ad8 = array(1, 2, 3, 4);
	while (!level flag::get("ee_safe_open")) {
		level flag::wait_till("ee_fuse_placed");
		level flag::wait_till("death_ray_trap_used");
		level thread [[@zm_castle_ee<scripts\zm\zm_castle_ee.gsc>::function_fb090902]](1);
		var_c5ea7ad8 = SArrayRandomize(var_c5ea7ad8, "zm_castle_ee_simon");
		level.var_a44ebbe8 = [];
		var_ebbefa14 = [];
		var_91d3caa4 = struct::get_array("golden_key_slot");
		foreach (s_slot in var_91d3caa4) {
			var_d733da61 = 1;
			if (s_slot.script_noteworthy == "launch_platform") {
				var_d733da61 = 2;
			}
			var_4d74106b = GetEnt("symbols_" + s_slot.script_noteworthy, "targetname");
			for (i = 1; i <= 4; i++) {
				var_4d74106b ShowPart((("tag_scn" + i) + "_sym") + (var_c5ea7ad8[i - 1]));
				exploder::exploder((("lgt_EE_consol" + var_d733da61) + "_monitor_") + i);
				s_monitor = struct::get((("monitor_" + s_slot.script_noteworthy) + "_") + i);
				s_monitor.var_a95f1f56 = i;
				s_monitor.var_d82c7c68 = var_c5ea7ad8[i - 1];
				s_monitor [[@zm_castle_util<scripts\zm\zm_castle_util.gsc>::create_unitrigger]](undefined, 16);
				level thread [[@zm_castle_ee<scripts\zm\zm_castle_ee.gsc>::function_96ca12f5]](s_monitor);
				if (!IsDefined(var_ebbefa14)) {
					var_ebbefa14 = [];
				}
				else if (!IsArray(var_ebbefa14)) {
					var_ebbefa14 = array(var_ebbefa14);
				}
				var_ebbefa14[var_ebbefa14.size] = s_monitor;
			}
		}
		level waittill(#"hash_a126360f");
		foreach (var_2bfe2eca in var_ebbefa14) {
			zm_unitrigger::unregister_unitrigger(var_2bfe2eca.s_unitrigger);
			exploder::kill_exploder("lgt_EE_consol1_monitor_" + var_2bfe2eca.var_a95f1f56);
			exploder::kill_exploder("lgt_EE_consol2_monitor_" + var_2bfe2eca.var_a95f1f56);
		}
		[[@zm_castle_ee<scripts\zm\zm_castle_ee.gsc>::function_2925fac8]]();
		var_d9768e8b = 1;
		for (i = 0; i < level.var_a44ebbe8.size; i++) {
			n_input = level.var_a44ebbe8[i] - 1;
			if (n_input != level.var_ab58bca7[i]) {
				var_d9768e8b = 0;
			}
		}
		if (var_d9768e8b && !level flag::get("switch_to_death_ray")) {
			foreach (slot in var_91d3caa4) {
				PlaySoundAtPosition("zmb_ee_simonsays_complete", slot.origin);
			}
			PlaySoundAtPosition("zmb_object_final_success", (0, 0, 0));
			level flag::set("dimension_set");
			level flag::set("ee_safe_open");
		}
		else {
			foreach (slot in var_91d3caa4) {
				PlaySoundAtPosition("zmb_ee_simonsays_nay", slot.origin);
			}
			PlaySoundAtPosition("zmb_object_fail", (0, 0, 0));
			[[@zm_castle_ee<scripts\zm\zm_castle_ee.gsc>::function_3918d831]]("safe_code_present");
			level flag::clear("ee_fuse_placed");
		}
		level.var_cc2ea6e8 = undefined;
	}
}

detour zm_castle_ee<scripts\zm\zm_castle_ee.gsc>::function_3fade785(var_6cbdc65)
{
	return function_3fade785(var_6cbdc65);
}

function_3fade785(var_6cbdc65)
{
	level flag::wait_till("spawn_zombies");
	for (i = 0; i < var_6cbdc65.size; i++) {
		e_target = SArrayRandom(level.players, "zm_castle_ee_mechz_spawn");
		while (!zm_utility::is_player_valid(e_target)) {
			wait 0.05;
			e_target = SArrayRandom(level.players, "zm_castle_ee_mechz_spawn");
		}
		s_spawn_pos = arraygetclosest(e_target.origin, level.zm_loc_types["mechz_location"]);
		if (IsDefined(s_spawn_pos)) {
			ai_mechz = function_314d744b(0, s_spawn_pos, 1);
			if (IsDefined(var_6cbdc65[i]) && var_6cbdc65[i]) {
				ai_mechz.no_damage_points = 1;
				ai_mechz.deathpoints_already_given = 1;
				ai_mechz.exclude_cleanup_adding_to_total = 1;
			}
		}
	}
}