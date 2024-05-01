import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:icansee_2_0/main.dart';
import 'package:icansee_2_0/src/bloc/chat_bloc.dart';
import 'package:icansee_2_0/src/controller/object_label_controller.dart';
import 'package:icansee_2_0/src/model/chat_message_model.dart';

class ResultPage extends StatefulWidget {
  const ResultPage({super.key});

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  final ChatBloc chatBloc = ChatBloc();
  final controller = LabelController.instance;
  final FlutterTts flutterTts = FlutterTts();
  TextEditingController textEditingController = TextEditingController();
//   String text =
//       """Please create a descriptive scene based on the objects detected around me:

// In the scene:

// ...
// Please incorporate these objects into a coherent scene description, considering their relative positions and interactions. Ensure the description is clear and informative, providing a vivid understanding of the surroundings for someone who cannot visually perceive the scene.

// Thank you for your assistance in creating a meaningful representation of the environment."
// """;

  @override
  void initState() {
    // TODO: implement initState
    speak("wait.....processing the data");
    chatBloc.add(ChatGenerateNewTextMessageEvent(
        inputMessage:
            """Please create a descriptive scene based on the objects detected around me in  ${controller.objectLabels.length} lines:
In the scene:
${controller.objectLabels}
"""));
    super.initState();
  }

  speak(String text) async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setPitch(1); // 0.5 to 1.5
    await flutterTts.speak(text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            controller.objectLabels.clear();
            flutterTts.stop();
            Get.back();
          },
        ),
      ),
      body: BlocConsumer<ChatBloc, ChatState>(
        bloc: chatBloc,
        listener: (context, state) {},
        builder: (context, state) {
          switch (state.runtimeType) {
            case ChatSuccessState:
              List<ChatMessageModel> messages =
                  (state as ChatSuccessState).messages;
              return GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: Container(
                  width: double.maxFinite,
                  height: double.maxFinite,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Container(
                      //   padding: const EdgeInsets.symmetric(horizontal: 16),
                      //   height: 100,
                      //   child: const Row(
                      //     crossAxisAlignment: CrossAxisAlignment.end,
                      //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //     children: [
                      //       Text(
                      //         "Space Pod",
                      //         style: TextStyle(
                      //             fontWeight: FontWeight.bold, fontSize: 24),
                      //       ),
                      //       // GestureDetector(
                      //       //     onTap: () {
                      //       //       messages = [];
                      //       //     },
                      //       //     child:
                      //       //         Icon(Icons.open_in_new, color: Colors.white)),
                      //     ],
                      //   ),
                      // ),
                      Expanded(
                          child: ListView.builder(
                              itemCount: messages.length,
                              itemBuilder: (context, index) {
                                speak(messages[index].parts.first.text);
                                return Container(
                                    margin: const EdgeInsets.only(
                                        bottom: 12, left: 16, right: 16),
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(16),
                                        color: Colors.white),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          messages[index].role == "user"
                                              ? "User"
                                              : "ICANSEE",
                                          style: TextStyle(
                                              fontSize: 14,
                                              color:
                                                  messages[index].role == "user"
                                                      ? Colors.amber
                                                      : Colors.purple.shade200),
                                        ),
                                        const SizedBox(
                                          height: 12,
                                        ),
                                        Text(
                                          messages[index].parts.first.text,
                                          style: const TextStyle(height: 1.2),
                                        ),
                                      ],
                                    ));
                              })),
                      if (chatBloc.generating)
                        Row(
                          children: [
                            // Container(
                            //     height: 200,
                            //     width: 200,
                            //     child: Lottie.asset('assets/space_loader.json')),
                            // const SizedBox(width: 20),
                            const Text("Loading..."),
                          ],
                        ),
                      const SizedBox(
                        height: 10,
                      ),
                      // Container(
                      //   width: double.infinity,
                      //   padding: const EdgeInsets.symmetric(horizontal: 10),
                      //   child: Row(
                      //     children: [
                      //       Expanded(
                      //           child: TextField(
                      //         controller: textEditingController,
                      //         style: const TextStyle(color: Colors.black),
                      //         cursorColor: Theme.of(context).primaryColor,
                      //         decoration: InputDecoration(
                      //             border: OutlineInputBorder(
                      //               borderRadius: BorderRadius.circular(100),
                      //             ),
                      //             fillColor: Colors.white,
                      //             hintText: "Ask Something from AI",
                      //             hintStyle:
                      //                 TextStyle(color: Colors.grey.shade400),
                      //             filled: true,
                      //             focusedBorder: OutlineInputBorder(
                      //                 borderRadius: BorderRadius.circular(100),
                      //                 borderSide: BorderSide(
                      //                     color:
                      //                         Theme.of(context).primaryColor))),
                      //       )),
                      //       const SizedBox(width: 12),
                      //       InkWell(
                      //         onTap: () {
                      //           if (textEditingController.text.isNotEmpty) {
                      //             String text = textEditingController.text;
                      //             textEditingController.clear();
                      //             chatBloc.add(ChatGenerateNewTextMessageEvent(
                      //                 inputMessage: text));
                      //           }
                      //         },
                      //         child: const CircleAvatar(
                      //           radius: 32,
                      //           backgroundColor: Colors.white,
                      //           child: CircleAvatar(
                      //             radius: 30,
                      //             backgroundColor: Colors.black87,
                      //             child: Center(
                      //               child: Icon(Icons.send, color: Colors.white),
                      //             ),
                      //           ),
                      //         ),
                      //       )
                      //     ],
                      //   ),
                      // ),
                      const SizedBox(
                        height: 20,
                      )
                    ],
                  ),
                ),
              );

            default:
              return const SizedBox();
          }
        },
      ),
    );
  }
}
