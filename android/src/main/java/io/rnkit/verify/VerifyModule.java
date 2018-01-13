package io.rnkit.verify;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.support.annotation.Nullable;

import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.bridge.WritableNativeMap;
import com.facebook.react.modules.core.DeviceEventManagerModule;

/**
 * Created by carlos on 2017/8/17.
 * 供JS调用的接口
 */

public class VerifyModule extends ReactContextBaseJavaModule {
    private ReactApplicationContext applicationContext;

    public VerifyModule(ReactApplicationContext reactContext) {
        super(reactContext);
        this.applicationContext = reactContext;
        IntentFilter intentFilter = new IntentFilter(VerifyModule.class.getName());
        reactContext.registerReceiver(broadcastReceiver, intentFilter);
    }

    @Override
    public String getName() {
        return "RNKitVerify";
    }

    /**
     * 初始化
     */
    @ReactMethod
    public void start(String url) {
        Intent intent = new Intent(getCurrentActivity(), MyActivity.class);
        intent.putExtra("jsUrl", url);
        getCurrentActivity().startActivity(intent);
    }


    private void sendEvent(ReactContext reactContext,
                           String eventName,
                           @Nullable WritableMap params) {
        reactContext
                .getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
                .emit(eventName, params);
    }

    @Override
    public boolean canOverrideExistingModule() {
        return true;
    }

    BroadcastReceiver broadcastReceiver = new BroadcastReceiver() {
        @Override
        public void onReceive(Context context, Intent intent) {
            if (intent.getAction().equals(VerifyModule.class.getName())) {
                if (intent.getStringExtra("result").equals("success")) {
                    WritableMap writableMap = new WritableNativeMap();
                    writableMap.putString("result", "success");
                    writableMap.putString("ticket", intent.getStringExtra("ticket"));
                    sendEvent(applicationContext, "verifyResult", writableMap);
                } else {
                    WritableMap writableMap = new WritableNativeMap();
                    writableMap.putString("result", "fail");
                    sendEvent(applicationContext, "verifyResult", writableMap);
                }
            }
        }
    };
}
