class OutputLayerNameError implements Exception{
  String errorMessage() {
    return "Output layer name is not found";
  }
}