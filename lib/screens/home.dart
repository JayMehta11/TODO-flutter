import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:todo_firebase/screens/add_task.dart';
import 'package:todo_firebase/screens/description.dart';

// ignore: duplicate_import
import 'add_task.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String uid = '';
  @override
  void initState() {
    getuid();
    super.initState();
  }

  getuid() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    final User user = auth.currentUser;
    setState(() {
      uid = user.uid;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'TODO',
        ),
        actions: [
          IconButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
              },
              icon: Icon(Icons.logout))
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('tasks')
              .doc(uid)
              .collection('mytasks')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              final docs = snapshot.data.docs;
              return ListView.builder(
                itemCount: docs.length,
                itemBuilder: (context, index) {
                  var time = (docs[index]['timestamp'] as Timestamp).toDate();

                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Description(
                            title: docs[index]['title'],
                            description: docs[index]['description'],
                          ),
                        ),
                      );
                    },
                    child: Container(
                        margin: EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(
                            color: Color(0xff121211),
                            borderRadius: BorderRadius.circular(10)),
                        height: 90,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                    margin: EdgeInsets.only(left: 20),
                                    child: Text(
                                      docs[index]['title'],
                                      style: GoogleFonts.roboto(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )),
                                SizedBox(
                                  height: 5,
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 20),
                                  child: Text(
                                      DateFormat.yMd().add_jm().format(time)),
                                )
                              ],
                            ),
                            Container(
                              child: IconButton(
                                icon: Icon(
                                  Icons.delete,
                                ),
                                onPressed: () async {
                                  await FirebaseFirestore.instance
                                      .collection('tasks')
                                      .doc(uid)
                                      .collection('mytasks')
                                      .doc(docs[index]['time'])
                                      .delete();
                                },
                              ),
                            )
                          ],
                        )),
                  );
                },
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => AddTask()));
        },
      ),
    );
  }
}
