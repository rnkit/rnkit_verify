package io.rnkit.moxie;

/**
 * Created by carlos on 2017/8/17.
 * 网络请求方法
 */

class StaticUtil {
    /**
     * 合作方系统中的客户ID
     */
    static String userId = "";
    /**
     * apikey
     */
    static String apiKey = "";

    /**
     * 校验参数不为空，且不为null
     */
    public static boolean stringVerify(String... args) {
        boolean result = false;
        for (String string : args) {
            result = string != null && !string.isEmpty();
            if (!result) {
                break;
            }
        }
        return result;
    }
}
