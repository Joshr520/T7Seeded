detour zm_tomb_utility<scripts\zm\zm_tomb_utility.gsc>::dug_zombie_think()
{
	self endon("death");
	self.ai_state = "zombie_think";
	find_flesh_struct_string = undefined;
	self waittill("zombie_custom_think_done", find_flesh_struct_string);
	node = undefined;
	desired_nodes = [];
	self.entrance_nodes = [];
	if (IsDefined(level.max_barrier_search_dist_override)) {
		max_dist = level.max_barrier_search_dist_override;
	}
	else {
		max_dist = 500;
	}
	if (!IsDefined(find_flesh_struct_string) && IsDefined(self.target) && self.target != "") {
		desired_origin = zombie_utility::get_desired_origin();
		origin = desired_origin;
		node = ArrayGetClosest(origin, level.exterior_goals);
		self.entrance_nodes[self.entrance_nodes.size] = node;
		self zm_spawner::zombie_history(("zombie_think -> #1 entrance (script_forcegoal) origin = ") + self.entrance_nodes[0].origin);
	}
	else {
		if (self zm_spawner::should_skip_teardown(find_flesh_struct_string)) {
			self zm_spawner::zombie_setup_attack_properties();
			if (IsDefined(self.target)) {
				end_at_node = GetNode(self.target, "targetname");
				if (IsDefined(end_at_node)) {
					self SetGoalNode(end_at_node);
					self waittill("goal");
				}
			}
			if (IS_TRUE(self.start_inert)) {
				self zm_spawner::zombie_complete_emerging_into_playable_area();
			}
			else {
				self thread [[@zm_tomb_utility<scripts\zm\zm_tomb_utility.gsc>::dug_zombie_entered_playable]]();
			}
			return;
		}
		if (IsDefined(find_flesh_struct_string)) {
			for (i = 0; i < level.exterior_goals.size; i++) {
				if (level.exterior_goals[i].script_string == find_flesh_struct_string) {
					node = level.exterior_goals[i];
					break;
				}
			}
			self.entrance_nodes[self.entrance_nodes.size] = node;
			self zm_spawner::zombie_history(("zombie_think -> #1 entrance origin = ") + node.origin);
			self thread zm_spawner::zombie_assure_node();
		}
		else {
			origin = self.origin;
			desired_origin = zombie_utility::get_desired_origin();
			if (IsDefined(desired_origin)) {
				origin = desired_origin;
			}
			nodes = util::get_array_of_closest(origin, level.exterior_goals, undefined, 3);
			desired_nodes[0] = nodes[0];
			prev_dist = Distance(self.origin, nodes[0].origin);
			for (i = 1; i < nodes.size; i++) {
				dist = Distance(self.origin, nodes[i].origin);
				if ((dist - prev_dist) > max_dist) {
					break;
				}
				prev_dist = dist;
				desired_nodes[i] = nodes[i];
			}
			node = desired_nodes[0];
			if (desired_nodes.size > 1) {
				node = desired_nodes[SRandomInt("zm_tomb_utility_dug_zombie_path", desired_nodes.size)];
			}
			self.entrance_nodes = desired_nodes;
			self zm_spawner::zombie_history(("zombie_think -> #1 entrance origin = ") + node.origin);
			self thread zm_spawner::zombie_assure_node();
		}
	}
	level thread zm_utility::draw_line_ent_to_pos(self, node.origin, "goal");
	self.first_node = node;
	self thread zm_spawner::zombie_goto_entrance(node);
}

detour zm_tomb_utility<scripts\zm\zm_tomb_utility.gsc>::dug_zombie_rise(spot, func_rise_fx = zm_spawner::zombie_rise_fx)
{
	self endon("death");
	self.in_the_ground = 1;
	self.no_eye_glow = 1;
	if (!IsDefined(spot.angles)) {
		spot.angles = (0, 0, 0);
	}
	target_org = zombie_utility::get_desired_origin();
	if (IsDefined(target_org)) {
		spot.angles = VectorToAngles(target_org - spot.origin);
	}
	level thread zombie_utility::zombie_rise_death(self, spot);
	spot thread [[func_rise_fx]](self);
	substate = 0;
	if (self.zombie_move_speed == "walk") {
		substate = SRandomInt("zm_tomb_utility_dug_rise", 2);
	}
	else if (self.zombie_move_speed == "run") {
		substate = 2;
	}
	else if (self.zombie_move_speed == "sprint") {
		substate = 3;
	}
	self PlaySound("zmb_vocals_capzomb_spawn");
	self [[@zm_tomb_utility<scripts\zm\zm_tomb_utility.gsc>::function_f356818]](spot);
	self notify("rise_anim_finished");
	spot notify("stop_zombie_rise_fx");
	self.in_the_ground = 0;
	self.no_eye_glow = 0;
	self thread zombie_utility::zombie_eye_glow();
	self notify("risen", spot.script_string);
	self.zombie_think_done = 1;
	self zm_spawner::zombie_complete_emerging_into_playable_area();
}

detour zm_tomb_utility<scripts\zm\zm_tomb_utility.gsc>::randomize_weather()
{
	weather_name = level.force_weather[level.round_number];
	if (!IsDefined(weather_name)) {
		n_round_weather = SRandomInt("zm_tomb_utility_weather", 100);
		rounds_since_snow = level.round_number - level.last_snow_round;
		rounds_since_rain = level.round_number - level.last_rain_round;
		if (n_round_weather < 40 || rounds_since_snow > 3) {
			weather_name = "snow";
		}
		else if (n_round_weather < 80 || rounds_since_rain > 4) {
			weather_name = "rain";
		}
		else {
			weather_name = "none";
		}
	}
	if (weather_name == "snow") {
		level.weather_snow = SRandomIntRange("zm_tomb_utility_weather", 1, 5);
		level.weather_rain = 0;
		level.weather_vision = 2;
		level.last_snow_round = level.round_number;
	}
	else if (weather_name == "rain") {
		level.weather_snow = 0;
		level.weather_rain = SRandomIntRange("zm_tomb_utility_weather", 1, 5);
		level.weather_vision = 1;
		level.last_rain_round = level.round_number;
	}
	else {
		level.weather_snow = 0;
		level.weather_rain = 0;
		level.weather_vision = 3;
	}
}

detour zm_tomb_utility<scripts\zm\zm_tomb_utility.gsc>::init_weather_manager()
{
	level.weather_snow = 0;
	level.weather_rain = 0;
	level.weather_fog = 0;
	level.weather_vision = 0;
	level thread [[@zm_tomb_utility<scripts\zm\zm_tomb_utility.gsc>::weather_manager]]();
	level thread [[@zm_tomb_utility<scripts\zm\zm_tomb_utility.gsc>::rotate_skydome]]();
	callback::on_connect(@zm_tomb_utility<scripts\zm\zm_tomb_utility.gsc>::set_weather_to_player);
	level.force_weather = [];
	level.force_weather[1] = "none";
	if (SCoinToss("zm_tomb_utility_weather")) {
		level.force_weather[3] = "snow";
	}
	else {
		level.force_weather[4] = "snow";
	}
	for (i = 5; i <= 9; i++) {
		if (SCoinToss("zm_tomb_utility_weather")) {
			level.force_weather[i] = "none";
			continue;
		}
		level.force_weather[i] = "rain";
	}
	level.force_weather[10] = "snow";
	level notify(#"hash_149fa2ac");
}