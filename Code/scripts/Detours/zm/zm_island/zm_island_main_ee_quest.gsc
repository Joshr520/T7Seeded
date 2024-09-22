detour main_quest<scripts\zm\zm_island_main_ee_quest.gsc>::function_35340bf6()
{
	while (!flag::get("aa_gun_ee_complete")) {
		e_vehicle = vehicle::simple_spawn_single("main_ee_aa_gun_plane");
		e_vehicle SetForceNoCull();
		e_vehicle thread function_45e9f465();
		e_vehicle thread [[@zm_island_perks<scripts\zm\zm_island_perks.gsc>::function_235019b6]]("main_ee_aa_gun_plane_path");
		e_vehicle waittill("reached_end_node");
		e_vehicle clientfield::set("plane_hit_by_aa_gun", 0);
		wait SRandomIntRange("zm_island_main_ee_quest_plane", 60, 120);
	}
}

detour main_quest<scripts\zm\zm_island_main_ee_quest.gsc>::function_f818f5b5()
{
	level flag::wait_till("all_challenges_completed");
	zm::register_actor_damage_callback(@main_quest<scripts\zm\zm_island_main_ee_quest.gsc>::function_16155679);
	zm::register_vehicle_damage_callback(@main_quest<scripts\zm\zm_island_main_ee_quest.gsc>::function_a7a11020);
	var_8d943e64 = GetEnt("ruins_lightning_trigger", "targetname");
	for (;;) {
		wait SRandomFloatRange("zm_island_main_ee_quest_lightning", 60, 90);
		exploder::exploder("fxexp_510");
		exploder::exploder("fxexp_511");
		exploder::exploder("fxexp_512");
		exploder::exploder("fxexp_513");
		exploder::exploder("fxexp_514");
		exploder::exploder("fxexp_820");
		exploder::exploder("fxexp_821");
		exploder::exploder("fxexp_822");
		exploder::exploder("fxexp_823");
		level thread [[@main_quest<scripts\zm\zm_island_main_ee_quest.gsc>::function_51f6829f]](var_8d943e64);
		wait 5;
		level notify(#"hash_6d764fa3");
		exploder::exploder_stop("fxexp_510");
		exploder::exploder_stop("fxexp_511");
		exploder::exploder_stop("fxexp_512");
		exploder::exploder_stop("fxexp_513");
		exploder::exploder_stop("fxexp_514");
		exploder::exploder_stop("fxexp_820");
		exploder::exploder_stop("fxexp_821");
		exploder::exploder_stop("fxexp_822");
		exploder::exploder_stop("fxexp_823");
	}
}

detour main_quest<scripts\zm\zm_island_main_ee_quest.gsc>::function_45e9f465()
{
	return function_45e9f465();
}

function_45e9f465()
{
	self endon("reached_end_node");
	level flag::wait_till("aa_gun_ee_complete");
	wait(0.3);
	self clientfield::set("plane_hit_by_aa_gun", 1);
	self PlaySound("evt_b17_explode");
	var_f7fded02 = struct::get_array("aa_gun_elevator_part_landing", "targetname");
	s_end = SArrayRandom(var_f7fded02, "zm_island_main_ee_quest_plane_cog");
	s_explosion = SpawnStruct();
	s_explosion.origin = self.origin;
	s_explosion.angles = self.angles;
	s_explosion thread scene::play("p7_fxanim_zm_island_b17_explode_bundle");
	self.delete_on_death = 1;
	self notify("death");
	if (!IsAlive(self)) {
		self Delete();
	}
	wait 0.05;
	if (s_end.script_noteworthy == "gear_meteor") {
		nd_path_start = GetVehicleNode("meteor_start", "targetname");
	}
	else if (s_end.script_noteworthy == "gear_bunker") {
		nd_path_start = GetVehicleNode("bunker_start", "targetname");
	}
	else {
		nd_path_start = GetVehicleNode("lab_start", "targetname");
	}
	var_6549ae27 = spawner::simple_spawn_single("gear_vehicle");
	mdl_part = util::spawn_model("p7_zm_bgb_gear_01", var_6549ae27.origin, s_end.angles);
	mdl_part LinkTo(var_6549ae27);
	mdl_part PlayLoopSound("evt_b17_piece_lp");
	util::wait_network_frame();
	mdl_part clientfield::set("smoke_trail_fx", 1);
	var_6549ae27 vehicle::get_on_and_go_path(nd_path_start);
	var_6549ae27 waittill("reached_end_node");
	var_6549ae27.delete_on_death = 1;
	var_6549ae27 notify("death");
	if (!IsAlive(var_6549ae27)) {
		var_6549ae27 Delete();
	}
	mdl_part MoveTo(s_end.origin, 0.1);
	mdl_part waittill("movedone");
	mdl_part clientfield::set("smoke_trail_fx", 0);
	mdl_part clientfield::set("smoke_smolder_fx", 1);
	mdl_part PlaySound("evt_b17_piece_impact");
	mdl_part StopLoopSound(0.25);
	mdl_part.trigger = [[@zm_island_util<scripts\zm\zm_island_util.gsc>::spawn_trigger_radius]](mdl_part.origin, 50, 1, @main_quest<scripts\zm\zm_island_main_ee_quest.gsc>::function_9bd3096f);
	mdl_part thread [[@main_quest<scripts\zm\zm_island_main_ee_quest.gsc>::function_d81e5824]]("elevator_part_gear3_found");
	s_explosion = undefined;
}