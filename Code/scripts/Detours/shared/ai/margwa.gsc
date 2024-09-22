detour margwaserverutils<scripts\shared\ai\margwa.gsc>::margwaheadsmash()
{
	self notify("stop_head_update");
	headalive = [];
	foreach (head in self.head) {
		if (head.health > 0) {
			headalive[headalive.size] = head;
		}
	}
	headalive = SArrayRandomize(headalive, "margwa_head_smash");
	open = 0;
	foreach (head in headalive) {
		if (!open) {
			head.candamage = 1;
			self clientfield::set(head.cf, head.smash);
			open = 1;
			continue;
		}
		self [[@margwaserverutils<scripts\shared\ai\margwa.gsc>::margwaclosehead]](head);
	}
}