detour zm_castle_pap_quest<scripts\zm\zm_castle_pap_quest.gsc>::function_c4641d12(is_powered)
{
	level.var_1c602ba8 = struct::get_array("s_pap_tp");
	level.pap_machine = self;
	self.zbarrier _zm_pack_a_punch::set_state_hidden();
	array::thread_all(level.var_1c602ba8, @zm_castle_pap_quest<scripts\zm\zm_castle_pap_quest.gsc>::function_53bc4f86, self);
	level.var_164e92cf = 2;
	level.var_1e4d46e3 = 0;
	level.var_22ce1993 = [];
	level.var_22ce1993[0] = "fxexp_804";
	level.var_22ce1993[1] = "fxexp_805";
	level.var_22ce1993[2] = "fxexp_803";
	var_6eb9e3e5 = [];
	var_6eb9e3e5[0] = "lgt_undercroft_exp";
	var_6eb9e3e5[1] = "lgt_rocketpad_exp";
	var_6eb9e3e5[2] = "lgt_bastion_exp";
	var_e98af28a = [];
	var_e98af28a[0] = "fxexp_801";
	var_e98af28a[1] = "fxexp_802";
	var_e98af28a[2] = "fxexp_800";
	while (level.var_1e4d46e3 < level.var_164e92cf) {
		wait 0.05;
	}
	self.zbarrier Show();
	pap_machine = GetEnt("pap_prefab", "prefabname");
	self.zbarrier _zm_pack_a_punch::set_state_initial();
	self.zbarrier _zm_pack_a_punch::set_state_power_on();
	level waittill("pack_machine_in_use");
	level.var_9b1767c1 = level.round_number + SRandomIntRange("zm_castle_pap_quest_move", 2, 4);
	var_94e7d6ca = undefined;
	var_3c7c9ebd = undefined;
	for (;;) {
		level waittill("end_of_round");
		if (IsDefined(var_94e7d6ca)) {
			var_94e7d6ca Delete();
		}
		if (IsDefined(var_3c7c9ebd)) {
			var_3c7c9ebd Delete();
		}
		if (level.round_number >= level.var_9b1767c1) {
			while (self.zbarrier.state == "eject_gun" || self.zbarrier.state == "take_gun") {
				wait 0.05;
			}
			e_clip = GetEnt(("pap_" + level.var_94c82bf8[level.var_2eccab0d].script_noteworthy) + "_clip", "targetname");
			e_clip [[@zm_castle_pap_quest<scripts\zm\zm_castle_pap_quest.gsc>::function_2209afdf]]();
			e_clip solid();
			var_4a6273cc = GetEnt("pap_debris_" + level.var_94c82bf8[level.var_2eccab0d].script_noteworthy, "targetname");
			var_4a6273cc Show();
			var_92f094dc = var_6eb9e3e5[level.var_2eccab0d];
			var_b57a445e = level.var_22ce1993[level.var_2eccab0d];
			PlayRumbleOnPosition("zm_castle_pap_tp", self.origin);
			level.var_2eccab0d++;
			if (level.var_2eccab0d >= level.var_94c82bf8.size)
			{
				level.var_2eccab0d = 0;
			}
			var_528227ee = level.var_94c82bf8[level.var_2eccab0d].origin;
			var_39796348 = level.var_94c82bf8[level.var_2eccab0d].angles;
			self.zbarrier _zm_pack_a_punch::set_state_leaving();
			var_3c7c9ebd = Spawn("script_model", self.origin + VectorScale((0, 0, 1), 72));
			var_3c7c9ebd SetModel("tag_origin");
			var_3c7c9ebd.angles = self.angles;
			var_94e7d6ca = Spawn("script_model", var_528227ee);
			var_94e7d6ca SetModel("tag_origin");
			var_94e7d6ca.angles = var_39796348;
			self.zbarrier waittill("leave_anim_done");
			var_4a6273cc = GetEnt("pap_debris_" + level.var_94c82bf8[level.var_2eccab0d].script_noteworthy, "targetname");
			var_4a6273cc Hide();
			e_clip = GetEnt(("pap_" + level.var_94c82bf8[level.var_2eccab0d].script_noteworthy) + "_clip", "targetname");
			e_clip NotSolid();
			var_3c7c9ebd clientfield::increment("pap_tp_fx");
			var_94e7d6ca clientfield::increment("pap_tp_fx");
			var_56f90684 = var_6eb9e3e5[level.var_2eccab0d];
			var_592384e6 = level.var_22ce1993[level.var_2eccab0d];
			exploder::exploder_stop(var_b57a445e);
			exploder::exploder_stop(var_92f094dc);
			exploder::exploder(var_592384e6);
			exploder::exploder(var_56f90684);
			self.origin = var_528227ee + VectorScale((0, 0, 1), 32);
			self.angles = var_39796348;
			self.zbarrier.origin = var_528227ee + (VectorScale((0, 0, -1), 16));
			self.zbarrier.angles = var_39796348;
			self thread [[@zm_castle_pap_quest<scripts\zm\zm_castle_pap_quest.gsc>::function_5f17a55c]]();
			wait 0.05;
			e_brush = GetEnt("pap_clip", "targetname");
			var_f72d376e = (VectorNormalize(AnglesToForward(level.var_94c82bf8[level.var_2eccab0d].angles + (VectorScale((0, -1, 0), 90))))) * 16;
			e_brush.origin = (var_528227ee + var_f72d376e) + VectorScale((0, 0, 1), 64);
			e_brush.angles = var_39796348 + VectorScale((0, 1, 0), 90);
			e_brush [[@zm_castle_pap_quest<scripts\zm\zm_castle_pap_quest.gsc>::function_88c193db]]();
			self.zbarrier _zm_pack_a_punch::set_state_arriving();
			level.var_9b1767c1 = level.round_number + SRandomIntRange("zm_castle_pap_quest_move", 2, 4);
		}
	}
}