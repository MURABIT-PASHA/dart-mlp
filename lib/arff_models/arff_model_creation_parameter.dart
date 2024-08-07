import 'package:mlp/arff_models/arff.dart';

class ARFFModelCreationParameter{

  /// ARFF data object.
  final ARFF arff;

  /// The name of the classified data.
  final String className;

  /// Creates an instance of `ARFFModelCreationParameter`.
  ///
  /// Takes [arff] and [className] parameters and assigns them
  /// to the class's internal variables.
  const ARFFModelCreationParameter({
    required this.arff,
    required this.className,
  });
}