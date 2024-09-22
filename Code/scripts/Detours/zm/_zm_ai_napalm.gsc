detour zm_ai_napalm<scripts\zm\_zm_ai_napalm.gsc>::__main__()
{
	[[@zm_ai_napalm<scripts\zm\_zm_ai_napalm.gsc>::init_napalm_fx]]();
	level.napalmzombiesenabled = 1;
	level.napalmzombieminroundwait = 1;
	level.napalmzombiemaxroundwait = 2;
	level.napalmzombieroundrequirement = 5;
	level.nextnapalmspawnround = level.napalmzombieroundrequirement + (SRandomIntRange("zm_ai_napalm_round", 0, level.napalmzombiemaxroundwait + 1));
	level.napalmzombiedamageradius = 250;
	level.napalmexploderadius = 90;
	level.napalmexplodekillradiusjugs = 90;
	level.napalmexplodekillradius = 150;
	level.napalmexplodedamageradius = 400;
	level.napalmexplodedamageradiuswet = 250;
	level.napalmexplodedamagemin = 50;
	level.napalmhealthmultiplier = 4;
	level.var_57ecc1a3 = 0;
	level.var_4e4c9791 = [];
	level.napalm_zombie_spawners = getentarray("napalm_zombie_spawner", "script_noteworthy");
	level flag::init("zombie_napalm_force_spawn");
	array::thread_all(level.napalm_zombie_spawners, spawner::add_spawn_function, @zm_ai_napalm<scripts\zm\_zm_ai_napalm.gsc>::napalm_zombie_spawn);
	array::thread_all(level.napalm_zombie_spawners, spawner::add_spawn_function, zombie_utility::round_spawn_failsafe);
	[[@zm_ai_napalm<scripts\zm\_zm_ai_napalm.gsc>::_napalm_initsounds]]();
	zm_spawner::register_zombie_damage_callback(@zm_ai_napalm<scripts\zm\_zm_ai_napalm.gsc>::_napalm_damage_callback);
	level thread function_7cce5d95();
}

detour zm_ai_napalm<scripts\zm\_zm_ai_napalm.gsc>::napalm_zombie_count_watch()
{
	if (!IsDefined(level.napalmzombiecount)) {
		level.napalmzombiecount = 0;
	}
	level.napalmzombiecount++;
	level.var_4e4c9791[level.var_4e4c9791.size] = self;
	self waittill("death");
	level.napalmzombiecount--;
	ArrayRemoveValue(level.var_4e4c9791, self, 0);
	if (IS_TRUE(self.shrinked)) {
		level.nextnapalmspawnround = level.round_number + 1;
	}
	else {
		level.nextnapalmspawnround = level.round_number + (SRandomIntRange("zm_ai_napalm_round", level.napalmzombieminroundwait, level.napalmzombiemaxroundwait + 1));
	}
}

detour zm_ai_napalm<scripts\zm\_zm_ai_napalm.gsc>::function_7cce5d95()
{
	return function_7cce5d95();
}

function_7cce5d95()
{
	level waittill("start_of_round");
	for (;;) {
		if ([[@zm_ai_napalm<scripts\zm\_zm_ai_napalm.gsc>::napalm_spawn_check]]()) {
			spawner_list = [[@zm_ai_napalm<scripts\zm\_zm_ai_napalm.gsc>::get_napalm_spawners]]();
			location_list = [[@zm_ai_napalm<scripts\zm\_zm_ai_napalm.gsc>::get_napalm_locations]]();
			spawner = SArrayRandom(spawner_list, "zm_ai_napalm_spawn_location");
			location = SArrayRandom(location_list, "zm_ai_napalm_spawn_location");
			ai = zombie_utility::spawn_zombie(spawner, spawner.targetname, location);
			if (IsDefined(ai)) {
				ai.spawn_point_override = location;
			}
		}
		wait 3;
	}
}