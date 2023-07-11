import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class curd extends StatefulWidget {
  const curd({super.key});

  @override
  State<curd> createState() => _curdState();
}

class _curdState extends State<curd> {
  final TextEditingController _nameEditingcontroller = TextEditingController();
  final TextEditingController _snEditingcontroller = TextEditingController();
  final TextEditingController _numberEditingcontroller =
      TextEditingController();
  final CollectionReference _items =
      FirebaseFirestore.instance.collection('items');

  //function for create

  Future<void> _create([DocumentSnapshot? documentSnapshot]) async {
    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          return Padding(
            padding: EdgeInsets.only(
                top: 20,
                right: 20,
                left: 20,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Center(
                  child: Text(
                    "Create your item",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                TextField(
                  controller: _nameEditingcontroller,
                  decoration: const InputDecoration(
                      labelText: 'Name', hintText: 'eg.Elon'),
                ),
                TextField(
                  keyboardType: TextInputType.number,
                  controller: _snEditingcontroller,
                  decoration:
                      const InputDecoration(labelText: 'S.N', hintText: 'eg.1'),
                ),
                TextField(
                  keyboardType: TextInputType.number,
                  controller: _numberEditingcontroller,
                  decoration: const InputDecoration(
                      labelText: 'Number', hintText: 'eg.10'),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                    onPressed: () async {
                      final String name = _nameEditingcontroller.text;
                      final int? sn = int.tryParse(_snEditingcontroller.text);
                      final int? number =
                          int.tryParse(_numberEditingcontroller.text);
                      if (number != null) {
                        await _items
                            .add({"name": name, "number": number, "sn": sn});
                        _nameEditingcontroller.text = '';
                        _snEditingcontroller.text = '';
                        _numberEditingcontroller.text = '';

                        Navigator.of(context).pop();
                      }
                    },
                    child: const Text("Create"))
              ],
            ),
          );
        });
  }

// function for update
  Future<void> _update([DocumentSnapshot? documentSnapshot]) async {
    if (documentSnapshot != null) {
      _nameEditingcontroller.text = documentSnapshot['name'];
      _snEditingcontroller.text = documentSnapshot['sn'].toString();
      _numberEditingcontroller.text = documentSnapshot['number'].toString();
    }
    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          return Padding(
            padding: EdgeInsets.only(
                top: 20,
                right: 20,
                left: 20,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: Text(
                    "Update your item",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                TextField(
                  controller: _nameEditingcontroller,
                  decoration: const InputDecoration(
                      labelText: 'Name', hintText: 'eg.Elon'),
                ),
                TextField(
                  keyboardType: TextInputType.number,
                  controller: _snEditingcontroller,
                  decoration:
                      const InputDecoration(labelText: 'S.N', hintText: 'eg.1'),
                ),
                TextField(
                  keyboardType: TextInputType.number,
                  controller: _numberEditingcontroller,
                  decoration: const InputDecoration(
                      labelText: 'Number', hintText: 'eg.10'),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                    onPressed: () async {
                      final String name = _nameEditingcontroller.text;
                      final int? sn = int.tryParse(_snEditingcontroller.text);
                      final int? number =
                          int.tryParse(_numberEditingcontroller.text);
                      if (number != null) {
                        await _items
                            .doc(documentSnapshot!.id)
                            .update({"name": name, "number": number, "sn": sn});
                        _nameEditingcontroller.text = '';
                        _snEditingcontroller.text = '';
                        _numberEditingcontroller.text = '';

                        Navigator.of(context).pop();
                      }
                    },
                    child: const Text("Update"))
              ],
            ),
          );
        });
  }

  // for delete operation
  Future<void> _delete(String productID) async {
    await _items.doc(productID).delete();

    // for snackBar
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("You have successfully deleted a itmes")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Center(
          child: Text(
            'CRDE OPERATION',
            style: TextStyle(fontSize: 25, color: Colors.white),
          ),
        ),
      ),
      body: StreamBuilder(
          stream: _items.snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
            if (streamSnapshot.hasData) {
              return ListView.builder(
                  itemCount: streamSnapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final DocumentSnapshot documentSnapshot =
                        streamSnapshot.data!.docs[index];

                    return Card(
                      color: Colors.blueAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(19),
                      ),
                      margin: EdgeInsets.all(10),
                      child: ListTile(
                        leading: CircleAvatar(
                          child: Text(
                            documentSnapshot['sn'].toString(),
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          backgroundColor: Colors.pinkAccent,
                          radius: 17,
                        ),
                        title: Text(documentSnapshot['name'].toString()),
                        subtitle: Text(documentSnapshot['number'].toString()),
                        trailing: SizedBox(
                          width: 100,
                          child: Row(
                            children: [
                              IconButton(
                                  color: Colors.black,
                                  onPressed: () => _update(documentSnapshot),
                                  icon: const Icon(Icons.edit)),
                              IconButton(
                                  color: Colors.black,
                                  onPressed: () => _delete(documentSnapshot.id),
                                  icon: const Icon(Icons.delete)),
                            ],
                          ),
                        ),
                      ),
                    );
                  });
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _create(),
        backgroundColor: const Color.fromARGB(255, 88, 136, 190),
        child: const Icon(Icons.add_circle),
      ),
    );
  }
}
