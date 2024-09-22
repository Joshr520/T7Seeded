detour zm_ai_sonic<scripts\zm\_zm_ai_sonic.gsc>::__main__()
{
	level.soniczombiesenabled = 1;
	level.soniczombieminroundwait = 1;
	level.soniczombiemaxroundwait = 3;
	level.soniczombieroundrequirement = 4;
	level.nextsonicspawnround = level.soniczombieroundrequirement + (SRandomIntRange("zm_ai_sonic_round", 0, level.soniczombiemaxroundwait + 1));
	level.sonicplayerdamage = 10;
	level.sonicscreamdamageradius = 300;
	level.sonicscreamattackradius = 240;
	level.sonicscreamattackdebouncemin = 3;
	level.sonicscreamattackdebouncemax = 9;
	level.sonicscreamattacknext = 0;
	level.sonichealthmultiplier = 2.5;
	level.sonic_zombie_spawners = GetEntArray("sonic_zombie_spawner", "script_noteworthy");
	zombie_utility::set_zombie_var("thundergun_knockdown_damage", 15);
	level.thundergun_gib_refs = [];
	level.thundergun_gib_refs[level.thundergun_gib_refs.size] = "guts";
	level.thundergun_gib_refs[level.thundergun_gib_refs.size] = "right_arm";
	level.thundergun_gib_refs[level.thundergun_gib_refs.size] = "left_arm";
	array::thread_all(level.sonic_zombie_spawners, spawner::add_spawn_function, @zm_ai_sonic<scripts\zm\_zm_ai_sonic.gsc>::sonic_zombie_spawn);
	array::thread_all(level.sonic_zombie_spawners, spawner::add_spawn_function, zombie_utility::round_spawn_failsafe);
	zm_spawner::register_zombie_damage_callback(@zm_ai_sonic<scripts\zm\_zm_ai_sonic.gsc>::_sonic_damage_callback);
	level thread function_1249f13c();
}

detour zm_ai_sonic<scripts\zm\_zm_ai_sonic.gsc>::_updatenextscreamtime()
{
	self.sonicscreamattacknext = GetTime();
	self.sonicscreamattacknext = self.sonicscreamattacknext + (SRandomIntRange("zm_ai_sonic_scream", self.sonicscreamattackdebouncemin * 1000, self.sonicscreamattackdebouncemax * 1000));
}

detour zm_ai_sonic<scripts\zm\_zm_ai_sonic.gsc>::sonic_zombie_count_watch()
{
	if (!IsDefined(level.soniczombiecount)) {
		level.soniczombiecount = 0;
	}
	level.soniczombiecount++;
	self waittill("death");
	level.soniczombiecount--;
    if (IS_TRUE(self.shrinked)) {
		level.nextsonicspawnround = level.round_number + 1;
	}
	else {
		level.nextsonicspawnround = level.round_number + (SRandomIntRange("zm_ai_sonic_round", level.soniczombieminroundwait, level.soniczombiemaxroundwait + 1));
	}
	attacker = self.attacker;
	if (IsDefined(attacker) && IsPlayer(attacker) && IS_TRUE(attacker.screamattackblur)) {
		attacker notify("blinded_by_the_fright_achieved");
	}
}

detour zm_ai_sonic<scripts\zm\_zm_ai_sonic.gsc>::function_1249f13c()
{
	return function_1249f13c();
}

function_1249f13c()
{
	level waittill("start_of_round");
	for (;;) {
		if ([[@zm_ai_sonic<scripts\zm\_zm_ai_sonic.gsc>::function_89ce0aca]]())
		{
			spawner_list = [[@zm_ai_sonic<scripts\zm\_zm_ai_sonic.gsc>::function_8b9e6756]]();
			location_list = [[@zm_ai_sonic<scripts\zm\_zm_ai_sonic.gsc>::function_1ebbce9b]]();
			spawner = SArrayRandom(spawner_list, "zm_ai_sonic_spawn_location");
			location = SArrayRandom(location_list, "zm_ai_sonic_spawn_location");
			ai = zombie_utility::spawn_zombie(spawner, spawner.targetname, location);
			if (IsDefined(ai)) {
				ai.spawn_point_override = location;
			}
		}
		wait 3;
	}
}