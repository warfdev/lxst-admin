// includes

#include <a_samp>

#include <Dini>

#include <zcmd>

#include <easyDialog>

#include <float>

#include <foreach>

#pragma tabsize 0

/*

|===================================

 \ v1.0.                           \\

  |  LXST-ADMIN SCRIPT              ||

  |                                ||

  |  by lost • discord lost#3232.  ||

 /                                //

|                                ||

|==================================

*/

public OnFilterScriptInit()

{

  new year,month,day;	getdate(year, month, day);  new hour,minute,second; gettime(hour,minute,second);

  

  print("\n|===================================|");

  print("| LXST FREEROAM ADMIN SCRIPT");

  print("| VERSION 1.0");

  print("| LOADED!");

  printf("| Date: %d/%d/%d -- %d:%d:%d", day, month, year, hour, minute, second);

  print("\n|===================================|\n");

  return 1;

}

// COLORS //

#define COLOR_GRAD2 0xBFC0C2FF

#define Renk 	0xB60000FF

#define COLOR_ANNOUNCE 0xFFAD00FF

#define beyaz 0x00FFFFFFAA

#define R_PM 		0xFFFF2AFF

#define R_I		0x00983BFF

#define Gri 0xAFAFAFAA

#define Yesil 0x33AA33AA

#define COLOR_RED 0xFF0000AA

#define Kirmizi 0xFF0000AA

#define Sari 0xFFFF00AA

#define Beyaz 0xFFFFAA

#define Mor 0xC2A2DAAA

#define Mavi 0x33AAFFFF

#define Turuncu 0xFF9900AA

#define Pembe 0xFF69B4FF

#define Siyah 0x000000FF

#define COLOR_GREY 0xAFAFAFAA

#define COLOR_GREEN 0x33AA33AA

#define COLOR_YELLOW 0xFFFF00AA

#define COLOR_WHITE 0xFFFFFFAA

#define COLOR_BRIGHTRED 0xE60000FF

#define COLOR_PURPLE 0xC2A2DAAA

#define COLOR_PURPLE 0xC2A2DAAA

#define COLOR_PURPLE 0xC2A2DAAA

// defines

#define KAYIT 3000

#define GIRIS 3001

// news

enum Player

{

  LoggedIn,

  Level,

  Coins,

  Score,

  HataliGiris,

  IsBanned,

  ToggleTag

}

new PlayerInfo[MAX_PLAYERS][Player];

new GirisYapti[MAX_PLAYERS];

#if !defined isnull

    #define isnull(%1) ((!(%1[0])) || (((%1[0]) == '\1') && (!(%1[1]))))

#endif

public OnPlayerConnect(playerid)

{

  PlayerInfo[playerid][HataliGiris] = 0;

  PlayerInfo[playerid][Level] = 0;

  PlayerInfo[playerid][LoggedIn] = 0;

  PlayerInfo[playerid][Coins] = 0;

  PlayerInfo[playerid][Score] = 0;

  

new Isim[MAX_PLAYER_NAME], Dosya[126];

GetPlayerName(playerid, Isim, sizeof(Isim));

format(Dosya, sizeof(Dosya), "/Hesaplar/%s.ini", Isim);

new isbanned = strval(dini_Get(Dosya, "pIsBanned"));

PlayerInfo[playerid][IsBanned] = isbanned;

if(PlayerInfo[playerid][IsBanned] == 1) return Kick(playerid);

if(!dini_Exists(Dosya))

{

  ShowPlayerDialog(playerid, KAYIT, DIALOG_STYLE_PASSWORD, "{F2FF00}LXST{FFFFFF} Freeroam", "{ffffff}Sunucuya hos geldin! sifreni yazarak kayit olabilirsin:", "Kayit", ""); 

}

else

{

    ShowPlayerDialog(playerid, GIRIS, DIALOG_STYLE_PASSWORD, "{F2FF00}LXST{FFFFFF} Freeroam", "{ffffff}Sunucuya hos geldin! sifreni yazarak giris yapabilirsin:", "Giris", "");

}

  

  

  return 1;

}

