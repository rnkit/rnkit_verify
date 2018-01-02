package io.rnkit.moxie;

import android.app.Application;
import android.support.annotation.Nullable;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.modules.core.DeviceEventManagerModule;
import com.moxie.client.manager.MoxieCallBack;
import com.moxie.client.manager.MoxieCallBackData;
import com.moxie.client.manager.MoxieContext;
import com.moxie.client.manager.MoxieSDK;
import com.moxie.client.model.MxParam;

/**
 * Created by carlos on 2017/8/17.
 * 供JS调用的接口
 */

public class DBJsModule extends ReactContextBaseJavaModule {
    private ReactApplicationContext applicationContext;

    public DBJsModule(ReactApplicationContext reactContext) {
        super(reactContext);
        this.applicationContext = reactContext;
    }

    @Override
    public String getName() {
        return "RNKitMoXie";
    }

    /**
     * 初始化
     *
     * @param userId 客户ID
     * @param apiKey apiKey
     */
    @ReactMethod
    public void initial(String userId, String apiKey) {
        if (StaticUtil.stringVerify(userId, apiKey)) {
            StaticUtil.userId = userId;
            StaticUtil.apiKey = apiKey;
            MoxieSDK.init((Application) applicationContext.getApplicationContext());
        }
    }

    /**
     * 要调用的功能字符串
     */
    @ReactMethod
    public void start(final String function) {
        MxParam mxParam = new MxParam();
        mxParam.setUserId(StaticUtil.userId);
        mxParam.setApiKey(StaticUtil.apiKey);
        mxParam.setFunction(function);
        MoxieSDK.getInstance().start(applicationContext.getCurrentActivity(), mxParam, new MoxieCallBack() {
            @Override
            public boolean callback(MoxieContext moxieContext, MoxieCallBackData moxieCallBackData) {
                if (moxieCallBackData != null) {
                    switch (moxieCallBackData.getCode()) {
                        case MxParam.ResultCode.IMPORTING:
                            if (moxieCallBackData.isLoginDone()) {
                                //任务已经登录成功，发送给客户端一个回调
                                WritableMap params = Arguments.createMap();
                                params.putString("functionName", function);
                                params.putString("taskId",moxieCallBackData.getTaskId());
                                sendEvent(applicationContext, "loginDone", params);
                                moxieContext.finish();

                            }
                            break;
                    }
                }
                return super.callback(moxieContext, moxieCallBackData);
            }

            @Override
            public boolean onError(MoxieContext moxieContext, int i, Throwable throwable) {
                return super.onError(moxieContext, i, throwable);
            }
        });
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
}
