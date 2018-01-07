package com.fenqi.controller;

import com.fenqi.pojo.User;
import com.fenqi.service.UserService;
import com.google.gson.Gson;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Random;

@Controller
@RequestMapping(value = "/")
public class RioController {

    private static Logger log = Logger.getLogger("RioController.class");

    @Autowired
    private UserService userService;

    @RequestMapping(value = "/coins/user/{id}", method = RequestMethod.GET)
    public void findUserCoinById(@PathVariable("id") int id,
                                 HttpServletRequest request, HttpServletResponse response) {
        response.setHeader("Content-type", "text/html;charset=UTF-8");

        User user = userService.findById(id);

        try {
            response.getWriter().write("用户信息为：" + new Gson().toJson(user));
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    @RequestMapping(value = "/user/add/{user_id}/{coins}", method = RequestMethod.GET)
    public void addUserCoins(@PathVariable("user_id") int userId, @PathVariable("coins") int coins,
                             HttpServletRequest request, HttpServletResponse response) {
        response.setHeader("Content-type", "text/html;charset=UTF-8");
        User user = new User();
        user.setUser_id(userId);
        user.setCoins(coins);
        int id = userService.insertAndGetId(user);

        try {
            response.getWriter().write("添加成功，其主键为：" + id);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    @RequestMapping(value = "/transaction/transfer/{from_user_id}/{to_user_id}/{coins}", method = RequestMethod.GET)
    public void transferCoins(@PathVariable("from_user_id") int from_user_id, @PathVariable("to_user_id") int to_user_id,
                              @PathVariable("coins") int coins,
                              HttpServletRequest request, HttpServletResponse response) {
        response.setHeader("Content-type", "text/html;charset=UTF-8");
        String result = userService.transferCoins(from_user_id, to_user_id, coins);

        try {
            response.getWriter().write("Transfer结果为：" + result);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

}
