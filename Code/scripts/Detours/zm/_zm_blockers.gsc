detour zm_blockers<scripts\zm\_zm_blockers.gsc>::remove_chunk(chunk, node, destroy_immediately, zomb)
{
	chunk zm_blockers::update_states("mid_tear");
	if (IsDefined(chunk.script_parameters)) {
		if (chunk.script_parameters == "board" || chunk.script_parameters == "repair_board" || chunk.script_parameters == "barricade_vents") {
			chunk thread zm_blockers::zombie_boardtear_audio_offset(chunk);
		}
	}
	if (IsDefined(chunk.script_parameters)) {
		if (chunk.script_parameters == "bar") {
			chunk thread zm_blockers::zombie_bartear_audio_offset(chunk);
		}
	}
	chunk NotSolid();
	fx = "wood_chunk_destory";
	if (IsDefined(self.script_fxid)) {
		fx = self.script_fxid;
	}
	if (IS_TRUE(chunk.script_moveoverride)) {
		chunk Hide();
	}
	if (IsDefined(chunk.script_parameters) && chunk.script_parameters == "bar") {
		if (IsDefined(chunk.script_noteworthy) && chunk.script_noteworthy == "4") {
			ent = Spawn("script_origin", chunk.origin);
			ent.angles = node.angles + VectorScale((0, 1, 0), 180);
			dist = 100;
			if (IsDefined(chunk.script_move_dist)) {
				dist_max = chunk.script_move_dist - 100;
				dist = 100 + SRandomInt("zm_blockers_remove_chunk", dist_max);
			}
			else {
				dist = 100 + SRandomInt("zm_blockers_remove_chunk", 100);
			}
			dest = ent.origin + (AnglesToForward(ent.angles) * dist);
			trace = BulletTrace(dest + VectorScale((0, 0, 1), 16), dest + (VectorScale((0, 0, -1), 200)), 0, undefined);
			if (trace["fraction"] == 1) {
				dest = dest + (VectorScale((0, 0, -1), 200));
			}
			else {
				dest = trace["position"];
			}
			chunk LinkTo(ent);
			time = ent zm_utility::fake_physicslaunch(dest, 300 + SRandomInt("zm_blockers_remove_chunk", 100));
			if (SRandomInt("zm_blockers_remove_chunk", 100) > 40) {
				ent RotatePitch(180, time * 0.5);
			}
			else {
				ent RotatePitch(90, time, time * 0.5);
			}
			wait time;
			chunk Hide();
			wait 0.1;
			ent Delete();
		}
		else {
			ent = Spawn("script_origin", chunk.origin);
			ent.angles = node.angles + VectorScale((0, 1, 0), 180);
			dist = 100;
			if (IsDefined(chunk.script_move_dist)) {
				dist_max = chunk.script_move_dist - 100;
				dist = 100 + SRandomInt("zm_blockers_remove_chunk", dist_max);
			}
			else {
				dist = 100 + SRandomInt("zm_blockers_remove_chunk", 100);
			}
			dest = ent.origin + (AnglesToForward(ent.angles) * dist);
			trace = BulletTrace(dest + VectorScale((0, 0, 1), 16), dest + (VectorScale((0, 0, -1), 200)), 0, undefined);
			if (trace["fraction"] == 1) {
				dest = dest + (VectorScale((0, 0, -1), 200));
			}
			else {
				dest = trace["position"];
			}
			chunk LinkTo(ent);
			time = ent zm_utility::fake_physicslaunch(dest, 260 + SRandomInt("zm_blockers_remove_chunk", 100));
			if (SRandomInt("zm_blockers_remove_chunk", 100) > 40) {
				ent RotatePitch(180, time * 0.5);
			}
			else {
				ent RotatePitch(90, time, time * 0.5);
			}
			wait time;
			chunk Hide();
			wait 0.1;
			ent Delete();
		}
		chunk zm_blockers::update_states("destroyed");
		chunk notify("destroyed");
	}
	if (IsDefined(chunk.script_parameters) && chunk.script_parameters == "board" || chunk.script_parameters == "repair_board" || chunk.script_parameters == "barricade_vents") {
		ent = Spawn("script_origin", chunk.origin);
		ent.angles = node.angles + VectorScale((0, 1, 0), 180);
		dist = 100;
		if (IsDefined(chunk.script_move_dist)) {
			dist_max = chunk.script_move_dist - 100;
			dist = 100 + SRandomInt("zm_blockers_remove_chunk", dist_max);
		}
		else {
			dist = 100 + SRandomInt("zm_blockers_remove_chunk", 100);
		}
		dest = ent.origin + (AnglesToForward(ent.angles) * dist);
		trace = BulletTrace(dest + VectorScale((0, 0, 1), 16), dest + (VectorScale((0, 0, -1), 200)), 0, undefined);
		if (trace["fraction"] == 1) {
			dest = dest + (VectorScale((0, 0, -1), 200));
		}
		else {
			dest = trace["position"];
		}
		chunk LinkTo(ent);
		time = ent zm_utility::fake_physicslaunch(dest, 200 + SRandomInt("zm_blockers_remove_chunk", 100));
		if (IsDefined(chunk.unbroken_section)) {
			if (!IsDefined(chunk.material) || chunk.material != "metal") {
				chunk.unbroken_section zm_utility::self_Delete();
			}
		}
		if (SRandomInt("zm_blockers_remove_chunk", 100) > 40) {
			ent RotatePitch(180, time * 0.5);
		}
		else {
			ent RotatePitch(90, time, time * 0.5);
		}
		wait time;
		if (IsDefined(chunk.unbroken_section)) {
			if (IsDefined(chunk.material) && chunk.material == "metal") {
				chunk.unbroken_section zm_utility::self_Delete();
			}
		}
		chunk Hide();
		wait 0.1;
		ent Delete();
		chunk zm_blockers::update_states("destroyed");
		chunk notify("destroyed");
	}
	if (IsDefined(chunk.script_parameters) && chunk.script_parameters == "grate") {
		if (IsDefined(chunk.script_noteworthy) && chunk.script_noteworthy == "6") {
			ent = Spawn("script_origin", chunk.origin);
			ent.angles = node.angles + VectorScale((0, 1, 0), 180);
			dist = 100 + SRandomInt("zm_blockers_remove_chunk", 100);
			dest = ent.origin + (AnglesToForward(ent.angles) * dist);
			trace = BulletTrace(dest + VectorScale((0, 0, 1), 16), dest + (VectorScale((0, 0, -1), 200)), 0, undefined);
			if (trace["fraction"] == 1) {
				dest = dest + (VectorScale((0, 0, -1), 200));
			}
			else {
				dest = trace["position"];
			}
			chunk LinkTo(ent);
			time = ent zm_utility::fake_physicslaunch(dest, 200 + SRandomInt("zm_blockers_remove_chunk", 100));
			if (SRandomInt("zm_blockers_remove_chunk", 100) > 40) {
				ent RotatePitch(180, time * 0.5);
			}
			else {
				ent RotatePitch(90, time, time * 0.5);
			}
			wait time;
			chunk Hide();
			ent Delete();
			chunk zm_blockers::update_states("destroyed");
			chunk notify("destroyed");
		}
		else {
			chunk Hide();
			chunk zm_blockers::update_states("destroyed");
			chunk notify("destroyed");
		}
	}
}