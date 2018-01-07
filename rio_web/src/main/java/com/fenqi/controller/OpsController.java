package com.fenqi.controller;

import com.fenqi.service.OpsService;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@Controller
@RequestMapping(value = "/")
public class OpsController {
    private static Logger log = Logger.getLogger("OpsController.class");

    @Autowired
    private OpsService opsService;

    @RequestMapping(value = "/ops/jstack", method = RequestMethod.GET)
    public void getJobSummary(HttpServletRequest request, HttpServletResponse response) {
        response.setHeader("Content-type", "text/html;charset=UTF-8");
        String result = opsService.getJstackInfo();

        try {
            response.getWriter().write(result);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }


}
