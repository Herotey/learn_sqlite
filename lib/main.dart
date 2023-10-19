import 'package:flutter/material.dart';
import 'package:sqlite_learn/dataBase.dart';
import 'package:sqlite_learn/item_card.dart';
import 'package:sqlite_learn/model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        floatingActionButtonTheme:
            FloatingActionButtonThemeData(backgroundColor: Colors.blue),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  DbManager dbManager = new DbManager();

  late Model model;
  late List<Model> modelList;
  TextEditingController input1 = TextEditingController();
  TextEditingController input2 = TextEditingController();
  late FocusNode input1FocusNode;
  late FocusNode input2FocusNode;

  @override
  void initState() {
    input1FocusNode = FocusNode();
    input2FocusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    input1FocusNode = FocusNode();
    input2FocusNode = FocusNode();
    super.dispose();
  }
 @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title:const Text('Testing SQL'),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) {
                  return DialogBox().dialog(
                      context: context,
                      onPressed: () {
                        Model model = Model(
                            fruitName: input1.text,
                            quantity: input2.text, id: 1,
                          );
                        dbManager.insterModel(model);
                        setState(() {
                          input1.text = "";
                          input2.text = "";
                        });
                        Navigator.of(context).pop();
                      },
                      textEditingController1: input1,
                      textEditingController2: input1,
                      input1FocusNode: input1FocusNode,
                      input2FocusNode: input2FocusNode);
                });
          },
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
        body: FutureBuilder(
            future: dbManager.getModelList(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                //print('ksfkjfshfshf');
                modelList = snapshot.data!;
                return ListView.builder(
                    itemCount: modelList.length,
                    itemBuilder: (context, index) {
                      Model _model = modelList[index];
                      return ItemCard(
                        model: _model,
                        input1: input1,
                        input2: input2,
                        onDeletePress: () {
                          dbManager.deleteModel(_model);
                          setState(() {});
                        },
                        onUpdatePress: () {
                          input1.text = _model.fruitName!;
                          input2.text = _model.quantity!;
                          showDialog(
                              context: context,
                              builder: (context) {
                                return DialogBox().dialog(
                                    context: context,
                                    onPressed: () {
                                      Model __model = Model(
                                          id: _model.id,
                                          fruitName: _model.fruitName,
                                          quantity: _model.quantity);
                                      dbManager.updateModel(__model);
                                      setState(() {
                                        input1.text = "";
                                        input2.text = "";
                                      });
                                      Navigator.of(context).pop();
                                    },
                                    textEditingController1: input1,
                                    textEditingController2: input2, input1FocusNode: input1FocusNode, input2FocusNode: input2FocusNode,
                                    );
                              });
                        },
                      );
                    });
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            }));
  }
}
