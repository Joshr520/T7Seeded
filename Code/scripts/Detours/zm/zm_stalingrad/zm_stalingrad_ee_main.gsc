detour zm_stalingrad_ee_main<scripts\zm\zm_stalingrad_ee_main.gsc>::function_af4b355b()
{
	level.var_57f8b6c5 = GetEntArray("ee_tube_terminal", "targetname");
	foreach (var_beb54dbd in level.var_57f8b6c5) {
		switch (var_beb54dbd.script_label) {
			case "armory": {
				var_beb54dbd.var_cd705a9 = array("library", "factory", "store");
				break;
			}
			case "barracks": {
				var_beb54dbd.var_cd705a9 = array("store", "factory", "command");
				break;
			}
			case "command": {
				var_beb54dbd.var_cd705a9 = array("library", "store", "barracks");
				break;
			}
			case "factory": {
				var_beb54dbd.var_cd705a9 = array("barracks", "library", "armory");
				break;
			}
			case "library": {
				var_beb54dbd.var_cd705a9 = array("command", "armory", "factory");
				break;
			}
			case "store": {
				var_beb54dbd.var_cd705a9 = array("armory", "barracks", "command");
				break;
			}
		}
	}
	level.var_57f8b6c5 = SArrayRandomize(level.var_57f8b6c5, "zm_stalingrad_ee_main_valves");
	level.var_57f8b6c5[5] scene::init("p7_fxanim_zm_stal_pneumatic_tube_stuck_bundle");
	level.var_57f8b6c5[5] HidePart("tag_vacume_door");
    foreach (var_beb54dbd in level.var_57f8b6c5) {
        var_beb54dbd.var_1f3c0ca7 = SRandomInt("zm_stalingrad_ee_main_valves", 3);
        var_beb54dbd.var_59c68a0b = 0;
        var_beb54dbd HidePart("tag_buttons_on");
        var_beb54dbd ShowPart("tag_buttons_off");
    }
	while ([[@zm_stalingrad_ee_main<scripts\zm\zm_stalingrad_ee_main.gsc>::function_797708de]]()) {
        foreach (var_beb54dbd in level.var_57f8b6c5) {
			var_beb54dbd.var_1f3c0ca7 = SRandomInt("zm_stalingrad_ee_main_valves", 3);
			var_beb54dbd.var_59c68a0b = 0;
			var_beb54dbd HidePart("tag_buttons_on");
			var_beb54dbd ShowPart("tag_buttons_off");
		}
    }
	array::run_all(level.var_57f8b6c5, @zm_stalingrad_ee_main<scripts\zm\zm_stalingrad_ee_main.gsc>::function_450d606e);
}

detour zm_stalingrad_ee_main<scripts\zm\zm_stalingrad_ee_main.gsc>::function_96953619()
{
	level.var_4c56821d = [];
	for (i = 1; i <= 6; i++) {
		n_index = i - 1;
		var_51a2f105 = level.var_a090a655 GetTagOrigin(("code_wheel_0" + i) + "_jnt");
		level.var_4c56821d[n_index] = util::spawn_model(("p7_fxanim_zm_stal_computer_sophia_code_ring_0" + i) + "_mod", var_51a2f105);
		level.var_4c56821d[n_index].takedamage = 1;
		util::wait_network_frame();
	}
	level.var_4c56821d[0].var_92f9e88c = 0;
	level.var_4c56821d[1].var_92f9e88c = 6;
	level.var_4c56821d[2].var_92f9e88c = 0;
	level.var_4c56821d[3].var_92f9e88c = 7;
	level.var_4c56821d[4].var_92f9e88c = 6;
	level.var_4c56821d[5].var_92f9e88c = 4;
	foreach ( var_82fe6472 in level.var_4c56821d) {
        var_82fe6472.var_c957db9f = SRandomInt("zm_stalingrad_ee_main_password", 8);
        var_82fe6472.angles = (0, var_82fe6472.var_c957db9f * 45, 0);
    }
	while ([[@zm_stalingrad_ee_main<scripts\zm\zm_stalingrad_ee_main.gsc>::function_432361e1]]()) {
        foreach ( var_82fe6472 in level.var_4c56821d) {
			var_82fe6472.var_c957db9f = SRandomInt("zm_stalingrad_ee_main_password", 8);
			var_82fe6472.angles = (0, var_82fe6472.var_c957db9f * 45, 0);
		}
    }
}

