// includes



#include <a_samp>



#include <Dini>



#include <zcmd>



#include <float>



#include <foreach>



#include <easyDialog>


#include <discord-connector>



#pragma tabsize 0







#define FILTERSCRIPT

// discord log channels
new DCC_Channel:d_AccountLog;
new DCC_Channel:BanLog;



public OnFilterScriptInit()



{
  d_AccountLog = DCC_FindChannelById("1130447358015049781");
  BanLog = DCC_FindChannelById("1130447358015049781");
  

  new year,month,day;	getdate(year, month, day);  new hour,minute,second; gettime(hour,minute,second);



  



  print("\n|===================================|");



  print("| XFR FREEROAM ADMIN SCRIPT");



  print("| VERSION 1.5");



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



  ToggleTag,



  IsMuted,



  LastOnline,



  IsFreezed,



  IsEmailVerified,


  IP



}





new PlayerInfo[MAX_PLAYERS][Player];



new GirisYapti[MAX_PLAYERS];



#if !defined isnull



    #define isnull(%1) ((!(%1[0])) || (((%1[0]) == '\1') && (!(%1[1]))))



#endif



public OnPlayerConnect(playerid)



{
  PlayerInfo[playerid][IP] = 0;


  PlayerInfo[playerid][HataliGiris] = 0;



  PlayerInfo[playerid][Level] = 0;



  PlayerInfo[playerid][LoggedIn] = 0;



  PlayerInfo[playerid][Coins] = 0;



  PlayerInfo[playerid][Score] = 0;



  PlayerInfo[playerid][ToggleTag] = 0;



  PlayerInfo[playerid][IsEmailVerified] = 0;



  





new Isim[MAX_PLAYER_NAME], Dosya[126];



GetPlayerName(playerid, Isim, sizeof(Isim));



format(Dosya, sizeof(Dosya), "/Hesaplar/%s.ini", Isim);



new isbanned = strval(dini_Get(Dosya, "pIsBanned"));



PlayerInfo[playerid][IsBanned] = isbanned;



if(PlayerInfo[playerid][IsBanned] == 1) return Kick(playerid);



if(!dini_Exists(Dosya))



{



  ShowPlayerDialog(playerid, KAYIT, DIALOG_STYLE_PASSWORD, "{F2FF00}XFR{FFFFFF} Freeroam", "{ffffff}Sunucuya hos geldin! sifreni yazarak kayit olabilirsin:", "Kayit", ""); 



}



else



{



    ShowPlayerDialog(playerid, GIRIS, DIALOG_STYLE_PASSWORD, "{F2FF00}XFR{FFFFFF} Freeroam", "{ffffff}Sunucuya hos geldin! sifreni yazarak giris yapabilirsin:", "Giris", "");



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



    new year,month,day;	getdate(year, month, day);

    new lastostr[128];

    format(lastostr, sizeof(lastostr), "%d-%d-%d", day, month, year);

    

    dini_Set(Dosya, "pLastOnline", lastostr);



    



  }



  return 1;



}



public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])



