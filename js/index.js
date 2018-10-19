import { NativeModules } from "react-native";
const { RNReactNativeZlib } = NativeModules;

if (!RNReactNativeZlib) {
  console.error(
    `NativeModules.RNReactNativeZlib is undefined. Make sure the library is linked on the native side.`
  );
}

export default RNReactNativeZlib;
