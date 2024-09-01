/// An exception that is thrown when the output layer name is not found.
///
/// This exception is used to indicate that a required output layer name could not
/// be located within a given context, such as an ARFF file's attributes.
class OutputLayerNameError implements Exception {
  /// Returns an error message indicating that the output layer name was not found.
  ///
  /// The message returned is "Output layer name is not found".
  String errorMessage() {
    return "Output layer name is not found";
  }
}
