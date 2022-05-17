import 'package:flutter/material.dart';
import 'package:thing_translator/classifier.dart';
import 'dart:io';
import 'classifier.dart';
import 'package:image_picker/image_picker.dart';
import 'package:translator/translator.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Thing Translator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          brightness: Brightness.light,
          primaryColor: Colors.blue,
          accentColor: Colors.cyan),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final Classifier classifier = Classifier();
  final picker = ImagePicker();
  late String imgClass = "";
  late String imgProb;
  final translator = GoogleTranslator();
  var languagespecificoutput = "";
  // Initial Selected Value
  String initialLanguage = "english";
  String finalLanguage = "en";



  // List of items in our dropdown menu

  final language_dict={'afrikaans': 'af',
    'albanian': 'sq',
    'amharic': 'am',
    'arabic': 'ar',
    'armenian': 'hy',
    'azerbaijani': 'az',
    'basque': 'eu',
    'belarusian': 'be',
    'bengali': 'bn',
    'bosnian': 'bs',
    'bulgarian': 'bg',
    'catalan': 'ca',
    'cebuano': 'ceb',
    'chichewa': 'ny',
    'chinese (simplified)': 'zh-cn',
    'chinese (traditional)': 'zh-tw',
    'corsican': 'co',
    'croatian': 'hr',
    'czech': 'cs',
    'danish': 'da',
    'dutch': 'nl',
    'english': 'en',
    'esperanto': 'eo',
    'estonian': 'et',
    'filipino': 'tl',
    'finnish': 'fi',
    'french': 'fr',
    'frisian': 'fy',
    'galician': 'gl',
    'georgian': 'ka',
    'german': 'de',
    'greek': 'el',
    'gujarati': 'gu',
    'haitian creole': 'ht',
    'hausa': 'ha',
    'hawaiian': 'haw',
    'hebrew': 'he',
    'hindi': 'hi',
    'hmong': 'hmn',
    'hungarian': 'hu',
    'icelandic': 'is',
    'igbo': 'ig',
    'indonesian': 'id',
    'irish': 'ga',
    'italian': 'it',
    'japanese': 'ja',
    'javanese': 'jw',
    'kannada': 'kn',
    'kazakh': 'kk',
    'khmer': 'km',
    'korean': 'ko',
    'kurdish (kurmanji)': 'ku',
    'kyrgyz': 'ky',
    'lao': 'lo',
    'latin': 'la',
    'latvian': 'lv',
    'lithuanian': 'lt',
    'luxembourgish': 'lb',
    'macedonian': 'mk',
    'malagasy': 'mg',
    'malay': 'ms',
    'malayalam': 'ml',
    'maltese': 'mt',
    'maori': 'mi',
    'marathi': 'mr',
    'mongolian': 'mn',
    'myanmar (burmese)': 'my',
    'nepali': 'ne',
    'norwegian': 'no',
    'odia': 'or',
    'pashto': 'ps',
    'persian': 'fa',
    'polish': 'pl',
    'portuguese': 'pt',
    'punjabi': 'pa',
    'romanian': 'ro',
    'russian': 'ru',
    'samoan': 'sm',
    'scots gaelic': 'gd',
    'serbian': 'sr',
    'sesotho': 'st',
    'shona': 'sn',
    'sindhi': 'sd',
    'sinhala': 'si',
    'slovak': 'sk',
    'slovenian': 'sl',
    'somali': 'so',
    'spanish': 'es',
    'sundanese': 'su',
    'swahili': 'sw',
    'swedish': 'sv',
    'tajik': 'tg',
    'tamil': 'ta',
    'telugu': 'te',
    'thai': 'th',
    'turkish': 'tr',
    'ukrainian': 'uk',
    'urdu': 'ur',
    'uyghur': 'ug',
    'uzbek': 'uz',
    'vietnamese': 'vi',
    'welsh': 'cy',
    'xhosa': 'xh',
    'yiddish': 'yi',
    'yoruba': 'yo',
    'zulu': 'zu'};

  var items=['afrikaans', 'albanian', 'amharic', 'arabic', 'armenian', 'azerbaijani', 'basque', 'belarusian', 'bengali', 'bosnian', 'bulgarian', 'catalan', 'cebuano', 'chichewa', 'chinese (simplified)', 'chinese (traditional)', 'corsican', 'croatian', 'czech', 'danish', 'dutch', 'english', 'esperanto', 'estonian', 'filipino', 'finnish', 'french', 'frisian', 'galician', 'georgian', 'german', 'greek', 'gujarati', 'haitian creole', 'hausa', 'hawaiian', 'hebrew', 'hindi', 'hmong', 'hungarian', 'icelandic', 'igbo', 'indonesian', 'irish', 'italian', 'japanese', 'javanese', 'kannada', 'kazakh', 'khmer', 'korean', 'kurdish (kurmanji)', 'kyrgyz', 'lao', 'latin', 'latvian', 'lithuanian', 'luxembourgish', 'macedonian', 'malagasy', 'malay', 'malayalam', 'maltese', 'maori', 'marathi', 'mongolian', 'myanmar (burmese)', 'nepali', 'norwegian', 'odia', 'pashto', 'persian', 'polish', 'portuguese', 'punjabi', 'romanian', 'russian', 'samoan', 'scots gaelic', 'serbian', 'sesotho', 'shona', 'sindhi', 'sinhala', 'slovak', 'slovenian', 'somali', 'spanish', 'sundanese', 'swahili', 'swedish', 'tajik', 'tamil', 'telugu', 'thai', 'turkish', 'ukrainian', 'urdu', 'uyghur', 'uzbek', 'vietnamese', 'welsh', 'xhosa', 'yiddish', 'yoruba', 'zulu'];

  // ignore: prefer_typing_uninitialized_variables
  XFile? image;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size; // Size of the screen on which user is running the app
    return Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            Positioned(
                height: size.height * 0.4,
                width: size.width,
                child: Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                    image: imgClass == ""
                        ? AssetImage("assets/background.jpeg") as ImageProvider
                        : FileImage(
                            File(image!.path),
                          ),
                    fit: BoxFit.cover,
                  )),
                )),
            Positioned(
                top: size.height * 0.35,
                height: size.height * 0.65,
                width: size.width,
                child: Container(
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(36.0),
                          topRight: Radius.circular(36.0))),
                  child: Column(
                    children: [
                      const SizedBox(height: 80),
                      const Text("Prediction",
                          style: TextStyle(
                              fontSize: 40, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      Text(languagespecificoutput == "" ? "" : imgProb == "" ? "Unable to identify" : "$imgProb% $languagespecificoutput",
                          style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.green)),
                      const SizedBox(height: 40),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // ignore: deprecated_member_use
                          Column(
                            children: [
                              // ignore: deprecated_member_use
                              OutlinedButton(
                                onPressed: () async {
                                  image = await picker.pickImage(
                                      source: ImageSource.camera, preferredCameraDevice: CameraDevice.rear,
                                      );

                                  final outputs =
                                      await classifier.classifyImage(image);
                                  late final output;
                                  if(finalLanguage != "en") {
                                    output = await translator.translate(
                                        outputs[0], from: "en",
                                        to: finalLanguage);
                                  }
                                  setState(() {
                                    imgClass = outputs[0];
                                    imgProb = outputs[1];
                                    if(double.parse(imgProb) < 25){
                                      imgProb = "";
                                    }
                                    else {
                                      if (finalLanguage != "en") {
                                        languagespecificoutput = output.text;
                                      }
                                      else {
                                        languagespecificoutput = imgClass;
                                      }
                                    }
                                  });
                                },
                                /*highlightedBorderColor: Colors.orange,
                                highlightElevation: 10.0,
                                color: Colors.white,
                                textColor: Colors.white,
                                padding: const EdgeInsets.all(16.0),
                                shape: const CircleBorder(),*/
                                style:OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.all(16.0),
                                  shape: const CircleBorder(),
                                ) ,
                                child: const Icon(
                                  Icons.camera_alt,
                                  size: 35,
                                  color: Colors.orange,
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.only(top: 20),
                                child: Text("Take Photo",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                          const SizedBox(width: 60),
                          // ignore: deprecated_member_use
                          Column(
                            children: [
                              // ignore: deprecated_member_use
                              OutlinedButton(
                                onPressed: () async {
                                  image = await picker.pickImage(
                                      source: ImageSource.gallery,
                                      );

                                  final outputs =
                                      await classifier.classifyImage(image);
                                  late final output;
                                  if(finalLanguage != "en") {
                                    output = await translator.translate(
                                        outputs[0], from: "en",
                                        to: finalLanguage);
                                  }
                                  setState(() {
                                    imgClass = outputs[0];
                                    imgProb = outputs[1];
                                    if(double.parse(imgProb) < 25){
                                      imgProb = "";
                                    }
                                    else {
                                      if (finalLanguage != "en") {
                                        languagespecificoutput = output.text;
                                      }
                                      else {
                                        languagespecificoutput = imgClass;
                                      }
                                    }
                                  });
                                },
                                /*highlightedBorderColor: Colors.orange,
                                highlightElevation: 10.0,
                                color: Colors.white,
                                textColor: Colors.white,
                                padding: const EdgeInsets.all(16.0),
                                shape: const CircleBorder(),*/
                                style:OutlinedButton.styleFrom(
                                  shape: const CircleBorder(),
                                  padding: const EdgeInsets.all(16.0),
                                ),
                                child: const Icon(
                                  Icons.photo,
                                  size: 35,
                                  color: Colors.blue,
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.only(top: 20),
                                child: Text("From Gallery",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 40),
                      DropdownButton(
                        // Initial Value
                        value: initialLanguage,

                        // Down Arrow Icon
                        icon: const Icon(Icons.keyboard_arrow_down,size: 60,),

                        // Array list of items
                        items: items.map((String items) {
                          return DropdownMenuItem(
                            value: items,
                            child: Text(items),
                          );
                        }).toList(),
                        // After selecting the desired option,it will
                        // change button value to selected value
                        onChanged:  (String? newValue) async {
                          finalLanguage = language_dict[newValue]!;
                          final output =await translator.translate(imgClass, from:"en", to:finalLanguage);

                          setState(() {
                            initialLanguage = newValue!;
                            languagespecificoutput=output.text;
                          });
                        },
                      ),
                    ],
                  ),
                ))
          ],
        ));
  }
}