{



  if(dialogid == KAYIT)



{



    new Isim[MAX_PLAYER_NAME], Dosya[126];



    



    if(!strlen(inputtext)) return ShowPlayerDialog(playerid, KAYIT, DIALOG_STYLE_PASSWORD, "{F2FF00}XFR{FFFFFF} Freeroam", "{ffffff}Sifrenizi yazmazsaniz hesabinizi kaydedemem:", "Kayit", "");



    GetPlayerName(playerid, Isim, sizeof(Isim));



    format(Dosya, sizeof(Dosya), "/Hesaplar/%s.ini", Isim);



    dini_Create(Dosya);



    dini_Set(Dosya, "pIsim", Isim);



    dini_IntSet(Dosya, "pCoins", GetPlayerMoney(playerid));



    dini_IntSet(Dosya, "pLevel", PlayerInfo[playerid][Level]);



    dini_IntSet(Dosya, "pScore", PlayerInfo[playerid][Score]);



    dini_IntSet(Dosya, "pLoggedIn", 0);



    dini_IntSet(Dosya, "pIsBanned", 0);

    dini_IntSet(Dosya, "pEmailVerified", 0);

    new ip[32];
    GetPlayerIp(playerid, ip, sizeof(ip));
    dini_Set(Dosya, "pUsrIP", ip);



    



    dini_Set(Dosya, "pSifre", inputtext);



    ShowPlayerDialog(playerid, GIRIS, DIALOG_STYLE_PASSWORD, "{F2FF00}XFR{FFFFFF} Freeroam", "{ffffff}Harika! Sifreni tekrar yazarak giris yapabilirsin:", "Giris", "");

    new dcstr[256], dcname[MAX_PLAYER_NAME];
    GetPlayerName(playerid, dcname, sizeof(dcname));
    format(dcstr, sizeof(dcstr), "[!] Yeni hesap oluşturuldu. hesap ismi: %s", dcname);
    DCC_SendChannelMessage(d_AccountLog, dcstr);
}



if(dialogid == GIRIS)



{



  new Isim[MAX_PLAYER_NAME], Dosya[126], Sifre[24];



  GetPlayerName(playerid, Isim, sizeof(Isim));



  format(Dosya, sizeof(Dosya), "/Hesaplar/%s.ini", Isim);



  format(Sifre, sizeof(Sifre), "%s", dini_Get(Dosya, "pSifre"));



  if(!strlen(inputtext)) return ShowPlayerDialog(playerid, GIRIS, DIALOG_STYLE_PASSWORD, "{F2FF00}XFR{FFFFFF} Freeroam", "{FFFFFF}Sifre girmediniz.Tekrar deneyin.", "Giris", "");



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



    ShowPlayerDialog(playerid, GIRIS, DIALOG_STYLE_PASSWORD, "{F2FF00}XFR{FFFFFF} Freeroam", "{FFFFFF}Girdiginiz sifre yanlis.Tekrar deneyin.", "Giris", "");



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





  if(PlayerInfo[playerid][IsEmailVerified] == 0)

  {

    Dialog_Show(playerid, 580000, DIALOG_STYLE_INPUT, "EMail Sistemi", "{ffffff}Lutfen alttaki kutuguca size ait olan bir mail'i yaziniz.\nYazmanizi istememizin sebebi hesabinizin sifresini unuttugunuzda veya farkli bir islemlerde kullanmak icindir.", "Tamam", "");

  }



  return 1;



}

Dialog:580000(playerid, response, listitem, inputtext[])

{

  if(isnull(inputtext)) return Dialog_Show(playerid, 580000, DIALOG_STYLE_INPUT, "Email Sistemi", "{ffffff}Lutfen mailinizi yaziniz.\nOrnek olarak: sample@gmail.com", "Tamam", "");





  new Isim[MAX_PLAYER_NAME], Dosya[126];



    GetPlayerName(playerid, Isim, sizeof(Isim));



    format(Dosya, sizeof(Dosya), "/Hesaplar/%s.ini", Isim);



    dini_IntSet(Dosya, "pIsEmailVerified", 1);

    PlayerInfo[playerid][IsEmailVerified] = 1;

    dini_Set(Dosya, "pEmail", inputtext);



    new estr[256];

    format(estr, sizeof(estr), "[EMAIL] basariyla sunucuya mailinizi kayit ettiniz.Kayit ettiginiz mail: %s", inputtext);

    SendClientMessage(playerid, COLOR_GREEN, estr);

  return 1;

}



// text tags



public OnPlayerText(playerid, text[])



{

  new Isim[MAX_PLAYER_NAME], Dosya[126];



    GetPlayerName(playerid, Isim, sizeof(Isim));



    format(Dosya, sizeof(Dosya), "/Hesaplar/%s.ini", Isim);



      new ismuted;

      ismuted = strval(dini_Get(Dosya, "pIsMute"));



    if(PlayerInfo[playerid][ToggleTag] == 0 && ismuted == 0)

    {

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





    if(PlayerInfo[playerid][Level] == 7)



  {



    new str[256], oyuncuN[24];



    GetPlayerName(playerid, oyuncuN, 24);



    format(str, sizeof(str), "{FFAA00}[FOUNDER] {%06x}%s{FFFFFF}(%d): {FFAA00}%s", GetPlayerColor(playerid) >>> 8, oyuncuN, playerid, text);



    SendClientMessageToAll(playerid, str);



    return 0;



  }

    } else if(PlayerInfo[playerid][ToggleTag] == 1 && ismuted == 0)

    {

        if(PlayerInfo[playerid][Level] >= 2)



  {



    new str[256], oyuncuN[24];



    GetPlayerName(playerid, oyuncuN, 24);



    format(str, sizeof(str), "{5CFFC5}[OYUNCU] {%06x}%s{FFFFFF}(%d): {FFFFFF}%s", GetPlayerColor(playerid) >>> 8, oyuncuN, playerid, text);



    SendClientMessageToAll(playerid, str);



    return 0;



  }

    } else if (ismuted == 1){

      SendClientMessage(playerid, COLOR_RED, "Susturuldugunuz icin konusamazsiniz");

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



  CMDMessage(playerid, "/setlevel");



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
      if(PlayerInfo[target][Level] == 0 || PlayerInfo[target][Level] == 1){



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

      CMDMessage(playerid, "/ban");
      new banstr[256], staff[MAX_PLAYER_NAME];
      GetPlayerName(playerid, staff, sizeof(staff));
  

      format(banstr, sizeof(banstr), "[BAN-LOG] - **%s(%d)** Yetkilisi **%s(%d)** oyuncuyu sunucudan yasakladi.", staff, playerid, Isim, target);
      DCC_SendChannelMessage(BanLog, banstr);

      


      } else return SendClientMessage(playerid, COLOR_RED, "[HATA] yetkili yasakyalamazsin.");
    } else return SendClientMessage(playerid, COLOR_RED, "[HATA] oyuncu bulunamadi.");



  }



  return 1;



}



