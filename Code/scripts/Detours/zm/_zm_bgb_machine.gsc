detour bgb_machine<scripts\zm\_zm_bgb_machine.gsc>::bgb_machine_select_bgb(player)
{
	if (!player.bgb_pack_randomized.size) {
		player.bgb_pack_randomized = SArrayRandomize(player.bgb_pack, "bgb_machine_random_bgb");
	}
	self.selected_bgb = array::pop_front(player.bgb_pack_randomized);
	clientfield::set("zm_bgb_machine_selection", level.bgb[self.selected_bgb].item_index);
	return player bgb::get_bgb_available(self.selected_bgb);
}