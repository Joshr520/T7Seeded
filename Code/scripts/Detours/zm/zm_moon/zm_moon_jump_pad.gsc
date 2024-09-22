detour zm_moon_jump_pad<scripts\zm\zm_moon_jump_pad.gsc>::moon_jump_pad_progression_end(ent_player)
{
	if (IsDefined(self.start.script_string)) {
		ent_player.script_string = self.start.script_string;
	}
	if (IsDefined(ent_player.script_string)) {
		end_spot_array = self.destination;
		end_spot_array = SArrayRandomize(end_spot_array, "zm_moon_jump_pad_progression");
		for (i = 0; i < end_spot_array.size; i++) {
			if (IsDefined(end_spot_array[i].script_string) && end_spot_array[i].script_string == ent_player.script_string) {
				end_point = end_spot_array[i];
				if (SRandomInt("zm_moon_jump_pad_progression", 100) < 5 && !level._pad_powerup && IsDefined(end_point.script_parameters)) {
					temptation_array = level._biodome_tempt_arrays[end_point.script_parameters];
				}
				return end_point;
			}
		}
	}
}

detour zm_moon_jump_pad<scripts\zm\zm_moon_jump_pad.gsc>::moon_low_gravity_velocity(ent_start_point, struct_end_point)
{
	end_point = struct_end_point;
	start_point = ent_start_point;
	z_velocity = undefined;
	z_dist = undefined;
	fling_this_way = undefined;
	world_gravity = GetDvarInt("bg_gravity");
	gravity_pulls = -13.3;
	top_velocity_sq = 810000;
	forward_scaling = 1;
	end_spot = struct_end_point.origin;
	if (!IS_TRUE(self.script_airspeed)) {
		rand_end = (SRandomFloatRange("zm_moon_jump_pad_velocity", 0.1, 1.2), SRandomFloatRange("zm_moon_jump_pad_velocity", 0.1, 1.2), 0);
		rand_scale = SRandomInt("zm_moon_jump_pad_velocity", 100);
		rand_spot = VectorScale(rand_end, rand_scale);
		end_spot = struct_end_point.origin + rand_spot;
	}
	pad_dist = Distance(start_point.origin, end_spot);
	z_dist = end_spot[2] - start_point.origin[2];
	jump_velocity = end_spot - start_point.origin;
	if (z_dist > 40 && z_dist < 135) {
		z_dist = z_dist * 0.2;
		forward_scaling = 0.8;
	}
	else if (z_dist >= 135) {
		z_dist = z_dist * 0.2;
		forward_scaling = 0.7;
	}
	else if (z_dist < 0) {
		z_dist = z_dist * 0.1;
		forward_scaling = 0.95;
	}
	n_reduction = 0.035;
	z_velocity = ((n_reduction * 0.75) * z_dist) * world_gravity;
	if (z_velocity < 0) {
		z_velocity = z_velocity * -1;
	}
	if (z_dist < 0) {
		z_dist = z_dist * -1;
	}
	jump_time = Sqrt((2 * pad_dist) / world_gravity);
	jump_time_2 = Sqrt(z_dist / world_gravity);
	jump_time = jump_time + jump_time_2;
	if (jump_time < 0) {
		jump_time = jump_time * -1;
	}
	x = (jump_velocity[0] * forward_scaling) / jump_time;
	y = (jump_velocity[1] * forward_scaling) / jump_time;
	z = z_velocity / jump_time;
	fling_this_way = (x, y, z);
	jump_info = [];
	jump_info[0] = fling_this_way;
	jump_info[1] = jump_time;
	return jump_info;
}

detour zm_moon_jump_pad<scripts\zm\zm_moon_jump_pad.gsc>::moon_biodome_random_pad_temptation()
{
	level endon("end_game");
	structs = struct::get_array("struct_biodome_temptation", "script_noteworthy");
	for (;;) {
		rand = SRandomInt("zm_moon_jump_pad_temptation", structs.size);
		if (IsDefined(level._biodome_tempt_arrays[structs[rand].targetname])) {
			tempt_array = level._biodome_tempt_arrays[structs[rand].targetname];
			tempt_array = SArrayRandomize(tempt_array, "zm_moon_jump_pad_temptation");
			if (IsDefined(level.zones["forest_zone"]) && IS_TRUE(level.zones["forest_zone"].is_enabled) && !level._pad_powerup) {
				level thread moon_biodome_powerup_temptation(tempt_array);
			}
		}
		wait SRandomIntRange("zm_moon_jump_pad_temptation", 60, 180);
	}
}

detour zm_moon_jump_pad<scripts\zm\zm_moon_jump_pad.gsc>::moon_pad_malfunction_think()
{
	level endon("end_game");
	pad_hook = Spawn("script_model", self.origin);
	pad_hook SetModel("tag_origin");
	while (IsDefined(self)) {
		wait SRandomIntRange("zm_moon_jump_pad_malfunction", 30, 60);
		pad_hook PlaySound("zmb_turret_down");
		pad_hook clientfield::set("dome_malfunction_pad", 1);
		util::wait_network_frame();
		self TriggerEnable(0);
		wait SRandomIntRange("zm_moon_jump_pad_malfunction", 0, 30);
		pad_hook PlaySound("zmb_turret_startup");
		pad_hook clientfield::set("dome_malfunction_pad", 0);
		util::wait_network_frame();
		self TriggerEnable(1);
	}
}

detour zm_moon_jump_pad<scripts\zm\zm_moon_jump_pad.gsc>::moon_biodome_powerup_temptation(struct_array)
{
	return moon_biodome_powerup_temptation(struct_array);
}

moon_biodome_powerup_temptation(struct_array)
{
	powerup = Spawn("script_model", struct_array[0].origin);
	level thread [[@zm_moon_jump_pad<scripts\zm\zm_moon_jump_pad.gsc>::moon_biodome_temptation_active]](powerup);
	powerup endon("powerup_grabbed");
	powerup endon("powerup_timedout");
	temptation_array = array("fire_sale", "insta_kill", "nuke", "double_points", "carpenter");
	temptation_index = 0;
	spot_index = 0;
	first_time = 1;
	struct = undefined;
	rotation = 0;
	temptation_array = SArrayRandomize(temptation_array, "zm_moon_jump_pad_temptation_powerup");
	while (IsDefined(powerup)) {
		if (temptation_array[temptation_index] == "fire_sale" && (level.zombie_vars["zombie_powerup_fire_sale_on"] == 1 || level.chest_moves == 0)) {
			temptation_index++;
			if (temptation_index >= temptation_array.size) {
				temptation_index = 0;
			}
			powerup zm_powerups::powerup_setup(temptation_array[temptation_index]);
		}
		else {
			powerup zm_powerups::powerup_setup(temptation_array[temptation_index]);
		}
		if (first_time) {
			powerup thread zm_powerups::powerup_timeout();
			powerup thread zm_powerups::powerup_wobble();
			powerup thread zm_powerups::powerup_grab();
			first_time = 0;
		}
		powerup.origin = struct_array[spot_index].origin;
		if (rotation == 0) {
			wait 15;
			rotation++;
		}
		else if (rotation == 1) {
			wait 7.5;
			rotation++;
		}
		else if (rotation == 2) {
			wait 2.5;
			rotation++;
		}
		else {
			wait 1.5;
			rotation++;
		}
		temptation_index++;
		if (temptation_index >= temptation_array.size) {
			temptation_index = 0;
		}
		spot_index++;
		if (spot_index >= struct_array.size) {
			spot_index = 0;
		}
	}
}