detour dragon<scripts\zm\zm_stalingrad_dragon.gsc>::function_b4d22afe()
{
	level endon(#"hash_dfaade1d");
	level thread [[@dragon<scripts\zm\zm_stalingrad_dragon.gsc>::function_f85863e2]]();
	level thread [[@dragon<scripts\zm\zm_stalingrad_dragon.gsc>::function_30137a38]]();
	level.var_2ed06b05 = [];
	level.var_2ed06b05[0] = "cin_t7_ai_zm_dlc3_dragon_flight_idle_a_1";
	level.var_2ed06b05[1] = "cin_t7_ai_zm_dlc3_dragon_flight_idle_b_1";
	n_path = 0;
	for (;;) {
		level scene::play(level.var_2ed06b05[n_path]);
		n_path = SRandomIntRange("zm_stalingrad_dragon_path", 0, level.var_2ed06b05.size);
		if (level.var_de98a8ad != 0) {
			var_f72c48e9 = SRandomFloat("zm_stalingrad_dragon_fire", 1);
			if (var_f72c48e9 <= level.var_de98a8ad) {
				level.var_777ffc66 = [[@dragon<scripts\zm\zm_stalingrad_dragon.gsc>::function_517c3b8c]]();
				[[@dragon<scripts\zm\zm_stalingrad_dragon.gsc>::dragon_hazard]]();
			}
		}
	}
}

detour dragon<scripts\zm\zm_stalingrad_dragon.gsc>::function_6a9f428b()
{
	level endon(#"hash_a35dee4e");
	level flag::set("dragon_boss_in_air");
	level scene::play(level.var_f6d7d191[level.var_181b1223]);
	level.var_357a65b clientfield::set("dragon_body_glow", 1);
	level scene::play(level.var_10b5de68[level.var_181b1223]);
	var_d5b51315 = SRandomIntRange("zm_stalingrad_dragon_boss", 2, 4);
	if (level.var_ef6a691 == 3) {
		var_d5b51315++;
	}
	for (i = 0; i < var_d5b51315; i++) {
		level.var_357a65b thread function_3a34c204();
		level scene::play(level.var_89507cd6[level.var_181b1223]);
	}
	level.var_357a65b clientfield::set("dragon_body_glow", 0);
	level scene::play(level.var_2c32671c[level.var_181b1223]);
	level flag::clear("dragon_boss_in_air");
	if (level flag::get("dragon_boss_vignette")) {
		if (![[@dragon<scripts\zm\zm_stalingrad_dragon.gsc>::dragon_boss_vignette_ready]]()) {
			level.var_b04a9a70 = 4;
			level thread [[@dragon<scripts\zm\zm_stalingrad_dragon.gsc>::function_c40e4649]](level.var_b04a9a70);
		}
		else {
			level.var_b04a9a70 = 5;
			level thread [[@dragon<scripts\zm\zm_stalingrad_dragon.gsc>::function_c40e4649]](level.var_b04a9a70);
		}
	}
	else {
		level.var_357a65b notify(#"hash_7869a7a5");
		level.var_62ebede++;
		level.var_b04a9a70 = 0;
		level thread [[@dragon<scripts\zm\zm_stalingrad_dragon.gsc>::function_c40e4649]](level.var_b04a9a70);
	}
}

detour dragon<scripts\zm\zm_stalingrad_dragon.gsc>::function_32faa6e1(no_delay = 0)
{
	self endon("stop_dragon_nikolai_think");
	self SetCanDamage(0);
	self thread [[@dragon<scripts\zm\zm_stalingrad_dragon.gsc>::attack_thread_gun]]();
	if (!no_delay) {
		wait 1;
	}
	self.var_11643dca = undefined;
	for (;;) {
		if (level flag::get("dragon_boss_vignette") && self.var_a079fbeb !== 1) {
			var_2edd3c78 = self.radius * 0.6;
			self SetNearGoalNotifyDist(var_2edd3c78);
			var_2443f661 = undefined;
			var_90863f97 = undefined;
			switch (level.var_7a29ed06) {
				case 1: {
					var_2443f661 = "east";
					var_90863f97 = "north";
					break;
				}
				case 2: {
					var_2443f661 = "west";
					var_90863f97 = "north";
					break;
				}
				case 3: {
					var_2443f661 = "south";
					var_90863f97 = "west";
					break;
				}
				default: {
					break;
				}
			}
			self.var_1163fa40 = 1;
			goalpos = level.var_4c8e35f4[var_90863f97].origin;
			if (![[@dragon<scripts\zm\zm_stalingrad_dragon.gsc>::function_1a2d9dc9]]() && Distance2DSquared(goalpos, self.origin) > (var_2edd3c78 * var_2edd3c78))
			{
				self SetVehGoalPos(goalpos, 1, 1);
				foundpath = self vehicle_ai::waittill_pathresult();
				if (foundpath) {
					self SetBrake(0);
					self ASMRequestSubState("locomotion@movement");
					self vehicle_ai::waittill_pathing_done();
					self CancelAIMove();
					self ClearVehGoalPos();
					self SetBrake(1);
				}
			}
			self thread [[@dragon<scripts\zm\zm_stalingrad_dragon.gsc>::function_f3810a1d]](var_2443f661);
			wait 0.2;
			continue;
		}
		self SetNearGoalNotifyDist(self.radius);
		var_b1a4952d = self [[@dragon<scripts\zm\zm_stalingrad_dragon.gsc>::function_b1a4952d]]();
		var_7649b699 = undefined;
		if (IsDefined(var_b1a4952d)) {
			var_7649b699 = var_b1a4952d.script_string;
		}
		var_f315c28 = array::filter(level.var_4c8e35f4, 0, @dragon<scripts\zm\zm_stalingrad_dragon.gsc>::function_30e5b419, level.var_181b1223, var_7649b699);
		var_2cd775bb = SArrayRandom(var_f315c28, "zm_stalingrad_dragon_nikolai");
		self SetVehGoalPos(var_2cd775bb.origin, 1, 1);
		foundpath = self vehicle_ai::waittill_pathresult();
		if (foundpath) {
			self SetBrake(0);
			self ASMRequestSubState("locomotion@movement");
			var_47314356 = self util::waittill_any_return("near_goal", "goal", "reselect_goal", "stop_dragon_nikolai_think");
			self CancelAIMove();
			self ClearVehGoalPos();
			self SetBrake(1);
			if (var_47314356 != "reselect_goal") {
				var_7a6fe6cc = SRandomIntRange("zm_stalingrad_dragon_nikolai", 5, 8);
				self util::waittill_any_timeout(var_7a6fe6cc, "reselect_goal", "stop_dragon_nikolai_think");
			}
		}
	}
}

detour dragon<scripts\zm\zm_stalingrad_dragon.gsc>::function_96eb8639()
{
	return function_96eb8639();
}

function_96eb8639()
{
	var_f72c48e9 = SRandomFloat("zm_stalingrad_dragon_num", 1);
	if (var_f72c48e9 <= 0.5) {
		if (!level flag::get("dragon_hazard_active")) {
			return 1;
		}
		if (level.var_ef6a691 >= 2) {
			return 2;
		}
		return 3;
	}
	if (level.var_ef6a691 >= 2) {
		return 2;
	}
	return 3;
}

detour dragon<scripts\zm\zm_stalingrad_dragon.gsc>::function_cf6274b2()
{
	level endon("dragon_interrupt");
	level endon(#"hash_a35dee4e");
	var_94bcf41e = SRandomFloat("zm_stalingrad_dragon_num", 1);
	if (level.var_ef6a691 < 3) {
		if (var_94bcf41e <= 0.05) {
			return 0;
		}
		if (var_94bcf41e > 0.05 && var_94bcf41e <= 0.9) {
			return function_96eb8639();
		}
		if (var_94bcf41e > 0.9 && var_94bcf41e <= 0.95) {
			return 3;
		}
		if (var_94bcf41e > 0.95 && var_94bcf41e <= 1) {
			return 4;
		}
	}
	else {
		if (var_94bcf41e <= 0.1) {
			return 0;
		}
		if (var_94bcf41e > 0.1 && var_94bcf41e <= 0.85) {
			return function_96eb8639();
		}
		if (var_94bcf41e > 0.85 && var_94bcf41e <= 1) {
			return 3;
		}
	}
}

detour dragon<scripts\zm\zm_stalingrad_dragon.gsc>::function_3a34c204()
{
	return function_3a34c204();
}

function_3a34c204()
{
	self endon(#"hash_7869a7a5");
	level endon(#"hash_a35dee4e");
	var_6646a04b = GetWeapon("launcher_dragon_fireball");
	self waittill(#"hash_5556f7b");
	var_201fdf35 = level.var_357a65b GetTagOrigin("tag_aim");
	a_e_players = ArraySortClosest(level.activeplayers, var_201fdf35);
	e_player = SArrayRandom(a_e_players, "zm_stalingrad_dragon_fireball");
	v_facing = AnglesToForward(e_player GetPlayerAngles());
	v_velocity = e_player GetVelocity() + v_facing;
	v_velocity = (v_velocity[0], v_velocity[1], 0);
	var_f840b1a7 = VectorNormalize(v_velocity);
	var_4cc0e23c = e_player.origin;
	for (i = 0; i < 3; i++) {
		var_270cdd14 = AnglesToForward((0, SRandomIntRange("zm_stalingrad_dragon_fireball", -180, 180), 0));
		v_target_origin = var_4cc0e23c + (var_270cdd14 * SRandomIntRange("zm_stalingrad_dragon_fireball", 36, 72));
		self thread [[@dragon<scripts\zm\zm_stalingrad_dragon.gsc>::function_98ee9e20]](i, var_6646a04b, v_target_origin);
		util::wait_network_frame();
		var_4cc0e23c = var_4cc0e23c + (var_f840b1a7 * 256);
	}
}