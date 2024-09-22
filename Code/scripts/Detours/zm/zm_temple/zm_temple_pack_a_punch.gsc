detour zm_temple_pack_a_punch<scripts\zm\zm_temple_pack_a_punch.gsc>::_randomize_pressure_plates(triggers)
{
	rand_nums = array(1, 2, 3, 4);
	rand_nums = SArrayRandomize(rand_nums, "zm_temple_pack_a_punch_tiles");
	for (i = 0; i < triggers.size; i++) {
		triggers[i].requiredplayers = rand_nums[i];
	}
}