detour zm_ai_quadrotor<scripts\zm\_zm_ai_quadrotor.gsc>::quadrotor_find_new_position()
{
	return quadrotor_find_new_position();
}

quadrotor_find_new_position()
{
	if (!IsDefined(self.current_pathto_pos)) {
		self.current_pathto_pos = self.origin;
	}
	origin = self.current_pathto_pos;
	nodes = GetNodesInRadius(self.current_pathto_pos, self.goalradius, 0, self.flyheight + 300, "Path");
	if (nodes.size == 0) {
		nodes = GetNodesInRadius(self.current_pathto_pos, self.goalradius + 1000, 0, self.flyheight + 1000, "Path");
	}
	if (nodes.size == 0) {
		nodes = GetNodesInRadius(self.current_pathto_pos, self.goalradius + 5000, 0, self.flyheight + 4000, "Path");
	}
	best_node = undefined;
	best_score = 0;
	foreach (node in nodes) {
		if (node.type == "BAD NODE") {
			continue;
		}
		if (IsDefined(node.quadrotor_fails) || IsDefined(node.quadrotor_claimed)) {
			score = SRandomFloat("zm_ai_quadrotor_pathing", 30);
		}
		else {
			score = SRandomFloat("zm_ai_quadrotor_pathing", 100);
		}
		if (score > best_score) {
			best_score = score;
			best_node = node;
		}
	}
	if (IsDefined(best_node)) {
		node_origin = best_node.origin + (0, 0, self.flyheight + (SRandomFloatRange("zm_ai_quadrotor_pathing",-30, 40)));
		z = self GetHeliHeightLockHeight(node_origin);
		node_origin = (node_origin[0], node_origin[1], z);
		node_origin = self GetClosestPointOnNavVolume(node_origin, 100);
		if (IsDefined(node_origin)) {
			origin = node_origin;
			self.goal_node = best_node;
		}
	}
	return origin;
}

detour zm_ai_quadrotor<scripts\zm\_zm_ai_quadrotor.gsc>::follow_ent(e_followee)
{
	level endon("end_game");
	self endon("death");
	while (IsDefined(e_followee)) {
		if (!self.returning_home) {
			v_facing = e_followee GetPlayerAngles();
			v_forward = AnglesToForward((0, v_facing[1], 0));
			candidate_goalpos = e_followee.origin + (v_forward * 128);
			trace_goalpos = PhysicsTrace(self.origin, candidate_goalpos);
			if (trace_goalpos["position"] == candidate_goalpos) {
				self.current_pathto_pos = e_followee.origin + (v_forward * 128);
			}
			else {
				self.current_pathto_pos = e_followee.origin + VectorScale((0, 0, 1), 60);
			}
			self.current_pathto_pos = self GetClosestPointOnNavVolume(self.current_pathto_pos, 100);
			if (!IsDefined(self.current_pathto_pos)) {
				self.current_pathto_pos = self.origin;
			}
		}
		wait SRandomFloatRange("zm_ai_quadrotor_follow", 1, 2);
	}
}

detour zm_ai_quadrotor<scripts\zm\_zm_ai_quadrotor.gsc>::quadrotor_fireupdate()
{
	level endon("end_game");
	self endon("death");
	for (;;) {
		if (IsDefined(self.enemy) && self VehCanSee(self.enemy)) {
			self SetLookAtEnt(self.enemy);
			self SetTurretTargetEnt(self.enemy);
			startaim = GetTime();
			while (!self.turretontarget && vehicle_ai::timesince(startaim) < 3) {
				wait 0.2;
			}
			self [[@zm_ai_quadrotor<scripts\zm\_zm_ai_quadrotor.gsc>::quadrotor_fire_for_time]](SRandomFloatRange("zm_ai_quadrotor_fire", 1.5, 3));
			if (IsDefined(self.enemy) && IsAI(self.enemy)) {
				wait SRandomFloatRange("zm_ai_quadrotor_fire", 0.5, 1);
			}
			else {
				wait SRandomFloatRange("zm_ai_quadrotor_fire", 0.5, 1.5);
			}
		}
		else {
			self ClearLookAtEnt();
			wait 0.4;
		}
	}
}

