
import 'package:flutter/material.dart';
import 'package:sqlhelper/api/todo_provider.dart';
import 'package:sqlhelper/database/databaseProvider.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {




  
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

   List<Map<String, dynamic>> _journals = [];
  var isLoading = false;
  _loadFromApi() async {
    setState(() {
      isLoading = true;
    });

    // var apiProvider = TodoApi();
    // await apiProvider.createAllapi();
    final _journals = TodoApi().createAllapi();
    print(_journals);

    // wait for 2 seconds to simulate loading of data
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      isLoading = false;
    });
  }
 

  @override
  void initState() {
    super.initState();
    
    _loadFromApi();
    _refreshJournals();
    print(_loadFromApi);
    print(_refreshJournals);
     // Loading the diary when the app starts
  }

//final _journals = Dbprovider.instance.getAllTodo();
void _refreshJournals() async{
 // final data = await Dbprovider.instance.getAllTodo();
    setState(() {
      _journals;
      print(_journals);
    });
  }
 
  // _deleteData() async {
  //   setState(() {
  //     isLoading = true;
  //   });

  //   await Dbprovider.instance.deleteAllTodo();

  //   // wait for 1 second to simulate loading of data
  //   await Future.delayed(const Duration(seconds: 1));

  //   setState(() {
  //     isLoading = true;
  //   });

  //   print('All employees deleted');
  // }
  // This function will be triggered when the floating button is pressed
  // It will also be triggered when you want to update an item

  void _showForm(int? id) async {
    if (id != null) {
      // id == null -> create new item
      //id != null -> update an existing item
   final existingJournal =
       _journals.firstWhere((element) => element['id'] == id);
      _titleController.text = existingJournal['title'];
      _descriptionController.text = existingJournal['description'];
    }

    showModalBottomSheet(
        context: context,
        elevation: 5,
        isScrollControlled: true,
        builder: (_) => Container(
              padding: EdgeInsets.only(
                top: 15,
                left: 15,
                right: 15,
                // this will prevent the soft keyboard from covering the text fields
                bottom: MediaQuery.of(context).viewInsets.bottom + 120,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  TextField(
                    controller: _titleController,
                    decoration: const InputDecoration(hintText: 'Title'),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(hintText: 'Description'),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      //Save new journal
                      // if (id == null) {
                      //   await _addItem();
                      // }

                      // if (id != null) {
                      //   await _updateItem(id);
                      // }

                      // Clear the text fields
                      _titleController.text = '';
                      _descriptionController.text = '';

                      // Close the bottom sheet
                      Navigator.of(context).pop();
                    },
                    child: Text(id == null ? 'Create New' : 'Update'),
                  )
                ],
              ),
            ));
  }
  
// Insert a new journal to the database
  // Future<void> _addItem() async {
  //   await Dbprovider.instance.createTodo(_titleController.text, _descriptionController.text);
  //   _refreshJournals();
  // }

  // Update an existing journal
  // Future<void> _updateItem(int id) async {
  //   await Dbprovider.instance.updated(
  //       id, _titleController.text, _descriptionController.text);
  //   _refreshJournals();
  // }


// // Delete an item
  // void _deleteItem(int id) async {
  //   await Dbprovider.instance.deleteAllTodo();
  //   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
  //     content: Text('Successfully deleted a journal!'),
  //   ));
  //   _refreshJournals();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CawaaleICT.com'),
      ),
     
       body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
              
            )
          : _buildTodoListView(),
    
    floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        //  onPressed: (){},
          onPressed: () => _showForm(null),
      )
      );
  }
    _buildTodoListView(){
      return FutureBuilder(
           // future: Dbprovider.instance.getAllTodo(),
           future: _loadFromApi(),
            builder: (BuildContext context, AsyncSnapshot snapshot){
              if(!snapshot.hasData){
                return Center(
                  child:  CircularProgressIndicator(
              semanticsLabel: 'Circular progress indicator',
            ),
                );
              }
              else{
                return ListView.separated(
                   separatorBuilder: (context, index) => Divider(
                      color: Colors.black12,
                    ), 
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index){
                    return ListTile(
                    title: Text("${snapshot.data[index].title}"),
                    subtitle: Text('${snapshot.data[index].description}'),
                    trailing: SizedBox(
                      width: 150,
                      child: Row(
                        children: [
                         "${snapshot.data[index].title}" != '' ? 
                          IconButton(
                            icon: const Icon(Icons.check_box),
                            onPressed: () {}
                          ): Text(""),
                          // IconButton(onPressed: () =>_loadFromApi(), icon: Icon(Icons.edit),),
                          // IconButton(
                          //   icon: const Icon(Icons.delete),
                          //   onPressed: () =>
                          //       _deleteItem(snapshot.data[index]['id']),
                          // ),
                        ],
                      ),
                    ));
                  }, 
                 );
              }
            },
       );
    }
  }

