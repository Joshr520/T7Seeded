detour zm_temple_elevators<scripts\zm\zm_temple_elevators.gsc>::alternate_geysers()
{
	currentgeyser = undefined;
	level waittill("geyser_enabled");
	for (;;) {
		geysers = [];
		for (i = 0; i < level.geysers.size; i++) {
			g = level.geysers[i];
			if (!IsDefined(currentgeyser) || g != currentgeyser && g.enabled) {
				geysers[geysers.size] = g;
			}
		}
		if (IsDefined(currentgeyser)) {
			currentgeyser notify("geyser_end");
			currentgeyser = undefined;
		}
		if (geysers.size > 0) {
			currentgeyser = SArrayRandom(geysers, "zm_temple_elevators_geysers");
			currentgeyser thread [[@zm_temple_elevators<scripts\zm\zm_temple_elevators.gsc>::geyser_start]]();
		}
		level waittill("between_round_over");
	}
}