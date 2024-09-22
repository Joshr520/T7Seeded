detour zm_ai_quad<scripts\zm\_zm_ai_quad.gsc>::quad_location()
{
	self endon("death");
	if (level.zm_loc_types["quad_location"].size <= 0) {
		self DoDamage(self.health * 2, self.origin);
		return;
	}
	spot = SArrayRandom(level.zm_loc_types["quad_location"], "zm_ai_quad_spawn_location");
	if (IsDefined(spot.target)) {
		self.target = spot.target;
	}
	if (IsDefined(spot.zone_name)) {
		self.zone_name = spot.zone_name;
	}
	self.anchor = Spawn("script_origin", self.origin);
	self.anchor.angles = self.angles;
	self linkto(self.anchor);
	if (!IsDefined(spot.angles)) {
		spot.angles = (0, 0, 0);
	}
	self Ghost();
	self.anchor MoveTo(spot.origin, 0.05);
	self.anchor waittill("movedone");
	target_org = zombie_utility::get_desired_origin();
	if (IsDefined(target_org)) {
		anim_ang = VectorToAngles(target_org - self.origin);
		self.anchor RotateTo((0, anim_ang[1], 0), 0.05);
		self.anchor waittill("rotatedone");
	}
	if (IsDefined(level.zombie_spawn_fx)) {
		PlayFX(level.zombie_spawn_fx, spot.origin);
	}
	self Unlink();
	if (IsDefined(self.anchor)) {
		self.anchor Delete();
	}
	self Show();
	self notify("risen", spot.script_string);
}