detour zm_stalingrad_ee_main<scripts\zm\zm_stalingrad_ee_main.gsc>::function_77e01bd0()
{
	level endon("ee_pursue_failed");
	self endon("step_complete");
	if (self [[@zm_stalingrad_util<scripts\zm\zm_stalingrad_util.gsc>::function_1af75b1b]](750)) {
		wait SRandomIntRange("zm_stalingrad_ee_main_gersh_chatter", 5, 10);
	}
	for (;;) {
		if (self.var_5149ab6f >= 7) {
			return;
		}
		if (self [[@zm_stalingrad_util<scripts\zm\zm_stalingrad_util.gsc>::function_1af75b1b]](750)) {
			self thread [[@zm_stalingrad_vo<scripts\zm\zm_stalingrad_vo.gsc>::function_e4acaa37]]("vox_gers_gersch_chatter_" + self.var_5149ab6f);
			self.var_5149ab6f++;
			wait 30;
		}
		wait 3;
	}
}

detour zm_stalingrad_ee_main<scripts\zm\zm_stalingrad_ee_main.gsc>::function_54457756()
{
	level endon("ee_pursue_failed");
	self endon("pap_damage");
	var_9add3f18 = SRandomFloatRange("zm_stalingrad_ee_main_gersh_wander", 20, 30);
	wait var_9add3f18;
	self notify("keep_wandering");
}

detour zm_stalingrad_ee_main<scripts\zm\zm_stalingrad_ee_main.gsc>::function_4b5f4145()
{
	level endon("weapon_cores_delivered");
	var_1f76714 = SArrayRandomize(array("vox_soph_sophia_chatter_0", "vox_soph_sophia_chatter_1", "vox_soph_sophia_chatter_2", "vox_soph_sophia_chatter_3", "vox_soph_sophia_chatter_4", "vox_soph_sophia_chatter_5"), "zm_stalingrad_ee_main_chatter");
	for (n_current_line = 0; n_current_line < 6; n_current_line++) {
		wait 50;
		level [[@zm_stalingrad_ee_main<scripts\zm\zm_stalingrad_ee_main.gsc>::function_9c8afe2b]]();
		str_notify = "sophia_preparations_complete";
		level.var_a090a655 thread [[@zm_stalingrad_ee_main<scripts\zm\zm_stalingrad_ee_main.gsc>::function_cbc0e672]](var_1f76714[n_current_line], 1, str_notify);
		level waittill(str_notify);
	}
}

detour zm_stalingrad_ee_main<scripts\zm\zm_stalingrad_ee_main.gsc>::function_3d77d2aa()
{
	var_fa839427 = array(@zm_stalingrad_ee_main<scripts\zm\zm_stalingrad_ee_main.gsc>::function_4769ea02, @zm_stalingrad_ee_main<scripts\zm\zm_stalingrad_ee_main.gsc>::function_f5139aae, ::function_62f0a233, ::function_6a1cc377, ::function_21284834);
	var_fa839427 = SArrayRandomize(var_fa839427, "zm_stalingrad_ee_main_challenges");
	foreach (n_index, var_ad364454 in var_fa839427) {
		if (var_ad364454 == (@zm_stalingrad_ee_main<scripts\zm\zm_stalingrad_ee_main.gsc>::function_f5139aae)) {
			var_e0c8798d = n_index;
			continue;
		}
		if (var_ad364454 == (::function_62f0a233)) {
			var_c1f2176c = n_index;
		}
	}
	var_9a5eed4d = Abs(var_e0c8798d - var_c1f2176c);
	while (var_9a5eed4d == 1) {
		var_fa839427 = SArrayRandomize(var_fa839427, "zm_stalingrad_ee_main_challenges");
		foreach (n_index, var_ad364454 in var_fa839427) {
			if (var_ad364454 == (@zm_stalingrad_ee_main<scripts\zm\zm_stalingrad_ee_main.gsc>::function_f5139aae)) {
				var_e0c8798d = n_index;
				continue;
			}
			if (var_ad364454 == (::function_62f0a233)) {
				var_c1f2176c = n_index;
			}
		}
		var_9a5eed4d = Abs(var_e0c8798d - var_c1f2176c);
	}
	if (!IsDefined(var_fa839427)) {
		var_fa839427 = [];
	}
	else if (!IsArray(var_fa839427)) {
		var_fa839427 = array(var_fa839427);
	}
	var_fa839427[var_fa839427.size] = @zm_stalingrad_ee_main<scripts\zm\zm_stalingrad_ee_main.gsc>::function_101e5b38;
	return var_fa839427;
}

