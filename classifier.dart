import 'dart:io';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';

class Classifier {
  Classifier();
  classifyImage(var image) async{
    var inputImage = File(image.path);
    ImageProcessor imageProcessor = ImageProcessorBuilder()
        .add(ResizeOp(224, 224, ResizeMethod.NEAREST_NEIGHBOUR))
        .build();

    TensorImage tensorImage = TensorImage.fromFile(inputImage);
    tensorImage = imageProcessor.process(tensorImage);

    TensorBuffer probabilityBuffer =
    TensorBuffer.createFixedSize(<int>[1, 1001], TfLiteType.uint8);

    final gpuDelegateV2 = GpuDelegateV2(
        options: GpuDelegateOptionsV2());

    try {
      // Create interpreter from asset.

      var interpreterOptions = InterpreterOptions()..addDelegate(gpuDelegateV2);
      Interpreter interpreter =
      await Interpreter.fromAsset("mobilenet_v2_1.0_224_quant.tflite", options: interpreterOptions);
      interpreter.run(tensorImage.buffer, probabilityBuffer.buffer);
    } catch (e) {
      print('Error loading model: ' + e.toString());
    }

    List<String> labels = await FileUtil.loadLabels("assets/classes.txt");
    SequentialProcessor<TensorBuffer> probabilityProcessor = TensorProcessorBuilder().build();
    TensorLabel tensorLabel = TensorLabel.fromList(
        labels, probabilityProcessor.process(probabilityBuffer));

    Map labeledProb = tensorLabel.getMapWithFloatValue();
    double highestProb = 0;
    late String imgName;

    labeledProb.forEach((name, probability) {
      if (probability > highestProb){
        highestProb = probability;
        imgName = name;
      }
    });
    // For the MobileNet quantized model, we need to divide each output value by 255 to obtain the probability ranging from 0 to 1
    highestProb = highestProb * 100 / 255;
    var outputProb = highestProb.toStringAsFixed(1);
    return [imgName, outputProb];

  }
}