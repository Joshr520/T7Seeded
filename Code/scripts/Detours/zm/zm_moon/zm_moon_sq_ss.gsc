detour zm_moon_sq_ss<scripts\zm\zm_moon_sq_ss.gsc>::generate_sequence(seq_length)
{
	seq = [];
	for ( i = 0; i < seq_length; i++) {
		seq[seq.size] = SRandomIntRange("zm_moon_sq_ss_code", 0, 4);
	}
	last = -1;
	num_reps = 0;
	for (i = 0; i < seq_length; i++) {
		if (seq[i] == last) {
			num_reps++;
			if (num_reps >= 2) {
				while (seq[i] == last) {
					seq[i] = SRandomIntRange("zm_moon_sq_ss_code", 0, 4);
				}
				num_reps = 0;
				last = seq[i];
			}
			continue;
		}
		last = seq[i];
		num_reps = 0;
    }
	if (1 == GetDvarInt("scr_debug_ss")) {
		for (i = 0; i < seq.size; i++) {
			seq[i] = 0;
		}
	}
	return seq;
}