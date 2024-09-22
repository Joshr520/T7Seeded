detour zmhd_cleanup<scripts\zm\zm_zmhd_cleanup_mgr.gsc>::check_player_available()
{
	self endon("death");
	while (IS_TRUE(self.b_zombie_path_bad)) {
		wait SRandomFloatRange(0.2, 0.5);
		if (self [[@zmhd_cleanup<scripts\zm\zm_zmhd_cleanup_mgr.gsc>::can_zombie_see_any_player]]()) {
			self.b_zombie_path_bad = undefined;
			self notify("reaquire_player");
			return;
		}
	}
}