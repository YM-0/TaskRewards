class Item {
  late int id;
  late String name;
  late int point;
  late int color;
  late String model; // taskの場合 : "Task" , rewardの場合 : "Reward"

  Item(this.id, this.name, this.point, this.color, this.model);

  // ItemモデルをMapに変換する（保存時に使用）
  Map toJson() {
    return {
      "id": id,
      "name": name,
      "point": point,
      "color": color,
      "model": model
    };
  }

  // MapをItemモデルに変換する（読み込み時に使用）
  Item.fromJson(Map json) {
    id = json["id"];
    name = json["name"];
    point = json["point"];
    color = json["color"];
    model = json["model"];
  }
}
