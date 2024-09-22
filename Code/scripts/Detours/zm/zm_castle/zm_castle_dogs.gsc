detour zm_castle_dogs<scripts\zm\zm_castle_dogs.gsc>::dog_round_tracker()
{
	level.dog_round_count = 1;
	level.next_dog_round = level.round_number + SRandomIntRange("zm_castle_dogs_round", 4, 6);
	old_spawn_func = level.round_spawn_func;
	old_wait_func = level.round_wait_func;
	for (;;) {
		level waittill("between_round_over");
		if (level.round_number == level.next_dog_round) {
			level.sndmusicspecialround = 1;
			old_spawn_func = level.round_spawn_func;
			old_wait_func = level.round_wait_func;
			[[@zm_ai_dogs<scripts\zm\_zm_ai_dogs.gsc>::dog_round_start]]();
			level.round_spawn_func = @zm_ai_dogs<scripts\zm\_zm_ai_dogs.gsc>::dog_round_spawning;
			level.round_wait_func = @zm_ai_dogs<scripts\zm\_zm_ai_dogs.gsc>::dog_round_wait_func;
			level clientfield::set("castle_fog_bank_switch", 1);
			level.next_dog_round = level.round_number + SRandomIntRange("zm_castle_dogs_round", 7, 14);
		}
		else if (level flag::get("dog_round")) {
			level clientfield::set("castle_fog_bank_switch", 0);
			[[@zm_ai_dogs<scripts\zm\_zm_ai_dogs.gsc>::dog_round_stop]]();
			level.round_spawn_func = old_spawn_func;
			level.round_wait_func = old_wait_func;
			level.dog_round_count = level.dog_round_count + 1;
		}
	}
}

detour zm_castle_dogs<scripts\zm\zm_castle_dogs.gsc>::function_33aa4940()
{
	var_88369d66 = 0;
	if (level.round_number > 30) {
		if (SRandomFloat("zm_castle_dogs_custom_spawn", 100) < 4) {
			var_88369d66 = 1;
		}
	}
	else if (level.round_number > 25) {
		if (SRandomFloat("zm_castle_dogs_custom_spawn", 100) < 3) {
			var_88369d66 = 1;
		}
	}
	else if (level.round_number > 20) {
		if (SRandomFloat("zm_castle_dogs_custom_spawn", 100) < 2) {
			var_88369d66 = 1;
		}
	}
	else if (level.round_number > 15) {
		if (SRandomFloat("zm_castle_dogs_custom_spawn", 100) < 1) {
			var_88369d66 = 1;
		}
	}
	if (var_88369d66) {
		special_dog_spawn(1);
		level.zombie_total--;
	}
	return var_88369d66;
}

detour zm_castle_dogs<scripts\zm\zm_castle_dogs.gsc>::function_92e4eaff(var_70e0fe97, var_19764360)
{
	var_2ad6ea05 = SArrayRandomize(level.zm_loc_types["dog_location"], "zm_castle_dogs_spawn");
	for (i = 0; i < var_2ad6ea05.size; i++) {
		if (IsDefined(level.old_dog_spawn) && level.old_dog_spawn == var_2ad6ea05[i]) {
			continue;
		}
		if (IsDefined(var_19764360)) {
			n_dist_squared = DistanceSquared(var_2ad6ea05[i].origin, var_19764360.origin);
			if (n_dist_squared > 360000 && n_dist_squared < 1440000) {
				level.old_dog_spawn = var_2ad6ea05[i];
				return var_2ad6ea05[i];
			}
		}
	}
	return var_2ad6ea05[0];
}