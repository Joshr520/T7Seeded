detour zm_castle_weap_quest_upgrade<scripts\zm\zm_castle_weap_quest_upgrade.gsc>::function_80d54dff(e_attacker)
{
	if (!level flag::get("demonic_rune_dropped")) {
		if (self [[@zm_castle_weap_quest_upgrade<scripts\zm\zm_castle_weap_quest_upgrade.gsc>::function_ab623d34]](level.var_6e68c0d8)) {
			if (level.var_234807d9.size > 0 && SRandomFloat("zm_castle_weap_quest_upgrade_void_rune", 1) <= 0.1) {
				self.no_powerups = 1;
				var_50ef61f9 = level.var_234807d9[0];
				level flag::set("demonic_rune_dropped");
				level._powerup_timeout_override = @zm_powerup_demonic_rune<scripts\zm\_zm_powerup_castle_demonic_rune.gsc>::function_5b767c2;
				level thread zm_powerups::specific_powerup_drop(var_50ef61f9, self.origin, undefined, undefined, undefined, level.var_6e68c0d8);
				level._powerup_timeout_override = undefined;
			}
		}
	}
}

detour zm_castle_weap_quest_upgrade<scripts\zm\zm_castle_weap_quest_upgrade.gsc>::function_88082ccd()
{
	self [[@zm_castle_weap_quest_upgrade<scripts\zm\zm_castle_weap_quest_upgrade.gsc>::function_3313abd5]]();
	for (;;) {
		self.var_67b5dd94 waittill("trigger", e_who);
		if (e_who === level.var_c62829c7) {
			zm_unitrigger::unregister_unitrigger(self.var_67b5dd94);
			break;
		}
	}
	e_who PlayRumbleOnEntity("zm_castle_quest_interact_rumble");
	level.var_bf08cf2d = undefined;
	level notify(#"hash_40e6d9e7");
	var_2716c17 = struct::get_array("aq_rp_fireplace_struct", "targetname");
	var_7f680434 = SArrayRandom(var_2716c17, "zm_castle_weap_quest_upgrade_fireplace");
	level [[@zm_castle_weap_quest_upgrade<scripts\zm\zm_castle_weap_quest_upgrade.gsc>::function_16248b25]](var_7f680434.script_int);
	var_235830d3 = var_7f680434.script_noteworthy;
	var_42d1b62e = GetEntArray("aq_rp_runic_circle", "script_noteworthy");
	foreach (var_9c1f46d7 in var_42d1b62e) {
		if (var_9c1f46d7.script_label != var_235830d3) {
			var_9c1f46d7 thread [[@zm_castle_weap_quest_upgrade<scripts\zm\zm_castle_weap_quest_upgrade.gsc>::function_aea90ad4]]();
		}
	}
	var_11307e05 = GetEntArray("aq_rp_runic_circle_symbol", "script_noteworthy");
	foreach (var_92fe416a in var_11307e05) {
		if (var_92fe416a.script_label != var_235830d3) {
			var_92fe416a thread [[@zm_castle_weap_quest_upgrade<scripts\zm\zm_castle_weap_quest_upgrade.gsc>::function_561d0d99]]();
		}
	}
	var_faf17913 = GetEntArray("aq_rp_runic_circle_volume", "script_noteworthy");
	foreach (var_9ea56658 in var_faf17913) {
		if (var_9ea56658.script_label != var_235830d3) {
			var_9ea56658 Delete();
			continue;
		}
		var_7a76a496 = var_9ea56658;
	}
	var_7a76a496.var_336f1366 = var_7f680434;
	var_9c1f46d7 = GetEnt(var_7a76a496.target, "targetname");
	var_9c1f46d7 clientfield::set("runic_circle_fx", 1);
	return var_7a76a496;
}

detour zm_castle_weap_quest_upgrade<scripts\zm\zm_castle_weap_quest_upgrade.gsc>::demon_gate_runes()
{
	level.var_ca3b8551 = 1;
	level thread [[@zm_castle_weap_quest_upgrade<scripts\zm\zm_castle_weap_quest_upgrade.gsc>::function_f3eb4a12]]();
	var_6b525fd2 = GetEntArray("aq_dg_circle_rune_outline", "script_noteworthy");
	foreach (var_1b7f8ea6 in var_6b525fd2)
	{
		var_1b7f8ea6 clientfield::set("demonic_circle_reveal", 1);
	}
	level.var_234807d9 = array("demonic_rune_lor", "demonic_rune_ulla", "demonic_rune_oth", "demonic_rune_zor", "demonic_rune_mar", "demonic_rune_uja");
	level.var_234807d9 = SArrayRandomize(level.var_234807d9, "zm_castle_weap_quest_upgrade_runes");
	level.var_289ae31d = [];
	level function_8700782f();
	level thread [[@zm_castle_weap_quest_upgrade<scripts\zm\zm_castle_weap_quest_upgrade.gsc>::function_dc9521bc]]();
	level thread [[@zm_castle_weap_quest_upgrade<scripts\zm\zm_castle_weap_quest_upgrade.gsc>::function_686645ab]]();
	while (!IsDefined(level.var_6e68c0d8)) {
		wait 0.5;
	}
	level.var_6e68c0d8 [[@zm_castle_weap_quest_upgrade<scripts\zm\zm_castle_weap_quest_upgrade.gsc>::function_3520622d]](1);
	level thread [[@zm_castle_weap_quest_upgrade<scripts\zm\zm_castle_weap_quest_upgrade.gsc>::function_cf05b763]]();
	level flag::wait_till("demon_gate_runes");
	if (IsDefined(level.var_6e68c0d8)) {
		level.var_6e68c0d8.var_c3f90c95 = undefined;
		level.var_6e68c0d8.var_a53f437d = undefined;
	}
	level [[@zm_castle_weap_quest_upgrade<scripts\zm\zm_castle_weap_quest_upgrade.gsc>::function_b9fe51c7]](); 
	level [[@zm_castle_weap_quest_upgrade<scripts\zm\zm_castle_weap_quest_upgrade.gsc>::function_695d82fd]]();
	level.var_ca3b8551 = undefined;
}

detour zm_castle_weap_quest_upgrade<scripts\zm\zm_castle_weap_quest_upgrade.gsc>::function_8700782f()
{
	return function_8700782f();
}

function_8700782f()
{
	var_579f5f7 = GetEntArray("aq_dg_circle_rune_trig", "targetname");
	var_579f5f7 = SArrayRandomize(var_579f5f7, "zm_castle_weap_quest_upgrade_runes");
	var_49f8925e = struct::get_array("aq_dg_armor_rune_struct", "targetname");
	var_49f8925e = SArrayRandomize(var_49f8925e, "zm_castle_weap_quest_upgrade_runes");
	for (i = 1; i < 4; i++) {
		var_49f8925e[i].n_index = i;
		if (!IsDefined(level.var_289ae31d)) {
			level.var_289ae31d = [];
		}
		else if (!IsArray(level.var_289ae31d)) {
			level.var_289ae31d = array(level.var_289ae31d);
		}
		level.var_289ae31d[level.var_289ae31d.size] = var_49f8925e[i].script_noteworthy;
	}
	for (i = 0; i < 6; i++) {
		var_25b51f6b = var_579f5f7[i].script_noteworthy;
		var_5a2492d5 = var_579f5f7[i].script_label;
		var_49f8925e[i] thread [[@zm_castle_weap_quest_upgrade<scripts\zm\zm_castle_weap_quest_upgrade.gsc>::function_f20a422b]](var_25b51f6b, var_5a2492d5);
		if (IsDefined(var_49f8925e[i].n_index)) {
			var_e046f594 = struct::get("aq_dg_rune_sequence_0" + var_49f8925e[i].n_index, "targetname");
			var_e046f594.var_a991b2d8 = var_25b51f6b;
		}
		var_579f5f7[i].var_483af51d = "fxexp_" + var_579f5f7[i].script_int;
		var_ca33ca2e = var_579f5f7[i].script_int + 1;
		var_579f5f7[i].var_6a1fa689 = "fxexp_" + var_ca33ca2e;
	}
}

detour zm_castle_weap_quest_upgrade<scripts\zm\zm_castle_weap_quest_upgrade.gsc>::function_afa0928d()
{
	level endon("demon_gate_runes");
	for (;;) {
		str_notify = level util::waittill_any_return("demon_gate_runes", "demonic_rune_grabbed", "demonic_rune_timed_out");
		if (str_notify == "demonic_rune_grabbed") {
			var_29c3c8d1 = array::pop_front(level.var_234807d9, 0);
			var_579f5f7 = GetEntArray("aq_dg_circle_rune_trig", "targetname");
			foreach (var_8b67f364 in var_579f5f7) {
				var_f77214c2 = "demonic_rune_" + var_8b67f364.script_label;
				if (var_f77214c2 === var_29c3c8d1) {
					var_8b67f364 thread [[@zm_castle_weap_quest_upgrade<scripts\zm\zm_castle_weap_quest_upgrade.gsc>::function_b08d39a1]]();
					var_7b98b639 = GetEnt("aq_dg_circle_rune_" + var_8b67f364.script_label, "targetname");
					var_7b98b639 clientfield::set("demonic_circle_reveal", 1);
					exploder::exploder(var_8b67f364.var_483af51d);
				}
			}
			if (level.var_234807d9.size == 0) {
				return;
			}
		}
		else {
			level.var_234807d9 = SArrayRandomize(level.var_234807d9, "zm_castle_weap_quest_upgrade_runes");
		}
	}
}

detour zm_castle_weap_quest_upgrade<scripts\zm\zm_castle_weap_quest_upgrade.gsc>::wolf_howl_paintings()
{
	var_da042480 = array("p7_zm_ctl_kings_painting_01", "p7_zm_ctl_kings_painting_02", "p7_zm_ctl_kings_painting_03", "p7_zm_ctl_kings_painting_04");
	var_18f50dca = struct::get_array("aq_wh_painting_struct", "script_noteworthy");
	var_18f50dca = SArrayRandomize(var_18f50dca, "zm_castle_weap_quest_upgrade_paintings");
	for (i = 0; i < 4; i++) {
		var_18f50dca[i] [[@zm_castle_weap_quest_upgrade<scripts\zm\zm_castle_weap_quest_upgrade.gsc>::function_3313abd5]](@zm_castle_weap_quest_upgrade<scripts\zm\zm_castle_weap_quest_upgrade.gsc>::function_47b1e30a);
		var_18f50dca[i] thread [[@zm_castle_weap_quest_upgrade<scripts\zm\zm_castle_weap_quest_upgrade.gsc>::function_2601ae75]](i, var_18f50dca);
		var_18f50dca[i].var_b5b31795 = util::spawn_model(var_da042480[i], var_18f50dca[i].origin, var_18f50dca[i].angles);
	}
	level flag::wait_till("wolf_howl_paintings");
	foreach (var_48c991cb in var_18f50dca) {
		zm_unitrigger::unregister_unitrigger(var_48c991cb.var_67b5dd94);
	}
	var_a462d6ee = struct::get("quest_start_wolf_howl");
	var_a462d6ee [[@zm_castle_weap_quest_upgrade<scripts\zm\zm_castle_weap_quest_upgrade.gsc>::function_5e09adfd]]();
	level thread scene::play("p7_fxanim_zm_castle_quest_wolf_wall_explode_bundle");
	level thread scene::play("p7_fxanim_zm_castle_quest_wolf_arrow_broken_reveal_bundle");
	level waittill(#"hash_44c83018");
	foreach (e_player in level.activeplayers) {
		e_player.var_b89ed4e5 = undefined;
	}
	level.var_eee1576 = GetEnt("quest_wolf_arrow_broken_reveal", "targetname");
	var_a462d6ee [[@zm_castle_weap_quest_upgrade<scripts\zm\zm_castle_weap_quest_upgrade.gsc>::function_f708e6b2]]();
}