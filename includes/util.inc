/*******************************************************************************
* FILENAME :        util.inc
*
* DESCRIPTION :
*       Useful functions & macros for GTA:SA-MP Pawn.
*
* NOTES :
*       -
*
*/

//------------------------------------------------------------------------------

/*
    Sounds macro
*/
#define PlayConfirmSound(%0)    PlayerPlaySound(%0,1058,0.0,0.0,0.0)
#define PlaySelectSound(%0)     PlayerPlaySound(%0,1083,0.0,0.0,0.0)
#define PlayCancelSound(%0)     PlayerPlaySound(%0,1084,0.0,0.0,0.0)
#define PlayErrorSound(%0)      PlayerPlaySound(%0,1085,0.0,0.0,0.0)

//------------------------------------------------------------------------------

/*
        ClearPlayerScreen
    description:
        Clear the player chat.
    args:
        playerid - ID of the player.
*/
stock ClearPlayerScreen(playerid)
{
    for(new i = 0; i < 100; i++)
        SendClientMessage(playerid, -1, " ");
}

/*
        IsPlayerInArea
    description:
        Checks if a player is in a area.
    args:
        playerid - ID of the player.
        minx - minimum X coord.
        miny - minimum Y coord.
        maxx - maximum X coord.
        maxy - maximum Y coord.
*/
stock IsPlayerInArea(playerid, Float:minx, Float:miny, Float:maxx, Float:maxy)
{
	new Float:X, Float:Y, Float:Z;
	GetPlayerPos(playerid, X, Y, Z);
	if(X >= minx && X <= maxx && Y >= miny && Y <= maxy)
		return 1;
	return 0;
}
