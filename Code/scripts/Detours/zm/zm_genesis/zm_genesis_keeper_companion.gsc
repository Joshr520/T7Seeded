detour zm_genesis_keeper_companion<scripts\zm\zm_genesis_keeper_companion.gsc>::function_dbc32a6d()
{
	var_7db6b6e1 = struct::get_array("companion_totem_part", "targetname");
	var_e5e70941 = SArrayRandom(var_7db6b6e1, "zm_genesis_keeper_companion_keeper_part");
	var_e5e70941.n_scale = 0.75;
	var_e5e70941.var_fdb628a4 = "keeper_callbox_totem";
	var_e5e70941.v_offset = VectorScale((0, 0, 1), 20);
	var_e5e70941 thread [[@zm_genesis_keeper_companion<scripts\zm\zm_genesis_keeper_companion.gsc>::function_85555c9]]();
	var_133619e4 = struct::get_array("companion_head_part", "targetname");
	var_6a2693c4 = SArrayRandom(var_133619e4, "zm_genesis_keeper_companion_keeper_part");
	var_6a2693c4.n_scale = 1.5;
	var_6a2693c4.var_fdb628a4 = "keeper_callbox_head";
	var_6a2693c4 thread [[@zm_genesis_keeper_companion<scripts\zm\zm_genesis_keeper_companion.gsc>::function_85555c9]]();
	var_79d5129b = struct::get_array("companion_gem_part", "targetname");
	var_fb9b76fb = SArrayRandom(var_79d5129b, "zm_genesis_keeper_companion_keeper_part");
	var_fb9b76fb.n_scale = 2;
	var_fb9b76fb.var_fdb628a4 = "keeper_callbox_gem";
	var_fb9b76fb thread [[@zm_genesis_keeper_companion<scripts\zm\zm_genesis_keeper_companion.gsc>::function_85555c9]]();
}