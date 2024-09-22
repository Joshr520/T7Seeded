detour util<scripts\shared\util_shared.gsc>::script_delay()
{
	if (IsDefined(self.script_delay)) {
		wait self.script_delay;
		return true;
	}
	if (IsDefined(self.script_delay_min) && IsDefined(self.script_delay_max)) {
		if (self.script_delay_max > self.script_delay_min) {
			wait SRandomFloatRange("util_shared_delay", self.script_delay_min, self.script_delay_max);
		}
		else {
			wait self.script_delay_min;
		}
		return true;
	}
	return false;
}