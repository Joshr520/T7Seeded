detour zm_island_pap_quest<scripts\zm\zm_island_pap_quest.gsc>::function_bd8082d1()
{
	var_1daee2f1 = GetEntArray("cocoon_bunker", "targetname");
	var_d43245b8 = [];
	foreach (mdl_cocoon in var_1daee2f1) {
		if (!mdl_cocoon.is_open) {
			if (!IsDefined(var_d43245b8)) {
				var_d43245b8 = [];
			}
			else if (!IsArray(var_d43245b8)) {
				var_d43245b8 = array(var_d43245b8);
			}
			var_d43245b8[var_d43245b8.size] = mdl_cocoon;
		}
	}
	var_696dc555 = SArrayRandom(var_d43245b8, "zm_island_pap_quest_cocoon");
	var_696dc555.var_166a0518 = 1;
}

detour zm_island_pap_quest<scripts\zm\zm_island_pap_quest.gsc>::defend_start()
{
	while (!level flag::exists("penstock_debris_cleared")) {
		wait 1;
	}
	var_44f2dff7 = struct::get_array("defend_valve_spawnpt");
	level.var_74049442 = 0;
	switch (level.players.size) {
		case 1: {
			var_4cf30066 = 8;
			break;
		}
		case 2: {
			var_4cf30066 = 10;
			break;
		}
		case 3: {
			var_4cf30066 = 14;
			break;
		}
		case 4: {
			var_4cf30066 = 18;
			break;
		}
	}
	level flag::wait_till("penstock_debris_cleared");
	level.mdl_gate.v_org = level.mdl_gate.origin;
	level.mdl_gate.v_pos = struct::get(level.mdl_gate.target).origin;
	level.mdl_clip Solid();
	level.mdl_clip DisconnectPaths();
	level.mdl_gate MoveTo(level.mdl_gate.v_pos, 3);
	level.mdl_gate PlaySound("zmb_papquest_defend_gate_close");
	exploder::exploder("fxexp_202");
	level.disable_nuke_delay_spawning = 1;
	level flag::clear("spawn_zombies");
	level thread [[@zm_island_pap_quest<scripts\zm\zm_island_pap_quest.gsc>::function_3d4e00c]]();
	exploder::exploder("lgt_penstock_event");
	while (level.var_74049442 < 13) {
		var_44f2dff7 = SArrayRandomize(var_44f2dff7, "zm_island_pap_quest_defend");
		for (i = 0; i < var_44f2dff7.size; i++) {
			while (GetFreeActorCount() < 1) {
				wait 0.05;
			}
			while ([[@zm_island_pap_quest<scripts\zm\zm_island_pap_quest.gsc>::function_a3ebebe]]() >= var_4cf30066) {
				wait 0.05;
			}
			ai_zombie = zombie_utility::spawn_zombie(level.zombie_spawners[0], "defend_zombie", var_44f2dff7[i]);
			if (IsDefined(ai_zombie)) {
				if (IsDefined(var_44f2dff7[i].script_int)) {
					ai_zombie.var_57b55f08 = 1;
				}
				ai_zombie thread [[@zm_island_pap_quest<scripts\zm\zm_island_pap_quest.gsc>::function_2392e644]]();
				level.var_74049442++;
				if (level.var_74049442 >= 13) {
					break;
				}
				wait 1.5;
			}
		}
		wait 0.1;
	}
}

detour zm_island_pap_quest<scripts\zm\zm_island_pap_quest.gsc>::function_4fdc8e70()
{
	level flag::wait_till("connect_bunker_exterior_to_bunker_interior");
	var_f89319f8 = struct::get_array("valvetwo_part_lever");
	mdl_part = util::spawn_model("p7_zm_isl_pap_elements_wheel", SArrayRandom(var_f89319f8, "zm_island_pap_quest_wheel").origin);
	mdl_part clientfield::set("show_part", 1);
	mdl_part SetScale(1.5);
	mdl_part.trigger = [[@zm_island_util<scripts\zm\zm_island_util.gsc>::spawn_trigger_radius]](mdl_part.origin, 50, 1, @zm_island_pap_quest<scripts\zm\zm_island_pap_quest.gsc>::function_9bd3096f);
	mdl_part thread [[@zm_island_pap_quest<scripts\zm\zm_island_pap_quest.gsc>::function_1a519eae]]("valve2_found");
}