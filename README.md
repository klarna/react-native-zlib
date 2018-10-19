
# @klarna/react-native-zlib

## Getting started

`$ npm install @klarna/react-native-zlib --save`

### Mostly automatic installation

`$ react-native link @klarna/react-native-zlib`

### Manual installation


#### iOS

1. In XCode, in the project navigator, right click `Libraries` ➜ `Add Files to [your project's name]`
2. Go to `node_modules` ➜ `react-native-zlib` and add `RNReactNativeZlib.xcodeproj`
3. In XCode, in the project navigator, select your project. Add `libRNReactNativeZlib.a` to your project's `Build Phases` ➜ `Link Binary With Libraries`
4. Run your project (`Cmd+R`)<

#### Android

1. Open up `android/app/src/main/java/[...]/MainActivity.java`
  - Add `import com.klarna.reactnative.zlib.RNReactNativeZlibPackage;` to the imports at the top of the file
  - Add `new RNReactNativeZlibPackage()` to the list returned by the `getPackages()` method
2. Append the following lines to `android/settings.gradle`:
  	```
  	include ':react-native-zlib'
  	project(':react-native-zlib').projectDir = new File(rootProject.projectDir, 	'../node_modules/react-native-zlib/android')
  	```
3. Insert the following lines inside the dependencies block in `android/app/build.gradle`:
  	```
      compile project(':react-native-zlib')
  	```


#### Android Helper

Open `settings.gradle` of your root project and add into it:

```groovy
 def configureRNModule(prj) {
     def dir = new File(rootProject.projectDir, "../node_modules/${prj.name}/android")
     def dirSrc = new File(rootProject.projectDir, "../node_modules/${prj.name}/src/android")
     def dirKlarna = new File(rootProject.projectDir, "../node_modules/@klarna/${prj.name}/android")

     if (dirKlarna.exists()) {
         prj.projectDir = dirKlarna
     } else if (dirSrc.exists()) {
         prj.projectDir = dirSrc
     } else if (dir.exists()) {
         prj.projectDir = dir
     } else {
         throw new Exception("project directory not found! project: ${prj.name}")
     }
}
```

after that you can replace line:

```gradle
project(':react-native-zlib').projectDir = new File(rootProject.projectDir, '../node_modules/react-native-zlib/android')
```

on shorter version:

```gradle
configureRNModule(project(':react-native-zlib'))
```

## Usage

```javascript
import RNReactNativeZlib from '@klarna/react-native-zlib';
import base64 from "react-native-base64";
import { Buffer } from "buffer";

/* Working with byte arrays */
const testArray = [0, 0, 0, 0, 0, 0, 0, 1, 2, 3, 4, 5, 6];
RNReactNativeZlib.deflate(testArray).then(compressed => {
  RNReactNativeZlib.inflate(compressed).then(decompressed => {
    // decompressed
  })
});

/* Working with base64 strings */
const testString = `{ experiment: 'something inside'}`;
const encoded1 = base64.encode(testString);
const encoded2 = Buffer.from(testString).toString("base64");

RNReactNativeZlib.deflateBase64(encoded1).then(compressed => {
  // base64 --> byte[] --> compressed byte[] --> base64
  
  RNReactNativeZlib.inflateBase64(compressed).then(decompressed => {
    const result1 = base64.decode(buffer);
    const result2 = Buffer.from(buffer, 'base64').toString('utf8')

    // decompressed
  })
});

```

## Supported API

## References on Alternatives

- [react-native-zip](https://github.com/remobile/react-native-zip)
- [react-native-zip-archive](https://github.com/mockingbot/react-native-zip-archive)
