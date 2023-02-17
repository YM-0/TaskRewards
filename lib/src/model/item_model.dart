class Item {
  late int id;
  late String name;
  late int point;
  late int color;
  late int sort;

  Item(this.id, this.name, this.point, this.color, this.sort);

  // ItemモデルをMapに変換する（保存時に使用）
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "point": point,
      "color": color,
      "sort": sort,
    };
  }

  // MapをItemモデルに変換する（読み込み時に使用）
  Item.fromMap(Map json) {
    id = json["id"];
    name = json["name"];
    point = json["point"];
    color = json["color"];
    sort = json["sort"];
  }
}