CMD:clearchat(playerid)



{



  if(PlayerInfo[playerid][Level] >= 3)



  {

    clearChat(playerid);

    CMDMessage(playerid, "/clearchat");

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



       CMDMessage(playerid, "/setscore");

      



    } else return SendClientMessage(playerid, COLOR_RED, "[HATA] oyuncu bulunamadi.");



  }



  return 1;



}









CMD:kickall(playerid)

{

  if(PlayerInfo[playerid][Level] >= 6)

  {

    CMDMessage(playerid, "/kickall");

    for(new i,a = GetMaxPlayers(); i < a; i++)

      {

              if(IsPlayerConnected(i))

              {

                if(PlayerInfo[i][Level] == 0 || PlayerInfo[i][Level] == 1 || PlayerInfo[i][Level] == 2 || PlayerInfo[i][Level] == 3) return Kick(i);

              }

      }

      SendClientMessage(playerid, COLOR_GREEN, "[SUNUCU] butun oyunculari sunucudan attiniz");

  }

  return 1;

}









CMD:togglemod(playerid)

{

  if(PlayerInfo[playerid][Level] >= 2)

  {

    if(PlayerInfo[playerid][ToggleTag] == 0)

    {

    PlayerInfo[playerid][ToggleTag] = 1;



      new Isim[MAX_PLAYER_NAME], Dosya[126], Sifre[24];



  GetPlayerName(playerid, Isim, sizeof(Isim));



  format(Dosya, sizeof(Dosya), "/Hesaplar/%s.ini", Isim);



  format(Sifre, sizeof(Sifre), "%s", dini_Get(Dosya, "pSifre"));



    dini_IntSet(Dosya, "pToggleMod", 1);



    SendClientMessage(playerid, COLOR_GREEN, "[SUNUCU] yetkili taginizi gizlediniz");

    } else if(PlayerInfo[playerid][ToggleTag] == 1)

    {

          PlayerInfo[playerid][ToggleTag] = 0;



      new Isim[MAX_PLAYER_NAME], Dosya[126], Sifre[24];



  GetPlayerName(playerid, Isim, sizeof(Isim));



  format(Dosya, sizeof(Dosya), "/Hesaplar/%s.ini", Isim);



  format(Sifre, sizeof(Sifre), "%s", dini_Get(Dosya, "pSifre"));



    dini_IntSet(Dosya, "pToggleMod", 0);



    SendClientMessage(playerid, COLOR_GREEN, "[SUNUCU] yetkili taginizin gizliligini kaldirdiniz");

    }

    CMDMessage(playerid, "/togglemod");

  }

  return 1;

}









