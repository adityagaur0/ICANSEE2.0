import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:get/route_manager.dart';
import 'package:icansee_2_0/src/controller/object_label_controller.dart';
import 'package:icansee_2_0/src/object_detector_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final FlutterTts flutterTts = FlutterTts();
  final controller = Get.put(LabelController());
  Map<String, int> objectLabels = {};
  speak(String text) async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setPitch(1); // 0.5 to 1.5
    await flutterTts.speak(text);
  }

  void updateLabels(Map<String, int> newLabels) {
    setState(() {
      objectLabels = newLabels;
    });
  }

  @override
  void initState() {
    speak("Object Detection.     Double tap to start the detection");
    super.initState();
  }

  @override
  void dispose() {
    flutterTts.stop();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        toolbarHeight: 56,
        title: const Center(
          child: Text(
            "ICANSEE 2.0",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontSize: 26,
            ),
          ),
        ),
        // actions: [
        //   IconButton(
        //     onPressed: _openHelpOverlay, //7****
        //     icon: const Icon(Icons.help),
        //   ),
        // ],
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: GestureDetector(
                    onDoubleTap: () {
                      controller.objectLabels.clear();
                      // Get.to(() => _viewPage);
                      flutterTts.stop();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ObjectDetectorView(
                              objectLabels: objectLabels,
                            ),
                          ));
                    },
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(20)),
                      child: Center(
                        child: Text(
                          'Object Detection..',
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 40,
                )
                // ExpansionTile(
                //   title: Text('Vision APIs'),
                //   children: [
                //     // CustomCard('Barcode Scanning', BarcodeScannerView()),
                //     // CustomCard('Face Detection', FaceDetectorView()),
                //     // CustomCard('Face Mesh Detection', FaceMeshDetectorView()),
                //     // CustomCard('Image Labeling', ImageLabelView()),
                // CustomCard(
                //     'Object Detection',
                // ObjectDetectorView(
                //   objectLabels: objectLabels,
                // ),
                // ),
                //     // CustomCard('Text Recognition', TextRecognizerView()),
                //     // CustomCard('Digital Ink Recognition', DigitalInkView()),
                //     // CustomCard('Pose Detection', PoseDetectorView()),
                //     // CustomCard('Selfie Segmentation', SelfieSegmenterView()),
                //   ],
                // ),

                // Obx(
                //   () => SizedBox(
                //     child: Column(
                //       // or ListView if you want scrolling
                //       children: controller.objectLabels.entries.map((entry) {
                //         String label = entry.key;
                //         int count = entry.value;
                //         print('length.....= $label: $count');
                //         return Text('$label: $count');
                //       }).toList(),
                //     ),
                //   ),
                // ),
                // ExpansionTile(
                //   title: Text('Natural Language APIs'),
                //   children: [
                //     CustomCard('Language ID', LanguageIdentifierView()),
                //     CustomCard(
                //         'On-device Translation', LanguageTranslatorView()),
                //     CustomCard('Smart Reply', SmartReplyView()),
                //     CustomCard('Entity Extraction', EntityExtractionView()),
                //  ],
                //),
                // Container(
                //   child: controller.objectLabels.forEach((label, count) {
                //     print('length.....= $label: $count');
                //   }),
                // )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CustomCard extends StatelessWidget {
  final String _label;
  final Widget _viewPage;
  final bool featureCompleted;

  const CustomCard(this._label, this._viewPage,
      {super.key, this.featureCompleted = true});

  @override
  Widget build(BuildContext context) {
    final controller = LabelController.instance;
    return Card(
      elevation: 5,
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        tileColor: Theme.of(context).primaryColor,
        title: Text(
          _label,
          style:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        onTap: () {
          if (!featureCompleted) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text('This feature has not been implemented yet')));
          } else {
            controller.objectLabels.clear();
            // Get.to(() => _viewPage);
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => _viewPage));
          }
        },
      ),
    );
  }
}
