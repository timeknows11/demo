package com.fenqi.service.impl;

import com.fenqi.service.OpsService;
import com.fenqi.utils.Utils;
import org.springframework.stereotype.Service;

/**
 * Created by majun on 2018/1/7.
 */
@Service
public class OpsServiceImpl implements OpsService {
    public String getJstackInfo() {
        String result = Utils.executeLinuxCmd("ps -ef|grep RemoteMavenServer | grep -v grep | awk -F ' ' '{print $2}' | xargs jstack");
        return result;
    }
}