CMD:mute(playerid, params[])

{

  if(PlayerInfo[playerid][Level] >= 2)

  {

    new target, targetname[MAX_PLAYER_NAME], authorname[MAX_PLAYER_NAME];

    new str[256], str2[256];



    if(!strlen(params)) return SendClientMessage(playerid, COLOR_RED, "[HATA] dogru kullanim /mute [playerid]");

    target = strval(params);



     if(IsPlayerConnected(target) && target != INVALID_PLAYER_ID)

     {

            new Isim[MAX_PLAYER_NAME], Dosya[126];



      GetPlayerName(target, Isim, sizeof(Isim));



      format(Dosya, sizeof(Dosya), "/Hesaplar/%s.ini", Isim);



       dini_IntSet(Dosya, "pIsMute", 1);



       GetPlayerName(playerid, authorname, sizeof(authorname));



       format(str, sizeof(str), "[SUNUCU] %s(%d) Yetkilisi tarafindan susturuldunuz", authorname, playerid);

       format(str2, sizeof(str2), "[SUNUCU] %s(%d) Oyuncusunu susturdunuz", Isim, target);



       SendClientMessage(playerid, COLOR_GREEN, str2);

       SendClientMessage(target, COLOR_YELLOW, str);

       CMDMessage(playerid, "/mute");

     } else return SendClientMessage(playerid, COLOR_RED, "[HATA] oyuncu bulunamadi");

  }

  return 1;

}









CMD:unmute(playerid, params[])

{

  if(PlayerInfo[playerid][Level] >= 2)

  {

    new target, targetname[MAX_PLAYER_NAME], authorname[MAX_PLAYER_NAME];

    new str[256], str2[256];



    if(!strlen(params)) return SendClientMessage(playerid, COLOR_RED, "[HATA] dogru kullanim /unmute [playerid]");

    target = strval(params);



     if(IsPlayerConnected(target) && target != INVALID_PLAYER_ID)

     {

            new Isim[MAX_PLAYER_NAME], Dosya[126];



      GetPlayerName(target, Isim, sizeof(Isim));



      format(Dosya, sizeof(Dosya), "/Hesaplar/%s.ini", Isim);



       dini_IntSet(Dosya, "pIsMute", 0);



       GetPlayerName(playerid, authorname, sizeof(authorname));



       format(str, sizeof(str), "[SUNUCU] %s(%d) Yetkilisi tarafindan susturulmaniz kalkti", authorname, playerid);

       format(str2, sizeof(str2), "[SUNUCU] %s(%d) Oyuncusunun susturmasini kaldirdiniz", Isim, target);



       SendClientMessage(playerid, COLOR_GREEN, str2);

       SendClientMessage(target, COLOR_YELLOW, str);

       CMDMessage(playerid, "/unmute");

     } else return SendClientMessage(playerid, COLOR_RED, "[HATA] oyuncu bulunamadi");

  }

  return 1;

}









CMD:announce(playerid, params[])

{

  if(PlayerInfo[playerid][Level] >= 4)

  {

    if(isnull(params)) return SendClientMessage(playerid, COLOR_RED, "[HATA] dogur kullanim /announce [message]");



    CMDMessage(playerid, "/announce");



    GameTextForAll(params, 4000, 3);

  }

  return 1;

}









CMD:god(playerid)

