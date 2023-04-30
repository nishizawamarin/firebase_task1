import 'package:firebase_exercise_2/constants/text_styles.dart';
import 'package:firebase_exercise_2/services/firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestorePractice extends StatefulWidget {
  const FirestorePractice({super.key});

  @override
  FirestorePracticeState createState() => FirestorePracticeState();
}

class FirestorePracticeState extends State<FirestorePractice> {

  final FirestoreService _firestoreService = FirestoreService();
  final TextEditingController _postEditingController = TextEditingController();
  final double _inputHeight = 60;
  late Stream<QuerySnapshot> _messagesStream;

  Stream<QuerySnapshot> _getMessagesStream(){
    return _firestoreService.getMessagesStream();
  }

  Future<void> _addMessage() async {
    try {
      await _firestoreService.addMessage({
        'text': _postEditingController.text,
        'date': DateTime.now().toString()
      });
      _postEditingController.clear();
    } catch (e) {
      if(!mounted)return;
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: const Text('メッセージを送信できませんでした'),
            margin: EdgeInsets.only(bottom: _inputHeight),
          )
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _messagesStream = _getMessagesStream();
  }

  @override
  void dispose() {
    super.dispose();
    _postEditingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          StreamBuilder<QuerySnapshot>(
              stream: _messagesStream,
              builder: (context, snapshot){
                if(snapshot.hasData){
                  List<DocumentSnapshot> postsData = snapshot.data!.docs;
                  return Expanded(
                    child: ListView.builder(
                        itemCount: postsData.length,
                        itemBuilder: (context, index){
                          Map<String, dynamic> postData = postsData[index].data() as Map<String, dynamic>;
                          return PostCard(postData: postData,);
                        }
                    ),
                  );
                }
                return const Center(child: CircularProgressIndicator(),);
              }
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: _inputHeight,
            child: Row(
              children: [
                Flexible(
                    child: TextField(
                      keyboardType: TextInputType.multiline,
                      minLines: 1,
                      maxLines: 5,
                      controller: _postEditingController,
                      decoration: const InputDecoration(border: OutlineInputBorder()),
                    )
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  child: IconButton(
                      onPressed: (){_addMessage();},
                      icon: const Icon(Icons.send)
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PostCard extends StatelessWidget {
  const PostCard({Key? key, required this.postData}) : super(key: key);
  final Map<String, dynamic> postData;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(postData['text']),
        subtitle: Text(postData['date']),
      ),
    );
  }
}


