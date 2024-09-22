detour zm_castle_ee_bossfight<scripts\zm\zm_castle_ee_bossfight.gsc>::function_77025eb5(spot)
{
	self endon("death");
	self.in_the_ground = 1;
	if (IsDefined(self.anchor)) {
		self.anchor Delete();
	}
	self.anchor = Spawn("script_origin", self.origin);
	self.anchor.angles = self.angles;
	self LinkTo(self.anchor);
	if (!IsDefined(spot.angles)) {
		spot.angles = (0, 0, 0);
	}
	anim_org = spot.origin;
	anim_ang = spot.angles;
	anim_org = anim_org + (0, 0, 0);
	self Ghost();
	self.anchor MoveTo(anim_org, 0.05);
	self.anchor waittill("movedone");
	target_org = zombie_utility::get_desired_origin();
	if (IsDefined(target_org)) {
		anim_ang = VectorToAngles(target_org - self.origin);
		self.anchor RotateTo((0, anim_ang[1], 0), 0.05);
		self.anchor waittill("rotatedone");
	}
	self Unlink();
	if (IsDefined(self.anchor)) {
		self.anchor Delete();
	}
	self thread zombie_utility::hide_pop();
	level thread zombie_utility::zombie_rise_death(self, spot);
	self clientfield::set("boss_zombie_rise_fx", 1);
	substate = 0;
	if (self.zombie_move_speed == "walk") {
		substate = SRandomInt("zm_castle_ee_bossfight_zombie_speed", 2);
	}
	else if (self.zombie_move_speed == "run") {
        substate = 2;
    }
	else if (self.zombie_move_speed == "sprint") {
        substate = 3;
    }
	self OrientMode("face default");
	if (IsDefined(level.custom_riseanim)) {
		self AnimScripted("rise_anim", self.origin, spot.angles, level.custom_riseanim);
	}
	else {
		self AnimScripted("rise_anim", self.origin, spot.angles, "ai_zombie_traverse_ground_climbout_fast");
	}
	self zombie_shared::donotetracks("rise_anim", zombie_utility::handle_rise_notetracks, spot);
	self notify("rise_anim_finished");
	spot notify("stop_zombie_rise_fx");
	self.in_the_ground = 0;
	self notify("risen", spot.script_string);
}