detour zm_stalingrad_ee_main<scripts\zm\zm_stalingrad_ee_main.gsc>::function_5fa7e851()
{
	for (i = 1; i <= 6; i++) {
		wait 0.05;
		exploder::exploder("map_display_" + i);
		level.var_f0d11538 PlaySound("zmb_scenarios_map_beep");
		wait 0.05;
		exploder::stop_exploder("map_display_" + i);
	}
	for (i = 6 - 1; i > 0; i--) {
		wait 0.05;
		exploder::exploder("map_display_" + i);
		level.var_f0d11538 PlaySound("zmb_scenarios_map_beep");
		wait 0.05;
		exploder::stop_exploder("map_display_" + i);
	}
	var_1f19614 = SArrayRandomize(array(1, 2, 3, 4, 5, 6), "zm_stalingrad_ee_main_challenges");
	for (i = 0; i < 2; i++) {
		foreach (var_5bc265e5 in var_1f19614) {
			str_exploder = "map_display_" + var_5bc265e5;
			wait 0.05;
			exploder::exploder(str_exploder);
			level.var_f0d11538 PlaySound("zmb_scenarios_map_beep");
			wait 0.05;
			exploder::stop_exploder(str_exploder);
		}
		var_1f19614 = SArrayRandomize(var_1f19614, "zm_stalingrad_ee_main_challenges");
	}
}

detour zm_stalingrad_ee_main<scripts\zm\zm_stalingrad_ee_main.gsc>::function_c324c7f6()
{
	for (;;) {
		s_pod = SArrayRandom(level.var_583e4a97.var_4dfc9f38, "zm_stalingrad_ee_main_groph");
		var_181d95e = [[@dragon<scripts\zm\zm_stalingrad_dragon.gsc>::function_9a5142a]]();
		if (!IsDefined(var_181d95e)) {
			return s_pod;
		}
		switch (var_181d95e) {
			case "library": {
				if (s_pod.script_string != "ee_library") {
					return s_pod;
				}
				break;
			}
			case "factory": {
				if (s_pod.script_string != "ee_factory") {
					return s_pod;
				}
				break;
			}
			case "judicial": {
				if (s_pod.script_string != "ee_command") {
					return s_pod;
				}
				break;
			}
		}
		wait 0.5;
	}
}

detour zm_stalingrad_ee_main<scripts\zm\zm_stalingrad_ee_main.gsc>::function_62f0a233()
{
	return function_62f0a233();
}

