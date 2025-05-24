class Datamodel {
  String? date;
  String? cashIn;
  String? cashout;
  String? day;
  String time;
  String? uid;
  Datamodel({
    this.uid,
    required this.cashIn, required this.cashout, required this.date,required this.day,required this.time});
  factory Datamodel.fromFireBase(Map<String, dynamic> docs) {
    return Datamodel(
      day: docs['day'],
      time: docs['time'],
        cashIn: docs['cashin'], cashout: docs['cashout'], date: docs['date']);
  }
  Map<String,dynamic> toJson(){
    return {
      'date':date,
      'time':time,
      'day':day,
      'cashout':cashout,
      'cashin':cashIn,
      'userId':uid,
    };
  }
}
