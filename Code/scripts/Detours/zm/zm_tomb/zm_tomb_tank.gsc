detour zm_tomb_tank<scripts\zm\zm_tomb_tank.gsc>::tank_flamethrower(str_tag, n_flamethrower_id)
{
	zombieless_waits = 0;
	time_between_flames = SRandomFloatRange("zm_tomb_tank_flamethrow", 3, 6);
	for (;;) {
		wait 1;
		if (n_flamethrower_id == 1) {
			self SetTurretTargetVec(self.origin + (AnglesToForward(self.angles) * 1000));
		}
		self flag::wait_till("tank_moving");
		a_targets = [[@zm_tomb_tank<scripts\zm\zm_tomb_tank.gsc>::tank_flamethrower_get_targets]](str_tag, n_flamethrower_id);
		if (a_targets.size > 0 || zombieless_waits > time_between_flames) {
			self clientfield::set("tank_flamethrower_fx", n_flamethrower_id);
			self thread [[@zm_tomb_tank<scripts\zm\zm_tomb_tank.gsc>::flamethrower_damage_zombies]](n_flamethrower_id, str_tag);
			if (n_flamethrower_id == 1) {
				self thread [[@zm_tomb_tank<scripts\zm\zm_tomb_tank.gsc>::tank_flamethrower_cycle_targets]](str_tag, n_flamethrower_id);
			}
			if (a_targets.size > 0) {
				wait 6;
			}
			else {
				wait 3;
			}
			self clientfield::set("tank_flamethrower_fx", 0);
			self notify("flamethrower_stop_" + n_flamethrower_id);
			zombieless_waits = 0;
			time_between_flames = SRandomFloatRange("zm_tomb_tank_flamethrow", 3, 6);
		}
		else {
			zombieless_waits++;
		}
	}
}