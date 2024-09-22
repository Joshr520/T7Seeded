detour zm_ai_margwa<scripts\zm\_zm_ai_margwa_no_idgun.gsc>::function_941cbfc5()
{
	r = SRandomIntRange("zm_ai_margwa_attack", 0, 100);
	if (r < 40) {
		self.var_cef86da1 = 2;
	}
	else {
		self.var_cef86da1 = 1;
	}
}