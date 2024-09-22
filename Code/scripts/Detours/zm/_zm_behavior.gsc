detour zm_behavior<scripts\zm\_zm_behavior.gsc>::zombieupdategoal()
{
	aiprofile_beginentry("zombieUpdateGoal");
	shouldrepath = 0;
	if (!shouldrepath && IsDefined(self.favoriteenemy)) {
		if (!IsDefined(self.nextgoalupdate) || self.nextgoalupdate <= GetTime()) {
			shouldrepath = 1;
		}
		else if (DistanceSquared(self.origin, self.favoriteenemy.origin) <= (level.zigzag_activation_distance * level.zigzag_activation_distance)) {
            shouldrepath = 1;
        }
        else if (IsDefined(self.pathgoalpos)) {
            distancetogoalsqr = DistanceSquared(self.origin, self.pathgoalpos);
            shouldrepath = distancetogoalsqr < (72 * 72);
        }
	}
	if (IS_TRUE(level.validate_on_navmesh)) {
		if (!IsPointOnNavMesh(self.origin, self)) {
			shouldrepath = 0;
		}
	}
	if (IS_TRUE(self.keep_moving)) {
		if (GetTime() > self.keep_moving_time) {
			self.keep_moving = 0;
		}
	}
	if (shouldrepath) {
		goalpos = self.favoriteenemy.origin;
		if (IsDefined(self.favoriteenemy.last_valid_position)) {
			goalpos = self.favoriteenemy.last_valid_position;
		}
		self SetGoal(goalpos);
		should_zigzag = 1;
		if (IsDefined(level.should_zigzag)) {
			should_zigzag = self [[level.should_zigzag]]();
		}
		if (IS_TRUE(level.do_randomized_zigzag_path) && should_zigzag) {
			if (DistanceSquared(self.origin, goalpos) > (level.zigzag_activation_distance * level.zigzag_activation_distance)) {
				self.keep_moving = 1;
				self.keep_moving_time = GetTime() + 250;
				path = self CalcApproximatePathToPosition(goalpos, 0);
				deviationdistance = SRandomIntRange("zm_behavior_update_goal", level.zigzag_distance_min, level.zigzag_distance_max);
				if (IsDefined(self.zigzag_distance_min) && IsDefined(self.zigzag_distance_max)) {
					deviationdistance = SRandomIntRange("zm_behavior_update_goal", self.zigzag_distance_min, self.zigzag_distance_max);
				}
				segmentlength = 0;
				for (index = 1; index < path.size; index++) {
					currentseglength = Distance(path[index - 1], path[index]);
					if ((segmentlength + currentseglength) > deviationdistance) {
						remaininglength = deviationdistance - segmentlength;
						seedposition = (path[index - 1]) + ((VectorNormalize(path[index] - (path[index - 1]))) * remaininglength);
						innerzigzagradius = level.inner_zigzag_radius;
						outerzigzagradius = level.outer_zigzag_radius;
						queryresult = PositionQuery_Source_Navigation(seedposition, innerzigzagradius, outerzigzagradius, 36, 16, self, 16);
						PositionQuery_Filter_InClaimedLocation(queryresult, self);
						if (queryresult.data.size > 0) {
							point = queryresult.data[SRandomInt("zm_behavior_update_goal", queryresult.data.size)];
							self SetGoal(point.origin);
						}
						break;
					}
					segmentlength = segmentlength + currentseglength;
				}
			}
		}
		self.nextgoalupdate = GetTime() + SRandomIntRange("zm_behavior_update_goal", 500, 1000);
	}
	aiprofile_endentry();
}

