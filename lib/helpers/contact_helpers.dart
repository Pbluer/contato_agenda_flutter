import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:async/async.dart';

const String contactTable = "contactTable";
const String idColumn = 'idColumn';
const String nameColumn = 'nameColumn';
const String emailColumn = 'emailColumn';
const String phoneColumn = 'phoneColumn';
const String imgColumn = 'imgColumn';

class ContactHelpers{

  static final ContactHelpers _instanc = ContactHelpers.internal();

  factory ContactHelpers() => _instanc;

  ContactHelpers.internal();

  Database _db;

  Future<Database>get db async{
    if(  _db != null){
      return _db;
    }else{
      _db = await initDb();

      return _db;
    }
  }

  // Cria o banco de dados
  Future<Database> initDb() async {
    final databasesPath = await getDatabasesPath();
    final path = join( databasesPath, 'contact.db' );
    
    return await openDatabase(path,version: 1, onCreate: ( Database db,int newerVersion ) async{
      await db.execute(
        "CREATE TABLE $contactTable($idColumn INT PRIMARY KEY, $nameColumn TEXT, $emailColumn TEXT, $phoneColumn TEXT, $imgColumn TEXT)"
      );
    });
  }

  Future<Contact> saveContact(Contact contact )async {
    Database dbContact = await db;
    contact.id = await dbContact.insert(contactTable, contact.toMap());
    return contact;
  }

  Future<Contact?> getContact(int id) async {
    Database dbContact = await db;
    List<Map> maps = await dbContact.query(contactTable,
    columns: [idColumn,nameColumn,emailColumn,phoneColumn,imgColumn],
    where: "$idColumn = ?",
    whereArgs: [id]);

    if( maps.length > 0 ){
      return Contact.fromMap(maps.first);
    }else{
      return null;
    }
  }

  Future<int> deleteContact(int id) async{
    Database dbContact = await db;

    return await dbContact.delete(contactTable,
      where: "$idColumn = ?",
      whereArgs: [id]
    );
  }

  Future<int> updateContact(Contact contact) async{
    Database dbContact = await db;

    return await dbContact.update(contactTable,contact.toMap(),
      where: "$idColumn = ?",
      whereArgs: [contact.id]
    );
  }

  Future<List<Contact>> getAllContacts() async {
    Database? dbContact = await db;
    List listMap = await dbContact.rawQuery("SELECT * FROM $contactTable");
    List<Contact> listContact = [];
    for (Map m in listMap) {
      listContact.add(Contact.fromMap(m));
    }
    return listContact;
  }

  Future<int?> getNumber() async {
    Database? dbContact = await db;
    return Sqflite.firstIntValue(
        await dbContact.rawQuery("SELECT COUNT(*) FROM $contactTable"));
  }

  Future close() async {
    Database? dbContact = await db;
    dbContact.close();
  }
}

class Contact{

  late int id;
  late String name;
  late String email;
  late String phone;
  late String img;

  Contact.fromMap(Map map){
    id = map[idColumn];
    name = map[nameColumn];
    email = map[emailColumn];
    phone = map[phoneColumn];
    img = map[imgColumn];
  }

  Map<String,dynamic> toMap(){
    Map<String,dynamic> map = {
      nameColumn: name,
      emailColumn: email,
      phoneColumn: phone,
      imgColumn: img
    };

    if( id != null ){
      map[idColumn] = id;
    }

    return map;
  }

  @override
  String toString() {
    // TODO: implement toString
    return 'Contact( id:$id, name:$name, email:$email, phone:$phone, img:$img)';
  }

}