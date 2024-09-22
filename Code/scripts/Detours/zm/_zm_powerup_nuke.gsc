detour zm_powerup_nuke<scripts\zm\_zm_powerup_nuke.gsc>::nuke_powerup(drop_item, player_team)
{
	level thread zm_powerup_nuke::nuke_delay_spawning(3);
	location = drop_item.origin;
	if (IsDefined(drop_item.fx)) {
		PlayFX(drop_item.fx, location);
	}
	level thread zm_powerup_nuke::nuke_flash(player_team);
	wait 0.5;
	zombies = GetAITeamArray(level.zombie_team);
	zombies = ArraySort(zombies, location);
	zombies_nuked = [];
	for (i = 0; i < zombies.size; i++) {
		if (IS_TRUE(zombies[i].ignore_nuke)) {
			continue;
		}
		if (IS_TRUE(zombies[i].marked_for_death)) {
			continue;
		}
		if (IsDefined(zombies[i].nuke_damage_func)) {
			zombies[i] thread [[zombies[i].nuke_damage_func]]();
			continue;
		}
		if (zm_utility::is_magic_bullet_shield_enabled(zombies[i])) {
			continue;
		}
		zombies[i].marked_for_death = 1;
		if (!IS_TRUE(zombies[i].nuked) && !zm_utility::is_magic_bullet_shield_enabled(zombies[i])) {
			zombies[i].nuked = 1;
			zombies_nuked[zombies_nuked.size] = zombies[i];
			zombies[i] clientfield::increment("zm_nuked");
		}
	}
	for (i = 0; i < zombies_nuked.size; i++) {
		wait SRandomFloatRange("zm_powerup_nuke_cleanup", 0.1, 0.7);
		if (!IsDefined(zombies_nuked[i])) {
			continue;
		}
		if (zm_utility::is_magic_bullet_shield_enabled(zombies_nuked[i])) {
			continue;
		}
		if (!IS_TRUE(zombies_nuked[i].isdog)) {
			if (!IS_TRUE(zombies_nuked[i].no_gib)) {
				zombies_nuked[i] zombie_utility::zombie_head_gib();
			}
			zombies_nuked[i] PlaySound("evt_nuked");
		}
		zombies_nuked[i] DoDamage(zombies_nuked[i].health + 666, zombies_nuked[i].origin);
		level thread zm_daily_challenges::increment_nuked_zombie();
	}
	level notify("nuke_complete");
	players = GetPlayers(player_team);
	for (i = 0; i < players.size; i++) {
		players[i] zm_score::player_add_points("nuke_powerup", 400);
	}
}