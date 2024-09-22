detour zm_island_spider_quest<scripts\zm\zm_island_spider_quest.gsc>::function_46c109d1()
{
	self waittill("death");
	if (!IsDefined(level.var_ce29fb51)) {
		level.var_ce29fb51 = 0;
	}
	if (!IsDefined(level.var_511c2e79)) {
		level.var_511c2e79 = 5;
	}
	if (SRandomInt("zm_island_spider_quest_max_ammo", 100) < 20 && !level.var_ce29fb51 && level.var_511c2e79 > 0) {
		level thread [[@zm_island_spider_quest<scripts\zm\zm_island_spider_quest.gsc>::function_81898ad7]]();
		level thread zm_powerups::specific_powerup_drop("full_ammo", self.origin);
	}
}

detour zm_island_spider_quest<scripts\zm\zm_island_spider_quest.gsc>::function_2152712c()
{
	level flag::wait_till("spider_attack_done");
	wait SRandomFloatRange("zm_island_spider_quest_atack", 0.5, 1.5);
	level flag::clear("spider_attack_done");
}