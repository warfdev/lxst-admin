// setup
#include <Dini>
#include <a_samp>

/*

\====================================\
 |========== LXST-ADMIN INC ==========|
 |============ BY: K7LOST ============|
/====================================/

VERSION: 1.0

*/

#if defined _lxstadmin_included
    #endinput
#endif
#define _lxstadmin_included



/*

========== FUNCTION'S ==========
1) GetPlayerData(playerid,data)
2) SetPlayerData(playerid,data,newvalue)
3) SetPlayerLevel(playerid,level)
4) SendClientAnnounce(playerid,text)
5) SetPlayerDataInt(playerid,data,newvalue)
6) SendClientAnnounceForAll(text)
*/



stock GetPlayerData(playerid, data[])
{
  new pname[MAX_PLAYER_NAME], dosya[64];
  GetPlayerName(playerid, pname, sizeof(pname));
  format(dosya, sizeof(dosya), "/Hesaplar/%s.ini", pname);
  
  if(IsPlayerConnected(playerid))
  {
    new pdata;
    pdata = dini_Get(dosya, data);
    return pdata;
  } else return false;
}


stock SetPlayerData(playerid, data[], newvalue[])
{
  new pname[MAX_PLAYER_NAME], dosya[64];
  GetPlayerName(playerid, pname, sizeof(pname));
  format(dosya, sizeof(dosya), "/Hesaplar/%s.ini", pname);
  
  if(IsPlayerConnected(playerid)){
  dini_Set(dosya, data, newvalue);
  }
}


stock SetPlayerDataInt(playerid, data[], newvalue)
{
  new pname[MAX_PLAYER_NAME], dosya[64];
  GetPlayerName(playerid, pname, sizeof(pname));
  format(dosya, sizeof(dosya), "/Hesaplar/%s.ini", pname);
  
  if(IsPlayerConnected(playerid)){
  new valuestring[256];
  format(valuestring, sizeof(valuestring), "%d", newvalue);
  dini_IntSet(dosya, data, valuestring);
  } else return false;
}


stock SetPlayerLevel(playerid, level)
{
  new pname[MAX_PLAYER_NAME], dosya[64];
  GetPlayerName(playerid, pname, sizeof(pname));
  format(dosya, sizeof(dosya), "/Hesaplar/%s.ini", pname);
  new valuestring[256];
  format(valuestring, sizeof(valuestring), "%d", newvalue);
  if(IsPlayerConnected(playerid)){ dini_IntSet(dosya, "pLevel", valuestring); } else return false;
}


stock SendClientAnnounce(playerid, text[])
{
  if(IsPlayerConnected(playerid)){ GameTextForPlayer(playerid, text, 4000, 3); } else return false;
}


stock SendClientAnnounceForAll(text[])
{
  for(new i,a = GetMaxPlayers(); i < a; i++){ if(IsPlayerConnected(i){ GameTextForPlayer(i, text, 4000, 3); } }
}


