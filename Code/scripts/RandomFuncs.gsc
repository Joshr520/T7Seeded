detour sys::RandomInt(max)
{
	return compiler::srandomint("default", max);
}

detour sys::RandomIntRange(min, max)
{
	return compiler::srandomintrange("default", min, max);
}

detour sys::RandomFloat(max)
{
	return compiler::srandomfloat("default", max);
}

detour sys::RandomFloatRange(min, max)
{
	return compiler::srandomfloatrange("default", min, max);
}

SArrayRandom(array, seed_type)
{
	if (array.size > 0) {
		keys = GetArrayKeys(array);
		n_rand = IsDefined(seed_type) ? SRandomInt(seed_type, keys.size) : RandomInt(keys.size);
		return array[keys[n_rand]];
	}
}

SArrayRandomize(array, seed_type)
{
	for (i = 0; i < array.size; i++) {
		j = IsDefined(seed_type) ? SRandomInt(seed_type, array.size) : RandomInt(array.size);
		temp = array[i];
		array[i] = array[j];
		array[j] = temp;
	}
	return array;
}

SCoinToss(seed_type)
{
	n_rand = IsDefined(seed_type) ? SRandomInt(seed_type, 100) : RandomInt(100);
	return n_rand >= 50;
}

SRandomInt(seed_type, max)
{
	return compiler::srandomint(seed_type, max);
}

SRandomIntRange(seed_type, min, max)
{
	return compiler::srandomintrange(seed_type, min, max);
}

SRandomFloat(seed_type, max)
{
	return compiler::srandomfloat(seed_type, max);
}

SRandomFloatRange(seed_type, min, max)
{
	return compiler::srandomfloatrange(seed_type, min, max);
}

init()
{
    SetDvar("sv_cheats", 1);
    SetDvar("scr_firstGumFree", 1);
	SetDvar("zm_private_rankedmatch", 1);
    level.givecustomloadout = ::GiveLoadout;
    level.onlinegame = true;
    level.zm_disable_recording_stats = true;
    level.rankedmatch = 1;
    level.var_dfc343e9 = 0;
}

on_player_spawned()
{
    if (self IsTestClient()) {
        return;
    }

    WaitFadeIn();
    self thread DebugTesting();
}

DebugTesting()
{
    self notify("stop_player_out_of_playable_area_monitor");
    self thread GodMode(1);
    self thread GiveAllPerks();
    self.score = 50000;
}

Godmode(enabled)
{
    level notify("godmode_request");
    level endon("godmode_request");

    if (enabled) {
        for (;;) {
            self EnableInvulnerability();
            wait 0.25;
        }
    }
    else {
        level notify("godmode_end");
        wait 0.5;
        self DisableInvulnerability();
    }
}

GiveAllPerks()
{
	self zm_utility::give_player_all_perks();
}

GiveLoadout()
{
    self GiveWeapon(level.weaponbasemelee);
    self zm_weapons::weapon_give(level.start_weapon, 0, 0, 1, 0);
    self GiveMaxAmmo(level.start_weapon);
    self zm_weapons::weapon_give(level.super_ee_weapon, 0, 0, 1, 1);
}

WaitFadeIn()
{
    while (!IsDefined(level.n_gameplay_start_time)) {
        wait 0.05;
    }
}