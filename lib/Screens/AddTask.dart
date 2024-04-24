import 'package:flutter/material.dart';
import 'package:meji/Screens/Homepage.dart';
import 'package:random_string/random_string.dart';
import '../Services/Database.dart';



class AddTaskScreen extends StatefulWidget {
  final String id;
  final String method;
  final String task;
  final String title;

  AddTaskScreen({super.key, required this.id, required this.method, required this.task, required this.title});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  TextEditingController title = TextEditingController();
  TextEditingController task = TextEditingController();

  final GlobalKey<FormState> _form = GlobalKey<FormState>();

  @override
  void initState() {
    title.text = widget.task;
    task.text = widget.title;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Add Task'),
        leading: InkWell(
          onTap: (){
            Navigator.pop(context);
          },
          child: const Icon(Icons.arrow_back_ios),
        ),
      ),
      body: Center(
        child: Form(
          key: _form,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.only(top: 30.0, bottom: 16, right: 16, left: 16),
                child: Text(
                  'Title',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TextFormField(
                  controller: title,
                  decoration: InputDecoration(
                    hintText: 'Enter Task Title',
                    hintStyle: TextStyle(
                      color: Colors.grey
                    ),
                    border: OutlineInputBorder(),
                  ),
                  validator: (val){
                    if(val!.isEmpty){
                      return 'Required';
                    }
                  },
                  onChanged: (value){
                    setState(() {
                      title.text = value;
                    });
                  },
                ),
              ),

              const Padding(
                padding: EdgeInsets.only(top: 30.0, bottom: 16, right: 16, left: 16),
                child: Text(
                  'Description',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TextFormField(
                  controller: task,
                  decoration: InputDecoration(
                    hintText: 'Enter Task Description',
                    hintStyle: TextStyle(
                      color: Colors.grey
                    ),
                    border: OutlineInputBorder(),
                  ),
                  validator: (val){
                    if(val!.isEmpty){
                      return 'Required';
                    }
                  },
                  onChanged: (value){
                    setState(() {
                      task.text = value;
                    });
                  },
                ),
              ),

              widget.method == 'save' ?
              InkWell(
                onTap: () {

                    databaseService().EditTask(widget.id, task.text, title.text);

                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                      content: const Text("Task Edited", style: TextStyle(color: Colors.black),),
                    ));

                    Navigator.pop(context);
                },
                child: Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    border: Border.all(color: Colors.green, ),
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    'Save',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.white
                    ),
                  ),
                ),
              ) : Container(),

              widget.method == 'new' ?
              InkWell(
                onTap: (){
                  if (!_form.currentState!.validate()) {
                    return;
                  }

                  _form.currentState!.save();
                  setState(() {
                    String id = randomAlphaNumeric(10);
                    Map<String,dynamic> taskinfo={
                      "title":title.text,
                      "work":task.text,
                      "id":id,
                      "isCompleted": false
                    };
                    databaseService().addTask(taskinfo, id);

                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                      content: const Text("Task Added", style: TextStyle(color: Colors.black)),
                    ));

                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MyHomePage()));
                  });
                },
                child: Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    border: Border.all(color: Colors.green, ),
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    'Add',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.white
                    ),
                  ),
                ),
              ) : Container(),
            ],
          ),
        ),
      ),
    );
  }
}



