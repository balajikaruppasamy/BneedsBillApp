import 'package:bneedsbillappnew/Utility/Logger.dart';

class CommonVariables {
  static List<String> dataList = [];
  static List<String> addnewgsm = [];
  static String? Previouspage;
  static String? CompanyName;

  static int? BNO;
  static int? BILLNO;
}

class CommonPrintVariables {
  static List<Map<String, dynamic>> SalesData = [];
  static String printCommand = "";

  static String calculatedrimkg = "";
  static String Barcode = "";
  static String Name = "";
  static String Width = "";
  static String Weight = "";
  static String Height = "";
  static String printPreviousPage = "";
  static String RIMNO = "";
  static String REROLLNO = "";
  static String GSM = "";
  static String BOARD = "";
  static String SHEETHT = "";
  static String SHEETWT = "";
  static String REEM = "";
  static String QUALITY = "";
  static String Bandleno = "";
  static String MINICUTTER = "";
  static String BUNDLEKG = "";
  //----------------------------

  static String TOTALREWIND = "";
  static String TOTALBUNDLE = "";
  static String LORRYNO = "";
  static String LORRYWT = "";
  static String SALESDATE = "";

  static String jumboEnds() {
    String width = CommonVariables.dataList[0];
    String weight = CommonVariables.dataList[1];
    String rollno = CommonVariables.dataList[2];
    String gsm = CommonVariables.dataList[7];
    String board = CommonVariables.dataList[8];
    CommonVariables.Previouspage = "JamboEnds";
    print("Generating print commands for jumboEnds...");

    String commands = """
    I8,A
    q799
    O
    JF
    ZT
    Q480,25
    N
    b443,116,Q,m2,s15,eL,"$rollno"
    A758,69,2,2,2,2,N,"$rollno"
    A398,423,2,2,2,2,N,"JUMBO"
    A398,359,2,2,2,2,N,"$gsm"
    A398,297,2,2,2,2,N,"$board"
    A398,233,2,2,2,2,N,"$width"
    A398,172,2,2,2,2,N,"$weight"
    P1


  """;

    commonUtils.log.i('++++++printer $commands');
    return commands;
  }

/*  static String Reprint() {
    CommonVariables.Previouspage = "Reprint";
    print("Generating print commands for RimEnds...");

    String boardAndGSM = "$GSM";
    if (BOARD.isNotEmpty) {
      boardAndGSM += " / $BOARD";
    }

    String widthAndHeight = "$Width";
    if (Height.isNotEmpty) {
      widthAndHeight += " / $Height";
    }

    String commands = """
               I8,A
    q799
    O
    JF
    ZT
    Q480,25
    N
    b443,116,Q,m2,s15,eL,"$Barcode"
    A758,69,2,2,2,2,N,"$Barcode"
    A398,423,2,2,2,2,N,"$Name"
    A398,359,2,2,2,2,N,"$boardAndGSM"
    A398,297,2,2,2,2,N,"$widthAndHeight"
    A398,233,2,2,2,2,N,"$Weight"
    A398,172,2,2,2,2,N,""
    A398,111,2,2,2,2,N,""
    P1
        """;
    commonUtils.log.i('++++++printer $commands');
    return commands;
  }*/

  static void printCheck(String option) {
    if (option == "jumboEnds") {
      printCommand = jumboEnds();
    }
  }
}