{

  if(PlayerInfo[playerid][Level] >= 2)

  {

    SetPlayerHealth(playerid, 9999);

    SetPlayerArmour(playerid, 9999);



    SendClientMessage(playerid, COLOR_GREEN, "[SUNUCU] sinirsiz can ve zirh verildi");

    CMDMessage(playerid, "/god");

  }

  return 1;

}









CMD:svclose(playerid)

{

  if(PlayerInfo[playerid][Level] >= 7){

    SendClientMessage(playerid, COLOR_GREEN, "[SUNUCU] sunucu kapatiliyor...");

    SetTimerEx("SvRestart", 1000, false, "i", playerid);

    CMDMessage(playerid, "/svclose");

  } else return SendClientMessage(playerid, COLOR_RED, "[HATA] RCON yetkiniz yok");

  return 1;

}

forward SvRestart(playerid);

public SvRestart(playerid)

{

  if(PlayerInfo[playerid][Level] >= 7)

  {

    SendRconCommand("exit");

  }

  return 1;

}









CMD:give(playerid)

{

  if(PlayerInfo[playerid][Level] >= 5)

  {

    CMDMessage(playerid, "/give");

    Dialog_Show(playerid, 50000, DIALOG_STYLE_LIST, "Give Menusu", "Jetpack\nMinigun\nGrenade\nMolotov Cocktail\nHS Rocket", "Sec", "Kapat");

  }

  return 1;

}

Dialog:50000(playerid, response, listitem, inputtext[])

{

  if(response)

  {

    if(listitem == 0)

    {//jetpack

      SetPlayerSpecialAction(playerid, 2);

      SendClientMessage(playerid, COLOR_GREEN, "[SUNUCU] jetpack aldiniz");

    }



    if(listitem == 1)

    {//minigun

      GivePlayerWeapon(playerid, 38, 5000);

      SendClientMessage(playerid, COLOR_GREEN, "[SUNUCU] minigun aldiniz");

    }



    if(listitem == 2)

    {//grenade

      GivePlayerWeapon(playerid, 16, 200);

      SendClientMessage(playerid, COLOR_GREEN, "[SUNUCU] grenade aldiniz");

    }



    if(listitem == 3)

    {//molotof

      GivePlayerWeapon(playerid, 18, 200);

      SendClientMessage(playerid, COLOR_GREEN, "[SUNUCU] molotov cocktail aldiniz");

    }



    if(listitem == 4)

    {//HSROCKET

      GivePlayerWeapon(playerid, 36, 2000);

      SendClientMessage(playerid, COLOR_GREEN, "[SUNUCU] hs rocket aldiniz");

    }

  }

  return 1;

}









CMD:kick(playerid, params[])

{

  if(PlayerInfo[playerid][Level] >= 2)

  {

    new target, targetname[MAX_PLAYER_NAME], yetkiliname[MAX_PLAYER_NAME];

    new str[256], str2[256];

    if(isnull(params)) return SendClientMessage(playerid, COLOR_RED, "[HATA] dogru kullanim /kick [playerid]");

    target = strval(params);

    if(IsPlayerConnected(target))

    {
      if(PlayerInfo[target][Level] == 0 || PlayerInfo[target][Level] == 1){

    GetPlayerName(target, targetname, sizeof(targetname));

    GetPlayerName(playerid, yetkiliname, sizeof(yetkiliname));

    format(str, sizeof(str), "[SUNUCU] %s(%d) oyuncusunu sunucudan attiniz", targetname, target);

    format(str2, sizeof(str2), "[SUNUCU] %s(%d) yetkilisi sizi oyundan atti", yetkiliname, playerid);

    SendClientMessage(playerid, COLOR_GREEN, str);

    SendClientMessage(target, COLOR_YELLOW, str2);

    CMDMessage(playerid, "/kick");

    SetTimerEx("KickPlayer", 1000, false, "i", target);
      } else return SendClientMessage(playerid, COLOR_RED, "[HATQ] yetkili atamazsin.");

    } else return SendClientMessage(playerid, COLOR_RED, "[HATA] oyuncu bulunamadi");

  }

  return 1;

}

forward KickPlayer(playerid);

