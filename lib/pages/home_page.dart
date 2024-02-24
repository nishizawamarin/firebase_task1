import 'package:firebase_exercise_2/constants/text_styles.dart';
import 'package:firebase_exercise_2/services/firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class FirestorePractice extends StatefulWidget {
  const FirestorePractice({super.key});

  @override
  FirestorePracticeState createState() => FirestorePracticeState();
}

class FirestorePracticeState extends State<FirestorePractice> {

  final _firestoreService = FirestoreService();
  final _messageEditingController = TextEditingController();
  final _listScrollController = ScrollController();
  final double _inputHeight = 60;
  late Stream<QuerySnapshot> _messagesStream;

  Stream<QuerySnapshot> _getMessagesStream(){
    return _firestoreService.getMessagesStream(limit: 10);
  }

  Future<void> _addMessage() async {
    try {
      await _firestoreService.addMessage({
        'text': _messageEditingController.text,
        // millisecondsSinceEpochは1970年1月1日午前0時0分0秒からの経過ミリ秒数
        'date': DateTime.now().millisecondsSinceEpoch
      });
      _messageEditingController.clear();
      _listScrollController.jumpTo(_listScrollController.position.maxScrollExtent);
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
    _messageEditingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Messages',style: AppTextStyles.title,),),
      body: Column(
        children: [
          StreamBuilder<QuerySnapshot>(
              stream: _messagesStream,
              builder: (context, snapshot){
                if(snapshot.hasData){
                  List<DocumentSnapshot> messagesData = snapshot.data!.docs;
                  return Expanded(
                    child: ListView.builder(
                      controller: _listScrollController,
                        itemCount: messagesData.length,
                        itemBuilder: (context, index){
                        final messageData = messagesData[index].data() as Map<String, dynamic>;
                          return MessageCard(messageData: messageData,);
                        }
                    ),
                  );
                }
                return const Center(child: CircularProgressIndicator(),);
              }
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            height: _inputHeight,
            child: Row(
              children: [
                Flexible(
                    child:TextField(
                      keyboardType: TextInputType.multiline,
                      minLines: 1,
                      maxLines: 5,
                      controller: _messageEditingController,
                      decoration: const InputDecoration(border: OutlineInputBorder()),
                    ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  child: IconButton(
                      onPressed: (){
                        if(_messageEditingController.text!=''){
                          _addMessage();
                        }},
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

class MessageCard extends StatelessWidget {
  const MessageCard({Key? key, required this.messageData}) : super(key: key);
  final Map<String, dynamic> messageData;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        // データ型のチェックをしている
        title: Text(messageData['text'] is String? messageData['text']:'無効なメッセージ'),
        // 日付の表示を整えている。intlパッケージが必要。
        subtitle: Text(DateFormat('yyyy/MM/dd HH:mm')
            .format(DateTime.fromMillisecondsSinceEpoch(messageData['date'] is int? messageData['date']:0))),
      ),
    );
  }
}