detour zm_behavior<scripts\zm\_zm_behavior.gsc>::zombieshouldattackthroughboardscondition(behaviortreeentity)
{
	if (IS_TRUE(behaviortreeentity.missinglegs)) {
		return false;
	}
	if (IsDefined(behaviortreeentity.first_node.zbarrier)) {
		if (!behaviortreeentity.first_node.zbarrier ZBarrierSupportsZombieReachThroughAttacks()) {
			chunks = undefined;
			if (IsDefined(behaviortreeentity.first_node)) {
				chunks = zm_utility::get_non_destroyed_chunks(behaviortreeentity.first_node, behaviortreeentity.first_node.barrier_chunks);
			}
			if (IsDefined(chunks) && chunks.size > 0) {
				return false;
			}
		}
	}
	if (GetDvarString("zombie_reachin_freq") == "") {
		SetDvar("zombie_reachin_freq", "50");
	}
	freq = GetDvarInt("zombie_reachin_freq");
	players = GetPlayers();
	attack = 0;
	behaviortreeentity.player_targets = [];
	for (i = 0; i < players.size; i++)
	{
		if (IsAlive(players[i]) && !IsDefined(players[i].revivetrigger) && Distance2D(behaviortreeentity.origin, players[i].origin) <= 109.8 && (!IS_TRUE(players[i].zombie_vars["zombie_powerup_zombie_blood_on"])) && !IS_TRUE(players[i].ignoreme)) {
			behaviortreeentity.player_targets[behaviortreeentity.player_targets.size] = players[i];
			attack = 1;
		}
	}
	if (!attack || freq < SRandomInt("zm_behavior_barrier_attack", 100)) {
		return false;
	}
	return true;
}

detour zm_behavior<scripts\zm\_zm_behavior.gsc>::zombieshouldtauntcondition(behaviortreeentity)
{
	if (IS_TRUE(behaviortreeentity.missinglegs)) {
		return false;
	}
	if (!IsDefined(behaviortreeentity.first_node.zbarrier)) {
		return false;
	}
	if (!behaviortreeentity.first_node.zbarrier ZBarrierSupportsZombieTaunts()) {
		return false;
	}
	if (GetDvarString("zombie_taunt_freq") == "") {
		SetDvar("zombie_taunt_freq", "5");
	}
	freq = GetDvarInt("zombie_taunt_freq");
	if (freq >= SRandomInt("zm_behavior_barrier_taunt", 100)) {
		return true;
	}
	return false;
}

detour zm_behavior<scripts\zm\_zm_behavior.gsc>::zombieupdategoalcode()
{
	aiprofile_beginentry("zombieUpdateGoalCode");
	shouldrepath = 0;
	if (!shouldrepath && IsDefined(self.enemy)) {
		if (!IsDefined(self.nextgoalupdate) || self.nextgoalupdate <= GetTime()) {
			shouldrepath = 1;
		}
		else if (DistanceSquared(self.origin, self.enemy.origin) <= (200 * 200)) {
			shouldrepath = 1;
		}
		else if (IsDefined(self.pathgoalpos)) {
			distancetogoalsqr = DistanceSquared(self.origin, self.pathgoalpos);
			shouldrepath = distancetogoalsqr < (72 * 72);
		}
	}
	if (IS_TRUE(self.keep_moving)) {
		if (GetTime() > self.keep_moving_time) {
			self.keep_moving = 0;
		}
	}
	if (shouldrepath) {
		goalpos = self.enemy.origin;
		if (IsDefined(self.enemy.last_valid_position)) {
			goalpos = self.enemy.last_valid_position;
		}
		if (IS_TRUE(level.do_randomized_zigzag_path)) {
			if (DistanceSquared(self.origin, goalpos) > (240 * 240)) {
				self.keep_moving = 1;
				self.keep_moving_time = GetTime() + 250;
				path = self CalcApproximatePathToPosition(goalpos, 0);
				deviationdistance = SRandomIntRange("zm_behavior_update_goal_code", 240, 480);
				segmentlength = 0;
				for (index = 1; index < path.size; index++) {
					currentseglength = Distance(path[index - 1], path[index]);
					if ((segmentlength + currentseglength) > deviationdistance) {
						remaininglength = deviationdistance - segmentlength;
						seedposition = (path[index - 1]) + ((VectorNormalize(path[index] - (path[index - 1]))) * remaininglength);
						innerzigzagradius = level.inner_zigzag_radius;
						outerzigzagradius = level.outer_zigzag_radius;
						queryresult = PositionQuery_Source_Navigation(seedposition, innerzigzagradius, outerzigzagradius, 36, 16, self, 16);
						PositionQuery_Filter_InClaimedLocation(queryresult, self);
						if (queryresult.data.size > 0) {
							point = queryresult.data[SRandomInt("zm_behavior_update_goal_code", queryresult.data.size)];
							if (TracePassedOnNavMesh(seedposition, point.origin, 16)) {
								goalpos = point.origin;
							}
						}
						break;
					}
					segmentlength = segmentlength + currentseglength;
				}
			}
		}
		self SetGoal(goalpos);
		self.nextgoalupdate = GetTime() + SRandomIntRange("zm_behavior_update_goal_code", 500, 1000);
	}
	aiprofile_endentry();
}