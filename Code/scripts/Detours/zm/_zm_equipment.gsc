detour zm_equipment<scripts\zm\_zm_equipment.gsc>::equipment_spawn_think()
{
	for (;;) {
		self waittill("trigger", player);
		if (player zm_utility::in_revive_trigger() || player.is_drinking > 0) {
			wait 0.1;
			continue;
		}
		if (!zm_equipment::is_limited(self.equipment) || !zm_equipment::limited_in_use(self.equipment)) {
			if (zm_equipment::is_limited(self.equipment)) {
				player zm_equipment::setup_limited(self.equipment);
				if (IsDefined(level.hacker_tool_positions)) {
					new_pos = SArrayRandom(level.hacker_tool_positions, "zm_equipment_location");
					self.origin = new_pos.trigger_org;
					model = GetEnt(self.target, "targetname");
					model.origin = new_pos.model_org;
					model.angles = new_pos.model_ang;
				}
			}
			player zm_equipment::give(self.equipment);
			continue;
		}
		wait 0.1;
	}
}