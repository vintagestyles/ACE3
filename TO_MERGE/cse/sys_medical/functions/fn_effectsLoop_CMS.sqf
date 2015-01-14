/**
 * fn_effectsLoop_CMS.sqf
 * @Descr: displays visual effects to user
 * @Author: Glowbal
 *
 * @Arguments: []
 * @Return:
 * @PublicAPI: false
 */

private ["_unit","_bloodLoss","_bloodStatus","_painStatus"];
_unit = player;
if (!hasInterface || !isPlayer _unit || !local _unit) exitwith{};
45 cutRsc ["RscCSEScreenEffectsBlack","PLAIN"];
cseDisplayingBleedingEffect = false;
cseDisplayingPainEffect = false;
cseDisplayingUnconiciousEffect = false;

_hb_effect = {
	_heartRate = _this select 0;
	if (_heartRate < 0.1) exitwith {};
	_hbSoundsFast = ["cse_heartbeat_fast_1", "cse_heartbeat_fast_2", "cse_heartbeat_fast_3", "cse_heartbeat_norm_1", "cse_heartbeat_norm_2"];
	_hbSoundsNorm = ["cse_heartbeat_norm_1", "cse_heartbeat_norm_2"];
	_hbSoundsSlow = ["cse_heartbeat_slow_1", "cse_heartbeat_slow_2", "cse_heartbeat_norm_1", "cse_heartbeat_norm_2"];
	if (isnil "CSE_PLAYING_HB_SOUND") then {
		CSE_PLAYING_HB_SOUND = false;
	};
	if (CSE_PLAYING_HB_SOUND) exitwith {};
	CSE_PLAYING_HB_SOUND = true;

	_sleep = 60 / _heartRate;
	if (_heartRate < 60) then {
		_sound = _hbSoundsSlow select (random((count _hbSoundsSlow) -1));
		playSound _sound;

		sleep _sleep;
	} else {
		if (_heartRate > 120) then {
			_sound = _hbSoundsFast select (random((count _hbSoundsFast) -1));
			playSound _sound;
			sleep _sleep;
		};
	};
	CSE_PLAYING_HB_SOUND = false;
};

while {true} do {
	_unit = player;
	if ([_unit] call cse_fnc_isAwake) then {
		sleep 0.25;
		_bloodLoss = _unit call cse_fnc_getBloodLoss_CMS;
		_bloodStatus = [_unit,"cse_bloodVolume",100] call cse_fnc_getVariable;
		_painStatus = [_unit,"cse_pain",0] call cse_fnc_getVariable;

		if (_bloodLoss >0) then {
			//["cse_sys_medical_isBleeding", true, "cse\cse_sys_medical\data\icons\icon_bleeding.paa", [1,1,1,1]] call cse_fnc_gui_displayIcon;
			[_bloodLoss] spawn cse_fnc_effectBleeding;
		} else {
			//["cse_sys_medical_isBleeding", false, "cse\cse_sys_medical\data\icons\icon_bleeding.paa", [1,1,1,1]] call cse_fnc_gui_displayIcon;
		};
		sleep 0.25 +(random(2));
		if (_painStatus > 0) then {
			[_painStatus] spawn cse_fnc_effectPain;
		};
		sleep 0.25 +(random(1));
		_heartRate = [_unit,"cse_heartRate",70] call cse_fnc_getVariable;
		[_heartRate] spawn _hb_effect;
	} else {
		cseDisplayingBleedingEffect = false;
	};
};
