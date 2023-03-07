import 'package:mongo_dart/mongo_dart.dart';
import '../conn/constant.dart';

Future<List> irtFetch() async {
  final db = await Db.create(MONGO_URL);
  await db.open();

  final collection = db.collection(COLLECTION_NAME);
  final data = await collection.find().toList();

  await db.close();
  
  return data;
}