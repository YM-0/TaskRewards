class History {
  late int id;
  late String name;
  late int point;
  late int color;
  late String model; // taskの場合 : "Task" , rewardの場合 : "Reward"
  late String date;

  History(this.id, this.name, this.point, this.color, this.model, this.date);

  // HistoryモデルをMapに変換する（保存時に使用）
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "point": point,
      "color": color,
      "model": model,
      "date": date
    };
  }

  // MapをHistoryモデルに変換する（読み込み時に使用）
  History.fromMap(Map json) {
    id = json["id"];
    name = json["name"];
    point = json["point"];
    color = json["color"];
    model = json["model"];
    date = json["date"];
  }
}
