detour zm_powerup_island_seed<scripts\zm\_zm_powerup_island_seed.gsc>::function_1f5d3f75(drop_point)
{
	if (!level [[@zm_powerup_island_seed<scripts\zm\_zm_powerup_island_seed.gsc>::function_f766ae15]]()) {
		return false;
	}
	if (level.var_9895ed0d >= level.var_325c412f) {
		return false;
	}
	rand_drop = SRandomInt("zm_powerup_island_seed_drop", 100);
	if (rand_drop > 2) {
		if (level.var_e964b72 == 0) {
			return;
		}
	}
	var_93eb638b = zm_powerups::specific_powerup_drop("island_seed", drop_point);
	level thread [[@zm_powerup_island_seed<scripts\zm\_zm_powerup_island_seed.gsc>::function_ca5485fa]](var_93eb638b);
	level.var_9895ed0d++;
	level.var_e964b72 = 0;
	return true;
}

detour zm_powerup_island_seed<scripts\zm\_zm_powerup_island_seed.gsc>::function_7a25b639(drop_point)
{
	if (!level [[@zm_powerup_island_seed<scripts\zm\_zm_powerup_island_seed.gsc>::function_f766ae15]]()) {
		return false;
	}
	if (level flag::get("round_1_seed_spawned")) {
		return false;
	}
	if (SCoinToss("zm_powerup_island_seed_drop") || GetAICount() < 1) {
		var_93eb638b = zm_powerups::specific_powerup_drop("island_seed", drop_point);
		level flag::set("round_1_seed_spawned");
		level thread [[@zm_powerup_island_seed<scripts\zm\_zm_powerup_island_seed.gsc>::function_ca5485fa]](var_93eb638b);
		level.var_9895ed0d++;
		return true;
	}
}