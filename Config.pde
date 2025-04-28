// --- Section 1 ---
String[] snakeNames1 = new String[] {
  "AbrilIrachetaSnake",
  "AdahSkaffSnake",
  "AdamZuberSnake",
  "AlanZhouSnake",
  "AlanaLeeSnake",
  "AlexRosemannSnake",
  "AllysonSalasSnake",
  "AndrewHeitmeyersnake",
  "AngelDuranGonzalezSnake",
  "AnnabelleKimSnake",
  "ArielLagunasSnake",
  "AvaCarzolaSnake",
  "BriannaTorresSnake",
  "BeccaYoungersSnake",
  "BrandonWickenSnake",
  "CameronAllisonSnake",
  "CarlyMillsSnake",
  "CharisElkintonSnake",
  "ChelseaLeeSnake",
  "ChiomaAguoruSnake",
  "ClaireHuangSnake"

};

String[] snakeNames2 = new String[] {
  "DaeYparraguirreSnake",
  "DanielColcockSnake",
  "DanielPortilloSnake",
  "DevonVoylesSnake",
  "DavidChienSnake",
  "ElizabethHanSnake",
  "EllaBagbySnake",
  "ElvisLeeSnake",
  "EricMoczygembaSnake",
  "EvaJimenezSnake",
  "EverestNguyenSnake",
  "EzraEstradaSnake",
  "FridaBalderas",
  "HeatherKimSnake",
  "HaydenRossSnake",
  "HelenRadzaSnake",
  "HoangMNguyenSnake",
  "JaeSandwegSnake",
  "JeremyScheppersSnake",
  "JialiJaddangiSnakee",
  "JocelynePartidaSnake",
  "JosiahVillarrealFloresSnake",

};

String[] snakeNames = new String[] {

  "KalebAzizSnake", // invsible
  "KattiaMoralesSnake",
  "KayliePerezSnake",
  "KaylaMarinSnake",
  "KeeganBeardSnake",
  "KeiraHumphriesSnake",
  "KimNguyenSnake",
  "KylaPatelSnake",
  "LanaNguyenSnake",
  "LaurenCogbillSnake",
  "LaurenFinnertySnake",
  "LillianCoan",
  "LinhTranSnake",
  "LuisTorresMillanSnake",
  "LuxiWangSnake",
  "MarceloMendezSnake",
  "MarcoHurtadoSnake",
  "MelikeKaraSnake",
  "NaomiVegaSnake",
  "NatalieSottekSnake",
  "NickMorrisSnake",
  "NicoleCainSnake",
  "NoahRutledgeSnake", // not a real submission


};

String[] snakeNames4 = new String[] {
  "OllieOtouBranckaertSnake",
  "RenBairdSnake",
  "ReginaAvilaSnake",
  "RinNishiwakiSnake",
  "RosalindaJoachimSnake",
  "SarahGruberSnake",
  "SebastianNietoSnake",
  "SethEastmanSnake",
  "SissiLaiSnake",
  "SkylarEvansSnake",
  "SydneyKittelbergerSnake",
  "TanmayeeBharadwajSnake",
  "TheodoreChauSnake",
  "ThomasChunSnake",
  "TreTrevinoSnake",
  "WesleyKuykendallSnake",
  "YasminGarciaSnake",
  "ZahraMehdiSnake",
  "YarisAmayaOrellanaSnake",
  //"MichelleEstrellaSnake",
  "VanessaFloresSnake",
  "JovannaMolinaSnake",
  "CrystalNguyenSnake",
  "MichaelGameSnake"
};




