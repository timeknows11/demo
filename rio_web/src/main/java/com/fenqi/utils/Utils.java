package com.fenqi.utils;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;

/**
 * Created by majun on 2018/1/7.
 */
public class Utils {
    public static String executeLinuxCmd(String cmd) {
        System.out.println("got cmd job : " + cmd);
        try {
            String[] cmds = {"/bin/sh","-c",cmd};
            Process pro = Runtime.getRuntime().exec(cmds);
            pro.waitFor();
            InputStream in = pro.getInputStream();
            BufferedReader read = new BufferedReader(new InputStreamReader(in));
            String line = null;
            StringBuilder sb = new StringBuilder();
            while((line = read.readLine())!=null){
                sb.append(line).append("\n");
            }
            return sb.toString();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public static void main(String args[]) {
        String result = executeLinuxCmd("ps -ef|grep tomcat | grep -v grep | awk -F ' ' '{print $2}' | xargs jstack");
        System.out.println(result);
    }
}
