detour zm_zod_idgun_quest<scripts\zm\zm_zod_idgun_quest.gsc>::function_14e2eca6(params)
{
	if (level.round_number < 12) {
		return;
	}
	if (self.does_not_count_to_round === 1) {
		return;
	}
	if (level flag::get("part_xenomatter" + "_found")) {
		return;
	}
	if (IS_TRUE(level.var_689ff92e)) {
		return;
	}
	if (!isplayer(params.eattacker)) {
		return;
	}
	n_rand = SRandomFloatRange("zm_zod_idgun_quest_xenomatter", 0, 1);
	if (n_rand >= 0.1) {
		return;
	}
	level.var_689ff92e = 1;
	var_dad4b542 = self GetOrigin();
	var_72cd7c0a = GetClosestPointOnNavMesh(var_dad4b542, 500, 0);
	var_ca79e2ce = (var_dad4b542[0], var_dad4b542[1], 0);
	var_dcaa8f8e = (var_72cd7c0a[0], var_72cd7c0a[1], 0);
	if (var_ca79e2ce == var_dcaa8f8e) {
		[[@zm_zod_idgun_quest<scripts\zm\zm_zod_idgun_quest.gsc>::special_craftable_spawn]](var_72cd7c0a, "part_xenomatter");
	}
	if (!level flag::get("part_xenomatter" + "_found")) {
		mdl_part = level zm_craftables::get_craftable_piece_model("idgun", "part_xenomatter");
		var_55d0f940 = struct::get("safe_place_for_items", "targetname");
		mdl_part.origin = var_55d0f940.origin;
		level.var_689ff92e = 0;
	}
}