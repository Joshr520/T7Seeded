detour zm_ai_raps<scripts\zm\_zm_ai_raps.gsc>::raps_round_tracker()
{
	level.raps_round_count = 1;
	level.n_next_raps_round = SRandomIntRange("zm_ai_raps_round", 9, 11);
	old_spawn_func = level.round_spawn_func;
	old_wait_func = level.round_wait_func;
	for (;;) {
		level waittill("between_round_over");
		if (level.round_number == level.n_next_raps_round) {
			level.sndmusicspecialround = 1;
			old_spawn_func = level.round_spawn_func;
			old_wait_func = level.round_wait_func;
			[[@zm_ai_raps<scripts\zm\_zm_ai_raps.gsc>::raps_round_start]]();
			level.round_spawn_func = @zm_ai_raps<scripts\zm\_zm_ai_raps.gsc>::raps_round_spawning;
			level.round_wait_func = @zm_ai_raps<scripts\zm\_zm_ai_raps.gsc>::raps_round_wait_func;
			if (IsDefined(level.zm_custom_get_next_raps_round)) {
				level.n_next_raps_round = [[level.zm_custom_get_next_raps_round]]();
			}
			else {
				level.n_next_raps_round = (10 + (level.raps_round_count * 10)) + (SRandomIntRange("zm_ai_raps_round", -1, 1));
			}
		}
		else if (level flag::get("raps_round")) {
			[[@zm_ai_raps<scripts\zm\_zm_ai_raps.gsc>::raps_round_stop]]();
			level.round_spawn_func = old_spawn_func;
			level.round_wait_func = old_wait_func;
			level.raps_round_count++;
		}
	}
}