public KickPlayer(playerid)

{

  Kick(playerid);

  return 1;

}









CMD:givem(playerid, params[])

{

  if(PlayerInfo[playerid][Level] >= 4)

  {

    new target, cash, targetname[MAX_PLAYER_NAME], yetkiliname[MAX_PLAYER_NAME];

    new str[256], str2[256];

    if(!strlen(params[0])) return SendClientMessage(playerid, COLOR_RED, "[HATA] dogru kullanim /givem [playerid] [money]");

    if(!strlen(params[1])) return SendClientMessage(playerid, COLOR_RED, "[HATA] dogru kullanim /givem [playerid] [money]");

    target = strval(params[0]);

    if(!IsPlayerConnected(target)) return SendClientMessage(playerid, COLOR_RED, "[HATA] oyuncu bulunamadi");

    cash = strval(params[1]);







 new Isim[MAX_PLAYER_NAME], Dosya[126], Sifre[24];



  GetPlayerName(playerid, Isim, sizeof(Isim));



  format(Dosya, sizeof(Dosya), "/Hesaplar/%s.ini", Isim);



  format(Sifre, sizeof(Sifre), "%s", dini_Get(Dosya, "pSifre"));





    GetPlayerName(playerid, yetkiliname, sizeof(yetkiliname));

    GetPlayerName(target, targetname, sizeof(targetname));



    format(str, sizeof(str), "[SUNUCU] %s(%d) oyuncusuna %d$ verdin", targetname, target, cash);

    format(str2, sizeof(str2), "[SUNUCU] %s(%d) yetkilisi size %d$ verdi", yetkiliname, playerid, cash);



    SendClientMessage(playerid, COLOR_GREEN, str);

    SendClientMessage(target, COLOR_YELLOW, str2);

    GivePlayerMoney(target, cash);

    CMDMessage(playerid, "/givem");





        new newcoin;

    newcoin = GetPlayerMoney(target);

    dini_IntSet(Dosya, "pCoins", newcoin);

  }

  return 1;

}









CMD:takem(playerid, params[])

{

  if(PlayerInfo[playerid][Level] >= 4)

  {

    new target, cash, targetname[MAX_PLAYER_NAME], yetkiliname[MAX_PLAYER_NAME];

    new str[256], str2[256];

    if(!strlen(params[0])) return SendClientMessage(playerid, COLOR_RED, "[HATA] dogru kullanim /takem [playerid] [money]");

    if(!strlen(params[1])) return SendClientMessage(playerid, COLOR_RED, "[HATA] dogru kullanim /takem [playerid] [money]");

    target = strval(params[0]);

    if(!IsPlayerConnected(target)) return SendClientMessage(playerid, COLOR_RED, "[HATA] oyuncu bulunamadi");

    cash = strval(params[1]);







      new Isim[MAX_PLAYER_NAME], Dosya[126], Sifre[24];



  GetPlayerName(playerid, Isim, sizeof(Isim));



  format(Dosya, sizeof(Dosya), "/Hesaplar/%s.ini", Isim);



  format(Sifre, sizeof(Sifre), "%s", dini_Get(Dosya, "pSifre"));







    if(GetPlayerMoney(target) <= cash) return SendClientMessage(playerid, COLOR_RED, "[HATA] kullanicinin parasi 0 in altina inemez");



    GetPlayerName(playerid, yetkiliname, sizeof(yetkiliname));

    GetPlayerName(target, targetname, sizeof(targetname));



    format(str, sizeof(str), "[SUNUCU] %s(%d) oyuncusundan %d$ aldin", targetname, target, cash);

    format(str2, sizeof(str2), "[SUNUCU] %s(%d) yetkilisi sizden %d$ aldi", yetkiliname, playerid, cash);



    SendClientMessage(playerid, COLOR_GREEN, str);

    SendClientMessage(target, COLOR_YELLOW, str2);

    GivePlayerMoney(target, -cash);

    CMDMessage(playerid, "/takem");



    new newcoin;

    newcoin = GetPlayerMoney(target);

    dini_IntSet(Dosya, "pCoins", newcoin);

  }

  return 1;

}









