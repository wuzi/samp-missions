/*******************************************************************************
* FILENAME :        modules/data/accounts.pwn
*
* DESCRIPTION :
*       Manage player accounts data, registering and login.
*
* NOTES :
*       This file only contains information about player's data and only handles
*       registration and login.
*
*
*/

#include <YSI\y_hooks>

//------------------------------------------------------------------------------

#define MAX_PLAYER_PASSWORD 32

//------------------------------------------------------------------------------

forward OnAccountLoad(playerid);
forward OnAccountCheck(playerid);
forward OnAccountRegister(playerid);

//------------------------------------------------------------------------------

enum e_player_adata
{
    e_player_database_id,
    e_player_password[MAX_PLAYER_PASSWORD],
    e_player_regdate,
    e_player_ip[16],
    e_player_lastlogin
}
static gPlayerAccountData[MAX_PLAYERS][e_player_adata];

//------------------------------------------------------------------------------

enum PlayerState (<<= 1)
{
    E_PLAYER_STATE_NONE,
    E_PLAYER_STATE_LOGGED = 1
}
static PlayerState:gplStates[MAX_PLAYERS];

//------------------------------------------------------------------------------

SetPlayerLogged(playerid, bool:set)
{
    if(set)
        gplStates[playerid] |= E_PLAYER_STATE_LOGGED;
    else
        gplStates[playerid] &= ~E_PLAYER_STATE_LOGGED;
}

//------------------------------------------------------------------------------

IsPlayerLogged(playerid)
{
    if(!IsPlayerConnected(playerid))
        return false;

    if(gplStates[playerid] & E_PLAYER_STATE_LOGGED)
        return true;

    return false;
}

//------------------------------------------------------------------------------

ResetPlayerAccount(playerid)
{
    new ct = gettime();

    gplStates[playerid] = E_PLAYER_STATE_NONE;

    gPlayerAccountData[playerid][e_player_database_id]  = 0;
    gPlayerAccountData[playerid][e_player_regdate]      = ct;
    gPlayerAccountData[playerid][e_player_lastlogin]    = ct;
}

//------------------------------------------------------------------------------

LoadPlayerAccount(playerid)
{
    new query[57 + MAX_PLAYER_NAME + 1], playerName[MAX_PLAYER_NAME + 1];
    GetPlayerName(playerid, playerName, sizeof(playerName));
    mysql_format(gMySQL, query, sizeof(query),"SELECT * FROM `players` WHERE `username` = '%e' LIMIT 1", playerName);
    mysql_tquery(gMySQL, query, "OnAccountLoad", "i", playerid);
}

//------------------------------------------------------------------------------

SavePlayerAccount(playerid)
{
    // Only save if the player is logged
    if(!IsPlayerLogged(playerid))
        return 0;

    // Account saving
    new query[90];
	mysql_format(gMySQL, query, sizeof(query), "UPDATE `players` SET `ip`='%s', `lastlogin`=%d WHERE `id`=%d", gPlayerAccountData[playerid][e_player_ip], gettime(), gPlayerAccountData[playerid][e_player_database_id]);
	mysql_pquery(gMySQL, query);
    return 1;
}

//------------------------------------------------------------------------------

hook OnPlayerConnect(playerid)
{
    ClearPlayerScreen(playerid);
    SetPlayerColor(playerid, 0xACACACFF);
    SendClientMessage(playerid, 0xA9C4E4FF, "Connecting to database, please wait...");
    return 1;
}

//------------------------------------------------------------------------------

hook OnPlayerRequestClass(playerid, classid)
{
    new query[57 + MAX_PLAYER_NAME + 1], playerName[MAX_PLAYER_NAME + 1];
    GetPlayerName(playerid, playerName, sizeof(playerName));
    mysql_format(gMySQL, query, sizeof(query),"SELECT * FROM `players` WHERE `username` = '%e' LIMIT 1", playerName);
    mysql_tquery(gMySQL, query, "OnAccountCheck", "i", playerid);
    return 1;
}

//------------------------------------------------------------------------------

hook OnPlayerRequestSpawn(playerid)
{
    if(!IsPlayerLogged(playerid))
    {
        SendClientMessage(playerid, 0xb44819ff, "* You are not logged.");
        return -1;
    }
    return 1;
}

//------------------------------------------------------------------------------

hook OnPlayerDisconnect(playerid, reason)
{
    SavePlayerAccount(playerid);
    SetPlayerLogged(playerid, false);
    ResetPlayerAccount(playerid);
    return 1;
}

//------------------------------------------------------------------------------

