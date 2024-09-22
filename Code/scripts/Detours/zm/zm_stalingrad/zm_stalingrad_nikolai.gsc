detour zm_stalingrad_nikolai<scripts\zm\zm_stalingrad_nikolai.gsc>::function_1d0e6184()
{
	return function_1d0e6184();
}

function_1d0e6184()
{
	level endon("nikolai_complete");
	var_3a73aa84 = undefined;
	while (!IsDefined(var_3a73aa84)) {
		foreach (player in level.activeplayers) {
			if (zombie_utility::is_player_valid(player, 1)) {
				if (!IsDefined(var_3a73aa84) || player.var_b3a9099 >= var_3a73aa84.var_b3a9099) {
					var_3a73aa84 = player;
				}
			}
		}
		if (IsDefined(var_3a73aa84)) {
			break;
		}
		wait 0.2;
	}
	if (SRandomInt("zm_stalingrad_nikolai_choose_enemy", 100) > 33) {
		self [[@zm_stalingrad_nikolai<scripts\zm\zm_stalingrad_nikolai.gsc>::function_211641b9]]();
	}
	self.favoriteenemy = var_3a73aa84;
}

detour zm_stalingrad_nikolai<scripts\zm\zm_stalingrad_nikolai.gsc>::function_39d2d4b6()
{
	self notify("reselect_goal");
	self endon("death");
	var_d3ffff5c = ArrayCopy(self.var_cba3d62a);
	var_d3ffff5c = array::filter(var_d3ffff5c, 0, @zm_stalingrad_nikolai<scripts\zm\zm_stalingrad_nikolai.gsc>::function_f75d4706, self.var_64627ad6);
	var_73c9db2b = var_d3ffff5c[SRandomIntRange("zm_stalingrad_nikolai_movement", 0, var_d3ffff5c.size)];
	self.var_64627ad6 = var_73c9db2b.script_string;
	self [[@siegebot_nikolai<scripts\zm\zm_siegebot_nikolai.gsc>::face_target]](var_73c9db2b.origin, 30);
	self SetGoal(var_73c9db2b.origin);
	self util::waittill_any_timeout(20, "near_goal", "death");
	self ClearForcedGoal();
}

detour zm_stalingrad_nikolai<scripts\zm\zm_stalingrad_nikolai.gsc>::function_f56920ff(var_d4d0fbf9)
{
	level endon("intermission");
	if (!IsDefined(self.favoriteenemy) || !IsAlive(self.favoriteenemy) || self.favoriteenemy laststand::player_is_in_laststand()) {
		self function_1d0e6184();
	}
	e_enemy = self.favoriteenemy;
	foreach (var_eb96527b in level.var_cf6e9729.var_9310b6ba) {
		if (e_enemy IsTouching(var_eb96527b)) {
			var_ed7a7e87 = StrTok(var_eb96527b.targetname, "_");
			break;
		}
	}
	switch (var_ed7a7e87[1]) {
		case "trench": {
			if (!IsDefined(level.var_5fe02c5a)) {
				var_a4787ecd = @zm_stalingrad_nikolai<scripts\zm\zm_stalingrad_nikolai.gsc>::function_29d15688;
			}
			break;
		}
		case "balcony": {
			var_a4787ecd = @zm_stalingrad_nikolai<scripts\zm\zm_stalingrad_nikolai.gsc>::function_960cbfc1;
			break;
		}
		case "ruins": {
			var_a4787ecd = @zm_stalingrad_nikolai<scripts\zm\zm_stalingrad_nikolai.gsc>::function_8b21fdfe;
			break;
		}
	}
	if (IsDefined(var_a4787ecd) && SCoinToss("zm_stalingrad_nikolai_attack")) {
		[[var_a4787ecd]]();
	}
	if (IsDefined(level.var_5fe02c5a)) {
		ArrayRemoveValue(var_d4d0fbf9, @zm_stalingrad_nikolai<scripts\zm\zm_stalingrad_nikolai.gsc>::function_29d15688);
	}
	[[SArrayRandom(var_d4d0fbf9, "zm_stalingrad_nikolai_attack")]]();
}