function_62f0a233()
{
	var_23424f41 = [];
	var_8338c325 = struct::get_array("raz_location", "script_noteworthy");
	foreach (var_1fc5be4a in var_8338c325) {
		switch (var_1fc5be4a.targetname) {
			case "factory_A_spawn":
			case "factory_C_spawn":
			case "factory_C_spawn_2":
			case "library_A_spawn":
			case "library_B_spawn": {
				if (!IsDefined(var_23424f41)) {
					var_23424f41 = [];
				}
				else if (!IsArray(var_23424f41)) {
					var_23424f41 = array(var_23424f41);
				}
				var_23424f41[var_23424f41.size] = var_1fc5be4a;
				break;
			}
		}
	}
	s_spawn = SArrayRandom(var_23424f41, "zm_stalingrad_ee_main_mangler");
	if (function_7ed6c714(1, @zm_stalingrad_ee_main<scripts\zm\zm_stalingrad_ee_main.gsc>::function_4d790672, 1, s_spawn)) {
		level thread [[@zm_stalingrad_ee_main<scripts\zm\zm_stalingrad_ee_main.gsc>::function_33803fac]]();
		var_71fb112c = level util::waittill_any_return("ee_kite_complete", "ee_kite_failed");
		if (var_71fb112c == "ee_kite_complete") {
			level [[@zm_stalingrad_ee_main<scripts\zm\zm_stalingrad_ee_main.gsc>::function_2868b6f4]]();
			level [[@zm_stalingrad_vo<scripts\zm\zm_stalingrad_vo.gsc>::function_e4acaa37]]("vox_soph_capture_raz_success_1", 0, 1, 0, 1);
			level [[@zm_stalingrad_ee_main<scripts\zm\zm_stalingrad_ee_main.gsc>::function_2f418bbf]]();
			return true;
		}
	}
	return false;
}

detour zm_stalingrad_ee_main<scripts\zm\zm_stalingrad_ee_main.gsc>::function_6a1cc377()
{
	return function_6a1cc377();
}

function_6a1cc377()
{
	level.var_8acfb18e++;
	if (level.var_8acfb18e == 1) {
		level thread [[@zm_stalingrad_vo<scripts\zm\zm_stalingrad_vo.gsc>::function_e4acaa37]]("vox_soph_security_system_orders_0", 0, 1, 0, 1);
	}
	var_4af7b97 = array("armory", "barracks", "command", "store", "supply", "tank");
	var_4af7b97 = SArrayRandomize(var_4af7b97, "zm_stalingrad_ee_main_bombs");
	level function_18375f27(var_4af7b97);
	level [[@zm_stalingrad_ee_main<scripts\zm\zm_stalingrad_ee_main.gsc>::function_2868b6f4]](0);
	level.var_178c3c6b = 0;
	level thread [[@zm_stalingrad_ee_main<scripts\zm\zm_stalingrad_ee_main.gsc>::function_df3d4b2f]]();
	var_7953b28 = GetEntarray("ee_timed", "script_label");
	array::thread_all(var_7953b28, @zm_stalingrad_ee_main<scripts\zm\zm_stalingrad_ee_main.gsc>::function_82d88307, var_4af7b97);
	var_2635052a = level util::waittill_any_return("ee_timed_complete", "ee_timed_failed");
	foreach (mdl_button in var_7953b28) {
		zm_unitrigger::unregister_unitrigger(mdl_button.s_unitrigger);
		mdl_button.s_unitrigger = undefined;
	}
	level.var_178c3c6b = undefined;
	if (var_2635052a == "ee_timed_complete") {
		level.var_49799ac6 = undefined;
		level [[@zm_stalingrad_ee_main<scripts\zm\zm_stalingrad_ee_main.gsc>::function_2868b6f4]]();
		level [[@zm_stalingrad_vo<scripts\zm\zm_stalingrad_vo.gsc>::function_e4acaa37]]("vox_soph_security_system_success_0", 0, 1, 0, 1);
		level [[@zm_stalingrad_ee_main<scripts\zm\zm_stalingrad_ee_main.gsc>::function_aeaa21eb]]();
		return true;
	}
	level [[@zm_stalingrad_ee_main<scripts\zm\zm_stalingrad_ee_main.gsc>::function_f715c0b9]](var_7953b28);
	wait 1;
	foreach (mdl_button in var_7953b28) {
		mdl_button thread scene::play("p7_fxanim_zm_stal_rigged_button_retract_bundle", array(mdl_button));
		mdl_button StopLoopSound(2);
	}
	return false;
}

