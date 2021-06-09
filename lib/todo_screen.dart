import 'package:flutter/material.dart';
import 'package:flutter_app/loading.dart';
import 'package:flutter_app/models/todo.dart';
import 'package:flutter_app/services/database_services.dart';

class ToDoMainScreen extends StatefulWidget {
  @override
  _ToDoMainScreenState createState() => _ToDoMainScreenState();
}

class _ToDoMainScreenState extends State<ToDoMainScreen> {
  bool isComplet = false;
  TextEditingController todoTitleController= TextEditingController();
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: SafeArea(
        child: StreamBuilder<List<Todo>>(
          stream: DatabaseService().listTodos(),
          builder: (context, snapshot) {
            if(!snapshot.hasData){
              return Loading();
            }
           List<Todo> todos=snapshot.data;
            return Padding(
              padding: EdgeInsets.all(35),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'MY TODO LIST',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,fontWeight: FontWeight.bold
                    ),
                  ),
                  Divider(),
                  SizedBox(height: 40,),
                  ListView.separated(
                    separatorBuilder: (context,index)=>Divider(color: Colors.yellow[800],),
                    shrinkWrap: true,
                    itemCount: todos.length,
                    itemBuilder: (context,index){
                      return Dismissible(
                        key: Key(todos[index].title),
                        background: Container(padding: EdgeInsets.only(left: 20),alignment: Alignment.centerLeft,child: Icon(Icons.delete),color: Colors.redAccent,),
                        onDismissed:(direction) async{
                          await DatabaseService().removeTodo(todos[index].uid);
                        },
                        child: ListTile(
                          onTap:(){
DatabaseService().completTask(todos[index].uid);
                          },
                          leading: Container(
                            padding: EdgeInsets.all(2),
                            height: 30,
                            width: 30,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle
                            ),
                            child:todos[index].isComplet? Icon(Icons.check_box,color: Colors.blue,
                            ):Container(

                            ),
                          ),
                          title: Text(
                            todos[index].title,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      );
                    },
                  )
                ],
              ),
            );
          }
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(

        child: Icon(Icons.add),
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {

              // return object of type Dialog
              return SimpleDialog(
                contentPadding: EdgeInsets.symmetric(horizontal: 20,vertical: 30),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                title: Row(
                  children: [
                    Text(
                      "ADD TODO",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                      ),
                    ),

                    Spacer(),
                    IconButton(
                      icon: Icon(
                        Icons.cancel,
                        color: Colors.grey,
                        size: 30,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),

                  ],
                ),
                children: [
                  Divider(),
                  TextFormField(
                    controller: todoTitleController,
                    autofocus: true,
                    decoration: InputDecoration(

                        hintText: "Add a Task"
                    ),
                    style: TextStyle(
                        letterSpacing: 1,
                        fontStyle: FontStyle.italic
                    ),
                  ),
                  SizedBox(height: 30,),
                  SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 40,
                      child:FlatButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                            'ADD'
                        ),
                        color: Colors.green,
                        textColor: Colors.black,
                        onPressed: () async {
                          if(todoTitleController.text.isNotEmpty){
                           await DatabaseService().createNewTodo(todoTitleController.text.trim());
                            Navigator.pop(context);
                          }
                        },
                      )


                  )
                ],


              );
            },


            // onPressed: (){
            //   SimpleDialog(
            //     title: Row(
            //       children: [
            //         Text('add Todo'),
            //         Spacer(),
            //         IconButton(
            //             icon: Icon(
            //                 Icons.cancel),
            //             color: Colors.grey,
            //             onPressed: (){},
            //         )





          );},
      ),
    );
  }
  }





