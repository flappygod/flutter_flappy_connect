package com.flappygo.flutterflappyconnect;

import android.content.Context;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.telephony.TelephonyManager;

public class IntenetUtil {
    //no network
    public static final int NETWORN_NONE = 0;
    //is wifi
    public static final int NETWORN_WIFI = 1;
    public static final int UnCon_WIFI = 7;
    //mobile
    public static final int NETWORN_2G = 2;
    public static final int NETWORN_3G = 3;
    public static final int NETWORN_4G = 4;
    public static final int NETWORN_5G = 5;
    public static final int NETWORN_MOBILE = 6;
    public static final int NETWORN_ETHERNET = 7;

    //get network state
    public static int getNetworkState(Context context) {
        //get mananger
        ConnectivityManager connManager = (ConnectivityManager) context.getSystemService(Context.CONNECTIVITY_SERVICE);
        //none
        if (null == connManager) {
            return NETWORN_NONE;
        }
        //get type
        NetworkInfo activeNetInfo = connManager.getActiveNetworkInfo();
        if (activeNetInfo == null || !activeNetInfo.isAvailable()) {
            return NETWORN_NONE;
        }
        // check is wifi or not
        NetworkInfo wifiInfo = connManager.getNetworkInfo(ConnectivityManager.TYPE_WIFI);
        if (null != wifiInfo) {
            NetworkInfo.State state = wifiInfo.getState();
            if (null != state)
                if (state == NetworkInfo.State.CONNECTED
                        || state == NetworkInfo.State.CONNECTING) {
                    return NETWORN_WIFI;
                } else if (state == NetworkInfo.State.DISCONNECTED) {
                    return UnCon_WIFI;
                }
        }
        // check G
        NetworkInfo networkInfo = connManager.getNetworkInfo(ConnectivityManager.TYPE_MOBILE);
        if (null != networkInfo) {
            NetworkInfo.State state = networkInfo.getState();
            String strSubTypeName = networkInfo.getSubtypeName();
            if (null != state)
                if (state == NetworkInfo.State.CONNECTED
                        || state == NetworkInfo.State.CONNECTING) {
                    switch (activeNetInfo.getSubtype()) {
                        // liantong 2g
                        case TelephonyManager.NETWORK_TYPE_GPRS:
                            // dianxin 2g
                        case TelephonyManager.NETWORK_TYPE_CDMA:
                        case TelephonyManager.NETWORK_TYPE_EDGE:
                            // yidong 2g
                        case TelephonyManager.NETWORK_TYPE_1xRTT:
                        case TelephonyManager.NETWORK_TYPE_IDEN:
                            return NETWORN_2G;
                        //3g
                        case TelephonyManager.NETWORK_TYPE_EVDO_A:
                        case TelephonyManager.NETWORK_TYPE_UMTS:
                        case TelephonyManager.NETWORK_TYPE_EVDO_0:
                        case TelephonyManager.NETWORK_TYPE_HSDPA:
                        case TelephonyManager.NETWORK_TYPE_HSUPA:
                        case TelephonyManager.NETWORK_TYPE_HSPA:
                        case TelephonyManager.NETWORK_TYPE_EVDO_B:
                        case TelephonyManager.NETWORK_TYPE_EHRPD:
                        case TelephonyManager.NETWORK_TYPE_HSPAP:
                            return NETWORN_3G;
                        //4g
                        case TelephonyManager.NETWORK_TYPE_LTE:
                            return NETWORN_4G;
                        //5g
                        case TelephonyManager.NETWORK_TYPE_NR:
                            return NETWORN_5G;
                        default:
                            //3G
                            if (strSubTypeName.equalsIgnoreCase("TD-SCDMA")
                                    || strSubTypeName.equalsIgnoreCase("WCDMA")
                                    || strSubTypeName.equalsIgnoreCase("CDMA2000")) {
                                return NETWORN_3G;
                            } else {
                                return NETWORN_MOBILE;
                            }
                    }
                }
        }
        NetworkInfo EthernetInfo = connManager.getNetworkInfo(ConnectivityManager.TYPE_ETHERNET);
        if (null != EthernetInfo) {
            NetworkInfo.State state = EthernetInfo.getState();
            if (null != state)
                if (state == NetworkInfo.State.CONNECTED || state == NetworkInfo.State.CONNECTING) {
                    return NETWORN_ETHERNET;
                }
        }
        return NETWORN_NONE;
    }
}