detour zm_stalingrad_ee_main<scripts\zm\zm_stalingrad_ee_main.gsc>::function_18375f27(var_4af7b97)
{
	return function_18375f27(var_4af7b97);
}

function_18375f27(var_4af7b97)
{
	var_cf5f1519 = GetEnt("ee_map", "targetname");
	level.var_f0d11538 PlaySound("zmb_scenarios_map_scenario_select");
	for (i = 0; i < 4; i++) {
		wait 0.4;
		foreach (str_location in var_4af7b97) {
			str_tag = "tag_map_screen_glow_" + str_location;
			var_cf5f1519 ShowPart(str_tag);
		}
		level.var_f0d11538 PlaySound("zmb_scenarios_map_beep_higher");
		wait 0.4;
		foreach (str_location in var_4af7b97) {
			str_tag = "tag_map_screen_glow_" + str_location;
			var_cf5f1519 HidePart(str_tag);
		}
	}
	var_bf616d4d = SArrayRandomize(var_4af7b97, "zm_stalingrad_ee_main_bombs");
	foreach (var_796743e2 in var_bf616d4d) {
		str_tag = "tag_map_screen_glow_" + var_796743e2;
		wait 0.1;
		var_cf5f1519 ShowPart(str_tag);
		var_cf5f1519 PlaySound("zmb_scenarios_map_beep_higher");
		wait 0.1;
		var_cf5f1519 HidePart(str_tag);
	}
	foreach (str_location in var_4af7b97) {
		str_tag = "tag_map_screen_glow_" + str_location;
		wait 0.3;
		var_cf5f1519 ShowPart(str_tag);
		var_cf5f1519 PlaySound("zmb_scenarios_map_beep_higher");
		wait 0.4;
		var_cf5f1519 HidePart(str_tag);
	}
	wait 0.1;
	for (i = 0; i < (4 - 1); i++) {
		foreach (str_location in var_4af7b97) {
			str_tag = "tag_map_screen_glow_" + str_location;
			var_cf5f1519 ShowPart(str_tag);
		}
		level.var_f0d11538 PlaySound("zmb_scenarios_map_beep_higher");
		wait 0.4;
		foreach (str_location in var_4af7b97) {
			str_tag = "tag_map_screen_glow_" + str_location;
			var_cf5f1519 HidePart(str_tag);
		}
		wait 0.4;
	}
	level.var_f0d11538 PlaySound("zmb_scenarios_map_scenario_select");
}

detour zm_stalingrad_ee_main<scripts\zm\zm_stalingrad_ee_main.gsc>::function_21284834()
{
	return function_21284834();
}

function_21284834()
{
	level.var_7f02c954 = struct::get_array("ee_pursue_position", "targetname");
	level.var_7f02c954 = SArrayRandomize(level.var_7f02c954, "zm_stalingrad_ee_main_pursue_location");
	var_4d7d0bda = array::pop_front(level.var_7f02c954, 0);
	level.var_a5fb1d00 = util::spawn_model("p7_fxanim_zm_stal_ray_gun_ball_mod", var_4d7d0bda.origin);
	level.var_a5fb1d00.takedamage = 1;
	level.var_a5fb1d00.var_92198510 = var_4d7d0bda;
	level.var_a5fb1d00.var_2b3fc782 = var_4d7d0bda;
	level.var_a5fb1d00.var_98b48961 = var_4d7d0bda;
	level.var_bce5f17f = 0;
	level.var_a5fb1d00.var_5149ab6f = 0;
	level.var_a5fb1d00 clientfield::set("ee_anomaly_loop", 1);
	loop_snd_ent = Spawn("script_origin", var_4d7d0bda.origin);
	loop_snd_ent PlayLoopSound("zmb_anomoly_loop", 0.5);
	loop_snd_ent LinkTo(level.var_a5fb1d00);
	loop_snd_ent thread [[@zm_stalingrad_ee_main<scripts\zm\zm_stalingrad_ee_main.gsc>::function_2808099a]]();
	level.var_a5fb1d00 thread [[@zm_stalingrad_ee_main<scripts\zm\zm_stalingrad_ee_main.gsc>::function_cfa09312]]();
	level.var_a5fb1d00 thread [[@zm_stalingrad_ee_main<scripts\zm\zm_stalingrad_ee_main.gsc>::function_27541a6d]]();
	level thread [[@zm_stalingrad_ee_main<scripts\zm\zm_stalingrad_ee_main.gsc>::function_6a47a4e9]]();
	var_e25d11fd = level util::waittill_any_return("ee_pursue_complete", "ee_pursue_failed");
	if (var_e25d11fd == "ee_pursue_complete") {
		level.var_7f02c954 = undefined;
		level.var_bce5f17f = undefined;
		level.var_a5fb1d00 = undefined;
		level [[@zm_stalingrad_ee_main<scripts\zm\zm_stalingrad_ee_main.gsc>::function_9aede4e6]]();
		return true;
	}
	return false;
}