public OnPlayerDisconnect(playerid, reason)

{

  new Isim[MAX_PLAYER_NAME], Dosya[126];

GetPlayerName(playerid, Isim, sizeof(Isim));

format(Dosya, sizeof(Dosya), "/Hesaplar/%s.ini", Isim);

  if(dini_Exists(Dosya))

  {

    new oldlvl = strval(dini_Get(Dosya, "pLevel"));

    new oldscore = strval(dini_Get(Dosya, "pScore"));

    new oldcoin = strval(dini_Get(Dosya, "pCoins"));

    new isbanned = strval(dini_Get(Dosya, "pIsBanned"));

    dini_IntSet(Dosya, "pLevel", oldlvl);

    dini_IntSet(Dosya, "pScore", oldscore);

    dini_IntSet(Dosya, "pCoins", oldcoin);

    dini_IntSet(Dosya, "pLoggedIn", 0);

    dini_IntSet(Dosya, "pIsBanned", isbanned);

    

  }

  return 1;

}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])

{

  if(dialogid == KAYIT)

{

    new Isim[MAX_PLAYER_NAME], Dosya[126];

    

    if(!strlen(inputtext)) return ShowPlayerDialog(playerid, KAYIT, DIALOG_STYLE_PASSWORD, "{F2FF00}LXST{FFFFFF} Freeroam", "{ffffff}Sifrenizi yazmazsaniz hesabinizi kaydedemem:", "Kayit", "");

    GetPlayerName(playerid, Isim, sizeof(Isim));

    format(Dosya, sizeof(Dosya), "/Hesaplar/%s.ini", Isim);

    dini_Create(Dosya);

    dini_Set(Dosya, "pIsim", Isim);

    dini_IntSet(Dosya, "pCoins", GetPlayerMoney(playerid));

    dini_IntSet(Dosya, "pLevel", PlayerInfo[playerid][Level]);

    dini_IntSet(Dosya, "pScore", PlayerInfo[playerid][Score]);

    dini_IntSet(Dosya, "pLoggedIn", 0);

    dini_IntSet(Dosya, "pIsBanned", 0);

    

    dini_Set(Dosya, "pSifre", inputtext);

    ShowPlayerDialog(playerid, 1, DIALOG_STYLE_PASSWORD, "{F2FF00}LXST{FFFFFF} Freeroam", "{ffffff}Harika! Sifreni tekrar yazarak giris yapabilirsin:", "Giris", "");

}

if(dialogid == GIRIS)

{

  new Isim[MAX_PLAYER_NAME], Dosya[126], Sifre[24];

  GetPlayerName(playerid, Isim, sizeof(Isim));

  format(Dosya, sizeof(Dosya), "/Hesaplar/%s.ini", Isim);

  format(Sifre, sizeof(Sifre), "%s", dini_Get(Dosya, "pSifre"));

  if(!strlen(inputtext)) return ShowPlayerDialog(playerid, GIRIS, DIALOG_STYLE_PASSWORD, "{F2FF00}LXST{FFFFFF} Freeroam", "{FFFFFF}Sifre girmediniz.Tekrar deneyin.", "Giris", "");

    if(!strcmp(inputtext, Sifre)){

      

      // player login

      pLogin(playerid);

      

    }

else

{

    PlayerInfo[playerid][HataliGiris]++;

    if(PlayerInfo[playerid][HataliGiris] == 4){

      Kick(playerid);

      SendClientMessage(playerid, COLOR_RED, "[GIRIS] 4 kez hatali sifre girisi yaptiginiz icin atildiniz. ( KICKED FROM SYSTEM )");

    }

    ShowPlayerDialog(playerid, GIRIS, DIALOG_STYLE_PASSWORD, "{F2FF00}LXST{FFFFFF} Freeroam", "{FFFFFF}Girdiginiz sifre yanlis.Tekrar deneyin.", "Giris", "");

}

}

  return 1;

}

