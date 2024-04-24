import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:meji/Screens/AddTask.dart';
import 'package:meji/Services/Database.dart';



class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  FirebaseFirestore db = FirebaseFirestore.instance;
  Stream? todotask;


  getdata() async{
    todotask = await databaseService().getTask();
    setState(() {});
  }

  @override
  void initState() {
   getdata();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        leading: const Icon(null),
        title: StreamBuilder(
          stream: todotask,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Todoey',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                    ),),
                  Text(
                    '${snapshot.data.docs.length} Tasks',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                    ),
                  ),
                ],
              );
            } else {
              return Text('');
            }
          },
        ),
      ),
      body: StreamBuilder(
        stream: todotask,
        builder: (context, AsyncSnapshot snapshot){
          return snapshot.hasData && snapshot.data.docs.length != 0?
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
            child:  ListView.builder(
              itemBuilder: (context, index) {
                DocumentSnapshot task = snapshot.data.docs[index];
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20.0),
                      topRight: Radius.circular(20.0),
                    ),
                    border: Border.all(color: Colors.black)
                  ),
                  child: ListTile(
                    leading: task["isCompleted"] == true ? Icon(Icons.done_all, color: Colors.green,):Icon(Icons.remove_circle, color: Colors.red.shade200,),
                    title: Text(
                      task["title"],
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                      ),),
                    subtitle: Text(
                      task["work"],
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),),
                    trailing: Container(
                      width: 140,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          InkWell(
                            onTap: () async{
                              await Navigator.push(context, MaterialPageRoute(builder: (context) =>
                                  AddTaskScreen(id: task["id"], method: 'save', task: task["work"], title: task["title"],)));

                            },
                            child: const Icon(Icons.edit, color: Colors.blue,),
                          ),
                          const SizedBox(width: 30,),
                          InkWell(
                            onTap: () {
                                databaseService().DeleteTask(task['id']);
                                // tasklength = snapshot.data.docs.length;
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                                  content: Text("${task["title"]}Task Deleted", style: TextStyle(color: Colors.black)),
                                ));

                            },
                            child: const Icon(Icons.delete_forever, color: Colors.red,),
                          ),
                          SizedBox(width: task["isCompleted"] == true ? 0:30,),
                          task["isCompleted"] == true ? Container() : InkWell(
                            onTap: (){
                              setState(() {
                                databaseService().markcompleteTask(task['id']);
                              });
                            },
                            child: const Icon(Icons.mark_chat_read_outlined, color: Colors.teal,),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
              itemCount: snapshot.data.docs.length,
            ),
          ) :
              const Center(
                child: Text(
                  'No Task Added',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                  ),
                ),
              );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => AddTaskScreen(id: '', method: 'new', task: '', title: '',)));
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}



