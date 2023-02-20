import 'dart:async';
import 'dart:io';
import 'package:management/src/model/item_model.dart';
import 'package:management/src/model/history_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static const _databaseName = "Database.db"; // DB名
  static const _databaseVersion = 1; // スキーマのバージョン

  // 各テーブル名
  static const taskTable = "task_table"; // Taskリスト
  static const rewardTable = "reward_table"; // Rewardリスト
  static const historyTable = "history_table"; // Historyリスト

  // カラム名
  static const columnId = "id"; // ID
  static const columnName = "name"; // Name
  static const columnPoint = "point"; // Point
  static const columnColor = "color"; // Color
  static const columnSort = "sort"; // Order
  static const columnModel = "model"; // Model
  static const columnDate = "date"; // Date

  // クラス定義
  DatabaseHelper._privateConstructor(); // 生成されたインスタンスを返す
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // Databaseクラス型のstatic変数を定義
  static Database? _database;

  // databaseメソッド定義
  // 初回参照時のみデータベースを初期化
  Future<Database?> get database async {
    if (_database != null) {
      return _database;
    }
    _database = await _initDatabase();
    return _database;
  }

  // データベース接続
  _initDatabase() async {
    // ドキュメントディレクトリのパスを取得
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    // 取得したパスからデータベースのパスを生成
    String path = join(documentsDirectory.path, _databaseName);
    // データベース接続
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  // テーブル作成
  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $taskTable (
        $columnId INTEGER PRIMARY KEY,
        $columnName TEXT NOT NULL,
        $columnPoint INTEGER,
        $columnColor INTEGER NOT NULL,
        $columnSort INTEGER NOT NULL
      )
      ''');
    await db.execute('''
      CREATE TABLE $rewardTable (
        $columnId INTEGER PRIMARY KEY,
        $columnName TEXT NOT NULL,
        $columnPoint INTEGER,
        $columnColor INTEGER NOT NULL,
        $columnSort INTEGER NOT NULL 
      )
      ''');
    await db.execute('''
      CREATE TABLE $historyTable (
        $columnId INTEGER PRIMARY KEY,
        $columnName TEXT NOT NULL,
        $columnPoint INTEGER,
        $columnColor INTEGER NOT NULL,
        $columnModel TEXT NOT NULL,
        $columnDate TEXT NOT NULL
      )
      ''');
  }

  // データ登録
  // Taskテーブル
  Future insertTask(Item task) async {
    Database? db = await instance.database;
    db!.insert(taskTable, task.toMap());
  }

  // Rewardテーブル
  Future insertReward(Item reward) async {
    Database? db = await instance.database;
    db!.insert(rewardTable, reward.toMap());
  }

  // Historyテーブル
  Future insertHistory(History history) async {
    Database? db = await instance.database;
    db!.insert(historyTable, history.toMap());
  }

  // データ取得
  // Taskテーブル
  Future<List<Item>> getTask() async {
    Database? db = await instance.database;
    final List<Map<String, dynamic>> maps = await db!.query(taskTable);
    // Map型からItem型に変換してListに追加
    return maps.map((json) => Item.fromMap(json)).toList();
  }

  // Rewardテーブル
  Future<List<Item>> getReward() async {
    Database? db = await instance.database;
    final List<Map<String, dynamic>> maps = await db!.query(rewardTable);
    // Map型からItem型に変換してListに追加
    return maps.map((json) => Item.fromMap(json)).toList();
  }

  // Historyテーブル
  Future<List<History>> getHistory() async {
    Database? db = await instance.database;
    final List<Map<String, dynamic>> maps = await db!.query(historyTable);
    // Map型からItem型に変換してListに追加
    return maps.map((json) => History.fromMap(json)).toList();
  }

  // データ更新
  // Taskテーブル
  Future updateTask(Item task) async {
    Database? db = await instance.database;
    await db!
        .update(taskTable, task.toMap(), where: "id = ?", whereArgs: [task.id]);
  }

  // Rewardテーブル
  Future updateReward(Item reward) async {
    Database? db = await instance.database;
    await db!.update(rewardTable, reward.toMap(),
        where: "id = ?", whereArgs: [reward.id]);
  }

  // データ削除
  // Taskテーブル
  Future deleteTask(int id) async {
    Database? db = await instance.database;
    await db!.delete(taskTable, where: "id = ?", whereArgs: [id]);
  }

  // Rewardテーブル
  Future deleteReward(int id) async {
    Database? db = await instance.database;
    await db!.delete(rewardTable, where: "id = ?", whereArgs: [id]);
  }

  // テーブルリセット
  // Historyテーブル
  Future resetHistory() async {
    Database? db = await instance.database;
    await db!.delete(historyTable);
  }
}
