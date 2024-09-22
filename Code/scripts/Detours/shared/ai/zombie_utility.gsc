detour zombie_utility<scripts\shared\ai\zombie_utility.gsc>::set_run_speed()
{
	if (IsDefined(level.zombie_force_run)) {
		self.zombie_move_speed = "run";
		level.zombie_force_run--;
		if (level.zombie_force_run <= 0)
		{
			level.zombie_force_run = undefined;
		}
		return;
	}
	rand = SRandomIntRange("zombie_utility_speed", level.zombie_move_speed, level.zombie_move_speed + 35);
	if (rand <= 35) {
		self.zombie_move_speed = "walk";
	}
	else if (rand <= 70) {
        self.zombie_move_speed = "run";
    }
    else {
        self.zombie_move_speed = "sprint";
    }
}