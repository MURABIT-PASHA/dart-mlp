import 'package:flutter/material.dart';
import 'package:mlp/arff_models/arff.dart';
import 'package:mlp/arff_models/arff_attributes.dart';
import 'package:mlp/arff_models/arff_converter.dart';
import 'package:mlp/arff_models/arff_data.dart';
import 'package:mlp/mlp.dart';
import 'package:mlp/mlp_models/layer.dart';
import 'package:mlp/mlp_models/model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MLP Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Multilayer Perceptron'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  ARFF? arff;
  Map<String, String?> inputValues = {};
  MultilayerPerceptron? mlp;
  int outputAttributeIndex = 0;
  Model? model;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.only(top: 10),
              height: 60,
              child: ElevatedButton(
                  onPressed: () async {
                    ARFFConverter arffConverter = ARFFConverter();
                    arff = await arffConverter.parseARFFFile(
                        fileName: 'assets/penguins.arff');
                    if (arff != null) {
                      mlp = MultilayerPerceptron(
                        inputLayer: Layer.input(
                            neurons: arff!
                                .getInputLayerNeurons(className: 'species')),
                        outputLayer: Layer.output(
                            neurons: arff!
                                .getOutputLayerNeurons(className: 'species')),
                      );
                      model = mlp!.createModelFromArff(
                          arff: arff!, className: 'species');

                      outputAttributeIndex = arff!.attributesList
                          .indexWhere((test) => test.name == 'species');
                      for (ARFFAttributes attrs in arff!.attributesList) {
                        inputValues[attrs.name] = null;
                      }
                    }
                    setState(() {});
                  },
                  child: const Text('Press to load example arff file')),
            ),
            Container(
              height: MediaQuery.sizeOf(context).height - 150,
              width: MediaQuery.sizeOf(context).width,
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: MediaQuery.sizeOf(context).height - 250,
                    width: MediaQuery.sizeOf(context).width,
                    child: arff != null
                        ? ListView.builder(
                            itemCount: arff!.attributesList.length,
                            itemBuilder: (BuildContext context, int index) {
                              if (index == outputAttributeIndex) {
                                return Container();
                              } else {
                                if (arff!.attributesList[index].type ==
                                    'nominal') {
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(arff!.attributesList[index].name),
                                      ...arff!
                                          .attributesList[index].nominalValues!
                                          .map<Widget>((value) {
                                        return RadioListTile<String>(
                                          title: Text(value),
                                          value: value,
                                          groupValue: inputValues[
                                              arff!.attributesList[index].name],
                                          onChanged: (String? newValue) {
                                            setState(() {
                                              inputValues[arff!
                                                  .attributesList[index]
                                                  .name] = newValue;
                                            });
                                          },
                                        );
                                      }),
                                    ],
                                  );
                                } else {
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(arff!.attributesList[index].name),
                                      TextField(
                                        keyboardType: TextInputType.number,
                                        onChanged: (newValue) {
                                          setState(() {
                                            inputValues[arff!
                                                .attributesList[index]
                                                .name] = newValue;
                                          });
                                        },
                                      ),
                                    ],
                                  );
                                }
                              }
                            },
                          )
                        : Container(),
                  ),
                  SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        List<ARFFData> dataList = [];
                        for (var key in inputValues.keys) {
                          if (inputValues[key] != null) {
                            var data = ARFFData(
                                name: key, value: inputValues[key].toString());
                            dataList.add(data);
                          }
                        }
                        // Real test set, not in training set
                        // 'Gentoo','Biscoe',42.8,14.2,209,4700,'female'
                        // 'Adelie','Biscoe',37.8,20.0,190,4250,'male'
                        if (dataList.isNotEmpty) {
                          if (mlp != null) {
                            if (model != null) {
                              var prediction = mlp!.getPrediction(
                                  arff: arff!, model: model!, data: dataList);
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return Dialog(
                                      child: Container(
                                        padding: const EdgeInsets.all(20),
                                          height: 200,
                                          width:
                                              MediaQuery.sizeOf(context).width -
                                                  10,
                                          child: Text(prediction.toString())),
                                    );
                                  });
                            }
                          }
                        }
                      },
                      child: const Text('Get prediction'),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
