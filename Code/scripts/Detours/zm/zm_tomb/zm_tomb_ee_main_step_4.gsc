detour zm_tomb_ee_main_step_4<scripts\zm\zm_tomb_ee_main_step_4.gsc>::stage_logic()
{
	level flag::wait_till("ee_quadrotor_disabled");
	level thread [[@zm_tomb_ee_main_step_4<scripts\zm\zm_tomb_ee_main_step_4.gsc>::sndee4music]]();
	if (!level flag::get("ee_mech_zombie_fight_completed")) {
		while (level.ee_mech_zombies_spawned < 8) {
			if (level.ee_mech_zombies_alive < 4) {
				ai = zombie_utility::spawn_zombie(level.mechz_spawners[0]);
				ai thread [[@zm_tomb_ee_main_step_4<scripts\zm\zm_tomb_ee_main_step_4.gsc>::ee_mechz_spawn]](level.ee_mech_zombies_spawned % 4);
				level.ee_mech_zombies_alive++;
				level.ee_mech_zombies_spawned++;
			}
			wait SRandomFloatRange("zm_tomb_ee_main_step_4_spawn", 0.5, 1);
		}
	}
	level flag::wait_till("ee_mech_zombie_fight_completed");
	util::wait_network_frame();
	zm_sidequests::stage_completed("little_girl_lost", level._cur_stage_name);
}