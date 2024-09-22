detour zm_ai_margwa<scripts\zm\_zm_ai_margwa.gsc>::function_941cbfc5()
{
	r = SRandomIntRange("zm_ai_margwa_attack", 0, 100);
	if (r < 40) {
		self.var_cef86da1 = 2;
	}
	else {
		self.var_cef86da1 = 1;
	}
}

detour zm_ai_margwa<scripts\zm\_zm_ai_margwa.gsc>::function_5d11b2dc(entity)
{
	if (IsDefined(entity.favoriteenemy)) {
		if (IS_TRUE(entity.favoriteenemy.on_train)) {
			var_d3443466 = level.o_zod_train [[@czmtrain<scripts\zm\zm_zod_train.gsc>::function_3e62f527]]();
			if (IS_TRUE(entity.locked_in_train) && !IS_TRUE(var_d3443466)) {
				return false;
			}
		}
	}
	if (!IS_TRUE(entity.needteleportout) && !IS_TRUE(entity.isteleporting) && IsDefined(entity.favoriteenemy)) {
		var_1dd5ad4d = 0;
		dist_sq = DistanceSquared(self.favoriteenemy.origin, entity.origin);
		var_9c921a96 = 2250000;
		if (dist_sq > var_9c921a96) {
			if (IsDefined(entity.destroy_octobomb)) {
				var_1dd5ad4d = 0;
			}
			else {
				var_1dd5ad4d = 1;
			}
		}
		else if (IsDefined(level.var_785a0d1e)) {
			if (entity [[level.var_785a0d1e]]()) {
				var_1dd5ad4d = 1;
			}
		}
		if (var_1dd5ad4d) {
			if (IsDefined(self.favoriteenemy.zone_name)) {
				wait_locations = level.zones[self.favoriteenemy.zone_name].a_loc_types["wait_location"];
				if (IsDefined(wait_locations) && wait_locations.size > 0) {
					wait_locations = SArrayRandomize(wait_locations, "zm_ai_margwa_wait_location");
					entity.needteleportout = 1;
					entity.teleportpos = wait_locations[0].origin;
					return true;
				}
			}
		}
	}
	return false;
}

detour zm_ai_margwa<scripts\zm\_zm_ai_margwa.gsc>::margwa_bodyfall()
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
		var_3dc91cb3 = SArrayRandom(var_3bd46762, "zm_ai_margwa_powerup");
		level thread zm_powerups::specific_powerup_drop(var_3dc91cb3, power_up_origin);
	}
}