detour zm_moon_wasteland<scripts\zm\zm_moon_wasteland.gsc>::perk_machine_arrival_update()
{
	top_height = 1200;
	fall_time = 4;
	num_model_swaps = 20;
	perk_index = SRandomIntRange("zm_moon_wasteland_perk", 0, 2);
	ent = level.speed_cola_ents[0];
	level thread [[@zm_moon_wasteland<scripts\zm\zm_moon_wasteland.gsc>::perk_arrive_fx]](ent.origin);
	[[@zm_moon_wasteland<scripts\zm\zm_moon_wasteland.gsc>::move_perk]](top_height, 0.01, 0.001);
	wait 0.3;
	[[@zm_moon_wasteland<scripts\zm\zm_moon_wasteland.gsc>::perk_machines_hide]](0, 0, 1);
	wait 1;
	[[@zm_moon_wasteland<scripts\zm\zm_moon_wasteland.gsc>::move_perk]](top_height * -1, fall_time, 1.5);
	wait_step = fall_time / num_model_swaps;
	for (i = 0; i < num_model_swaps; i++) {
		[[@zm_moon_wasteland<scripts\zm\zm_moon_wasteland.gsc>::perk_machine_show_selected]](perk_index, 1);
		wait wait_step;
		perk_index++;
		if (perk_index > 1) {
			perk_index = 0;
		}
	}
	while (perk_index == level.last_perk_index) {
		perk_index = SRandomIntRange("zm_moon_wasteland_perk", 0, 2);
	}
	level.last_perk_index = perk_index;
	[[@zm_moon_wasteland<scripts\zm\zm_moon_wasteland.gsc>::perk_machine_show_selected]](perk_index, 0);
}

detour zm_moon_wasteland<scripts\zm\zm_moon_wasteland.gsc>::spawn_a_zombie(max_zombies, var_c194e88d, wait_delay, ignoregravity)
{
	zombies = GetAISpeciesArray(level.zombie_team);
	if (zombies.size >= max_zombies) {
		return undefined;
	}
	var_71aee853 = GetEntArray("nml_zone_spawner", "targetname");
	e_spawner = SArrayRandom(var_71aee853, "zm_moon_wasteland_spawn_location");
	var_50f2968b = struct::get_array(var_c194e88d, "targetname");
	s_spawn_loc = SArrayRandom(var_50f2968b, "zm_moon_wasteland_spawn_location");
	ai = zombie_utility::spawn_zombie(e_spawner, var_c194e88d, s_spawn_loc);
	if (IsDefined(ai)) {
		if (IS_TRUE(ignoregravity)) {
			ai.ignore_gravity = 1;
		}
		if (IS_TRUE(level.mp_side_step)) {
			ai.shouldsidestepfunc = @zm_moon_wasteland<scripts\zm\zm_moon_wasteland.gsc>::nml_shouldsidestep;
			ai.sidestepanims = [];
		}
	}
	return ai;
}