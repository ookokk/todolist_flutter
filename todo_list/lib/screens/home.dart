import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_list/constants/colors.dart';
import 'package:todo_list/widgets/todo_item.dart';
import 'package:todo_list/model/todo.dart';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final todosList = ToDo.todoList();
  List<ToDo> _foundToDo = [];
  final _todoController = TextEditingController();

  @override
  void initState() {
    _foundToDo = todosList;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tdBGColor,
      appBar: _buildAppBar(),
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            child: Column(
              children: [
                searchBox(),
                Expanded(
                  child: ListView(
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 20),
                        child: Text(
                          'To Do List',
                          style: GoogleFonts.lato(
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.w400,
                              fontSize: 30),
                        ),
                      ),
                      for (ToDo todo in _foundToDo.reversed)
                        ToDoItem(
                          todo: todo,
                          onToDoChanged: _handleToDoChange,
                          onDeleteItem: _deleteToDoItem,
                        ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          width: 100,
                          height: 40,
                          margin:
                              EdgeInsets.only(bottom: 20, left: 20, right: 20),
                          padding:
                              EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.white70,
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.grey,
                                offset: Offset(0.0, 0.0),
                                blurRadius: 10.0,
                                spreadRadius: 0.0,
                              ),
                            ],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: TextField(
                            controller: _todoController,
                            decoration: InputDecoration(
                                hintText: 'Add a new todo item',
                                suffixStyle: GoogleFonts.lato(
                                    fontStyle: FontStyle.italic),
                                border: InputBorder.none),
                          ),
                        ),
                      ),
                      Container(
                        height: 50,
                        margin: EdgeInsets.only(bottom: 20, right: 20),
                        child: ElevatedButton(
                          onPressed: () {
                            _addToDoItem(_todoController.text);
                          },
                          style: ElevatedButton.styleFrom(
                            shape: CircleBorder(),
                            backgroundColor: tdBlue,
                            minimumSize: Size(50, 50),
                            elevation: 10,
                          ),
                          child: Text(
                            '+',
                            style: TextStyle(
                              fontSize: 40,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _handleToDoChange(ToDo todo) {
    setState(() {
      todo.isDone = !todo.isDone;
    });
  }

  void _deleteToDoItem(String id) {
    setState(() {
      todosList.removeWhere((item) => item.id == id);
    });
  }

  void _addToDoItem(String toDo) {
    setState(() {
      todosList.add(ToDo(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          todoText: toDo));
    });
    _todoController.clear();
  }

  void _runFilter(String enteredKeyword) {
    List<ToDo> results = [];
    if (enteredKeyword.isEmpty) {
      results = todosList;
    } else {
      results = todosList
          .where((item) => item.todoText!
              .toLowerCase()
              .contains(enteredKeyword.toLowerCase()))
          .toList();
    }
    setState(() {
      _foundToDo = results;
    });
  }

  Widget searchBox() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.black12,
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: TextField(
        onChanged: (value) => _runFilter(value),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(0),
          prefixIcon: Icon(
            Icons.search_sharp,
            color: tdBlack,
            size: 20,
          ),
          prefixIconConstraints: BoxConstraints(maxHeight: 20, minWidth: 25),
          border: InputBorder.none,
          hintText: 'Search',
          hintStyle: GoogleFonts.lato(fontStyle: FontStyle.italic),
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: tdBGColor,
      elevation: 0,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
            ),
            onPressed: () {
              setState(() {});
            },
            child: Icon(
              Icons.refresh,
              color: Colors.white70,
              size: 30,
            ),
          ),
          Container(
            decoration: BoxDecoration(color: tdBlue, shape: BoxShape.circle),
            height: 50,
            width: 50,
            child: ClipOval(
              child: Image.asset(
                'assets/images/avatar.jpg',
              ),
            ),
          )
        ],
      ),
    );
  }
}
