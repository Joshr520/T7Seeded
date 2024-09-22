detour zm_moon_sq_osc<scripts\zm\zm_moon_sq_osc.gsc>::moon_jolie_access(ent_hacker)
{
	level thread [[@zm_moon_sq_osc<scripts\zm\zm_moon_sq_osc.gsc>::play_moon_jolie_access_vox]](ent_hacker);
	level._lid_close_sound = 1;
	for (i = 0; i < level._osc_rb_jolie_spots.size; i++) {
		[[@zm_equip_hacker<scripts\zm\_zm_equip_hacker.gsc>::deregister_hackable_struct]](level._osc_rb_jolie_spots[i]);
	}
	level._osc_terms = 0;
	random_array = level._osc_st;
	random_array = SArrayRandomize(random_array, "zm_moon_sq_osc_jolie");
	for (j = 0; j < 4; j++) {
		random_array[j].focus._light = Spawn("script_model", random_array[j].focus._light_spot.origin);
		random_array[j].focus._light.angles = random_array[j].focus._light_spot.angles;
		random_array[j].focus._light SetModel("tag_origin");
		random_array[j] [[@zm_moon_sq_osc<scripts\zm\zm_moon_sq_osc.gsc>::function_27fd2e20]](1);
		random_array[j].focus._light PlaySound("evt_sq_rbs_light_on");
		random_array[j].focus._light PlayLoopSound("evt_sq_rbs_light_loop", 1);
		[[@zm_equip_hacker<scripts\zm\_zm_equip_hacker.gsc>::register_pooled_hackable_struct]](random_array[j].focus, @zm_moon_sq_osc<scripts\zm\zm_moon_sq_osc.gsc>::moon_jolie_work);
	}
	level thread [[@zm_moon_sq_osc<scripts\zm\zm_moon_sq_osc.gsc>::moon_good_jolie]]();
	level thread [[@zm_moon_sq_osc<scripts\zm\zm_moon_sq_osc.gsc>::moon_bad_jolie]]();
	array::thread_all(random_array, @zm_moon_sq_osc<scripts\zm\zm_moon_sq_osc.gsc>::moon_jolie_timer_vox);
}