public OnAccountCheck(playerid)
{
	new rows, fields, playerName[MAX_PLAYER_NAME];
	cache_get_data(rows, fields, gMySQL);
    GetPlayerName(playerid, playerName, sizeof(playerName));
	if(rows)
	{
        cache_get_field_content(0, "password", gPlayerAccountData[playerid][e_player_password], gMySQL, MAX_PLAYER_PASSWORD);
        gPlayerAccountData[playerid][e_player_database_id] = cache_get_field_content_int(0, "id", gMySQL);

        new info[104];
        format(info, sizeof(info), "Welcome back, %s!\n\nYour account is registered.\nType your password to login.", playerName);
        ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, "Login", info, "Access", "Quit");
        PlaySelectSound(playerid);
	}
    else
    {
        new info[102];
        format(info, sizeof(info), "Welcome, %s!\n\nYour account is not registered.\nType a password to register.", playerName);
        ShowPlayerDialog(playerid, DIALOG_REGISTER, DIALOG_STYLE_INPUT, "Registering...", info, "Register", "Quit");
        PlaySelectSound(playerid);
    }
    return 1;
}

//------------------------------------------------------------------------------

public OnAccountRegister(playerid)
{
    gPlayerAccountData[playerid][e_player_database_id] = cache_insert_id();
    SetSpawnInfo(playerid, 255, 0, 2234.6855, -1260.9462, 23.9329, 270.0490, 0, 0, 0, 0, 0, 0);
    SpawnPlayer(playerid);

    new playerName[MAX_PLAYER_NAME];
    GetPlayerName(playerid, playerName, sizeof(playerName));
	printf("[mysql] new account registered on database. ID: %d, Username: %s", gPlayerAccountData[playerid][e_player_database_id], playerName);
	return 1;
}

//------------------------------------------------------------------------------

public OnAccountLoad(playerid)
{
	new rows, fields;
	cache_get_data(rows, fields, gMySQL);
	if(rows)
	{
        GetPlayerIp(playerid, gPlayerAccountData[playerid][e_player_ip], 16);
        gPlayerAccountData[playerid][e_player_lastlogin] = cache_get_field_content_int(0, "lastlogin", gMySQL);

        SetSpawnInfo(playerid, 255, 0, 2234.6855, -1260.9462, 23.9329, 270.0490, 0, 0, 0, 0, 0, 0);
        SpawnPlayer(playerid);

        SetPlayerColor(playerid, 0xFFFFFFFF);
        SetPlayerLogged(playerid, true);
    }
    return 1;
}

//------------------------------------------------------------------------------

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    switch(dialogid)
    {
        case DIALOG_LOGIN:
        {
            if(!response)
                return Kick(playerid);

            if(!strcmp(gPlayerAccountData[playerid][e_player_password], inputtext) && !isnull(gPlayerAccountData[playerid][e_player_password]) && !isnull(inputtext))
            {
                PlayConfirmSound(playerid);
                LoadPlayerAccount(playerid);
                SendClientMessage(playerid, 0x88AA62FF, "Logged.");
            }
            else
            {
                ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_INPUT, "Login->Wrong password", "Wrong password!\nTry again:", "Login", "Quit"),
                PlayErrorSound(playerid);
            }
            return -2;
        }
        case DIALOG_REGISTER:
        {
            if(!response)
                Kick(playerid);
            else if(strlen(inputtext) < 6)
                ShowPlayerDialog(playerid, DIALOG_REGISTER, DIALOG_STYLE_INPUT, "Registering...->Pass too short", "Try again:", "Register", "Quit"),
                PlayErrorSound(playerid);
            else if(strlen(inputtext) > MAX_PLAYER_PASSWORD-1)
                ShowPlayerDialog(playerid, DIALOG_REGISTER, DIALOG_STYLE_INPUT, "Registering...->Pass too long", "Try again:", "Register", "Quit"),
                PlayErrorSound(playerid);
            else
            {
                PlayConfirmSound(playerid);
                SetPlayerLogged(playerid, true);
                SendClientMessage(playerid, 0x88AA62FF, "Registered.");

                new playerIP[16], playerName[MAX_PLAYER_NAME];
                GetPlayerName(playerid, playerName, sizeof(playerName));
                GetPlayerIp(playerid, playerIP, sizeof(playerIP));

                new query[128];
                mysql_format(gMySQL, query, sizeof(query), "INSERT INTO `players` (`username`, `password`, `ip`, `regdate`) VALUES ('%e', '%e', '%s', %d)", playerName, inputtext, playerIP, gettime());
            	mysql_tquery(gMySQL, query, "OnAccountRegister", "i", playerid);
            }
            return -2;
        }
    }
    return 1;
}
