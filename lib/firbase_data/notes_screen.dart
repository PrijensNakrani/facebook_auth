import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NotesScreen extends StatelessWidget {
  final _title = TextEditingController();
  final _description = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notes"),
      ),
      drawer: Drawer(
        child: Column(
          children: [
            const SizedBox(
              height: 100,
            ),
            Container(
              height: 170,
              width: 170,
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Column(
                  children: [
                    Text("Add title"),
                    TextFormField(
                      controller: _title,
                      decoration: InputDecoration(hintText: "Title"),
                    ),
                    TextFormField(
                      controller: _description,
                      decoration: InputDecoration(hintText: "Description"),
                    ),
                  ],
                ),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("cencel"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      FirebaseFirestore.instance
                          .collection("User1")
                          .doc(FirebaseAuth.instance.currentUser!.uid)
                          .collection("Notes")
                          .add({
                        "title": _title.text,
                        "description": _description.text
                      });
                      Navigator.pop(context);
                      _title.clear();
                      _description.clear();
                    },
                    child: Text("Add"),
                  ),
                ],
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("User1")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection("Notes")
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            List<DocumentSnapshot> notes = snapshot.data!.docs;
            return ListView.builder(
              itemCount: notes.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    notes[index].get("title"),
                  ),
                  subtitle: Text(
                    notes[index].get("description"),
                  ),
                  leading: Container(
                    height: 60,
                    width: 60,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: NetworkImage(""),
                      ),
                    ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Column(
                                  children: [
                                    Text("Add title"),
                                    TextFormField(
                                      controller: _title,
                                      decoration:
                                          InputDecoration(hintText: "Title"),
                                    ),
                                    TextFormField(
                                      controller: _description,
                                      decoration: InputDecoration(
                                          hintText: "Description"),
                                    ),
                                  ],
                                ),
                                actions: [
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text("cencel"),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      FirebaseFirestore.instance
                                          .collection("User1")
                                          .doc(FirebaseAuth
                                              .instance.currentUser!.uid)
                                          .collection("Notes")
                                          .doc(notes[index].id)
                                          .update({
                                        "title": _title.text,
                                        "description": _description.text
                                      });
                                      Navigator.pop(context);
                                      _title.clear();
                                      _description.clear();
                                    },
                                    child: Text("Update"),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        icon: Icon(Icons.edit),
                      ),
                      IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text("Do you want to Delete"),
                                actions: [
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text("cencel"),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      FirebaseFirestore.instance
                                          .collection("User1")
                                          .doc(FirebaseAuth
                                              .instance.currentUser!.uid)
                                          .collection("Notes")
                                          .doc(notes[index].id)
                                          .delete();
                                      Navigator.pop(context);
                                      _title.clear();
                                      _description.clear();
                                    },
                                    child: Text("Delete"),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        icon: Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          } else {
            return SizedBox();
          }
        },
      ),
    );
  }
}
