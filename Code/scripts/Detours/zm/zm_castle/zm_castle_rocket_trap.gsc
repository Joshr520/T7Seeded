detour zm_castle_rocket_trap<scripts\zm\zm_castle_rocket_trap.gsc>::function_6827f93b()
{
	n_timeout = SRandomIntRange("zm_castle_rocket_trap", 30, 240);
	level waittill("castle_teleporter_used");
	level thread [[@zm_castle_rocket_trap<scripts\zm\zm_castle_rocket_trap.gsc>::function_79ce76bb ]]();
	level.zones["zone_v10_pad_exterior"].is_spawning_allowed = 1;
	level.zones["zone_v10_pad_door"].is_spawning_allowed = 1;
	level.zones["zone_v10_pad"].adjacent_zones["zone_v10_pad_door"].is_connected = 1;
	wait 60;
	for (;;) {
		level util::waittill_any_timeout(n_timeout, "rocket_blast", "powerup_dropped");
		[[@zm_castle_rocket_trap<scripts\zm\zm_castle_rocket_trap.gsc>::function_713600fe]]();
		n_timeout = SRandomIntRange("zm_castle_rocket_trap", 90, 300);
	}
}