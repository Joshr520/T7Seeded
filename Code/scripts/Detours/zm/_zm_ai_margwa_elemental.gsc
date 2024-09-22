detour zm_ai_margwa_elemental<scripts\zm\_zm_ai_margwa_elemental.gsc>::function_aa4e7619()
{
	self.waiting = 1;
	goal_pos = self.enemy.origin;
	if (IsDefined(self.enemy.last_valid_position)) {
		goal_pos = self.enemy.last_valid_position;
	}
	path = self CalcApproximatePathToPosition(goal_pos, 0);
	var_2fd16fa4 = SRandomIntRange("zm_ai_margwa_elemental_teleport", 96, 192);
	segment_length = 0;
	teleport_point = [];
	var_f2593821 = 0;
	for (index = 1; index < path.size; index++) {
		var_cabd9641 = Distance(path[index - 1], path[index]);
		if ((segment_length + var_cabd9641) > var_2fd16fa4) {
			var_bee1a4a2 = var_2fd16fa4 - segment_length;
			var_5a78f4fc = (path[index - 1]) + ((VectorNormalize(path[index] - (path[index - 1]))) * var_bee1a4a2);
			query_result = PositionQuery_Source_Navigation(var_5a78f4fc, 64, 128, 36, 16, self, 16);
			if (query_result.data.size > 0) {
				point = query_result.data[SRandomInt("zm_ai_margwa_elemental_teleport", query_result.data.size)];
				teleport_point[var_f2593821] = point.origin;
				var_f2593821++;
				if (var_f2593821 == 3) {
					break;
				}
			}
		}
	}
	foreach (point in teleport_point) {
		var_bd23de7b = point + VectorScale((0, 0, 1), 60);
		dist = Distance(self.traveler.origin, var_bd23de7b);
		time = dist / 1200;
		if (time < 0.1) {
			time = 0.1;
		}
		if (IsDefined(self.traveler)) {
			self.traveler MoveTo(var_bd23de7b, time);
			self.traveler util::waittill_any_timeout(time, "movedone");
		}
	}
	self.teleportpos = point;
	self.waiting = 0;
	self.var_523cacc3 = 1;
}

detour zm_ai_margwa_elemental<scripts\zm\_zm_ai_margwa_elemental.gsc>::function_f10db74e()
{
	self.waiting = 1;
	queryresult = PositionQuery_Source_Navigation(self.origin, 120, 360, 128, 32, self);
	pointlist = SArrayRandomize(queryresult.data, "zm_ai_margwa_elemental_dont_move");
	self.var_58b84a32 = pointlist[0].origin;
	self ForceTeleport(self.var_58b84a32);
	wait 0.5 ;
	self.waiting = 0;
	self.var_5df615f0 = 1;
}

detour zm_ai_margwa_elemental<scripts\zm\_zm_ai_margwa_elemental.gsc>::margwa_bodyfall()
{
	power_up_origin = (self.origin + VectorScale(AnglesToForward(self.angles), 32)) + VectorScale((0, 0, 1), 16);
	if (IsDefined(power_up_origin) && !IS_TRUE(self.no_powerups)) {
		var_3bd46762 = [];
		foreach (powerup in level.zombie_powerup_array) {
			if (powerup == "carpenter") {
				continue;
			}
			if (![[level.zombie_powerups[powerup].func_should_drop_with_regular_powerups]]()) {
				continue;
			}
			var_3bd46762[var_3bd46762.size] = powerup;
		}
		var_3dc91cb3 = SArrayRandom(var_3bd46762, "zm_ai_margwa_elemental_powerup");
		level thread zm_powerups::specific_powerup_drop(var_3dc91cb3, power_up_origin);
	}
}