CMD:freeze(playerid, params[])

{

  if(PlayerInfo[playerid][Level] >= 4)

  {

    new target, targetname[MAX_PLAYER_NAME], yetkiliname[MAX_PLAYER_NAME];

    new str[256], str2[256];

    if(isnull(params)) return SendClientMessage(playerid, COLOR_RED, "[HATA] dogru kullanim /freeze [playerid]");

    target = strval(params);



    if(!IsPlayerConnected(target)) return SendClientMessage(playerid, COLOR_RED, "[HATA] oyuncu bulunamadi");



          new Dosya[126], Sifre[24];



  GetPlayerName(target, targetname, sizeof(targetname));

  GetPlayerName(playerid, yetkiliname, sizeof(yetkiliname));



  format(Dosya, sizeof(Dosya), "/Hesaplar/%s.ini", targetname);



  format(Sifre, sizeof(Sifre), "%s", dini_Get(Dosya, "pSifre"));



  format(str, sizeof(str), "[SUNUCU] %s(%d) oyuncusunu dondurdunuz", targetname, target);

  format(str2, sizeof(str2), "[SUNUCU] %s(%d) yetkilisi sizi dondurdu", yetkiliname, playerid);



  SendClientMessage(playerid, COLOR_GREEN, str);

  SendClientMessage(target, COLOR_YELLOW, str2);

  TogglePlayerControllable(target, 0);



  dini_IntSet(Dosya, "pFreezed", 0);



  CMDMessage(playerid, "/freeze");



  }

  return 1;

}









CMD:unfreeze(playerid, params[])

{

  if(PlayerInfo[playerid][Level] >= 4)

  {

    new target, targetname[MAX_PLAYER_NAME], yetkiliname[MAX_PLAYER_NAME];

    new str[256], str2[256];

    if(isnull(params)) return SendClientMessage(playerid, COLOR_RED, "[HATA] dogru kullanim /unfreeze [playerid]");

    target = strval(params);



    if(!IsPlayerConnected(target)) return SendClientMessage(playerid, COLOR_RED, "[HATA] oyuncu bulunamadi");



          new Dosya[126], Sifre[24];



  GetPlayerName(target, targetname, sizeof(targetname));

  GetPlayerName(playerid, yetkiliname, sizeof(yetkiliname));



  format(Dosya, sizeof(Dosya), "/Hesaplar/%s.ini", targetname);



  format(Sifre, sizeof(Sifre), "%s", dini_Get(Dosya, "pSifre"));



  format(str, sizeof(str), "[SUNUCU] %s(%d) oyuncusunun dondurulmasini kaldirdiniz", targetname, target);

  format(str2, sizeof(str2), "[SUNUCU] %s(%d) yetkilisi sizin dondurulmanizi kaldirdi", yetkiliname, playerid);



  SendClientMessage(playerid, COLOR_GREEN, str);

  SendClientMessage(target, COLOR_YELLOW, str2);

  TogglePlayerControllable(target, 1);



  dini_IntSet(Dosya, "pFreezed", 1);

  

  CMDMessage(playerid, "/unfreeze");



  }

  return 1;

}









CMD:goto(playerid, params[])

{

  if(PlayerInfo[playerid][Level] >= 3)

  {

    new target, targetname[MAX_PLAYER_NAME], yetkiliname[MAX_PLAYER_NAME];

    new Float:A;

    new Float:Y;

    new Float:Z;

    new Float:X;



    if(isnull(params)) return SendClientMessage(playerid, COLOR_RED, "[HATA] dogru kullanim /goto [playerid]");

    target = strval(params);

    if(!IsPlayerConnected(target)) return SendClientMessage(playerid, COLOR_RED, "[HATA] oyuncu bulunamadi");

    new str[256], str2[256];

    GetPlayerName(target, targetname, sizeof(targetname));

    GetPlayerName(playerid, yetkiliname, sizeof(yetkiliname));

    GetPlayerPos(target, X, Y, Z); GetPlayerFacingAngle(target, A);

    SetPlayerPos(playerid, X, Y ,Z); SetPlayerFacingAngle(playerid, A);



    format(str, sizeof(str), "[SUNUCU] %s(%d) oyuncusuna isinlandiniz", targetname, target);

    format(str2, sizeof(str2), "[SUNUCU] %s(%d) yetkilisi sizin yaniniza isinlandi", yetkiliname, playerid);

    SendClientMessage(playerid, COLOR_GREEN, str); 

    SendClientMessage(target, COLOR_YELLOW, str2);



    CMDMessage(playerid, "/goto");



  }

  return 1;

}









