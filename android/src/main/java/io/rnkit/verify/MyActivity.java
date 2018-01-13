package io.rnkit.verify;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.view.Display;
import android.view.ViewGroup;
import android.view.Window;
import android.view.WindowManager;
import android.webkit.WebView;
import android.widget.LinearLayout;

import com.token.verifysdk.VerifyCoder;

/**
 * Created by carlos on 2018/1/13.
 */

public class MyActivity extends Activity implements VerifyCoder.VerifyListener {
    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        requestWindowFeature(Window.FEATURE_NO_TITLE);
        WindowManager m = getWindowManager();
        Display d = m.getDefaultDisplay(); // 为获取屏幕宽、高
        android.view.WindowManager.LayoutParams p = getWindow().getAttributes();
        p.height = (int) (d.getHeight() * 0.3); // 高度设置为屏幕的0.3
        p.width = (int) (d.getWidth() * 0.6); // 宽度设置为屏幕的0.7
        getWindow().setAttributes(p);
        setContentView(R.layout.layout_my);
        if (getIntent().getStringExtra("jsUrl") != null) {
            VerifyCoder.getVerifyCoder().setShowtitle(false);
            WebView webView = VerifyCoder.getVerifyCoder().getWebView(this, getIntent().getStringExtra("jsUrl"), this);
            webView.setLayoutParams(new LinearLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.MATCH_PARENT));
            ((LinearLayout) findViewById(R.id.linearLayout)).addView(webView);
        }
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        if (requestCode == 99) {
            if (resultCode == Activity.RESULT_OK) {
                Intent intent = new Intent();
                intent.putExtra("result", "success");
                intent.setAction(VerifyModule.class.getName());
                intent.putExtra("ticket", data.getStringExtra("ticket"));
            } else {
                Intent intent = new Intent();
                intent.putExtra("result", "fail");
                intent.setAction(VerifyModule.class.getName());
                this.sendBroadcast(intent);
            }
        }
        finish();
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
    }

    @Override
    public void onVerifySucc(String s, String s1) {
        Intent intent = new Intent();
        intent.putExtra("result", "success");
        intent.setAction(VerifyModule.class.getName());
        intent.putExtra("ticket", s);
        this.sendBroadcast(intent);
        finish();
    }

    @Override
    public void onVerifyFail() {
        Intent intent = new Intent();
        intent.putExtra("result", "fail");
        intent.setAction(VerifyModule.class.getName());
        this.sendBroadcast(intent);
        finish();
    }
}
