/*******************************************************************************
* FILENAME :        modules/def/ftime.pwn
*
* DESCRIPTION :
*       Global constants and functions to check if the player is doing something
*       for the first time.
*
* NOTES :
*       -
*/

//------------------------------------------------------------------------------

#include <YSI\y_hooks>

// Maximum 32 values per variable
enum FirstTime:(<<= 1)
{
	INVALID_FIRST_TIME_ACTION,
	FIRST_TIME_HOSPITAL = 1
}
static FirstTime:gplFirstTime[MAX_PLAYERS];

//------------------------------------------------------------------------------

SetPlayerFirstTime(playerid, FirstTime:id, bool:set)
{
	if(set)
        gplFirstTime[playerid] |= id;
    else
        gplFirstTime[playerid] &= ~id;
}

//------------------------------------------------------------------------------

bool:GetPlayerFirstTime(playerid, FirstTime:id)
{
    if(gplFirstTime[playerid] & id)
        return true;
    return false;
}

//------------------------------------------------------------------------------

hook OnPlayerConnect(playerid)
{
    gplFirstTime[playerid] = INVALID_FIRST_TIME_ACTION;
    return 1;
}