public OnPlayerSpawn(playerid)

{

  if(PlayerInfo[playerid][LoggedIn] == 0)

  {

    SendClientMessage(playerid, COLOR_RED, "[SUNUCU] giris yapmadan spawn olmaya calistiginiz icin atildiniz.");

    Kick(playerid);

  }

  return 1;

}

// text tags

public OnPlayerText(playerid, text[])

{

  new Isim[MAX_PLAYER_NAME], Dosya[126];

    GetPlayerName(playerid, Isim, sizeof(Isim));

    format(Dosya, sizeof(Dosya), "/Hesaplar/%s.ini", Isim);

  if(PlayerInfo[playerid][Level] == 0)

  {

    new str[256], oyuncuN[24];

    GetPlayerName(playerid, oyuncuN, 24);

    format(str, sizeof(str), "{5CFFC5}[OYUNCU] {%06x}%s{FFFFFF}(%d): {FFFFFF}%s", GetPlayerColor(playerid) >>> 8, oyuncuN, playerid, text);

    SendClientMessageToAll(playerid, str);

    return 0;

  }

  

  if(PlayerInfo[playerid][Level] == 1)

  {

    new str[256], oyuncuN[24];

    GetPlayerName(playerid, oyuncuN, 24);

    format(str, sizeof(str), "{D5D800}[VIP] {%06x}%s{FFFFFF}(%d): {D5D800}%s", GetPlayerColor(playerid) >>> 8, oyuncuN, playerid, text);

    SendClientMessageToAll(playerid, str);

    return 0;

  }

  

  if(PlayerInfo[playerid][Level] == 2)

  {

    new str[256], oyuncuN[24];

    GetPlayerName(playerid, oyuncuN, 24);

    format(str, sizeof(str), "{FF73E0}[MODERATOR] {%06x}%s{FFFFFF}(%d): {C3FF7F}%s", GetPlayerColor(playerid) >>> 8, oyuncuN, playerid, text);

    SendClientMessageToAll(playerid, str);

    return 0;

  }

  

  if(PlayerInfo[playerid][Level] == 3)

  {

    new str[256], oyuncuN[24];

    GetPlayerName(playerid, oyuncuN, 24);

    format(str, sizeof(str), "{A50A00}[GUARDIAN] {%06x}%s{FFFFFF}(%d): {C3FF7F}%s", GetPlayerColor(playerid) >>> 8, oyuncuN, playerid, text);

    SendClientMessageToAll(playerid, str);

    return 0;

  }

  

  if(PlayerInfo[playerid][Level] == 4)

  {

    new str[256], oyuncuN[24];

    GetPlayerName(playerid, oyuncuN, 24);

    format(str, sizeof(str), "{FF5926}[ADMIN] {%06x}%s{FFFFFF}(%d): {FFF900}%s", GetPlayerColor(playerid) >>> 8, oyuncuN, playerid, text);

    SendClientMessageToAll(playerid, str);

    return 0;

  }

  

  if(PlayerInfo[playerid][Level] == 5)

  {

    new str[256], oyuncuN[24];

    GetPlayerName(playerid, oyuncuN, 24);

    format(str, sizeof(str), "{801CFF}[DEV] {%06x}%s{FFFFFF}(%d): {FFAA00}%s", GetPlayerColor(playerid) >>> 8, oyuncuN, playerid, text);

    SendClientMessageToAll(playerid, str);

    return 0;

  }

  

  if(PlayerInfo[playerid][Level] == 6)

  {

    new str[256], oyuncuN[24];

    GetPlayerName(playerid, oyuncuN, 24);

    format(str, sizeof(str), "{FFAA00}[FOUNDER] {%06x}%s{FFFFFF}(%d): {FFAA00}%s", GetPlayerColor(playerid) >>> 8, oyuncuN, playerid, text);

    SendClientMessageToAll(playerid, str);

    return 0;

  }

  

  return 1;

}

////////////////////////////////////////////////////////////

// VIP COMMANDS

//

