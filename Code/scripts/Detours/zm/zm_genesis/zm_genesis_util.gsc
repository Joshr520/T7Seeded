detour zm_genesis_util<scripts\zm\zm_genesis_util.gsc>::electricity_rune_quest_start()
{
	a_s_start_pos = struct::get_array("electricity_rune_quest_start", "targetname");
	s_start_pos = SArrayRandom(a_s_start_pos, "zm_genesis_util_location");
	s_start_pos thread [[@zm_genesis_util<scripts\zm\zm_genesis_util.gsc>::function_15e7a0c8]]("electricity_rq_started", @zm_genesis_util<scripts\zm\zm_genesis_util.gsc>::function_2f157912, @zm_genesis_util<scripts\zm\zm_genesis_util.gsc>::function_e889d17c);
}

detour zm_genesis_util<scripts\zm\zm_genesis_util.gsc>::fire_rune_quest_start()
{
	a_s_start_pos = struct::get_array("fire_rune_quest_start", "targetname");
	s_start_pos = SArrayRandom(a_s_start_pos, "zm_genesis_util_location");
	s_start_pos thread [[@zm_genesis_util<scripts\zm\zm_genesis_util.gsc>::function_15e7a0c8]]("fire_rq_started", @zm_genesis_util<scripts\zm\zm_genesis_util.gsc>::function_8164c629, @zm_genesis_util<scripts\zm\zm_genesis_util.gsc>::function_9b7022b5);
}

detour zm_genesis_util<scripts\zm\zm_genesis_util.gsc>::light_rune_quest_start()
{
	a_s_start_pos = struct::get_array("light_rune_quest_start", "targetname");
	s_start_pos = SArrayRandom(a_s_start_pos, "zm_genesis_util_location");
	s_start_pos thread [[@zm_genesis_util<scripts\zm\zm_genesis_util.gsc>::function_15e7a0c8]]("light_rq_started", @zm_genesis_util<scripts\zm\zm_genesis_util.gsc>::function_45c80653, @zm_genesis_util<scripts\zm\zm_genesis_util.gsc>::function_aef2e0a3);
}

detour zm_genesis_util<scripts\zm\zm_genesis_util.gsc>::shadow_rune_quest_start()
{
	a_s_start_pos = struct::get_array("shadow_rune_quest_start", "targetname");
	s_start_pos = SArrayRandom(a_s_start_pos, "zm_genesis_util_location");
	s_start_pos thread [[@zm_genesis_util<scripts\zm\zm_genesis_util.gsc>::function_15e7a0c8]]("shadow_rq_started", @zm_genesis_util<scripts\zm\zm_genesis_util.gsc>::function_9944ee4d, @zm_genesis_util<scripts\zm\zm_genesis_util.gsc>::function_6d12ad69);
}
