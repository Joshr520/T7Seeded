autoexec fix_chamber_discs_anim()
{
	a_m_chamber_discs = GetEntArray("crypt_puzzle_disc", "script_noteworthy");
	while (a_m_chamber_discs.size != 4) {
		wait 0.05;
		a_m_chamber_discs = GetEntArray("crypt_puzzle_disc", "script_noteworthy");
	}
	foreach (m_chamber_disc in a_m_chamber_discs) {
		m_chamber_disc_fixed = util::spawn_anim_model(m_chamber_disc.model, m_chamber_disc.origin, m_chamber_disc.angles);
		m_chamber_disc_fixed.targetname = m_chamber_disc.targetname;
		m_chamber_disc_fixed.target = m_chamber_disc.target;
		m_chamber_disc_fixed.script_noteworthy = m_chamber_disc.script_noteworthy;
		m_chamber_disc_fixed.script_int = m_chamber_disc.script_int;
		m_chamber_disc Delete();
	}
}

detour zm_tomb_quest_crypt<scripts\zm\zm_tomb_quest_crypt.gsc>::chamber_discs_randomize()
{
	discs = GetEntArray("crypt_puzzle_disc", "script_noteworthy");
	prev_disc_pos = 0;
	foreach (disc in discs) {
		if (!IsDefined(disc.target)) {
			continue;
		}
		disc.position = (prev_disc_pos + SRandomIntRange("zm_tomb_quest_crypt_dials", 1, 3)) % 4;
		prev_disc_pos = disc.position;
	}
	[[@zm_tomb_quest_crypt<scripts\zm\zm_tomb_quest_crypt.gsc>::chamber_discs_move_all_to_position]](discs);
}

detour zm_tomb_quest_crypt<scripts\zm\zm_tomb_quest_crypt.gsc>::chamber_disc_run()
{
	self.position = 0;
	if (!IsDefined(level.var_6d86123b)) {
		level.var_6d86123b = [];
	}
	level flag::wait_till("start_zombie_round_logic");
	self [[@zm_tomb_quest_crypt<scripts\zm\zm_tomb_quest_crypt.gsc>::bryce_cake_light_update]](0);
	if (IsDefined(self.target)) {
		a_levers = GetEntArray(self.target, "targetname");
		foreach (e_lever in a_levers) {
			e_lever.trigger_stub = [[@zm_tomb_utility<scripts\zm\zm_tomb_utility.gsc>::tomb_spawn_trigger_radius]](e_lever.origin, 100, 1);
			e_lever.trigger_stub.require_look_at = 0;
			clockwise = e_lever.script_string === "clockwise";
			e_lever.trigger_stub thread [[@zm_tomb_quest_crypt<scripts\zm\zm_tomb_quest_crypt.gsc>::chamber_disc_trigger_run]](self, e_lever, clockwise);
		}
		self thread [[@zm_tomb_quest_crypt<scripts\zm\zm_tomb_quest_crypt.gsc>::chamber_disc_move_to_position]]();
	}
	if (!IsDefined(self.script_int)) {
		self AnimScripted("disc_idle", self.origin, self.angles, "p7_fxanim_zm_ori_chamber_mid_ring_idle_anim");
		return;
	}
	level.var_6d86123b[self.script_int] = self;
	n_wait = SRandomFloatRange("zm_tomb_quest_crypt_disc", 0, 5);
	wait n_wait;
	self.v_start_origin = self.origin;
	self.v_start_angles = self.angles;
	wait 0.05;
	str_name = "fxanim_disc" + self.script_int;
	level scene::play(str_name, "targetname");
}