detour zm_island_power<scripts\zm\zm_island_power.gsc>::function_75656c0a()
{
	return function_75656c0a();
}

function_75656c0a()
{
	for (;;) {
		self.model = util::spawn_model("p7_zm_isl_bucket_115", self.origin, self.angles);
		self.trigger = [[@zm_island_util<scripts\zm\zm_island_util.gsc>::spawn_trigger_radius]](self.origin, 50, 1, @zm_island_power<scripts\zm\zm_island_power.gsc>::function_16434440);
		self.model clientfield::set("bucket_fx", 1);
		while (!IsDefined(self.trigger)) {
			wait 0.05;
		}
		for (;;) {
			self.trigger waittill("trigger", e_who);
			if (e_who clientfield::get_to_player("bucket_held")) {
				continue;
			}
			e_who thread zm_audio::create_and_play_dialog("bucket", "pickup");
			e_who clientfield::set_to_player("bucket_held", 1);
			e_who.var_6fd3d65c = 1;
			e_who PlaySound("zmb_bucket_pickup");
			if (self.script_int === 1) {
				e_who.var_bb2fd41c = 1;
				e_who.var_c6cad973 = SRandomIntRange("zm_island_power_bucket", 1, 4);
			}
			else {
				e_who.var_bb2fd41c = 0;
				e_who.var_c6cad973 = 0;
			}
			e_who thread [[@zm_island_power<scripts\zm\zm_island_power.gsc>::function_ef097ea]](e_who.var_c6cad973, e_who.var_bb2fd41c, e_who [[@zm_island_power<scripts\zm\zm_island_power.gsc>::function_89538fbb]](), 1);
			self.model clientfield::set("bucket_fx", 0);
			self.model Delete();
			zm_unitrigger::unregister_unitrigger(self.trigger);
			self.trigger = undefined;
			level flag::set("any_player_has_bucket");
			break;
		}
		e_who util::waittill_any("clone_plant_bucket_lost", "disconnect");
	}
}

detour zm_island_power<scripts\zm\zm_island_power.gsc>::function_5144d0ee()
{
	var_e43d9cdb = struct::get_array("bunker_door_open_spawners", "targetname");
	var_e43d9cdb = SArrayRandomize(var_e43d9cdb, "zm_island_power_spawn_location");
	var_7809d454 = [];
	for (i = 0; i < var_e43d9cdb.size; i++) {
		while (GetFreeActorCount() < 1) {
			wait 0.05;
		}
		s_loc = var_e43d9cdb[i];
		ai_zombie = zombie_utility::spawn_zombie(level.zombie_spawners[0], "bunker_entrance_zombie", s_loc);
		if (!IsDefined(var_7809d454)) {
			var_7809d454 = [];
		}
		else if (!IsArray(var_7809d454)) {
			var_7809d454 = array(var_7809d454);
		}
		var_7809d454[var_7809d454.size] = ai_zombie;
		wait 0.25;
	}
	level thread [[@zm_island_power<scripts\zm\zm_island_power.gsc>::function_5c09306d]](var_7809d454);
	[[@zm_island_power<scripts\zm\zm_island_power.gsc>::function_3d11144a]]();
}

detour zm_island_power<scripts\zm\zm_island_power.gsc>::function_662fba30()
{
	level flag::init("any_player_has_bucket");
	var_c66f413a = struct::get_array("water_bucket_location", "targetname");
	for ( i = 1; i < 5; i++) {
		a_temp = [];
		foreach (var_991ffe1 in var_c66f413a) {
			if (var_991ffe1.script_int === i) {
				a_temp[a_temp.size] = var_991ffe1;
			}
		}
		var_623d6569 = SArrayRandom(a_temp, "zm_island_power_bucket");
		var_623d6569 thread function_75656c0a();
	}
}