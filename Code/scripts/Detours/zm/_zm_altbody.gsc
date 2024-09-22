detour zm_altbody<scripts\zm\_zm_altbody.gsc>::trigger_monitor_visibility(name, whenvisible)
{
	self endon("death");
	self SetInvisibleToAll();
	level flagsys::wait_till("start_zombie_round_logic");
	self SetVisibleToAll();
	pid = 0;
	self.is_unlocked = 1;
	while (IsDefined(self)) {
		players = level.players;
		if (pid >= players.size) {
			pid = 0;
		}
		player = players[pid];
		pid++;
		if (IsDefined(player)) {
			visible = 1;
			visible = player [[@zm_altbody<scripts\zm\_zm_altbody.gsc>::player_can_altbody]](self, name);
			if (visible == whenvisible && (!IS_TRUE(player.altbody) || IS_TRUE(player.see_kiosks_in_altbody)) && IS_TRUE(self.is_unlocked)) {
				self SetVisibleToPlayer(player);
			}
			else {
				self SetInvisibleToPlayer(player);
			}
		}
		wait SRandomFloatRange("zm_altbody_visibility", 0.2, 0.5);
	}
}