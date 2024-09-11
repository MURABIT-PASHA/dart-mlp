## 0.0.1

* Initial release of the `mlp` package.
* Added core classes:
    * `Neuron`: Represents a neuron in the neural network.
    * `Layer`: Represents a layer of neurons, with support for input, hidden, and output layers.
    * `Edge`: Represents a connection between neurons with an optional weight.
    * `Model`: Represents the entire neural network model, composed of multiple layers.
* Provided factory constructors for creating input, hidden, and output layers.
* Enabled easy construction and manipulation of multi-layer perceptron (MLP) neural networks.

## 0.0.2

### New Features
- Added `ARFFModelCreationParameter` class. This class is designed to work with the `compute` function and includes:
  - `arff`: An ARFF data object.
  - `className`: The name of the class to be used in the model.

### Usage
- The `ARFFModelCreationParameter` class provides a parameter set containing ARFF data and a class name. This class can be used with the `compute` function for background processing tasks.

## 0.0.3

### New Features
- Added `parseFromCSVFile` method to the `ARFFConverter` class. That provides users to:
  - Parse CSV files and automatically convert them into ARFF format.

## 0.0.4

### UPDATE
- Removed unnecessary imports

## 1.0.0

### New Features
- **`save()` Method**:
  - Added a method to serialize the model's layers, including neurons and their connections, into a JSON format and save it to a file. This allows for the model's state to be saved and restored later.

- **`readFrom()` Method**:
  - Added a method to read a JSON file and reconstruct the model from the saved data. This method dynamically creates input, hidden, and output layers, along with their respective neurons and connections, to restore the model's state.

### Changes
- **Renamed Method**:
  - Renamed `createModelFromARFF` to `createModel` for improved clarity and usability.
