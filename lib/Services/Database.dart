import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class databaseService{

  Future addTask(Map<String, dynamic> taskinfo, String id) async{

    return await FirebaseFirestore.instance
        .collection("Task")
        .doc(id)
        .set(taskinfo).then((value){
      print('==============================================savedddddddddddddddddddd==========================================================');
      // print(value.toString());
    }).catchError((err){
          print('==============================================errorrrrrrrrrrr==========================================================');
          print(err);
    });

  }

  Future<Stream<QuerySnapshot>> getTask() async{

    FirebaseFirestore db = FirebaseFirestore.instance;

    return await db.collection("Task").snapshots();

  }

  Future EditTask(String id, String task, String title) async{

    return await FirebaseFirestore.instance.collection('Task').doc(id).update({
      "title":title,
      'work': task,
    }).catchError((onError){
      print(onError);
    });

  }

  Future markcompleteTask(String id) async{

    return await FirebaseFirestore.instance.collection('Task').doc(id).update({
      'isCompleted': true,
    }).catchError((onError){
      print(onError);
    });

  }

  Future DeleteTask(String id) async{

    return await FirebaseFirestore.instance.collection('Task').doc(id).delete();

  }

}