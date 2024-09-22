detour zm_castle_zombie<scripts\zm\zm_castle_zombie.gsc>::set_gravity(gravity)
{
	if (gravity == "low") {
		self.low_gravity = 1;
		if (IS_TRUE(self.missinglegs)) {
			self.low_gravity_variant = SRandomInt("zm_castle_zombie_gravity", level.var_4fb25bb9["crawl"]);
		}
		else {
			self.low_gravity_variant = SRandomInt("zm_castle_zombie_gravity", level.var_4fb25bb9[self.zombie_move_speed]);
		}
	}
	else if (gravity == "normal") {
		self.low_gravity = 0;
	}
}