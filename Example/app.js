/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 * @flow
 */

import React, { Component } from 'react';
import { AppRegistry, Text, StyleSheet, View, TouchableHighlight } from 'react-native';
import RNKitMoXie from "rnkit_moxie";
import { DeviceEventEmitter } from 'react-native';

export default class App extends Component {
    constructor(props) {
        super(props);
        RNKitMoXie.initial('15172443007', '3be322fb90ce4af9b85c19577fbdaf5b');
        DeviceEventEmitter.addListener('loginDone', function (e) {
            console.log('接收到事件');
            console.log(e.functionName);
        });
        this.state = {
            count: -3
        }
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