detour zm_castle_ee_bossfight<scripts\zm\zm_castle_ee_bossfight.gsc>::function_28bb5727(var_4a14cd40)
{
	level endon("_zombie_game_over");
	if (!IsDefined(self.var_41c1a53f)) {
		self.var_41c1a53f = [];
	}
	switch (self.var_7e383b58) {
		case 1: {
			var_e516b508 = 3;
			if (level.var_1a4b8a19) {
				self.var_41c1a53f[0] = @zm_castle_ee_bossfight<scripts\zm\zm_castle_ee_bossfight.gsc>::function_e3ea9055;
				self.var_41c1a53f[1] = @zm_castle_ee_bossfight<scripts\zm\zm_castle_ee_bossfight.gsc>::function_e3ea9055;
			}
			else {
				self.var_41c1a53f[0] = @zm_castle_ee_bossfight<scripts\zm\zm_castle_ee_bossfight.gsc>::function_74d4ae55;
				self.var_41c1a53f[1] = @zm_castle_ee_bossfight<scripts\zm\zm_castle_ee_bossfight.gsc>::function_f6b53f16;
			}
			break;
		}
		case 3: {
			self thread [[@zm_castle_ee_bossfight<scripts\zm\zm_castle_ee_bossfight.gsc>::function_e2f41bf2]]();
			var_e516b508 = 4;
			if (level.var_1a4b8a19) {
				self.var_41c1a53f[2] = @zm_castle_ee_bossfight<scripts\zm\zm_castle_ee_bossfight.gsc>::function_e3ea9055;
			}
			else {
				self.var_41c1a53f[2] = @zm_castle_ee_bossfight<scripts\zm\zm_castle_ee_bossfight.gsc>::function_45988f28;
			}
			self.var_41c1a53f[3] = @zm_castle_ee_bossfight<scripts\zm\zm_castle_ee_bossfight.gsc>::function_db1c6f68;
			self.n_health = self.n_health + self.var_4bd4bce6;
			break;
		}
		case 5: {
			var_e516b508 = 5;
			self thread [[@zm_castle_ee_bossfight<scripts\zm\zm_castle_ee_bossfight.gsc>::function_e2f41bf2]]();
			self.n_health = self.n_health + self.var_4bd4bce6;
			break;
		}
	}
	if (self.var_7e383b58 == 5) {
		var_cfe6cb9 = [];
	}
	self.var_42433bc = 0;
	var_19427a0d = self.var_41c1a53f.size;
	var_bb2bcd1a = self.var_41c1a53f.size;
	var_48d25fcc = 0;
	while (!var_48d25fcc) {
		for (i = 0; i < var_e516b508; i++) {
			if (i == 3 && self.var_7e383b58 == 5 && !level.var_1a4b8a19 && level.var_2b421938 > 1) {
				var_cfe6cb9 = array::remove_dead(var_cfe6cb9, 0);
				var_cfe6cb9 = array::remove_undefined(var_cfe6cb9, 0);
				if (var_cfe6cb9.size < 1) {
					ai_zombie = self [[@zm_castle_ee_bossfight<scripts\zm\zm_castle_ee_bossfight.gsc>::function_8a46476]]();
					if (!IsDefined(var_cfe6cb9)) {
						var_cfe6cb9 = [];
					}
					else if (!IsArray(var_cfe6cb9)) {
						var_cfe6cb9 = array(var_cfe6cb9);
					}
					var_cfe6cb9[var_cfe6cb9.size] = ai_zombie;
				}
			}
			while (!IsDefined(self.var_551d8fa5)) {
				n_rand = SRandomInt("zm_castle_ee_bossfight_attacks", self.var_1e4b92cb.size);
				self.var_551d8fa5 = self.var_1e4b92cb[n_rand].origin;
				if (IsDefined(self.var_c5bd1959)) {
					if (self.var_c5bd1959 == self.var_551d8fa5 || DistanceSquared(self.var_c5bd1959, self.var_551d8fa5) < 40000) {
						self.var_551d8fa5 = undefined;
						continue;
					}
				}
				foreach (player in level.players) {
					if (DistanceSquared(self.var_551d8fa5, player.origin) < 40000) {
						self.var_551d8fa5 = undefined;
						break;
					}
				}
			}
			self [[@zm_castle_ee_bossfight<scripts\zm\zm_castle_ee_bossfight.gsc>::function_1b20ff86]](self.var_551d8fa5);
			self.var_c5bd1959 = self.var_551d8fa5;
			self.var_551d8fa5 = undefined;
			if (self.var_7e383b58 == 5) {
				self function_5faafe36();
			}
			else {
				while (var_19427a0d == var_bb2bcd1a) {
					var_19427a0d = SRandomInt("zm_castle_ee_bossfight_attacks", self.var_41c1a53f.size);
					if (var_19427a0d == 3) {
						if (level.var_1a4b8a19) {
							var_90aa6e9 = 4;
						}
						else {
							var_90aa6e9 = 8;
						}
						self.var_77e69b0f = array::remove_dead(self.var_77e69b0f, 0);
						self.var_77e69b0f = array::remove_undefined(self.var_77e69b0f, 0);
						if (self.var_77e69b0f.size >= var_90aa6e9) {
							var_19427a0d = var_bb2bcd1a;
							continue;
						}
					}
				}
				self [[self.var_41c1a53f[var_19427a0d]]](0);
				var_bb2bcd1a = var_19427a0d;
			}
			wait 1;
			self [[@zm_castle_ee_bossfight<scripts\zm\zm_castle_ee_bossfight.gsc>::function_ca8445e1]]();
			wait 2;
		}
		var_48d25fcc = self [[@zm_castle_ee_bossfight<scripts\zm\zm_castle_ee_bossfight.gsc>::function_abdb4498]]();
		if (!var_48d25fcc) {
			self [[@zm_castle_ee_bossfight<scripts\zm\zm_castle_ee_bossfight.gsc>::function_ca8445e1]]();
			if (self.n_health < 5000)
			{
				self.n_health = 5000;
			}
		}
		else {
			level notify(#"hash_cd6f3cf8");
			if (IsDefined(var_cfe6cb9)) {
				foreach (var_24c17812 in var_cfe6cb9) {
					if (IsDefined(var_24c17812) && IsAlive(var_24c17812)) {
						var_24c17812 Kill();
					}
				}
			}
			level thread [[@zm_castle_ee_bossfight<scripts\zm\zm_castle_ee_bossfight.gsc>::function_8fbf0a59]](self.var_8016f006, self.var_77e69b0f);
			array::run_all(level.players, ::PlayRumbleOnEntity, "zm_castle_boss_roar_pain");
			if (self.var_7e383b58 != 5) {
				self.var_40b46e43 [[@zm_castle_ee_bossfight<scripts\zm\zm_castle_ee_bossfight.gsc>::function_a1658f19]]("ai_zm_dlc1_archon_float_roar", "ai_zm_dlc1_archon_float_idle");
			}
			wait 1;
		}
	}
}

detour zm_castle_ee_bossfight<scripts\zm\zm_castle_ee_bossfight.gsc>::function_5faafe36()
{
	return function_5faafe36();
}

function_5faafe36()
{
	var_731b9e03 = SRandomInt("zm_castle_ee_bossfight_attacks", self.var_41c1a53f.size);
	var_fc76d161 = var_731b9e03;
	while (var_fc76d161 == var_731b9e03 || (var_731b9e03 == 1 && var_fc76d161 == 2) || (var_fc76d161 == 1 && var_731b9e03 == 2)) {
		var_fc76d161 = SRandomInt("zm_castle_ee_bossfight_attacks", self.var_41c1a53f.size);
	}
	self thread [[@zm_castle_ee_bossfight<scripts\zm\zm_castle_ee_bossfight.gsc>::function_be0acb1a]](var_fc76d161);
	self [[self.var_41c1a53f[var_731b9e03]]]();
}

detour zm_castle_ee_bossfight<scripts\zm\zm_castle_ee_bossfight.gsc>::function_20559b9e(s_spawn_point, var_f328e82)
{
	if (level.round_number < 25) {
		ai_zombie = zombie_utility::spawn_zombie(var_f328e82[0], "spell_stage_zombie", s_spawn_point, 25);
	}
	else {
		ai_zombie = zombie_utility::spawn_zombie(var_f328e82[0], "spell_stage_zombie", s_spawn_point, level.round_number);
	}
	if (IsDefined(ai_zombie)) {
		ai_zombie thread [[@zm_castle_ee_bossfight<scripts\zm\zm_castle_ee_bossfight.gsc>::function_2777756a]]();
		ai_zombie SetGoal(ai_zombie.origin);
		ai_zombie PathMode("move allowed");
		ai_zombie.script_string = "find_flesh";
		ai_zombie.zombie_think_done = 1;
		ai_zombie.is_elemental_zombie = 1;
		ai_zombie.no_gib = 1;
		ai_zombie.candamage = 1;
		ai_zombie.is_zombie = 1;
		ai_zombie.deathpoints_already_given = 1;
		ai_zombie.no_damage_points = 1;
		ai_zombie.exclude_distance_cleanup_adding_to_total = 1;
		ai_zombie.exclude_cleanup_adding_to_total = 1;
		ai_zombie.heroweapon_kill_power = 4;
		ai_zombie.sword_kill_power = 4;
		ai_zombie.no_powerups = 1;
		util::wait_network_frame();
		ai_zombie.maxhealth = int(level.var_74b7ddca);
		ai_zombie.health = ai_zombie.maxhealth;
		n_roll = SRandomInt("zm_castle_ee_bossfight_zombie_speed", 10);
		if (n_roll <= 6) {
			ai_zombie zombie_utility::set_zombie_run_cycle("sprint");
		}
		else {
			ai_zombie zombie_utility::set_zombie_run_cycle("run");
		}
		if (IsDefined(ai_zombie) && ai_zombie.archetype === "zombie") {
			ai_zombie clientfield::increment("boss_skeleton_eye_glow_fx_change", 1);
			ai_zombie.animname = "zombie";
			ai_zombie thread zm_spawner::play_ambient_zombie_vocals();
			ai_zombie thread zm_audio::zmbaivox_notifyconvert();
			ai_zombie.zmb_vocals_attack = "zmb_vocals_zombie_attack";
			ai_zombie zombie_utility::delayed_zombie_eye_glow();
		}
		return ai_zombie;
	}
	return undefined;
}

detour zm_castle_ee_bossfight<scripts\zm\zm_castle_ee_bossfight.gsc>::function_5db6ba34(var_dcc4bd3d)
{
	wait 0.5;
	a_ai_zombies = [];
	if (IsDefined(var_dcc4bd3d)) {
		a_ai_zombies = var_dcc4bd3d;
	}
	else {
		a_ai_zombies = GetAITeamArray(level.zombie_team);
	}
	var_6b1085eb = [];
	foreach (ai_zombie in a_ai_zombies) {
		if (!IsDefined(ai_zombie)) {
			continue;
		}
		if (!IsAlive(ai_zombie)) {
			continue;
		}
		ai_zombie.no_powerups = 1;
		ai_zombie.deathpoints_already_given = 1;
		if (IS_TRUE(ai_zombie.ignore_nuke)) {
			continue;
		}
		if (IS_TRUE(ai_zombie.marked_for_death)) {
			continue;
		}
		if (IsDefined(ai_zombie.nuke_damage_func)) {
			ai_zombie thread [[ai_zombie.nuke_damage_func]]();
			continue;
		}
		if (zm_utility::is_magic_bullet_shield_enabled(ai_zombie)) {
			continue;
		}
		ai_zombie.marked_for_death = 1;
		ai_zombie.nuked = 1;
		var_6b1085eb[var_6b1085eb.size] = ai_zombie;
	}
	foreach (i, var_f92b3d80 in var_6b1085eb) {
		wait SRandomFloatRange("zm_castle_ee_bossfight_cleanup", 0.1, 0.2);
		if (!IsDefined(var_f92b3d80)) {
			continue;
		}
		if (zm_utility::is_magic_bullet_shield_enabled(var_f92b3d80)) {
			continue;
		}
		if (i < 5 && !IS_TRUE(var_f92b3d80.isdog)) {
			var_f92b3d80 thread zombie_death::flame_death_fx();
		}
		if (!IS_TRUE(var_f92b3d80.isdog)) {
			if (!IS_TRUE(var_f92b3d80.no_gib)) {
				var_f92b3d80 zombie_utility::zombie_head_gib();
			}
		}
		var_f92b3d80 DoDamage(var_f92b3d80.health, var_f92b3d80.origin);
		if (!level flag::get("special_round")) {
			level.zombie_total++;
		}
	}
}

detour zm_castle_ee_bossfight<scripts\zm\zm_castle_ee_bossfight.gsc>::get_unused_spawn_point(var_4a032429 = 0, var_f759b439 = 0, var_610499ec = 0)
{
	a_valid_spawn_points = [];
	a_all_spawn_points = [];
	b_all_points_used = 0;
	if (var_4a032429) {
		a_all_spawn_points = self.var_f7afb996;
	}
	else {
		if (var_f759b439) {
			a_all_spawn_points = self.var_9680b225;
		}
		else if (var_610499ec) {
			a_all_spawn_points = self.var_772c4512;
		}
		else {
			a_all_spawn_points = self.var_828cb4c9;
		}
	}
	while (!a_valid_spawn_points.size) {
		foreach (s_spawn_point in a_all_spawn_points) {
			if (!IsDefined(s_spawn_point.spawned_zombie) || b_all_points_used) {
				s_spawn_point.spawned_zombie = 0;
			}
			if (!s_spawn_point.spawned_zombie) {
				array::add(a_valid_spawn_points, s_spawn_point, 0);
			}
		}
		if (!a_valid_spawn_points.size) {
			b_all_points_used = 1;
		}
		wait 0.05;
	}
	s_spawn_point = SArrayRandom(a_valid_spawn_points, "zm_castle_ee_bossfight_unused_spawn");
	s_spawn_point.spawned_zombie = 1;
	return s_spawn_point;
}