Snake spawnNewSnake(int x, int y, String name) {
  switch (name) {

  case "MichaelGameSnake":
    return new MichaelGameSnake(x, y);
  case "YarisAmayaOrellanaSnake":
    return new YarisAmayaOrellanaSnake(x, y);
  case "SkylarEvansSnake":
    return new SkylarEvansSnake(x, y);
  case "KimNguyenSnake":
    return new KimNguyenSnake(x, y);
  case "AllysonSalasSnake":
    return new AllysonSalasSnake(x, y);
  case "LaurenFinnertySnake":
    return new LaurenFinnertySnake(x, y);
    case "KylaPatelSnake":
        return new KylaPatelSnake(x, y);
  case "ThomasChunSnake":
    return new ThomasChunSnake(x, y);
  case "TanmayeeBharadwajSnake":
    return new TanmayeeBharadwajSnake(x, y);
  case "ReginaAvilaSnake":
    return new ReginaAvilaSnake(x, y);
  case "MarceloMendezSnake":
    return new MarceloMendezSnake(x, y);
  case "LuxiWangSnake":
    return new LuxiWangSnake(x, y);
  case "LuisTorresMillanSnake":
    return new LuisTorresMillanSnake(x, y);
  case "KaylaMarinSnake":
    return new KaylaMarinSnake(x, y);
  case "KattiaMoralesSnake":
    return new KattiaMoralesSnake(x, y);
  case "JaeSandwegSnake":
    return new JaeSandwegSnake(x, y);
  case "HelenRadzaSnake":
    return new HelenRadzaSnake(x, y);
  case "HeatherKimSnake":
    return new HeatherKimSnake(x, y);
  case "EzraEstradaSnake":
    return new EzraEstradaSnake(x, y);
  case "EllaBagbySnake":
    return new EllaBagbySnake(x, y);
  case "EverestNguyenSnake":
    return new EverestNguyenSnake(x, y);
  case "DevonVoylesSnake":
    return new DevonVoylesSnake(x, y);
  case "AbrilIrachetaSnake":
    return new AbrilIrachetaSnake(x, y);
  case "AdahSkaffSnake":
    return new AdahSkaffSnake(x, y);
  case "BriannaTorresSnake":
    return new BriannaTorresSnake(x, y);
  case "AdamZuberSnake":
    return new AdamZuberSnake(x, y);
  case "AlanZhouSnake":
    return new AlanZhouSnake(x, y);
  case "AlanaLeeSnake":
    return new AlanaLeeSnake(x, y);
  case "AlexRosemannSnake":
    return new AlexRosemannSnake(x, y);
  case "AndrewHeitmeyersnake":
    return new AndrewHeitmeyersnake(x, y);
  case "AngelDuranGonzalezSnake":
    return new AngelDuranGonzalezSnake(x, y);
  case "AnnabelleKimSnake":
    return new AnnabelleKimSnake(x, y);
  case "ArielLagunasSnake":
    return new ArielLagunasSnake(x, y);
  case "AvaCarzolaSnake":
    return new AvaCarzolaSnake(x, y);
  case "BeccaYoungersSnake":
    return new BeccaYoungersSnake(x, y);
  case "CameronAllisonSnake":
    return new CameronAllisonSnake(x, y);
  case "CarlyMillsSnake":
    return new CarlyMillsSnake(x, y);
  case "CharisElkintonSnake":
    return new CharisElkintonSnake(x, y);
  case "ChelseaLeeSnake":
    return new ChelseaLeeSnake(x, y);
  case "ChiomaAguoruSnake":
    return new ChiomaAguoruSnake(x, y);
  case "ClaireHuangSnake":
    return new ClaireHuangSnake(x, y);
  case "CrystalNguyenSnake":
    return new CrystalNguyenSnake(x, y);
  case "DaeYparraguirreSnake":
    return new DaeYparraguirreSnake(x, y);
  case "DanielColcockSnake":
    return new DanielColcockSnake(x, y);
  case "DanielPortilloSnake":
    return new DanielPortilloSnake(x, y);
  case "DavidChienSnake":
    return new DavidChienSnake(x, y);
  case "ElizabethHanSnake":
    return new ElizabethHanSnake(x, y);
  case "ElvisLeeSnake":
    return new ElvisLeeSnake(x, y);
  case "EricMoczygembaSnake":
    return new EricMoczygembaSnake(x, y);
  case "EvaJimenezSnake":
    return new EvaJimenezSnake(x, y);
  case "FridaBalderas":
    return new FridaBalderasSnake(x, y);
  case "HaydenRossSnake":
    return new HaydenRossSnake(x, y);
  case "HoangMNguyenSnake":
    return new HoangMNguyenSnake(x, y);
  case "JeremyScheppersSnake":
    return new JeremyScheppersSnake(x, y);
  case "JialiJaddangiSnakee":
    return new JialiJaddangiSnakee(x, y);
  case "JocelynePartidaSnake":
    return new JocelynePartidaSnake(x, y);
  case "JosiahVillarrealFloresSnake":
    return new JosiahVillarrealFloresSnake(x, y);
  case "JovannaMolinaSnake":
    return new JovannaMolinaSnake(x, y);
  case "KalebAzizSnake":
    return new KalebAzizSnake(x, y);
  case "KayliePerezSnake":
    return new KayliePerezSnake(x, y);
  case "KeeganBeardSnake":
    return new KeeganBeardSnake(x, y);
  case "KeiraHumphriesSnake":
    return new KeiraHumphriesSnake(x, y);
  case "LanaNguyenSnake":
    return new LanaNguyenSnake(x, y);
  case "LaurenCogbillSnake":
    return new LaurenCogbillSnake(x, y);
  case "LillianCoan":
    return new LillianCoanSnake(x, y);
  case "LinhTranSnake":
    return new LinhTranSnake(x, y);
  case "MarcoHurtadoSnake":
    return new MarcoHurtadoSnake(x, y);
  case "MelikeKaraSnake":
    return new MelikeKaraSnake(x, y);
  case "NaomiVegaSnake":
    return new NaomiVegaSnake(x, y);
  case "NatalieSottekSnake":
    return new NatalieSottekSnake(x, y);
  case "NickMorrisSnake":
    return new NickMorrisSnake(x, y);
  case "NicoleCainSnake":
    return new NicoleCainSnake(x, y);
  case "NoahRutledgeSnake":
    return new NoahRutledgeSnake(x, y);
  case "OllieOtouBranckaertSnake":
    return new OllieOtouBranckaertSnake(x, y);
  case "RenBairdSnake":
    return new RenBairdSnake(x, y);
  case "RinNishiwakiSnake":
    return new RinNishiwakiSnake(x, y);
  case "RosalindaJoachimSnake":
    return new RosalindaJoachimSnake(x, y);
  case "SarahGruberSnake":
    return new SarahGruberSnake(x, y);
  case "SebastianNietoSnake":
    return new SebastianNietoSnake(x, y);
  case "SethEastmanSnake":
    return new SethEastmanSnake(x, y);
  case "SissiLaiSnake":
    return new SissiLaiSnake(x, y);
  case "SydneyKittelbergerSnake":
    return new SydneyKittelbergerSnake(x, y);
  case "TheodoreChauSnake":
    return new TheodoreChauSnake(x, y);
  case "TreTrevinoSnake":
    return new TreTrevinoSnake(x, y);
  case "WesleyKuykendallSnake":
    return new WesleyKuykendallSnake(x, y);
  case "YasminGarciaSnake":
    return new YasminGarciaSnake(x, y);
  case "ZahraMehdiSnake":
    return new ZahraMehdiSnake(x, y);
  case "BrandonWickenSnake":
    return new BrandonWickenSnake(x, y);
    //case "MichelleEstrellaSnake":
    //  return new MichelleEstrellaSnake(x, y);
  case "VanessaFloresSnake":
    return new VanessaFloresSnake(x, y);
  default:
    System.out.println("No matching Snake class for name: " + name);
    return null;
  }
}


