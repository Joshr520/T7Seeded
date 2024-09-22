detour zm_ai_spiders<scripts\zm\_zm_ai_spiders.gsc>::function_a96551fe()
{
	self endon("death");
	while (!IS_TRUE(self.var_b8a7fb78._door_open)) {
		wait 0.5;
	}
	for (;;) {
		self trigger::wait_till();
		if (IS_TRUE(self.who.b_is_spider) || IS_TRUE(level.var_f618f3e1)) {
			var_59bd3c5a = self.who;
			var_94aebe65 = SRandomInt("zm_ai_spiders_behavior", 100);
			if (var_94aebe65 < level.var_42034f6a) {
				self.var_cb6fa5c5 = 0;
				self thread [[@zm_ai_spiders<scripts\zm\_zm_ai_spiders.gsc>::function_e96bd0d2]]();
				if (IsAlive(var_59bd3c5a) && IS_TRUE(var_59bd3c5a.b_is_spider)) {
					var_59bd3c5a [[@zm_ai_spiders<scripts\zm\_zm_ai_spiders.gsc>::function_d8cfc139]](self);
				}
				self [[@zm_ai_spiders<scripts\zm\_zm_ai_spiders.gsc>::function_c83dc712]]();
				level util::waittill_any_ents(level, "end_of_round", level, "between_round_over", level, "start_of_round", self, "death", level, "enable_all_webs");
			}
			else {
				wait 3;
			}
		}
	}
}

detour zm_ai_spiders<scripts\zm\_zm_ai_spiders.gsc>::function_2a424152()
{
	level.var_3013498 = level.round_number + SRandomIntRange("zm_ai_spiders_round", 4, 7);
	level.var_5ccd3661 = level.var_3013498;
	old_spawn_func = level.round_spawn_func;
	old_wait_func = level.round_wait_func;
	for (;;) {
		level waittill("between_round_over");
		if (level.round_number == level.var_3013498) {
			level.sndmusicspecialround = 1;
			old_spawn_func = level.round_spawn_func;
			old_wait_func = level.round_wait_func;
			[[@zm_ai_spiders<scripts\zm\_zm_ai_spiders.gsc>::function_9f7a20d2]]();
			level.round_spawn_func = @zm_ai_spiders<scripts\zm\_zm_ai_spiders.gsc>::function_a2a299a1;
			level.round_wait_func = @zm_ai_spiders<scripts\zm\_zm_ai_spiders.gsc>::function_872e306e;
			level.var_3013498 = level.round_number + SRandomIntRange("zm_ai_spiders_round", 4, 6);
		}
		else if (level flag::get("spider_round")) {
			[[@zm_ai_spiders<scripts\zm\_zm_ai_spiders.gsc>::function_123b370a]]();
			level.round_spawn_func = old_spawn_func;
			level.round_wait_func = old_wait_func;
			level.var_6ea0fe2e = level.var_6ea0fe2e + 1;
		}
	}
}

detour zm_ai_spiders<scripts\zm\_zm_ai_spiders.gsc>::function_49e57a3b(var_c79d3f71, ent = self, var_a79b986e = 0)
{
	return function_49e57a3b(var_c79d3f71, ent, var_a79b986e);
}

