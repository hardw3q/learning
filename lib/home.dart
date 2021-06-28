import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'dart:html';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);
  @override
  _HomeState createState() => _HomeState();
}

void initFirebase() async{
 WidgetsFlutterBinding.ensureInitialized();
 await Firebase.initializeApp();
}
class _HomeState extends State<Home> {
  List list = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initFirebase();
    //list.addAll(['m', 'f', 'f']);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text('Приложение список'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('list').snapshots(),
        builder: (BuildContext context, AsyncSnapshot <QuerySnapshot> snapshot){
          if(!snapshot.hasData) return Text('Ты мудила');
          return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (BuildContext context, int index){
                return Dismissible(key: Key(snapshot.data!.docs[index].id),
                  child: Card(
                      child: ListTile(title: Text(snapshot.data!.docs[index].get('item')))
                  ),
                  onDismissed: (direction){
                    setState(() {
                      FirebaseFirestore.instance.collection('list').doc(snapshot.data!.docs[index].id).delete();
                    });
                  },
                );
              }
          );
        },
      ),
      floatingActionButton: new FloatingActionButton(onPressed: (){
        var userToDo;
       showDialog(context: context, builder: (BuildContext context){
         return AlertDialog(
             title: Text('Добавить элемент'),
         actions: [ElevatedButton(onPressed: (){
           FirebaseFirestore.instance.collection('list').add({'item':userToDo});
           Navigator.of(context).pop();
         },
         child: Text('Добавить'))],
         content: TextField(
              onChanged: (String value){
                userToDo = value;
              },
         )
         );
       });

      },
        child: Icon(Icons.add),
      ),
    );
  }
}