final color[] ARCADE_COLORS = {
  color(45, 255, 204),
  color(102, 255, 51),
  color(0, 234, 127),
  color(204, 0, 255),
  color(255, 255, 68),
  color(0, 225, 183),
  color(0, 240, 117),
  color(255, 0, 127),
  color(54, 255, 219),
  color(255, 30, 255),
  color(153, 255, 30),
  color(102, 0, 238),
  color(255, 189, 0),
  color(0, 180, 255),
  color(255, 66, 219),
  color(0, 238, 104),
  color(192, 255, 0),
  color(225, 0, 90),
  color(76, 255, 204),
  color(234, 51, 255),
  color(127, 0, 255),
  color(255, 105, 255),
  color(255, 255, 45),
  color(68, 255, 255),
  color(255, 66, 108),
  color(117, 255, 72),
  color(255, 153, 72),
  color(102, 147, 255),
  color(240, 66, 255),
  color(66, 255, 165),
  color(255, 0, 132),
  color(0, 255, 174),
  color(255, 117, 0),
  color(219, 0, 255),
  color(0, 255, 0),
  color(255, 0, 255),
  color(0, 204, 249),
  color(255, 72, 0),
  color(153, 255, 63),
  color(90, 0, 255),
  color(255, 219, 0),
  color(0, 168, 255),
  color(255, 72, 186),
  color(0, 255, 111),
  color(204, 255, 9),
  color(255, 0, 111),
  color(33, 255, 198),
  color(204, 33, 255),
  color(132, 0, 255),
  color(255, 87, 255),
  color(246, 255, 51),
  color(63, 255, 234),
  color(255, 63, 144),
  color(138, 255, 51),
  color(255, 135, 51),
  color(108, 162, 255),
  color(255, 63, 234),
  color(63, 255, 147),
  color(255, 6, 135),
  color(9, 255, 186),
  color(255, 129, 21),
  color(213, 0, 255),
  color(0, 255, 15),
  color(246, 0, 255),
  color(0, 195, 255),
  color(255, 87, 6),
  color(162, 255, 78),
  color(111, 0, 255),
  color(255, 198, 0),
  color(0, 180, 240),
  color(255, 51, 192),
  color(0, 255, 138),
  color(186, 255, 0),
  color(255, 0, 96),
  color(57, 255, 213),
  color(192, 72, 255),
  color(144, 0, 255),
  color(255, 99, 255),
  color(255, 246, 51),
  color(78, 255, 255),
  color(255, 87, 120),
  color(123, 255, 69),
  color(255, 165, 57),
  color(117, 138, 255),
  color(231, 60, 255),
  color(66, 255, 174),
  color(255, 0, 144),
  color(0, 255, 165),
  color(255, 120, 42),
  color(198, 0, 255),
  color(0, 255, 6),
  color(255, 0, 240),
  color(0, 213, 255),
  color(255, 69, 18),
  color(147, 255, 60),
  color(84, 0, 255),
  color(255, 213, 18),
  color(0, 159, 255),
  color(255, 66, 198),
  color(0, 255, 120),
  color(213, 255, 15),
  color(255, 0, 123),
  color(48, 255, 198),
  color(213, 60, 255),
  color(138, 0, 255),
  color(255, 111, 255),
  color(255, 255, 78),
  color(51, 255, 255),
  color(255, 51, 102),
  color(102, 255, 51),
  color(255, 153, 51),
  color(102, 153, 255),
  color(255, 51, 255),
  color(51, 255, 153)
};
