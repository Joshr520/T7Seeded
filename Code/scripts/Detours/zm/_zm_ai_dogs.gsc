detour zm_ai_dogs<scripts\zm\_zm_ai_dogs.gsc>::special_dog_spawn(num_to_spawn, spawners, spawn_point)
{
	return special_dog_spawn(num_to_spawn, spawners, spawn_point);
}

special_dog_spawn(num_to_spawn, spawners, spawn_point)
{
	dogs = GetAISpeciesArray("all", "zombie_dog");
	if (IsDefined(dogs) && dogs.size >= 9) {
		return false;
	}
	if (!IsDefined(num_to_spawn)) {
		num_to_spawn = 1;
	}
	spawn_point = undefined;
	count = 0;
	while (count < num_to_spawn) {
		players = GetPlayers();
		favorite_enemy = [[@zm_ai_dogs<scripts\zm\_zm_ai_dogs.gsc>::get_favorite_enemy]]();
		if (IsDefined(spawners)) {
			if (!IsDefined(spawn_point)) {
				spawn_point = spawners[SRandomInt("zm_ai_dogs_spawn_special", spawners.size)];
			}
			ai = zombie_utility::spawn_zombie(spawn_point);
			if (IsDefined(ai)) {
				ai.favoriteenemy = favorite_enemy;
				spawn_point thread [[@zm_ai_dogs<scripts\zm\_zm_ai_dogs.gsc>::dog_spawn_fx]](ai);
				count++;
				level flag::set("dog_clips");
			}
		}
		else if (IsDefined(level.dog_spawn_func)) {
            spawn_loc = [[level.dog_spawn_func]](level.dog_spawners, favorite_enemy);
            ai = zombie_utility::spawn_zombie(level.dog_spawners[0]);
            if (IsDefined(ai)) {
                ai.favoriteenemy = favorite_enemy;
                spawn_loc thread [[@zm_ai_dogs<scripts\zm\_zm_ai_dogs.gsc>::dog_spawn_fx]](ai, spawn_loc);
                count++;
                level flag::set("dog_clips");
            }
        }
        else {
            spawn_point = dog_spawn_factory_logic(favorite_enemy);
            ai = zombie_utility::spawn_zombie(level.dog_spawners[0]);
            if (IsDefined(ai)) {
                ai.favoriteenemy = favorite_enemy;
                spawn_point thread [[@zm_ai_dogs<scripts\zm\_zm_ai_dogs.gsc>::dog_spawn_fx]](ai, spawn_point);
                count++;
                level flag::set("dog_clips");
            }
        }
		[[@zm_ai_dogs<scripts\zm\_zm_ai_dogs.gsc>::waiting_for_next_dog_spawn]](count, num_to_spawn);
	}
	return true;
}

detour zm_ai_dogs<scripts\zm\_zm_ai_dogs.gsc>::dog_round_tracker()
{
	level.dog_round_count = 1;
	level.next_dog_round = level.round_number + SRandomIntRange("zm_ai_dogs_round", 4, 7);
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
			level.next_dog_round = level.round_number + SRandomIntRange("zm_ai_dogs_round", 4, 6);
		}
		else if (level flag::get("dog_round")) {
			[[@zm_ai_dogs<scripts\zm\_zm_ai_dogs.gsc>::dog_round_stop]]();
			level.round_spawn_func = old_spawn_func;
			level.round_wait_func = old_wait_func;
			level.dog_round_count = level.dog_round_count + 1;
		}
	}
}

detour zm_ai_dogs<scripts\zm\_zm_ai_dogs.gsc>::dog_spawn_factory_logic(favorite_enemy)
{
	return dog_spawn_factory_logic(favorite_enemy);
}

dog_spawn_factory_logic(favorite_enemy)
{
	dog_locs = SArrayRandomize(level.zm_loc_types["dog_location"], "zm_ai_dogs_spawn_location");
	for (i = 0; i < dog_locs.size; i++) {
		if (IsDefined(level.old_dog_spawn) && level.old_dog_spawn == dog_locs[i]) {
			continue;
		}
		if (!IsDefined(favorite_enemy)) {
			continue;
		}
		dist_squared = DistanceSquared(dog_locs[i].origin, favorite_enemy.origin);
		if (dist_squared > 160000 && dist_squared < 1000000) {
			level.old_dog_spawn = dog_locs[i];
			return dog_locs[i];
		}
	}
	return dog_locs[0];
}