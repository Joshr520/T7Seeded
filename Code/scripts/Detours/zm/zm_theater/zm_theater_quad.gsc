detour zm_theater_quad<scripts\zm\zm_theater_quad.gsc>::spawn_a_quad_zombie(spawn_array)
{
	spawn_point = spawn_array[SRandomInt("zm_theater_quad_spawn", spawn_array.size)];
	ai = zombie_utility::spawn_zombie(spawn_point);
	if (IsDefined(ai)) {
		ai thread zombie_utility::round_spawn_failsafe();
		ai thread [[@zm_theater_quad<scripts\zm\zm_theater_quad.gsc>::quad_traverse_death_fx]]();
	}
	wait level.zombie_vars["zombie_spawn_delay"];
	util::wait_network_frame();
}

detour zm_theater_quad<scripts\zm\zm_theater_quad.gsc>::spawn_second_wave_quads(second_wave_targetname)
{
	second_wave_spawners = [];
	second_wave_spawners = GetEntArray(second_wave_targetname, "targetname");
	if (second_wave_spawners.size < 1) {
		return;
	}
	for (i = 0; i < second_wave_spawners.size; i++) {
		ai = zombie_utility::spawn_zombie(second_wave_spawners[i]);
		if (IsDefined(ai)) {
			ai thread zombie_utility::round_spawn_failsafe();
			ai thread [[@zm_theater_quad<scripts\zm\zm_theater_quad.gsc>::quad_traverse_death_fx]]();
		}
		wait SRandomIntRange("zm_theater_quad_wave", 10, 45);
	}
	util::wait_network_frame();
}

detour zm_theater_quad<scripts\zm\zm_theater_quad.gsc>::manage_zombie_spawn_delay(start_timer)
{
	if ((GetTime() - start_timer) < 15000) {
		level.zombie_vars["zombie_spawn_delay"] = SRandomIntRange("zm_theater_quad_delay", 30, 45);
	}
	else if ((GetTime() - start_timer) < 25000) {
		level.zombie_vars["zombie_spawn_delay"] = SRandomIntRange("zm_theater_quad_delay", 15, 30);
	}
	else if ((GetTime() - start_timer) < 35000) {
		level.zombie_vars["zombie_spawn_delay"] = SRandomIntRange("zm_theater_quad_delay", 10, 15);
	}
	else if ((GetTime() - start_timer) < 50000) {
		level.zombie_vars["zombie_spawn_delay"] = SRandomIntRange("zm_theater_quad_delay", 5, 10);
	}
}