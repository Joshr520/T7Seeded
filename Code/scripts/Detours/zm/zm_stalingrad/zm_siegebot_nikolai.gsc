detour siegebot_nikolai<scripts\zm\zm_siegebot_nikolai.gsc>::function_f7035c2f(nikolai_driver)
{
	self endon("death");
	nikolai_driver endon("death");
	self.nikolai_driver = nikolai_driver;
	self EnableLinkTo();
	nikolai_driver.origin = self GetTagOrigin("tag_driver");
	nikolai_driver.angles = self GetTagAngles("tag_driver");
	nikolai_driver.targetname = "nikolai_driver";
	nikolai_driver LinkTo(self, "tag_driver");
	for (;;) {
		nikolai_driver scene::play("cin_zm_stalingrad_nikolai_cockpit_drink");
		nikolai_driver thread scene::play("cin_zm_stalingrad_nikolai_cockpit_idle");
		wait 10 + SRandomFloat("zm_siegebot_nikolai_idle", 10);
	}
}

detour siegebot_nikolai<scripts\zm\zm_siegebot_nikolai.gsc>::attack_thread_gun()
{
	self endon("death");
	self endon("change_state");
	self endon("end_attack_thread");
	self notify("end_attack_thread_gun");
	self endon("end_attack_thread_gun");
	for (;;) {
		e_enemy = self.enemy;
		if (!IsDefined(e_enemy) || self.var_a7cd606 === 1) {
			self SetTurretTargetRelativeAngles((0, 0, 0));
			wait 0.4;
			continue;
		}
		self vehicle_ai::setturrettarget(e_enemy, 0);
		self vehicle_ai::setturrettarget(e_enemy, 1);
		var_eb3cc6f2 = gettime();
		while (IsDefined(e_enemy) && !self.gunner1ontarget && vehicle_ai::timesince(var_eb3cc6f2) < 2) {
			wait 0.4;
		}
		if (!IsDefined(e_enemy)) {
			continue;
		}
		var_9e93cc65 = gettime();
		while (IsDefined(e_enemy) && e_enemy === self.enemy && self VehSeenRecently(e_enemy, 1) && vehicle_ai::timesince(var_9e93cc65) < 5) {
			if (self flag::get("halt_thread_gun")) {
				break;
			}
			self vehicle_ai::fire_for_time(1 + SRandomFloat("zm_siegebot_nikolai_attack", 0.4), 1);
			if (IsDefined(e_enemy) && IsPlayer(e_enemy)) {
				wait 0.6 + SRandomFloat("zm_siegebot_nikolai_attack", 0.2);
			}
			wait 0.1;
		}
		wait 0.1;
	}
}

detour siegebot_nikolai<scripts\zm\zm_siegebot_nikolai.gsc>::side_step()
{
	step_size = 180;
	right_dir = AnglesToRight(self.angles);
	start = self.origin + VectorScale((0, 0, 1), 10);
	tracedir = right_dir;
	jukestate = "juke_r@movement";
	oppositejukestate = "juke_l@movement";
	if (SCoinToss("zm_siegebot_nikolai_movement")) {
		tracedir = tracedir * -1;
		jukestate = "juke_l@movement";
		oppositejukestate = "juke_r@movement";
	}
	trace = PhysicsTrace(start, start + (tracedir * step_size), 0.8 * (self.radius * -1, self.radius * -1, 0), 0.8 * (self.radius, self.radius, self.height), self, 2);
	if (trace["fraction"] < 1) {
		tracedir = tracedir * -1;
		trace = PhysicsTrace(start, start + (tracedir * step_size), 0.8 * (self.radius * -1, self.radius * -1, 0), 0.8 * (self.radius, self.radius, self.height), self, 2);
		jukestate = oppositejukestate;
	}
	if (trace["fraction"] >= 1) {
		self ASMRequestSubState(jukestate);
		self vehicle_ai::waittill_asm_complete(jukestate, 3);
		self [[@siegebot_nikolai<scripts\zm\zm_siegebot_nikolai.gsc>::locomotion_start]]();
		return true;
	}
	return false;
}