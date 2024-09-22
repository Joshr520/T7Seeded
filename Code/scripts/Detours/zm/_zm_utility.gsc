detour zm_utility<scripts\zm\_zm_utility.gsc>::init_zombie_run_cycle()
{
	if (IsDefined(level.speed_change_round)) {
		if (level.round_number >= level.speed_change_round) {
			speed_percent = 0.2 + ((level.round_number - level.speed_change_round) * 0.2);
			speed_percent = Min(speed_percent, 1);
			change_round_max = Int(level.speed_change_max * speed_percent);
			change_left = change_round_max - level.speed_change_num;
			if (change_left == 0) {
				self zombie_utility::set_zombie_run_cycle();
				return;
			}
			change_speed = SRandomInt("zm_utility_run_cycle", 100);
			if (change_speed > 80) {
				self zm_utility::change_zombie_run_cycle();
				return;
			}
			zombie_count = zombie_utility::get_current_zombie_count();
			zombie_left = level.zombie_ai_limit - zombie_count;
			if (zombie_left == change_left) {
				self zm_utility::change_zombie_run_cycle();
				return;
			}
		}
	}
	self zombie_utility::set_zombie_run_cycle();
}

detour zm_utility<scripts\zm\_zm_utility.gsc>::get_random_destroyed_chunk(barrier, barrier_chunks)
{
	if (IsDefined(barrier.zbarrier)) {
		ret = undefined;
		pieces = barrier.zbarrier GetZBarrierPieceIndicesInState("open");
		if (pieces.size) {
			ret = SArrayRandomize(pieces, "zm_utility_destroyed_chunk")[0];
		}
		return ret;
	}
	chunk = undefined;
	chunks_repair_grate = undefined;
	chunks = zm_utility::get_destroyed_chunks(barrier_chunks);
	chunks_repair_grate = zm_utility::get_destroyed_repair_grates(barrier_chunks);
	if (IsDefined(chunks)) {
		return chunks[SRandomInt("zm_utility_destroyed_chunk", chunks.size)];
	}
	if (IsDefined(chunks_repair_grate)) {
		return zm_utility::grate_order_destroyed(chunks_repair_grate);
	}
	return undefined;
}

detour zm_utility<scripts\zm\_zm_utility.gsc>::get_closest_non_destroyed_chunk(origin, barrier, barrier_chunks)
{
	chunks = undefined;
	chunks_grate = undefined;
	chunks_grate = zm_utility::get_non_destroyed_chunks_grate(barrier, barrier_chunks);
	chunks = zm_utility::get_non_destroyed_chunks(barrier, barrier_chunks);
	if (IsDefined(barrier.zbarrier)) {
		if (IsDefined(chunks)) {
			return SArrayRandomize(chunks, "zm_utility_get_chunk")[0];
		}
		if (IsDefined(chunks_grate)) {
			return SArrayRandomize(chunks_grate, "zm_utility_get_chunk")[0];
		}
	}
	else {
		if (IsDefined(chunks)) {
			return zm_utility::non_destroyed_bar_board_order(origin, chunks);
		}
		if (IsDefined(chunks_grate)) {
			return zm_utility::non_destroyed_grate_order(origin, chunks_grate);
		}
	}
	return undefined;
}