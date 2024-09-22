detour zm_perk_random<scripts\zm\_zm_perk_random.gsc>::machine_think()
{
	level notify("machine_think");
	level endon("machine_think");
	self.num_time_used = 0;
	self.num_til_moved = SRandomIntRange("zm_perk_random_move", 3, 7);
	if (self.state !== "initial" || "idle") {
		self thread [[@zm_perk_random<scripts\zm\_zm_perk_random.gsc>::set_perk_random_machine_state]]("arrive");
		self waittill("arrived");
		self thread [[@zm_perk_random<scripts\zm\_zm_perk_random.gsc>::set_perk_random_machine_state]]("initial");
		wait 1;
	}
	if (IsDefined(level.zm_custom_perk_random_power_flag)) {
		level flag::wait_till(level.zm_custom_perk_random_power_flag);
	}
	else {
		while (![[@zm_perk_random<scripts\zm\_zm_perk_random.gsc>::is_power_on]](self.script_int)) {
			wait 1;
		}
	}
	self thread [[@zm_perk_random<scripts\zm\_zm_perk_random.gsc>::set_perk_random_machine_state]]("idle");
	if (IsDefined(level.bottle_spawn_location)) {
		level.bottle_spawn_location Delete();
	}
	level.bottle_spawn_location = Spawn("script_model", self.origin);
	level.bottle_spawn_location SetModel("tag_origin");
	level.bottle_spawn_location.angles = self.angles;
	level.bottle_spawn_location.origin = level.bottle_spawn_location.origin + VectorScale((0, 0, 1), 65);
	for (;;) {
		self waittill("trigger", player);
		level flag::clear("machine_can_reset");
		if (!player zm_score::can_player_purchase(level._random_zombie_perk_cost)) {
			self PlaySound("evt_perk_deny");
			continue;
		}
		self.machine_user = player;
		self.num_time_used++;
		player zm_stats::increment_client_stat("use_perk_random");
		player zm_stats::increment_player_stat("use_perk_random");
		player zm_score::minus_to_player_score(level._random_zombie_perk_cost);
		self thread [[@zm_perk_random<scripts\zm\_zm_perk_random.gsc>::set_perk_random_machine_state]]("vending");
		if (IsDefined(level.perk_random_vo_func_usemachine) && IsDefined(player)) {
			player thread [[level.perk_random_vo_func_usemachine]]();
		}
		for (;;) {
			random_perk = get_weighted_random_perk(player);
			self PlaySound("zmb_rand_perk_start");
			self PlayLoopSound("zmb_rand_perk_loop", 1);
			wait 1;
			self notify("bottle_spawned");
			self thread [[@zm_perk_random<scripts\zm\_zm_perk_random.gsc>::start_perk_bottle_cycling]]();
			self thread [[@zm_perk_random<scripts\zm\_zm_perk_random.gsc>::perk_bottle_motion]]();
			model = [[@zm_perk_random<scripts\zm\_zm_perk_random.gsc>::get_perk_weapon_model]](random_perk);
			wait 3;
			self notify("done_cycling");
			if (self.num_time_used >= self.num_til_moved && level.perk_random_machine_count > 1) {
				level.bottle_spawn_location SetModel("wpn_t7_zmb_perk_bottle_bear_world");
				self StopLoopSound(0.5);
				self thread [[@zm_perk_random<scripts\zm\_zm_perk_random.gsc>::set_perk_random_machine_state]]("leaving");
				wait 3;
				player zm_score::add_to_player_score(level._random_zombie_perk_cost);
				level.bottle_spawn_location SetModel("tag_origin");
				self thread [[@zm_perk_random<scripts\zm\_zm_perk_random.gsc>::machine_selector]]();
				self clientfield::set("lightning_bolt_FX_toggle", 0);
				self.machine_user = undefined;
				break;
			}
			else {
				level.bottle_spawn_location SetModel(model);
			}
			self PlaySound("zmb_rand_perk_bottle");
			self.grab_perk_hint = 1;
			self thread [[@zm_perk_random<scripts\zm\_zm_perk_random.gsc>::grab_check]](player, random_perk);
			self thread [[@zm_perk_random<scripts\zm\_zm_perk_random.gsc>::time_out_check]]();
			self util::waittill_either("grab_check", "time_out_check");
			self.grab_perk_hint = 0;
			self PlaySound("zmb_rand_perk_stop");
			self StopLoopSound(0.5);
			self.machine_user = undefined;
			level.bottle_spawn_location SetModel("tag_origin");
			self thread [[@zm_perk_random<scripts\zm\_zm_perk_random.gsc>::set_perk_random_machine_state]]("idle");
			break;
		}
		level flag::wait_till("machine_can_reset");
	}
}

detour zm_perk_random<scripts\zm\_zm_perk_random.gsc>::perk_random_machine_init()
{
	foreach (machine in level.perk_random_machines) {
		if (!IsDefined(machine.cost)) {
			machine.cost = 1500;
		}
		machine.current_perk_random_machine = 0;
		machine.uses_at_current_location = 0;
		machine [[@zm_perk_random<scripts\zm\_zm_perk_random.gsc>::create_perk_random_machine_unitrigger_stub]]();
		machine clientfield::set("init_perk_random_machine", 1);
		wait 0.5;
		machine thread [[@zm_perk_random<scripts\zm\_zm_perk_random.gsc>::set_perk_random_machine_state]]("power_off");
	}
	level.perk_random_machines = SArrayRandomize(level.perk_random_machines, "zm_perk_random_init");
	[[@zm_perk_random<scripts\zm\_zm_perk_random.gsc>::init_starting_perk_random_machine_location]]();
}

detour zm_perk_random<scripts\zm\_zm_perk_random.gsc>::get_weighted_random_perk(player)
{
	return get_weighted_random_perk(player);
}

get_weighted_random_perk(player)
{
	keys = SArrayRandomize(GetArrayKeys(level._random_perk_machine_perk_list), "zm_perk_random_location");
	if (IsDefined(level.custom_random_perk_weights)) {
		keys = player [[level.custom_random_perk_weights]]();
	}
	for (i = 0; i < keys.size; i++) {
		if (player HasPerk(level._random_perk_machine_perk_list[keys[i]])) {
			continue;
		}
		return level._random_perk_machine_perk_list[keys[i]];
	}
	return level._random_perk_machine_perk_list[keys[0]];
}