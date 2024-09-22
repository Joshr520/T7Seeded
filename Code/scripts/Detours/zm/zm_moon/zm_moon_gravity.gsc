detour zm_moon_gravity<scripts\zm\zm_moon_gravity.gsc>::zombie_moon_player_float()
{
	self endon("death");
	self endon("disconnect");
	boost_chance = 40;
	for (;;) {
		if (zombie_utility::is_player_valid(self) && IS_TRUE(self.in_low_gravity) && self IsOnGround() && self IsSprinting()) {
			boost = SRandomInt("zm_moon_gravity_player_boost", 100);
			if (boost < boost_chance) {
				time = SRandomFloatRange("zm_moon_gravity_player_boost", 0.75, 1.25);
				wait time;
				if (IS_TRUE(self.in_low_gravity) && self IsOnGround() && self IsSprinting()) {
					self SetOrigin(self.origin + (0, 0, 1));
					player_velocity = self GetVelocity();
					boost_velocity = player_velocity + VectorScale((0, 0, 1), 100);
					self SetVelocity(boost_velocity);
					if (!IS_TRUE(level.var_833e8251)) {
						self thread zm_audio::create_and_play_dialog("general", "moonjump");
						level.var_833e8251 = 1;
					}
					boost_chance = 40;
					wait 2;
				}
				else {
					boost_chance = boost_chance + 10;
				}
			}
			else {
				wait 2;
			}
		}
		util::wait_network_frame();
	}
}