detour zm_ai_quadrotor<scripts\zm\_zm_ai_quadrotor.gsc>::quadrotor_movementupdate()
{
	level endon("end_game");
	self endon("death");
	self endon("change_state");
	a_powerups = [];
	old_goalpos = self.current_pathto_pos;
	self.current_pathto_pos = self [[@zm_ai_quadrotor<scripts\zm\_zm_ai_quadrotor.gsc>::make_sure_goal_is_well_above_ground]](self.current_pathto_pos);
	if (!self.vehonpath) {
		if (IsDefined(self.attachedpath)) {
			self util::script_delay();
		}
		else if (DistanceSquared(self.origin, self.current_pathto_pos) < 10000 && (self.current_pathto_pos[2] > (old_goalpos[2] + 10) || (self.origin[2] + 10) < self.current_pathto_pos[2])) {
			self SetVehGoalPos(self.current_pathto_pos, 1, 1);
			self PathVariableOffset(VectorScale((0, 0, 1), 20), 2);
			self util::waittill_any_timeout(4, "near_goal", "force_goal", "death", "change_state");
		}
		else {
			goalpos = self [[@zm_ai_quadrotor<scripts\zm\_zm_ai_quadrotor.gsc>::quadrotor_get_closest_node]]();
			self SetVehGoalPos(goalpos, 1, 1);
			self util::waittill_any_timeout(2, "near_goal", "force_goal", "death", "change_state");
		}
	}
	self SetVehicleAvoidance(1);
	for (;;) {
		self [[@zm_ai_quadrotor<scripts\zm\_zm_ai_quadrotor.gsc>::waittill_pathing_done]]();
		self thread [[@zm_ai_quadrotor<scripts\zm\_zm_ai_quadrotor.gsc>::quadrotor_blink_lights]]();
		if (self.returning_home) {
			self SetNearGoalNotifyDist(64);
			self SetHeliHeightLock(0);
			is_valid_exit_path_found = 0;
			quadrotor_table = level.quadrotor_status.pickup_trig.model;
			var_946c2ab7 = self GetClosestPointOnNavVolume(quadrotor_table.origin, 100);
			if (IsDefined(var_946c2ab7)) {
				is_valid_exit_path_found = self SetVehGoalPos(var_946c2ab7, 1, 1);
			}
			if (is_valid_exit_path_found) {
				self notify("attempting_return");
				self util::waittill_any("near_goal", "force_goal", "reached_end_node", "return_timeout");
				continue;
			}
			else {
				self thread [[@zm_ai_quadrotor<scripts\zm\_zm_ai_quadrotor.gsc>::quadrotor_escape_into_air]]();
			}
			self util::waittill_any("near_goal", "force_goal", "reached_end_node", "return_timeout");
		}
		if (!IsDefined(self.revive_target)) {
			player = self [[@zm_ai_quadrotor<scripts\zm\_zm_ai_quadrotor.gsc>::player_in_last_stand_within_range]](500);
			if (IsDefined(player)) {
				self.revive_target = player;
				player.quadrotor_revive = 1;
			}
		}
		if (IsDefined(self.revive_target)) {
			origin = self.revive_target.origin;
			origin = (origin[0], origin[1], origin[2] + 100);
			origin = self GetClosestPointOnNavVolume(origin, 100);
			if (self SetVehGoalPos(origin, 1, 1)) {
				self util::waittill_any("near_goal", "force_goal", "reached_end_node");
				level thread [[@zm_ai_quadrotor<scripts\zm\_zm_ai_quadrotor.gsc>::watch_for_fail_revive]](self);
				wait 1;
				if (IsDefined(self.revive_target) && self.revive_target laststand::player_is_in_laststand()) {
					self.revive_target notify("remote_revive", self.player_owner);
					self.player_owner notify("revived_player_with_quadrotor");
				}
				self.revive_target = undefined;
				self SetVehGoalPos(origin, 1, 1);
				wait 1;
				continue;
			}
			else {
				player.quadrotor_revive = undefined;
			}
			wait 0.1;
		}
		a_powerups = [];
		if (level.active_powerups.size > 0 && IsDefined(self.player_owner)) {
			a_powerups = util::get_array_of_closest(self.player_owner.origin, level.active_powerups, undefined, undefined, 500);
		}
		if (a_powerups.size > 0) {
			b_got_powerup = 0;
			foreach (powerup in a_powerups) {
				var_2b346da7 = self GetClosestPointOnNavVolume(powerup.origin, 100);
				if (!IsDefined(var_2b346da7)) {
					continue;
				}
				if (self SetVehGoalPos(var_2b346da7, 1, 1)) {
					self util::waittill_any("near_goal", "force_goal", "reached_end_node");
					if (IsDefined(powerup)) {
						self.player_owner.ignore_range_powerup = powerup;
						b_got_powerup = 1;
					}
					wait 1;
					break;
				}
			}
			if (b_got_powerup) {
				continue;
			}
			wait 0.1;
		}
		a_special_items = GetEntArray("quad_special_item", "script_noteworthy");
		if (IsDefined(level.n_ee_medallions) && level.n_ee_medallions > 0 && IsDefined(self.player_owner)) {
			e_special_item = ArrayGetClosest(self.player_owner.origin, a_special_items, 500);
			if (IsDefined(e_special_item)) {
				var_146a0124 = self GetClosestPointOnNavVolume(e_special_item.origin, 100);
				self SetVehGoalPos(var_146a0124, 1, 1);
				self util::waittill_any("near_goal", "force_goal", "reached_end_node");
				wait 1;
				PlayFX(level._effect["staff_charge"], e_special_item.origin);
				e_special_item hide();
				level.n_ee_medallions--;
				level notify("quadrotor_medallion_found", self);
				if (level.n_ee_medallions == 0) {
					s_mg_spawn = struct::get("mgspawn", "targetname");
					var_50cc6658 = self GetClosestPointOnNavVolume(s_mg_spawn.origin, 100);
					self SetVehGoalPos(var_50cc6658 + VectorScale((0, 0, 1), 30), 1, 1);
					self util::waittill_any("near_goal", "force_goal", "reached_end_node");
					wait 1;
					PlayFX(level._effect["staff_charge"], var_50cc6658);
					e_special_item playsound("zmb_perks_packa_ready");
					level flag::set("ee_medallions_collected");
				}
				e_special_item Delete();
				self SetNearGoalNotifyDist(30);
				self SetVehGoalPos(self.origin, 1, 1);
			}
		}
		if (IsDefined(level.quadrotor_custom_behavior)) {
			self [[level.quadrotor_custom_behavior]]();
		}
		goalpos = quadrotor_find_new_position();
		if (self SetVehGoalPos(goalpos, 1, 1)) {
			if (IsDefined(self.goal_node)) {
				self.goal_node.quadrotor_claimed = 1;
			}
			self util::waittill_any_timeout(12, "near_goal", "force_goal", "reached_end_node", "change_state", "death");
			if (IsDefined(self.enemy) && self VehCanSee(self.enemy)) {
				wait SRandomFloatRange("zm_ai_quadrotor_movement", 1, 4);
			}
			else {
				wait SRandomFloatRange("zm_ai_quadrotor_movement", 1, 3);
			}
			if (IsDefined(self.goal_node)) {
				self.goal_node.quadrotor_claimed = undefined;
			}
		}
		else {
			if (IsDefined(self.goal_node)) {
				self.goal_node.quadrotor_fails = 1;
			}
			self.current_pathto_pos = self.origin;
			self SetVehGoalPos(self.origin, 1, 1);
			wait 0.5;
			continue;
		}
	}
}