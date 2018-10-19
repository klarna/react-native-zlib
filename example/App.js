/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 *
 * @format
 * @flow
 */

import React, { Component } from "react";
import { Platform, StyleSheet, Text, View, Button } from "react-native";
import RNReactNativeZlib from "@klarna/react-native-zlib";
// import base64 from "react-native-base64";
import { Buffer } from "buffer";

const instructions = Platform.select({
  ios: "Press Cmd+R to reload,\n" + "Cmd+D or shake for dev menu",
  android:
    "Double tap R on your keyboard to reload,\n" +
    "Shake or press menu button for dev menu"
});

type Props = {};

function arraysIdentical(a, b) {
  var i = a.length;
  if (i != b.length) return false;
  while (i--) {
    if (a[i] !== b[i]) return false;
  }
  return true;
}

export default class App extends Component<Props> {
  onCompressApiClicked = () => {
    const testString = `{ experiment: 'something inside'}`;
    const testArray = [0, 0, 0, 0, 0, 0, 0, 1, 2, 3, 4, 5, 6];
    // const encoded = base64.encode(testString);
    const encoded = Buffer.from(testString).toString("base64");

    RNReactNativeZlib.deflate(testArray).then(data => {
      RNReactNativeZlib.inflate(data).then(result => {
        if (arraysIdentical(result, testArray)) {
          // throw new Error(`PASSED!`);
        } else {
          throw new Error(`FAILED! Compression does not work`);
        }
      });
    });

    RNReactNativeZlib.deflateBase64(encoded).then(data => {
      RNReactNativeZlib.inflateBase64(data).then(buffer => {
        // const result = base64.decode(buffer);
        const result = Buffer.from(buffer, 'base64').toString('utf8')

        if (result === testString) {
          throw new Error("PASSED! BASE64 processing.");
        } else {
          throw new Error("FAILED! BASE64 processing.");
        }
      });
    });
  };

  render() {
    return (
      <View style={styles.container}>
        <Text style={styles.welcome} ref={ref => (this._welcome = ref)}>
          Welcome to React Native!
        </Text>
        <Text
          style={styles.instructions}
          ref={ref => (this._instructions = ref)}
        >
          {instructions}
        </Text>
        <Button
          onPress={() => this.onCompressApiClicked()}
          style={styles.button}
          title="Test"
          ref={ref => (this._button = ref)}
        />
      </View>
    );
  }
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: "center",
    alignItems: "center",
    backgroundColor: "#F5FCFF"
  },
  welcome: {
    fontSize: 20,
    textAlign: "center",
    margin: 10
  },
  instructions: {
    textAlign: "center",
    color: "#333333",
    marginBottom: 5
  },
  button: {
    width: 200,
    height: 100,
    margin: 20,
    alignItems: "center",
    backgroundColor: "#841584",
    padding: 20,
    color: "white"
  }
});
