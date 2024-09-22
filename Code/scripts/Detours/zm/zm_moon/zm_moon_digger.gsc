detour zm_moon_digger<scripts\zm\zm_moon_digger.gsc>::digger_round_logic()
{
	level endon("digger_logic_stop");
	level flag::wait_till("power_on");
	wait 30;
	last_active_round = level.round_number;
	first_digger_activated = 0;
	if (SRandomInt("zm_moon_digger_activate", 100) >= 90) {
		digger_activate();
		last_active_round = level.round_number;
		first_digger_activated = 1;
	}
	rnd = 0;
	while (!first_digger_activated) {
		level waittill("between_round_over");
		if (level flag::exists("teleporter_used") && level flag::get("teleporter_used")) {
			continue;
		}
		if (SRandomInt("zm_moon_digger_activate", 100) >= 90 || rnd > 2) {
			digger_activate();
			last_active_round = level.round_number;
			first_digger_activated = 1;
		}
		rnd++;
	}
	for (;;) {
		level waittill("between_round_over");
		if (level flag::exists("teleporter_used") && level flag::get("teleporter_used")) {
			continue;
		}
		if (level flag::get("digger_moving")) {
			continue;
		}
		if (level.round_number < 10) {
			min_activation_time = 3;
			max_activation_time = 8;
		}
		else {
			min_activation_time = 2;
			max_activation_time = 8;
		}
		diff = Abs(level.round_number - last_active_round);
		if (diff >= min_activation_time && diff < max_activation_time) {
			if (SRandomInt("zm_moon_digger_activate", 100) >= 80) {
				digger_activate();
				last_active_round = level.round_number;
			}
		}
		else if (diff >= max_activation_time) {
			digger_activate();
			last_active_round = level.round_number;
		}
	}
}

detour zm_moon_digger<scripts\zm\zm_moon_digger.gsc>::digger_activate(force_digger)
{
	return digger_activate(force_digger);
}

digger_activate(force_digger)
{
	if (IsDefined(force_digger)) {
		level flag::set(("start_" + force_digger) + "_digger");
		level thread [[@zm_moon_digger<scripts\zm\zm_moon_digger.gsc>::send_clientnotify]](force_digger, 0);
		level thread [[@zm_moon_digger<scripts\zm\zm_moon_digger.gsc>::play_digger_start_vox]](force_digger);
		wait 1;
		level notify(force_digger + "_vox_timer_stop");
		level thread [[@zm_moon_digger<scripts\zm\zm_moon_digger.gsc>::play_timer_vox]](force_digger);
		return;
	}
	non_active = [];
	for (i = 0; i < level.diggers.size; i++) {
		if (!level flag::get(("start_" + level.diggers[i]) + "_digger")) {
			non_active[non_active.size] = level.diggers[i];
		}
	}
	if (non_active.size > 0) {
		digger_to_activate = SArrayRandom(non_active, "zm_moon_digger_activate");
		level flag::set(("start_" + digger_to_activate) + "_digger");
		level thread [[@zm_moon_digger<scripts\zm\zm_moon_digger.gsc>::send_clientnotify]](digger_to_activate, 0);
		level thread [[@zm_moon_digger<scripts\zm\zm_moon_digger.gsc>::play_digger_start_vox]](digger_to_activate);
		wait 1;
		level thread [[@zm_moon_digger<scripts\zm\zm_moon_digger.gsc>::play_timer_vox]](digger_to_activate);
	}
}