CMD:summon(playerid, params[])

{

  if(PlayerInfo[playerid][Level] >= 3)

  {

    new target, targetname[MAX_PLAYER_NAME], yetkiliname[MAX_PLAYER_NAME];

    new Float:A;

    new Float:Y;

    new Float:Z;

    new Float:X;



    if(isnull(params)) return SendClientMessage(playerid, COLOR_RED, "[HATA] dogru kullanim /summon [playerid]");

    target = strval(params);

    if(!IsPlayerConnected(target)) return SendClientMessage(playerid, COLOR_RED, "[HATA] oyuncu bulunamadi");

    new str[256], str2[256];

    GetPlayerName(target, targetname, sizeof(targetname));

    GetPlayerName(playerid, yetkiliname, sizeof(yetkiliname));

    GetPlayerPos(playerid, X, Y, Z); GetPlayerFacingAngle(playerid, A);

    SetPlayerPos(target, X, Y ,Z); SetPlayerFacingAngle(target, A);



    format(str, sizeof(str), "[SUNUCU] %s(%d) oyuncusunu yaniniza cektiniz", targetname, target);

    format(str2, sizeof(str2), "[SUNUCU] %s(%d) yetkilisi sizi yanina cekti", yetkiliname, playerid);

    SendClientMessage(playerid, COLOR_GREEN, str); 

    SendClientMessage(target, COLOR_YELLOW, str2);



    CMDMessage(playerid, "/summon");



  }

  return 1;

}









CMD:killplayer(playerid, params[])

{

  if(PlayerInfo[playerid][Level] >= 5)

  {

    new target, targetname[MAX_PLAYER_NAME], yetkiliname[MAX_PLAYER_NAME];

    new str[256], str2[256];



    if(isnull(params)) return SendClientMessage(playerid, COLOR_RED, "[HATA] dogru kullanim /killplayer [playerid]");

    target = strval(params);



    if(!IsPlayerConnected(target)) return SendClientMessage(playerid, COLOR_RED, "[HATA] oyuncu bulunamadi");

    GetPlayerName(playerid, yetkiliname, sizeof(yetkiliname));

    GetPlayerName(target, targetname, sizeof(targetname));



    KillPlayer(target);



    format(str, sizeof(str), "[SUNUCU] %s(%d) oyuncusunu oldurdunuz", targetname, target);

    format(str2, sizeof(str2), "[SUNUCU] %s(%d) yetkilisi sizi oldurdu", yetkiliname, playerid);

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



  PlayerInfo[playerid][IsEmailVerified] = strval(dini_Get(Dosya, "pIsEmailVerified"));



  



  



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





forward MessageToAdmins(color,const string[]);

public MessageToAdmins(color,const string[])

{

	for(new i = 0; i < MAX_PLAYERS; i++)

	{

		if(IsPlayerConnected(i) == 1) if (PlayerInfo[i][Level] >= 2) SendClientMessage(i, color, string);

	}

	return 1;

}



stock CMDMessage(playerid,command[])

{

	new string[128]; GetPlayerName(playerid,string,sizeof(string));

	format(string,sizeof(string),"[COMMAND-LOG] %s Yetkilisi bu komutu kullandi: %s",string,command);

	return MessageToAdmins(COLOR_PURPLE,string);

}







KillPlayer(playerid)

{

  SetPlayerHealth(playerid, 0.0);

}









