detour zm_cosmodrome_traps<scripts\zm\zm_cosmodrome_traps.gsc>::centrifuge_random()
{
	centrifuge_model = GetEnt("rotating_trap_group1", "targetname");
	centrifuge_damage_trigger = GetEnt("trigger_centrifuge_damage", "targetname");
	centrifuge_start_angles = centrifuge_model.angles;
	for (;;) {
		if (!IS_TRUE(level.var_6708aa9c)) {
			malfunction_for_round = SRandomInt("zm_cosmodrome_traps_centrifuge", 10);
			if (malfunction_for_round > 6) {
				level waittill("between_round_over");
			}
			else if (malfunction_for_round == 1) {
				level waittill("between_round_over");
				level waittill("between_round_over");
			}
			wait SRandomIntRange("zm_cosmodrome_traps_centrifuge", 24, 90);
		}
		rotation_amount = SRandomIntRange("zm_cosmodrome_traps_centrifuge", 3, 7) * 360;
		wait_time = SRandomIntRange("zm_cosmodrome_traps_centrifuge", 4, 7);
		level [[@zm_cosmodrome_traps<scripts\zm\zm_cosmodrome_traps.gsc>::centrifuge_spin_warning]](centrifuge_model);
		centrifuge_model clientfield::set("COSMO_CENTRIFUGE_RUMBLE", 1);
		centrifuge_model RotateYaw(rotation_amount, wait_time, 1, 2);
		centrifuge_damage_trigger thread [[@zm_cosmodrome_traps<scripts\zm\zm_cosmodrome_traps.gsc>::centrifuge_damage]]();
		wait 3;
		centrifuge_model StopLoopSound(4);
		centrifuge_model PlaySound("zmb_cent_end");
		centrifuge_model waittill("rotatedone");
		centrifuge_damage_trigger notify("trap_done");
		centrifuge_model PlaySound("zmb_cent_lockdown");
		centrifuge_model clientfield::set("COSMO_CENTRIFUGE_LIGHTS", 0);
		centrifuge_model clientfield::set("COSMO_CENTRIFUGE_RUMBLE", 0);
	}
}