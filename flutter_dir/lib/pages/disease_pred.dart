import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;

class CropDiseasePredictionPage extends StatefulWidget {
  const CropDiseasePredictionPage({super.key});

  @override
  _CropDiseasePredictionPageState createState() =>
      _CropDiseasePredictionPageState();
}

class _CropDiseasePredictionPageState extends State<CropDiseasePredictionPage> {
  Future<Interpreter> _interpreter =
      Interpreter.fromAsset('assets/models/mobileNetV2_plantDisease.tflite');
  File? _imageFile;
  String _predictionResult = '';

  final Map<int, String> _cropNames = {
    0: 'Apple',
    1: 'Cherry_(including_sour)',
    2: 'Corn_(maize)',
    3: 'Grape',
    4: 'Peach',
    5: 'Pepper,_bell',
    6: 'Potato',
    7: 'Strawberry',
    8: 'Tomato'
  };
  late int _selectedCropIndex;

  final Map<int, String> _diseaseClasses = {
    0: 'Apple - Apple Scab',
    1: 'Apple - Black Rot',
    2: 'Apple - Cedar Apple Rust',
    3: 'Apple - Healthy',
    4: 'Cherry - Powdery Mildew',
    5: 'Cherry - Healthy',
    6: 'Corn - Cercospora Leaf Spot',
    7: 'Corn - Common Rust',
    8: 'Corn - Northern Leaf Blight',
    9: 'Corn - Healthy',
    10: 'Grape - Black Rot',
    11: 'Grape - Esca (Black Measles)',
    12: 'Grape - Leaf Blight',
    13: 'Grape - Healthy',
    14: 'Peach - Bacterial Spot',
    15: 'Peach - Healthy',
    16: 'Bell Pepper - Bacterial Spot',
    17: 'Bell Pepper - Healthy',
    18: 'Potato - Early Blight',
    19: 'Potato - Late Blight',
    20: 'Potato - Healthy',
    21: 'Strawberry - Leaf Scorch',
    22: 'Strawberry - Healthy',
    23: 'Tomato - Bacterial Spot',
    24: 'Tomato - Early Blight',
    25: 'Tomato - Late Blight',
    26: 'Tomato - Leaf Mold',
    27: 'Tomato - Septoria Leaf Spot',
    28: 'Tomato - Spider Mites',
    29: 'Tomato - Target Spot',
    30: 'Tomato - Yellow Leaf Curl Virus',
    31: 'Tomato - Mosaic Virus',
    32: 'Tomato - Healthy'
  };

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _selectedCropIndex = 0;
    // _loadModel();
  }

  // Future<void> _loadModel() async {
  //   try {
  //     _interpreter = await Interpreter.fromAsset(
  //         'assets/models/mobileNetV2_plantDisease.tflite');
  //     print('Model loaded successfully');
  //   } catch (e) {
  //     print('Error loading model: $e');
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Failed to load model: $e')),
  //     );
  //   }
  // }

  int _mapToEqualizedRange(int value, List<int> sortedValues) {
    var index = sortedValues.indexOf(value);
    return ((index / sortedValues.length) * 255).toInt();
  }

  Future<void> _preprocessAndPredict(File imageFile) async {
    try {
      final bytes = await imageFile.readAsBytes();
      var decodedImage = img.decodeImage(bytes);

      if (decodedImage == null) {
        _showErrorDialog('Could not decode image');
        return;
      }

      var resizedImage = img.copyResize(decodedImage, width: 224, height: 224);
      var inputTensor = Float32List(1 * 224 * 224 * 3);
      var pixelIndex = 0;

      var grayValues = <int>[];

      for (var y = 0; y < 224; y++) {
        for (var x = 0; x < 224; x++) {
          var pixel = resizedImage.getPixel(x, y);
          var r = pixel.r;
          var g = pixel.g;
          var b = pixel.b;

          var grayValue = (0.299 * r + 0.587 * g + 0.114 * b).toInt();
          grayValues.add(grayValue);
        }
      }

      grayValues.sort();

      for (var y = 0; y < 224; y++) {
        for (var x = 0; x < 224; x++) {
          var pixel = resizedImage.getPixel(x, y);
          var r = pixel.r;
          var g = pixel.g;
          var b = pixel.b;

          var grayValue = (0.299 * r + 0.587 * g + 0.114 * b).toInt();

          var equalizedValue = _mapToEqualizedRange(grayValue, grayValues);
          var normalizedValue = equalizedValue / 255.0;

          inputTensor[pixelIndex++] = normalizedValue;
          inputTensor[pixelIndex++] = normalizedValue;
          inputTensor[pixelIndex++] = normalizedValue;
        }
      }

      var cropInput = Float32List(1 * 9);
      cropInput.fillRange(0, 9, 0.0);
      cropInput[_selectedCropIndex] = 1.0;

      var inputs = [
        inputTensor.reshape([1, 224, 224, 3]),
        cropInput.reshape([1, 9])
      ];
      var outputTensor = List.filled(1 * 33, 0.0);
      var outputs = [outputTensor];

      // _interpreter.run(inputs, outputs);
      _interpreter.then((interpreter) {
        interpreter.run(inputs, outputs);
      });

      var predictions = outputs[0];
      var maxProbability = predictions.reduce((a, b) => a > b ? a : b);
      var predictedClassIndex = predictions.indexOf(maxProbability);

      String diseaseName =
          _diseaseClasses[predictedClassIndex] ?? 'Unknown Disease';

      setState(() {
        _predictionResult = '''
        Crop: ${_cropNames[_selectedCropIndex]}
        Detected Disease: $diseaseName
        ''';
      });
    } catch (e) {
      print('Prediction error: $e');
      _showErrorDialog('Prediction failed: $e');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 224,
        maxHeight: 224,
        imageQuality: 90,
      );

      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
        });
        await _preprocessAndPredict(_imageFile!);
      }
    } catch (e) {
      _showErrorDialog('Image selection failed: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crop Disease Detector'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DropdownButtonFormField<int>(
              decoration: InputDecoration(
                labelText: 'Select Crop',
                border: OutlineInputBorder(),
              ),
              value: _selectedCropIndex,
              items: _cropNames.entries.map((entry) {
                return DropdownMenuItem(
                  value: entry.key,
                  child: Text(entry.value.replaceAll('_', ' ')),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCropIndex = value!;
                });
              },
            ),
            SizedBox(height: 16),

            // Image Display
            if (_imageFile != null)
              Image.file(
                _imageFile!,
                height: 250,
                width: double.infinity,
                fit: BoxFit.cover,
              ),

            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () => _pickImage(ImageSource.camera),
                  icon: Icon(Icons.camera_alt),
                  label: Text('Take Photo'),
                ),
                ElevatedButton.icon(
                  onPressed: () => _pickImage(ImageSource.gallery),
                  icon: Icon(Icons.photo_library),
                  label: Text('Choose from Gallery'),
                ),
              ],
            ),

            SizedBox(height: 16),

            // Prediction Result
            if (_predictionResult.isNotEmpty)
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green.shade200),
                ),
                child: Text(
                  _predictionResult,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _interpreter.then((interpreter) {
      if (interpreter != null) {
        interpreter.close();
      }
    });
    super.dispose();
  }

}

extension ListReshape on List<double> {
  List<double> reshape(List<int> shape) {
    return this;
  }
}
