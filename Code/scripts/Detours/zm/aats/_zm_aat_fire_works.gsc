detour zm_aat_fire_works<scripts\zm\aats\_zm_aat_fire_works.gsc>::zm_aat_fire_works_get_target()
{
	a_ai_zombies = SArrayRandomize(GetAITeamArray("axis"), "zm_aat_fire_works_target");
	los_checks = 0;
	for (i = 0; i < a_ai_zombies.size; i++) {
		zombie = a_ai_zombies[i];
		test_origin = zombie GetCentroid();
		if (DistanceSquared(self.origin, test_origin) > 360000) {
			continue;
		}
		if (los_checks < 3 && !zombie DamageConeTrace(self.origin)) {
			los_checks++;
			continue;
		}
		return zombie;
	}
	if (a_ai_zombies.size) {
		return a_ai_zombies[0];
	}
	return undefined;
}