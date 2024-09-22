detour zm_tomb_chamber<scripts\zm\zm_tomb_chamber.gsc>::chamber_wall_change_randomly()
{
	level flag::wait_till("start_zombie_round_logic");
	a_element_enums = array(1, 2, 3, 4);
	level endon("stop_random_chamber_walls");
	n_elem_prev = undefined;
	for (;;) {
		while (![[@zm_tomb_chamber<scripts\zm\zm_tomb_chamber.gsc>::is_chamber_occupied]]()) {
			wait 1;
		}
		level flag::wait_till("any_crystal_picked_up");
		n_round = [[@zm_tomb_chamber<scripts\zm\zm_tomb_chamber.gsc>::cap_value]](level.round_number, 10, 30);
		f_progression_pct = (n_round - 10) / (30 - 10);
		n_change_wall_time = LerpFloat(15, 5, f_progression_pct);
		n_elem = SArrayRandom(a_element_enums, "zm_tomb_chamber_walls");
		ArrayRemoveValue(a_element_enums, n_elem, 0);
		if (IsDefined(n_elem_prev)) {
			a_element_enums[a_element_enums.size] = n_elem_prev;
		}
		[[@zm_tomb_chamber<scripts\zm\zm_tomb_chamber.gsc>::chamber_change_walls]](n_elem);
		wait n_change_wall_time;
		n_elem_prev = n_elem;
	}
}

detour zm_tomb_chamber<scripts\zm\zm_tomb_chamber.gsc>::ee_zombie_blood_dig()
{
    return ee_zombie_blood_dig();
}

ee_zombie_blood_dig()
{
	self endon("disconnect");
	n_z_spots_found = 0;
	a_z_spots = struct::get_array("zombie_blood_dig_spot", "targetname");
	self.t_zombie_blood_dig = Spawn("trigger_radius_use", (0, 0, 0), 0, 100, 50);
	self.t_zombie_blood_dig.e_unique_player = self;
	self.t_zombie_blood_dig TriggerIgnoreTeam();
	self.t_zombie_blood_dig SetCursorHint("HINT_NOICON");
	self.t_zombie_blood_dig SetHintString(&"ZM_TOMB_X2D");
	self.t_zombie_blood_dig [[@zm_powerup_zombie_blood<scripts\zm\_zm_powerup_zombie_blood.gsc>::make_zombie_blood_entity]]();
	while (n_z_spots_found < 4) {
		a_randomized = SArrayRandomize(a_z_spots, "zm_tomb_chamber_ee_blood");
		n_index = undefined;
		for (i = 0; i < a_randomized.size; i++) {
			if (!IsDefined(a_randomized[i].n_player)) {
				n_index = i;
				break;
			}
		}
		s_z_spot = a_randomized[n_index];
		s_z_spot.n_player = self GetEntityNumber();
		s_z_spot [[@zm_tomb_chamber<scripts\zm\zm_tomb_chamber.gsc>::create_zombie_blood_dig_spot]](self);
		n_z_spots_found++;
		level waittill("end_of_round");
	}
	self.t_zombie_blood_dig delete();
}