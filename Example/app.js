/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 * @flow
 */

import React, { Component } from 'react';
import { AppRegistry, Text, StyleSheet, View, TouchableHighlight, Platform } from 'react-native';
import RNKitMoXie from "rnkit_moxie";
import { DeviceEventEmitter, NativeEventEmitter } from 'react-native';

export default class App extends Component {
    constructor(props) {
        super(props);
        this.moxieSubscription
        this._initMoxie()
        this.state = {
            count: -3
        }
    }

    componentWillUnmount() {
        if (this.moxieSubscription) {
            // remember to remove
            this.moxieSubscription.remove()
        }
    }

    _initMoxie () {
        RNKitMoXie.initial('15172443007', '3be322fb90ce4af9b85c19577fbdaf5b')
        if (Platform.OS === 'ios') {
            const moxieEmitter = new NativeEventEmitter(RNKitMoXie)
            this.moxieSubscription = moxieEmitter.addListener('loginDone', (e) => {
                this._callbackForMoxie(e)
            })
        } else {
            DeviceEventEmitter.addListener('loginDone', function (e) {
                this._callbackForMoxie(e)
            })
        }
    }

    _callbackForMoxie(e) {
        console.log('接收到事件')
        console.log(e.functionName)
    }

    async _nextPage() {
        console.log("这里执行了")
        RNKitMoXie.start('email');
    }
    render() {

        return (

            <View style={styles.constainer}>

                <TouchableHighlight
                    style={styles.touch}
                    onPress={this._nextPage.bind(this)}>
                    <View>
                        <Text>下一个页面</Text>
                    </View>
                </TouchableHighlight>
            </View>

        )

    }
}


const styles = StyleSheet.create({
    constainer: {
        flex: 1,
        alignItems: 'center',
        justifyContent: 'center',
    },
    touch: {
        marginTop: 20,
        width: 100,
        height: 40,
        backgroundColor: 'green'
    },

});