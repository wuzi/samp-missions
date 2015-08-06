/*******************************************************************************
* FILENAME :        modules/def/mapicons.pwn
*
* DESCRIPTION :
*       Makes mapicon's checkpoints be called on OnPlayerEnterCheckpoint().
*
* NOTES :
*       -
*/

#include <YSI\y_hooks>

#define MAX_MAP_ICONS 100

// Checks if the player is in checkpoint
static gplIsInCP[MAX_PLAYERS] = {-1, ...};

enum e_map_icon_data
{
    Float:e_map_icon_x,
    Float:e_map_icon_y,
    Float:e_map_icon_z,

    e_map_icon_type,
    e_map_icon_color,
    e_map_icon_style
}
static gMapIconData[MAX_PLAYERS][MAX_MAP_ICONS][e_map_icon_data];

hook OnPlayerDisconnect(playerid, reason)
{
    for(new i = 0; i < MAX_MAP_ICONS; i++)
    {
        gMapIconData[playerid][i][e_map_icon_x]      = 0.0;
        gMapIconData[playerid][i][e_map_icon_y]      = 0.0;
        gMapIconData[playerid][i][e_map_icon_z]      = 0.0;
        gMapIconData[playerid][i][e_map_icon_type]   = 0;
        gMapIconData[playerid][i][e_map_icon_color]  = 0;
        gMapIconData[playerid][i][e_map_icon_style]  = 0;
    }
    return 1;
}

hook OnPlayerUpdate(playerid)
{
    if(IsPlayerInAnyVehicle(playerid))
        return 1;

    if(gplIsInCP[playerid] == -1)
    {
        for(new i = 0; i < MAX_MAP_ICONS; i++)
        {
            if(IsPlayerInRangeOfPoint(playerid, 2.0, gMapIconData[playerid][i][e_map_icon_x], gMapIconData[playerid][i][e_map_icon_y], gMapIconData[playerid][i][e_map_icon_z]) && (gMapIconData[playerid][i][e_map_icon_style] == MAPICON_GLOBAL_CHECKPOINT || gMapIconData[playerid][i][e_map_icon_style] == MAPICON_LOCAL_CHECKPOINT))
            {
                gplIsInCP[playerid] = i;
                CallLocalFunction("OnPlayerEnterCheckpoint", "i", playerid);
            }
        }
    }
    else
    {
        new i = gplIsInCP[playerid];
        if(!IsPlayerInRangeOfPoint(playerid, 2.0, gMapIconData[playerid][i][e_map_icon_x], gMapIconData[playerid][i][e_map_icon_y], gMapIconData[playerid][i][e_map_icon_z]))
        {
            gplIsInCP[playerid] = -1;
        }
    }
    return 1;
}

stock mdm_SetPlayerMapIcon(playerid, iconid, Float:x, Float:y, Float:z, markertype, color, style)
{
    if(iconid < 0 || iconid > MAX_MAP_ICONS)
        return 0;
    else if(gMapIconData[playerid][iconid][e_map_icon_x] != 0.0 && gMapIconData[playerid][iconid][e_map_icon_y] != 0.0)
        return 0;

    gMapIconData[playerid][iconid][e_map_icon_x]      = x;
    gMapIconData[playerid][iconid][e_map_icon_y]      = y;
    gMapIconData[playerid][iconid][e_map_icon_z]      = z;
    gMapIconData[playerid][iconid][e_map_icon_type]   = markertype;
    gMapIconData[playerid][iconid][e_map_icon_color]  = color;
    gMapIconData[playerid][iconid][e_map_icon_style]  = style;

	SetPlayerMapIcon(playerid, iconid, x, y, z, markertype, color, style);
	return 1;
}
#if defined _ALS_SetPlayerMapIcon
    #undef SetPlayerMapIcon
#else
    #define _ALS_SetPlayerMapIcon
#endif

#define SetPlayerMapIcon mdm_SetPlayerMapIcon

stock mdm_RemovePlayerMapIcon(playerid, iconid)
{
    if(iconid < 0 || iconid > MAX_MAP_ICONS)
        return 0;

    gMapIconData[playerid][iconid][e_map_icon_x]      = 0.0;
    gMapIconData[playerid][iconid][e_map_icon_y]      = 0.0;
    gMapIconData[playerid][iconid][e_map_icon_z]      = 0.0;
    gMapIconData[playerid][iconid][e_map_icon_type]   = 0;
    gMapIconData[playerid][iconid][e_map_icon_color]  = 0;
    gMapIconData[playerid][iconid][e_map_icon_style]  = 0;

	RemovePlayerMapIcon(playerid, iconid);
	return 1;
}
#if defined _ALS_RemovePlayerMapIcon
    #undef RemovePlayerMapIcon
#else
    #define _ALS_RemovePlayerMapIcon
#endif

#define RemovePlayerMapIcon mdm_RemovePlayerMapIcon
