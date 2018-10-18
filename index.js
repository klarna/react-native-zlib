'use strict';

import { NativeModules } from 'react-native';

module.exports = {
    inflate: function (){
        return NativeModules.RNReactNativeZlib.inflate
    },
    deflate: function (){
        return NativeModules.RNReactNativeZlib.deflate
    }
}