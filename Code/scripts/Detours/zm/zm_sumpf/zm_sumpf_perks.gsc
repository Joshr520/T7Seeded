detour zm_sumpf_perks<scripts\zm\zm_sumpf_perks.gsc>::randomize_vending_machines()
{
	level._dont_unhide_quickervive_on_hotjoin = 1;
	vending_machines = [];
	vending_machines = [[@zm_sumpf_perks<scripts\zm\zm_sumpf_perks.gsc>::function_1b58b796]]("zombie_vending");
	start_locations = [];
	start_locations[0] = GetEnt("random_vending_start_location_0", "script_noteworthy");
	start_locations[1] = GetEnt("random_vending_start_location_1", "script_noteworthy");
	start_locations[2] = GetEnt("random_vending_start_location_2", "script_noteworthy");
	start_locations[3] = GetEnt("random_vending_start_location_3", "script_noteworthy");
	level.start_locations = [];
	level.start_locations[level.start_locations.size] = start_locations[0].origin;
	level.start_locations[level.start_locations.size] = start_locations[1].origin;
	level.start_locations[level.start_locations.size] = start_locations[2].origin;
	level.start_locations[level.start_locations.size] = start_locations[3].origin;
	start_locations = SArrayRandomize(start_locations, "zm_sumpf_perks_location");
	start_locations[4] = GetEnt("random_vending_start_location_4", "script_noteworthy");
	level.start_locations[level.start_locations.size] = start_locations[4].origin;
	for (i = 0; i < vending_machines.size; i++) {
		if (vending_machines[i].script_noteworthy == "specialty_quickrevive") {
			t_temp = vending_machines[i];
			vending_machines[i] = vending_machines[4];
			vending_machines[4] = t_temp;
		}
	}
	for (i = 0; i < vending_machines.size; i++) {
		origin = start_locations[i].origin;
		angles = start_locations[i].angles;
		machine = vending_machines[i] [[@zm_sumpf_perks<scripts\zm\zm_sumpf_perks.gsc>::get_vending_machine]](start_locations[i]);
		if (vending_machines[i].script_noteworthy != "specialty_quickrevive") {
			vending_machines[i] TriggerEnable(0);
		}
		start_locations[i].origin = origin;
		start_locations[i].angles = angles;
		machine.origin = origin;
		machine.angles = angles;
		if (machine.script_string != "revive_perk") {
			machine Ghost();
			vending_machines[i] thread [[@zm_sumpf_perks<scripts\zm\zm_sumpf_perks.gsc>::function_bede3562]](machine);
		}
	}
	level.sndperksacolajingleoverride = @zm_sumpf_perks<scripts\zm\zm_sumpf_perks.gsc>::function_25413096;
	level notify(#"hash_57a00baa");
}