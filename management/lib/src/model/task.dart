class Task {
  late int id;
  late String name;
  late int point;
  late int color;

  Task(this.id, this.name, this.point, this.color);

  // TaskモデルをMapに変換する（保存時に使用）
  Map toJson() {
    return {"id": id, "name": name, "point": point, "color": color};
  }

  // MapをTaskモデルに変換する（読み込み時に使用）
  Task.fromJson(Map json) {
    id = json["id"];
    name = json["name"];
    point = json["point"];
    color = json["color"];
  }
}
