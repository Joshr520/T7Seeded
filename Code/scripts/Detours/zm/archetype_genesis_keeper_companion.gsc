detour keepercompanionbehavior<scripts\zm\archetype_genesis_keeper_companion.gsc>::keepercompanionmovementservice(entity)
{
	if (IsDefined(level.var_bfd9ed83) && IS_TRUE(level.var_bfd9ed83.eligible_leader)) {
		entity.leader = level.var_bfd9ed83;
	}
	if (IS_TRUE(entity.outro)) {
		return;
	}
	if (entity.var_2fd11bbd === 1) {
		return;
	}
	if (!IsDefined(entity.var_57e708f6)) {
		entity.var_57e708f6 = 0;
	}
	if (entity.reviving_a_player === 1) {
		return;
	}
	if (entity.var_53ce2a4e === 1 || entity.b_teleporting === 1) {
		return;
	}
	if (entity.var_c0e8df41 === 1) {
		return;
	}
	if (entity.var_f1e0aeaf === 1) {
		return;
	}
	if (IsDefined(entity.leader)) {
		if (IS_TRUE(entity.leader.b_teleporting)) {
			entity thread [[@keepercompanionbehavior<scripts\zm\archetype_genesis_keeper_companion.gsc>::function_34117adf]](entity.leader.teleport_location);
			return;
		}
		if (entity.leader.is_flung === 1) {
			if (IsDefined(entity.leader.var_fa1ecd39)) {
				entity thread [[@keepercompanionbehavior<scripts\zm\archetype_genesis_keeper_companion.gsc>::function_3463b8c2]](entity.leader.var_fa1ecd39);
			}
			return;
		}
		if (DistanceSquared(entity.leader.origin, entity.origin) > 490000) {
			if (!IsDefined(entity.var_539a912c) || GetTime() > entity.var_539a912c) {
				entity thread [[@keepercompanionbehavior<scripts\zm\archetype_genesis_keeper_companion.gsc>::function_469c9511]](entity);
			}
		}
	}
	foreach (player in level.players) {
		if (player laststand::player_is_in_laststand() && entity.reviving_a_player === 0 && player.revivetrigger.beingrevived !== 1) {
			time = GetTime();
			if (DistanceSquared(entity.origin, player.origin) <= (1024 * 1024) && time >= entity.var_57e708f6) {
				entity.reviving_a_player = 1;
				entity [[@keepercompanionbehavior<scripts\zm\archetype_genesis_keeper_companion.gsc>::function_95adf61c]](player);
				return;
			}
		}
	}
	if (!IsDefined(entity.var_a0c5deb2)) {
		entity.var_a0c5deb2 = GetTime();
	}
	if (GetTime() >= entity.var_a0c5deb2 && IsDefined(level.active_powerups) && level.active_powerups.size > 0) {
		if (!IsDefined(entity.var_34a9f1ad)) {
			entity.var_34a9f1ad = 0;
		}
		foreach (powerup in level.active_powerups) {
			if (IsInArray(entity.var_fb400bf7, powerup.powerup_name))
			{
				dist = DistanceSquared(entity.origin, powerup.origin);
				if (dist <= 147456 && SRandomInt("keeper_powerup", 100) < (50 + (10 * entity.var_34a9f1ad))) {
					entity SetGoal(powerup.origin, 1);
					entity.var_a0c5deb2 = GetTime() + SRandomIntRange("keeper_powerup", 2500, 3500);
					entity.next_move_time = GetTime() + SRandomIntRange("keeper_powerup", 2500, 3500);
					entity.var_34a9f1ad = 0;
					return;
				}
				entity.var_34a9f1ad = entity.var_34a9f1ad + 1;
			}
		}
		entity.var_a0c5deb2 = GetTime() + SRandomIntRange("keeper_powerup", 333, 666);
	}
	follow_radius_squared = 256 * 256;
	if (IsDefined(entity.leader)) {
		entity.companion_anchor_point = entity.leader.origin;
	}
	dist_check_start_point = entity.origin;
	if (IsDefined(entity.pathgoalpos)) {
		dist_check_start_point = entity.pathgoalpos;
	}
	if (DistanceSquared(dist_check_start_point, entity.companion_anchor_point) > follow_radius_squared) {
		if (IsDefined(entity.leader) && entity.companion_anchor_point == entity.leader.origin) {
			enemies = GetAITeamArray(level.zombie_team);
			validenemies = [];
			foreach (enemy in enemies) {
				if (IS_TRUE(enemy.completed_emerging_into_playable_area) && entity CanSee(entity.leader, 3000) && util::within_fov(entity.leader.origin, entity.leader.angles, enemy.origin, Cos(70))) {
					validenemies[validenemies.size] = enemy;
				}
			}
			if (IsDefined(validenemies) && validenemies.size) {
				averagepoint = [[@keepercompanionbehavior<scripts\zm\archetype_genesis_keeper_companion.gsc>::get_average_origin]](validenemies, entity.leader.origin[2]);
				var_be4a51b9 = VectorNormalize(averagepoint - entity.leader.origin);
				point = entity.leader.origin + VectorScale(var_be4a51b9, 179.2);
				entity.companion_anchor_point = point + VectorScale(AnglesToRight(entity.leader.angles), 30);
			}
		}
		entity pick_new_movement_point();
	}
	if (GetTime() >= entity.next_move_time && !IS_TRUE(entity.var_92aa697)) {
		entity pick_new_movement_point();
	}
}

detour keepercompanionbehavior<scripts\zm\archetype_genesis_keeper_companion.gsc>::pick_new_movement_point()
{
	return pick_new_movement_point();
}

pick_new_movement_point()
{
	queryresult = PositionQuery_Source_Navigation(self.companion_anchor_point, 96, 256, 48, 20, self);
	if (queryresult.data.size) {
		if (IsDefined(self.enemy) && self.enemy.archetype == "parasite") {
			array::filter(queryresult.data, 0, @keepercompanionbehavior<scripts\zm\archetype_genesis_keeper_companion.gsc>::function_ab299a53, self.enemy);
		}
	}
	if (queryresult.data.size) {
		point = queryresult.data[SRandomInt("keeper_movement", queryresult.data.size)];
		pathsuccess = self FindPath(self.origin, point.origin, 1, 0);
		if (pathsuccess) {
			self.companion_destination = point.origin;
		}
		else {
			self.next_move_time = GetTime() + SRandomIntRange("keeper_movement", 500, 1500);
			return;
		}
	}
	if (IsDefined(self.companion_destination)) {
		self SetGoal(self.companion_destination, 1);
	}
	self.next_move_time = GetTime() + SRandomIntRange("keeper_movement", 6000, 9000);
}

detour keepercompanionbehavior<scripts\zm\archetype_genesis_keeper_companion.gsc>::keepercompaniondelaymovement(entity)
{
	entity PathMode("move delayed", 0, SRandomFloatRange("keeper_movement", 1, 2));
}