CMD:extrahp(playerid)

{

  if(PlayerInfo[playerid][Level] >= 1)

  {

    SetPlayerHealth(playerid, 350);

    SendClientMessage(playerid, COLOR_GREEN, "[VIP] 350 can verildi.");

  } else return SendClientMessage(playerid, COLOR_RED, "[HATA] VIP degilsiniz.");

  return 1;

}

CMD:extraar(playerid)

{

  if(PlayerInfo[playerid][Level] >= 1)

  {

    SetPlayerArmour(playerid, 350);

    SendClientMessage(playerid, COLOR_GREEN, "[VIP] 350 zirh verildi.");

  } else return SendClientMessage(playerid, COLOR_RED, "[HATA] VIP degilsiniz.");

  return 1;

}

CMD:vduyur(playerid, params[])

{

  if(PlayerInfo[playerid][Level] >= 1)

  {

    if(isnull(params)) return SendClientMessage(playerid, COLOR_RED, "[HATA] dogru kullanim /duyur [duyuru mesaji]");

    new pName[MAX_PLAYER_NAME], str[256];

    GetPlayerName(playerid, pName, sizeof(pName));

    format(str, sizeof(str), "{62FFFD}[VIP-DUYURUSU] {D0D0D0}( {ffffff}%s(%d){D0D0D0} ) {62FFFD}(MESAJI): {FFFFFF}%s", pName, playerid, params);

    SendClientMessageToAll(-1, str);

    new Float:pX, Float:pY, Float:pZ;

    GetPlayerPos(playerid,pX,pY,pZ);

    PlayerPlaySound(playerid,1057,pX,pY,pZ);

  } else return SendClientMessage(playerid, COLOR_RED, "[HATA] VIP degilsiniz.");

  return 1;

}

////////////////////////////////////////////////////////////

// STAFF COMMANDS

//

CMD:setlevel(playerid, params[])

{

  if(PlayerInfo[playerid][Level] >= 6){

  

  new target, plvl;

  if(!strlen(params[0])) return SendClientMessage(playerid, COLOR_RED, "[HATA] dogru kullanim /setlevel [playerid] [level]");

  target = strval(params[0]);

  if(!strlen(params[1])) return SendClientMessage(playerid, COLOR_RED, "[HATA] dogru kullanim /setlevel [playerid] [level]");

  plvl = strval(params[1]);

  if(plvl == 0 || plvl == 1 || plvl == 2 || plvl == 3 || plvl == 4 || plvl == 5 || plvl == 6){

    if(IsPlayerConnected(target) && target != INVALID_PLAYER_ID){

      new Isim[MAX_PLAYER_NAME], Dosya[126], Sifre[24];

      GetPlayerName(target, Isim, sizeof(Isim));

      format(Dosya, sizeof(Dosya), "/Hesaplar/%s.ini", Isim);

      format(Sifre, sizeof(Sifre), "%s", dini_Get(Dosya, "pSifre"));

  

  PlayerInfo[playerid][Level] = plvl;

  dini_IntSet(Dosya, "pLevel", plvl);

  

  new str[256], str2[256];

  format(str, sizeof(str), "[SUNUCU] %s(%d) oyuncusunun levelini %d yaptiniz.", Isim, target, plvl);

  format(str2, sizeof(str2), "[SUNUCU] leveliniz %d olarak ayarlandi.", plvl);

  SendClientMessage(playerid, COLOR_GREEN, str);

  SendClientMessage(target, COLOR_GREEN, str2);

  

    } else return SendClientMessage(playerid, COLOR_RED, "[HATA] oyuncu bulunamadi.");

  } else return SendClientMessage(playerid, COLOR_RED, "[HATA] hatali level girdiniz.");

  }

  return 1;

}

CMD:ban(playerid, params[])

