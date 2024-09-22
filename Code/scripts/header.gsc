#include scripts\codescripts\struct;

#include scripts\shared\aat_shared;
#include scripts\shared\ai_shared;
#include scripts\shared\animation_shared;
#include scripts\shared\array_shared;
#include scripts\shared\callbacks_shared;
#include scripts\shared\clientfield_shared;
#include scripts\shared\damagefeedback_shared;
#include scripts\shared\exploder_shared;
#include scripts\shared\flag_shared;
#include scripts\shared\flagsys_shared;
#include scripts\shared\fx_shared;
#include scripts\shared\laststand_shared;
#include scripts\shared\lui_shared;
#include scripts\shared\math_shared;
#include scripts\shared\scene_shared;
#include scripts\shared\spawner_shared;
#include scripts\shared\trigger_shared;
#include scripts\shared\util_shared;
#include scripts\shared\vehicle_ai_shared;
#include scripts\shared\vehicle_shared;
#include scripts\shared\ai\zombie_death;
#include scripts\shared\ai\zombie_shared;
#include scripts\shared\ai\zombie_utility;
#include scripts\shared\ai\systems\animation_state_machine_notetracks;

#include scripts\zm\_zm;
#include scripts\zm\_zm_audio;
#include scripts\zm\_zm_behavior;
#include scripts\zm\_zm_bgb;
#include scripts\zm\_zm_blockers;
#include scripts\zm\_zm_daily_challenges;
#include scripts\zm\_zm_equipment;
#include scripts\zm\_zm_laststand;
#include scripts\zm\_zm_magicbox;
#include scripts\zm\_zm_net;
#include scripts\zm\_zm_pack_a_punch;
#include scripts\zm\_zm_pack_a_punch_util;
#include scripts\zm\_zm_perks;
#include scripts\zm\_zm_powerup_nuke;
#include scripts\zm\_zm_powerups;
#include scripts\zm\_zm_score;
#include scripts\zm\_zm_sidequests;
#include scripts\zm\_zm_spawner;
#include scripts\zm\_zm_stats;
#include scripts\zm\_zm_unitrigger;
#include scripts\zm\_zm_utility;
#include scripts\zm\_zm_weapons;
#include scripts\zm\_zm_zonemgr;
#include scripts\zm\aats\_zm_aat_fire_works;
#include scripts\zm\bgbs\_zm_bgb_anywhere_but_here;
#include scripts\zm\bgbs\_zm_bgb_disorderly_combat;
#include scripts\zm\bgbs\_zm_bgb_flavor_hexed;
#include scripts\zm\bgbs\_zm_bgb_im_feelin_lucky;
#include scripts\zm\bgbs\_zm_bgb_soda_fountain;
#include scripts\zm\craftables\_zm_craftables;

#namespace serious;

autoexec __init__sytem__()
{
	compiler::detour();
	compiler::srandominit();
	callback::on_start_gametype(::init);
	callback::on_spawned(::on_player_spawned);
}

IS_TRUE(__a)
{
	return IsDefined(__a) && __a;
}