detour zm_moon_sq_ctvg<scripts\zm\zm_moon_sq_ctvg.gsc>::wire()
{
	level endon("wire_restart");
	wires = struct::get_array("sq_wire_pos", "targetname");
	wires = SArrayRandomize(wires, "zm_moon_sq_ctvg_wire");
	wire_struct = wires[0];
	wire = Spawn("script_model", wire_struct.origin);
	if (IsDefined(wire_struct.angles)) {
		wire.angles = wire_struct.angles;
	}
	wire SetModel("p7_zm_moo_computer_rocket_launch_wire");
	wire thread zm_sidequests::fake_use("pickedup_wire");
	wire waittill("pickedup_wire", who);
	who thread [[@zm_moon_sq_ctvg<scripts\zm\zm_moon_sq_ctvg.gsc>::monitor_wire_disconnect]]();
	who thread zm_audio::create_and_play_dialog("eggs", "quest5", 7);
	who PlaySound("evt_grab_wire");
	who._has_wire = 1;
	wire Delete();
	who zm_sidequests::add_sidequest_icon("sq", "wire");
	level flag::wait_till("c_built");
	wire_struct = struct::get("sq_wire_final", "targetname");
	wire_struct thread zm_sidequests::fake_use("placed_wire", @zm_moon_sq_ctvg<scripts\zm\zm_moon_sq_ctvg.gsc>::wire_qualifier);
	wire_struct waittill("placed_wire", who);
	who thread zm_audio::create_and_play_dialog("eggs", "quest5", 8);
	who PlaySound("evt_casimir_charge");
	who PlaySound("evt_sq_rbs_light_on");
	who._has_wire = undefined;
	who zm_sidequests::remove_sidequest_icon("sq", "wire");
	level clientfield::set("sq_wire_init", 1);
	level flag::set("w_placed");
}