autoexec fix_robot_sole_anim()
{
	for (i = 0; i <= 2; i++) {
		m_sole = GetEnt("target_sole_" + i, "targetname");
		while (!IsDefined(m_sole)) {
			wait 0.05;
			m_sole = GetEnt("target_sole_" + i, "targetname");
		}
		m_sole_fixed = util::spawn_anim_model("veh_t7_zhd_robot_foot_hatch", m_sole.origin, m_sole.angles);
		m_sole_fixed.targetname = "target_sole_" + i;
		m_sole Delete();
	}
}

detour zm_tomb_giant_robot<scripts\zm\zm_tomb_giant_robot.gsc>::robot_cycling()
{
	three_robot_round = 0;
	last_robot = -1;
	level thread [[@zm_tomb_giant_robot<scripts\zm\zm_tomb_giant_robot.gsc>::giant_robot_intro_walk]](1);
	level waittill("giant_robot_intro_complete");
	for (;;) {
		if (!level.round_number % 4 && three_robot_round != level.round_number) {
			level flag::set("three_robot_round");
		}
		if (level flag::get("ee_all_staffs_placed") && !level flag::get("ee_mech_zombie_hole_opened")) {
			level flag::set("three_robot_round");
		}
		if (level flag::get("three_robot_round")) {
			level.zombie_ai_limit = 22;
			random_number = SRandomInt("zm_tomb_giant_robot_cycle", 3);
			if (random_number == 2 || level flag::get("all_robot_hatch")) {
				level thread giant_robot_start_walk(2);
			}
			else {
				level thread giant_robot_start_walk(2, 0);
			}
			wait 5;
			if (random_number == 0 || level flag::get("all_robot_hatch")) {
				level thread giant_robot_start_walk(0);
			}
			else {
				level thread giant_robot_start_walk(0, 0);
			}
			wait 5;
			if (random_number == 1 || level flag::get("all_robot_hatch")) {
				level thread giant_robot_start_walk(1);
			}
			else {
				level thread giant_robot_start_walk(1, 0);
			}
			level waittill("giant_robot_walk_cycle_complete");
			level waittill("giant_robot_walk_cycle_complete");
			level waittill("giant_robot_walk_cycle_complete");
			wait 5;
			level.zombie_ai_limit = 24;
			three_robot_round = level.round_number;
			last_robot = -1;
			level flag::clear("three_robot_round");
		}
		else {
			if (!level flag::get("activate_zone_nml")) {
				random_number = SRandomInt("zm_tomb_giant_robot_cycle", 2);
			}
            else {
                while (random_number == last_robot) {
                    random_number = SRandomInt("zm_tomb_giant_robot_cycle", 3);
                }
            }
			last_robot = random_number;
			level thread giant_robot_start_walk(random_number);
			level waittill("giant_robot_walk_cycle_complete");
			wait 5;
		}
	}
}

detour zm_tomb_giant_robot<scripts\zm\zm_tomb_giant_robot.gsc>::giant_robot_start_walk(n_robot_id, b_has_hatch = 1)
{
	return giant_robot_start_walk(n_robot_id, b_has_hatch);
}

giant_robot_start_walk(n_robot_id, b_has_hatch = 1)
{
	ai = GetEnt("giant_robot_" + n_robot_id, "targetname");
	level.gr_foot_hatch_closed[n_robot_id] = 1;
	ai.b_has_hatch = b_has_hatch;
	ai flag::clear("kill_trigger_active");
	ai flag::clear("robot_head_entered");
	if (IS_TRUE(ai.b_has_hatch)) {
		m_sole = GetEnt("target_sole_" + n_robot_id, "targetname");
	}
	if (IsDefined(m_sole) && IS_TRUE(ai.b_has_hatch)) {
		m_sole SetCanDamage(1);
		m_sole.health = 99999;
		m_sole Unlink();
	}
	wait 10;
	if (IsDefined(m_sole)) {
		if (SCoinToss("zm_tomb_giant_robot_sole")) {
			ai.hatch_foot = "left";
		}
		else {
			ai.hatch_foot = "right";
		}
		if (ai.hatch_foot == "left") {
			n_sole_origin = ai GetTagOrigin("TAG_ATTACH_HATCH_LE");
			v_sole_angles = ai GetTagAngles("TAG_ATTACH_HATCH_LE");
			ai.hatch_foot = "left";
			str_sole_tag = "tag_attach_hatch_le";
			ai Attach("veh_t7_zhd_robot_foot_hatch", "TAG_ATTACH_HATCH_RI");
		}
		else if (ai.hatch_foot == "right") {
			n_sole_origin = ai GetTagOrigin("TAG_ATTACH_HATCH_RI");
			v_sole_angles = ai GetTagAngles("TAG_ATTACH_HATCH_RI");
			ai.hatch_foot = "right";
			str_sole_tag = "tag_attach_hatch_ri";
			ai Attach("veh_t7_zhd_robot_foot_hatch", "TAG_ATTACH_HATCH_LE");
		}
		m_sole.origin = n_sole_origin;
		m_sole.angles = v_sole_angles;
		wait 0.1;
		m_sole LinkTo(ai, str_sole_tag, (0, 0, 0));
		m_sole Show();
	}
	if (!IS_TRUE(ai.b_has_hatch)) {
		ai Attach("veh_t7_zhd_robot_foot_hatch", "TAG_ATTACH_HATCH_RI");
		ai Attach("veh_t7_zhd_robot_foot_hatch", "TAG_ATTACH_HATCH_LE");
	}
	wait 0.05;
	ai thread [[@zm_tomb_giant_robot<scripts\zm\zm_tomb_giant_robot.gsc>::giant_robot_think]](ai.trig_stomp_kill_right, ai.trig_stomp_kill_left, ai.clip_foot_right, ai.clip_foot_left, m_sole, n_robot_id);
}