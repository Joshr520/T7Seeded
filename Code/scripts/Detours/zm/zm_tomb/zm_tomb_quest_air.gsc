detour zm_tomb_quest_air<scripts\zm\zm_tomb_quest_air.gsc>::ceiling_ring_randomize()
{
	n_offset_from_final = SRandomIntRange("zm_tomb_quest_air_tiles", 1, 4);
	self.position = (self.script_int + n_offset_from_final) % 4;
	[[@zm_tomb_quest_air<scripts\zm\zm_tomb_quest_air.gsc>::ceiling_ring_update_position]]();
}