function_49e57a3b(var_c79d3f71, ent = self, var_a79b986e = 0)
{
	var_c79d3f71 endon("death");
	var_c79d3f71 ai::set_ignoreall(1);
	if (!IsDefined(ent.target) || var_a79b986e) {
		var_c79d3f71 Ghost();
		var_c79d3f71 util::delay(0.2, "death", ::Show);
		var_c79d3f71 util::delay_notify(0.2, "visible", "death");
		var_c79d3f71.origin = ent.origin;
		var_c79d3f71.angles = ent.angles;
		var_c79d3f71 vehicle_ai::set_state("scripted");
		if (IsAlive(var_c79d3f71)) {
			a_ground_trace = GroundTrace(var_c79d3f71.origin + VectorScale((0, 0, 1), 100), var_c79d3f71.origin - VectorScale((0, 0, 1), 1000), 0, var_c79d3f71, 1);
			if (IsDefined(a_ground_trace["position"])) {
				var_197f1988 = util::spawn_model("tag_origin", a_ground_trace["position"], var_c79d3f71.angles);
			}
			else {
				var_197f1988 = util::spawn_model("tag_origin", var_c79d3f71.origin, var_c79d3f71.angles);
			}
			var_197f1988 scene::play("scene_zm_dlc2_spider_burrow_out_of_ground", var_c79d3f71);
			state = "combat";
			if (SRandomFloat("zm_ai_spiders_ai", 1) > 0.6) {
				state = "meleeCombat";
			}
			var_c79d3f71 vehicle_ai::set_state(state);
			var_c79d3f71 SetVisibleToAll();
			var_c79d3f71 ai::set_ignoreme(0);
		}
	}
	else {
		var_c79d3f71.disablearrivals = 1;
		var_c79d3f71.disableexits = 1;
		var_c79d3f71 vehicle_ai::set_state("scripted");
		var_c79d3f71 notify("visible");
		var_ce7c81e4 = struct::get_array(ent.target, "targetname");
		var_ed41ff6b = SArrayRandom(var_ce7c81e4, "zm_ai_spiders_ai");
		if (IsDefined(var_ed41ff6b) && IsAlive(var_c79d3f71)) {
			var_ed41ff6b.script_play_multiple = 1;
			level scene::play(ent.target, var_c79d3f71);
		}
		else {
			var_36eb5144 = GetVehicleNodeArray(ent.target, "targetname");
			var_a8deb964 = SArrayRandom(var_36eb5144, "zm_ai_spiders_ai");
			var_c79d3f71 Ghost();
			var_c79d3f71.var_75bf86b = spawner::simple_spawn_single("spider_mover_spawner");
			var_c79d3f71.origin = var_c79d3f71.var_75bf86b.origin;
			var_c79d3f71.angles = var_c79d3f71.var_75bf86b.angles;
			var_c79d3f71 LinkTo(var_c79d3f71.var_75bf86b);
			s_end = struct::get(var_a8deb964.target, "targetname");
			var_c79d3f71.var_75bf86b vehicle::get_on_path(var_a8deb964);
			var_c79d3f71 Show();
			if (IsDefined(var_a8deb964.script_int)) {
				var_c79d3f71.var_75bf86b SetSpeed(var_a8deb964.script_int);
			}
			else {
				var_c79d3f71.var_75bf86b SetSpeed(20);
			}
			var_c79d3f71.var_75bf86b vehicle::go_path();
			var_c79d3f71 notify(#"hash_a81735f9");
			var_c79d3f71 UnLink();
			var_c79d3f71.var_75bf86b Delete();
		}
		Earthquake(0.1, 0.5, var_c79d3f71.origin, 256);
		state = "combat";
		if (SRandomFloat("zm_ai_spiders_ai", 1) > 0.6) {
			state = "meleeCombat";
		}
		var_c79d3f71 vehicle_ai::set_state(state);
		var_c79d3f71.completed_emerging_into_playable_area = 1;
	}
	var_c79d3f71 ai::set_ignoreall(0);
}

detour zm_ai_spiders<scripts\zm\_zm_ai_spiders.gsc>::function_6c15e157(var_f0566a69 = 4, var_d1bb0869 = 0.25)
{
	self endon("death");
	if (!IsDefined(self.var_1e831600)) {
		return;
	}
	if (!IS_TRUE(self.var_c8acfaf8)) {
		self.var_c8acfaf8 = 1;
		v_original_pos = self.var_1e831600.origin;
		for (i = 0; i < var_f0566a69; i++) {
			var_45634a22 = (SRandomFloatRange("zm_ai_spiders_movement", 0, 2), SRandomFloatRange("zm_ai_spiders_movement", 0, 2), 0);
			self.var_1e831600 MoveTo(v_original_pos + var_45634a22, var_d1bb0869);
			self.var_1e831600 waittill("movedone");
			self.var_1e831600 MoveTo(v_original_pos, var_d1bb0869);
			self.var_1e831600 waittill("movedone");
		}
		self.var_c8acfaf8 = 0;
	}
}

detour zm_ai_spiders<scripts\zm\_zm_ai_spiders.gsc>::function_570247b9(var_19764360)
{
	switch (level.players.size) {
		case 1: {
			var_3a613778 = 2500;
			var_e27d607a = 490000;
			break;
		}
		case 2: {
			var_3a613778 = 2500;
			var_e27d607a = 810000;
			break;
		}
		case 3: {
			var_3a613778 = 2500;
			var_e27d607a = 1000000;
			break;
		}
		case 4: {
			var_3a613778 = 2500;
			var_e27d607a = 1000000;
			break;
		}
		default: {
			var_3a613778 = 2500;
			var_e27d607a = 490000;
			break;
		}
	}
	if (IsDefined(level.zm_loc_types["spider_location"])) {
		var_aa136cb0 = SArrayRandomize(level.zm_loc_types["spider_location"], "zm_ai_spiders_spawn_location");
	}
	else {
		return;
	}
	for (i = 0; i < var_aa136cb0.size; i++) {
		if (IsDefined(level.var_fcbb5ce0) && level.var_fcbb5ce0 == var_aa136cb0[i]) {
			continue;
		}
		n_dist_squared = DistanceSquared(var_aa136cb0[i].origin, var_19764360.origin);
		n_height_diff = Abs(var_aa136cb0[i].origin[2] - var_19764360.origin[2]);
		if (n_dist_squared > var_3a613778 && n_dist_squared < var_e27d607a && n_height_diff < 128) {
			s_spawn_loc = [[@zm_ai_spiders<scripts\zm\_zm_ai_spiders.gsc>::function_4df33b5a]](var_aa136cb0[i]);
			level.var_fcbb5ce0 = s_spawn_loc;
			return s_spawn_loc;
		}
	}
	s_spawn_loc = [[@zm_ai_spiders<scripts\zm\_zm_ai_spiders.gsc>::function_4df33b5a]](ArrayGetClosest(var_19764360.origin, var_aa136cb0));
	level.var_fcbb5ce0 = s_spawn_loc;
	return s_spawn_loc;
}