{

  if(PlayerInfo[playerid][Level] >= 2)

  {

    new target;

    if(!strlen(params[0])) return SendClientMessage(playerid, COLOR_RED, "[HATA] dogru kullanim /ban [playerid]");

    target = strval(params[0]);

    

    if(IsPlayerConnected(target) && target != INVALID_PLAYER_ID){

      new Isim[MAX_PLAYER_NAME], Dosya[126];

      GetPlayerName(target, Isim, sizeof(Isim));

      format(Dosya, sizeof(Dosya), "/Hesaplar/%s.ini", Isim);

      

      PlayerInfo[target][IsBanned] = 1;

      dini_IntSet(Dosya, "pIsBanned", 1);

      

      new str[256], str2[256], global[256], yetkili[MAX_PLAYER_NAME];

      GetPlayerName(playerid, yetkili, sizeof(yetkili));

      format(str, sizeof(str), "[SUNUCU] %s(%d) isimli oyuncuyu sunucudan yasakladiniz.", Isim, target);

      format(str2, sizeof(str2), "[BAN-SYSTEM] %s(%d) isimli yetkili sizi sunucudan yasakladi.", yetkili, playerid);

      format(global, sizeof(global), "{FF5300}[BAN] {FFFA00}%s(%d) isimli oyuncu sunucudan kalici yasaklandi.", Isim, target);

      

      SendClientMessage(target, COLOR_RED, str2);

      SendClientMessage(playerid, COLOR_GREEN, str);

      SendClientMessageToAll(-1, global);

      

      Kick(target);

      

    } else return SendClientMessage(playerid, COLOR_RED, "[HATA] oyuncu bulunamadi.");

  }

  return 1;

}

CMD:clearchat(playerid)

{

  if(PlayerInfo[playerid][Level] >= 3)

  {

    clearChat(playerid);

  }

  return 1;

}

CMD:setscore(playerid, params[])

{

  if(PlayerInfo[playerid][Level] >= 4)

  {

    new target, score;

    if(!strlen(params)) return SendClientMessage(playerid, COLOR_RED, "[HATA] dogru kullanim /setscore [playerid] [score]");

    target = strval(params);

    

    if(!strlen(params[1])) return SendClientMessage(playerid, COLOR_RED, "[HATA] dogru kullanim /setscore [playerid] [score]");

    score = strval(params[1]);

    

    if(IsPlayerConnected(target) && target != INVALID_PLAYER_ID)

    {

      new targetname[MAX_PLAYER_NAME], authorname[MAX_PLAYER_NAME], str[256], str2[256];

      GetPlayerName(target, targetname, sizeof(targetname));

      GetPlayerName(playerid, authorname, sizeof(authorname));

      

      format(str, sizeof(str), "[SUNUCU] %s(%d) oyuncusuna %d score gonderdiniz.", targetname, target, score);

      format(str2, sizeof(str2), "[SUNUCU] %s(%d) yetkilisi size %d score gonderdi.", authorname, playerid, score);

      

      SendClientMessage(playerid, COLOR_GREEN, str);

      SendClientMessage(target, COLOR_YELLOW, str2);

      

      SetPlayerScore(target, score);

      

    } else return SendClientMessage(playerid, COLOR_RED, "[HATA] oyuncu bulunamadi.");

  }

  return 1;

}

////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////

// STOCKS  ||  OTHERS

stock PlayerName2(playerid) {

  new name[MAX_PLAYER_NAME];

  GetPlayerName(playerid, name, sizeof(name));

  return name;

}

pLogin(playerid)

{

  new Isim[MAX_PLAYER_NAME], Dosya[126], Sifre[24];

  GetPlayerName(playerid, Isim, sizeof(Isim));

  format(Dosya, sizeof(Dosya), "/Hesaplar/%s.ini", Isim);

  format(Sifre, sizeof(Sifre), "%s", dini_Get(Dosya, "pSifre"));

  

  // news

  new seviye = strval(dini_Get(Dosya, "pLevel"));

  new para = strval(dini_Get(Dosya, "pCoins"));

  new skor = strval(dini_Get(Dosya, "pScore"));

  

  

  

  // LOGIN PLAYER DATA //

  

  PlayerInfo[playerid][LoggedIn] = 1;

  dini_IntSet(Dosya, "pLoggedIn", 1);

  

  

  PlayerInfo[playerid][Level] = seviye;

  

  

  GivePlayerMoney(playerid, para);

  PlayerInfo[playerid][Coins] = para;

  

  

  SetPlayerScore(playerid, skor);

  PlayerInfo[playerid][Score] = skor;

  

  new loginmsg[256];

  format(loginmsg, sizeof(loginmsg), "Basariyla giris yaptiniz! ( Level: %d )", seviye);

  SendClientMessage(playerid, COLOR_GREEN, loginmsg);

}

