
class CalculateFactoryUtils {
 
  static double getAveragePace(List<int> paceRecord,int startIndex,int endIndex) {
  int rs=0;
    for(var i=startIndex;i<=endIndex;i++){
      rs=rs+paceRecord[i];
    }
    return (rs/(endIndex-startIndex+1));
  }
    static double getAverageElevation(List<double>? elevaRecord,int? startIndex,int? endIndex) {
  double rs=0;
    for(var i=startIndex;i!<=endIndex!;i++){
      rs=rs+elevaRecord![i];
    }
     return (rs/(endIndex-startIndex!+1));
  }
    int convertTimeStrToSecond(String time) {
    var splited = time.split(':');
    int hour = int.parse(splited[0]);
    int minute = int.parse(splited[1]) + hour * 60;
    int second = int.parse(splited[2]);

    int rs=hour*60*60+minute*60+second;
   
    return rs;
  }
 
}
