
魔蝎 SDK for [React Native][rn].  

## Getting Started

First, `cd` to your RN project directory, and install RNMK through [rnpm](https://github.com/rnpm/rnpm) . If you don't have rnpm, you can install RNMK from npm with the command `npm i -S rnkit_sensor` and link it manually (see below).

### iOS

```
$ yarn add rnkit_sensor
# or: 
$ npm install -S rnkit_sensor

# then:  
$ react-native link rnkit_moxie
```

#### Manually
1. Add `node_modules/rnkit_moxie/ios/RNKitMoXie.xcodeproj` to your xcode project, usually under the `Libraries` group  

2. Add `libRNKitMoXie.a` (from `Products` under `RNKitMoXie.xcodeproj `) to build target's `Linked Frameworks and Libraries` list  

3. Add `-ObjC` to `Build Settings -> Other Linker Flags`  

4. Add `libz.tbd` to `libBuild phases -> Link Binary With Libraries`  

5. Open the access to albums (some operations need to scan a qrcode): goto `Info.plist` file and add the privacy key according to your requirement:  

	```
	Key:  Privacy - Camera Usage Description   
	Value: 需要您的同意,才能访问相册
	```

### Android

```
$ yarn add rnkit_sensor
# or: 
$ npm install -S rnkit_sensor

# then:  
$ react-native link rnkit_moxie
```

#### Manually

TODO: 

## Usage

example:  

```
import { Platform } from 'react-native';
import RNKitMoXie from "rnkit_moxie";
import { DeviceEventEmitter, NativeEventEmitter } from 'react-native';

_initMoxie () {
    RNKitMoXie.initial('user_id', 'api_key_value')
    if (Platform.OS === 'ios') {
        const moxieEmitter = new NativeEventEmitter(RNKitMoXie)
        const moxieSubscription = moxieEmitter.addListener('loginDone', (e) => {
            this._callbackForMoxie(e)
        });
    } else {
        DeviceEventEmitter.addListener('loginDone', function (e) {
            this._callbackForMoxie(e)
        })
    }
}

_callbackForMoxie(e) {
    console.log('receive functionName: ' + e.functionName)
}
```