clearChat(playerid)

{

  SendClientMessageToAll(-1, "  ");

  SendClientMessageToAll(-1, "  ");

  SendClientMessageToAll(-1, "  ");

  SendClientMessageToAll(-1, "  ");

  SendClientMessageToAll(-1, "  ");

  SendClientMessageToAll(-1, "  ");

  SendClientMessageToAll(-1, "  ");

  SendClientMessageToAll(-1, "  ");

  SendClientMessageToAll(-1, "  ");

  SendClientMessageToAll(-1, "  ");

  SendClientMessageToAll(-1, "  ");

  SendClientMessageToAll(-1, "  ");

  SendClientMessageToAll(-1, "  ");

  SendClientMessageToAll(-1, "  ");

  SendClientMessageToAll(-1, "  ");

  SendClientMessageToAll(-1, "  ");

  SendClientMessageToAll(-1, "  ");

  SendClientMessageToAll(-1, "  ");

  SendClientMessageToAll(-1, "  ");

  SendClientMessageToAll(-1, "  ");

  SendClientMessageToAll(-1, "  ");

  SendClientMessageToAll(-1, "  ");

  SendClientMessageToAll(-1, "  ");

  SendClientMessageToAll(-1, "  ");

  SendClientMessageToAll(-1, "  ");

  SendClientMessageToAll(-1, "  ");

  SendClientMessageToAll(-1, "  ");

  SendClientMessageToAll(-1, "  ");

  SendClientMessageToAll(-1, "  ");

  SendClientMessageToAll(-1, "  ");

  SendClientMessageToAll(-1, "  ");

  SendClientMessageToAll(-1, "  ");

  SendClientMessageToAll(-1, "  ");

  SendClientMessageToAll(-1, "  ");

  SendClientMessageToAll(-1, "  ");

  SendClientMessageToAll(-1, "  ");

  SendClientMessageToAll(-1, "  ");

  SendClientMessageToAll(-1, "  ");

  SendClientMessageToAll(-1, "  ");

  SendClientMessageToAll(-1, "  ");

  SendClientMessageToAll(-1, "  ");

  SendClientMessageToAll(-1, "  ");

  SendClientMessageToAll(-1, "  ");

  SendClientMessageToAll(-1, "  ");

  SendClientMessageToAll(-1, "  ");

  SendClientMessageToAll(-1, "  ");

  SendClientMessageToAll(-1, "  ");

  SendClientMessageToAll(-1, "  ");

  SendClientMessageToAll(-1, "  ");

  SendClientMessageToAll(-1, "  ");

  SendClientMessageToAll(-1, "  ");

  SendClientMessageToAll(-1, "  ");

  SendClientMessageToAll(-1, "  ");

  SendClientMessageToAll(-1, "  ");

  SendClientMessageToAll(-1, "  ");

  SendClientMessageToAll(-1, "  ");

  SendClientMessageToAll(-1, "  ");

  SendClientMessageToAll(-1, "  ");

  SendClientMessageToAll(-1, "  ");

  SendClientMessageToAll(-1, "  ");

  SendClientMessageToAll(-1, "  ");

  SendClientMessageToAll(-1, "  ");

  SendClientMessageToAll(-1, "  ");

  SendClientMessageToAll(-1, "  ");

  

  

  SendClientMessage(playerid, COLOR_GREEN, "[SUNUCU] chati temizlediniz.");

}