detour zm_stalingrad_ee_main<scripts\zm\zm_stalingrad_ee_main.gsc>::function_4981184b()
{
	if ([[@zm_stalingrad_ee_main<scripts\zm\zm_stalingrad_ee_main.gsc>::function_4b3ee36b]]()) {
		level.var_7f02c954 = struct::get_array("ee_pursue_position", "targetname");
		level.var_7f02c954 = SArrayRandomize(level.var_7f02c954, "zm_stalingrad_ee_main_pursue_location");
	}
	for (;;) {
		if (level.var_bce5f17f >= level.var_7f02c954.size) {
			level.var_bce5f17f = 0;
		}
		var_6db1518a = level.var_7f02c954[level.var_bce5f17f];
		if ([[@zm_stalingrad_ee_main<scripts\zm\zm_stalingrad_ee_main.gsc>::function_44084295]](var_6db1518a)) {
			ArrayRemoveValue(level.var_7f02c954, var_6db1518a);
			return var_6db1518a;
		}
		level.var_bce5f17f++;
	}
}

detour zm_stalingrad_ee_main<scripts\zm\zm_stalingrad_ee_main.gsc>::function_a6093653()
{
	level endon("ee_escort_failed");
	var_fe8b6de3 = GetVehicleNode("ee_escort_entrance", "targetname");
	while (!zm_zonemgr::any_player_in_zone("start_A_zone") && !zm_zonemgr::any_player_in_zone("start_B_zone") && !zm_zonemgr::any_player_in_zone("start_C_zone")) {
		wait 1;
	}
	self vehicle::get_on_and_go_path(var_fe8b6de3);
	self thread [[@zm_stalingrad_ee_main<scripts\zm\zm_stalingrad_ee_main.gsc>::function_8c3c41dc]]();
	self [[@zm_stalingrad_ee_main<scripts\zm\zm_stalingrad_ee_main.gsc>::function_cd8abf88]]("store");
	if (!level flag::get("dept_to_yellow") && !level flag::get("department_floor3_to_red_brick_open")) {
		level flag::wait_till_any(array("dept_to_yellow", "department_floor3_to_red_brick_open"));
	}
	if (!level flag::get("dept_to_yellow")) {
		var_294b0130 = "barracks";
	}
	else {
		if (!level flag::get("department_floor3_to_red_brick_open")) {
			var_294b0130 = "armory";
		}
		else if (SCoinToss("zm_stalingrad_ee_main_escort")) {
			var_294b0130 = "barracks";
		}
		else {
			var_294b0130 = "armory";
		}
	}
	self [[@zm_stalingrad_ee_main<scripts\zm\zm_stalingrad_ee_main.gsc>::function_cd8abf88]](var_294b0130);
	self [[@zm_stalingrad_ee_main<scripts\zm\zm_stalingrad_ee_main.gsc>::function_cd8abf88]]("command");
	level notify(#"hash_611549c5");
	level [[@zm_stalingrad_ee_main<scripts\zm\zm_stalingrad_ee_main.gsc>::function_694a61ea]](self);
	level notify("ee_escort_complete");
}