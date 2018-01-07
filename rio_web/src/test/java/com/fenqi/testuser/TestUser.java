package com.fenqi.testuser;

import com.fenqi.dao.IRioDao;
import com.fenqi.pojo.User;
import com.fenqi.service.UserService;
import org.junit.*;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import java.util.Random;
import java.util.concurrent.locks.Lock;
import java.util.concurrent.locks.ReentrantLock;

/**
 * Created by apple on 2018/1/7.
 */
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = {"classpath:spring-mybatis.xml"})
public class TestUser {

    @Autowired
    private IRioDao rioDao;

    private Lock lock = new ReentrantLock();

    @Before
    public void before() throws Exception {
        User user = new User();
        user.setUser_id(1);
        user.setCoins(10);

        User findedUser = rioDao.findByUserId(1);
        // 防止相同userId重复插入,也可做抛出异常处理
        if (findedUser == null || findedUser.getUser_id() != user.getUser_id()) {
            rioDao.insertAndGetId(user);
        }

        user = new User();
        user.setUser_id(4920);
        user.setCoins(10);

        findedUser = rioDao.findByUserId(4920);
        // 防止相同userId重复插入,也可做抛出异常处理
        if (findedUser == null || findedUser.getUser_id() != user.getUser_id()) {
            rioDao.insertAndGetId(user);
        }

    }

    @After
    public void after() throws Exception {
        User findedUser = rioDao.findByUserId(1);
        if (findedUser != null) {
            findedUser.setCoins(10);
            rioDao.doUpdate(findedUser);
        }
        findedUser = rioDao.findByUserId(4920);
        if (findedUser != null) {
            findedUser.setCoins(10);
            rioDao.doUpdate(findedUser);
        }
    }

    @Test
    public void testInsert() throws Exception {
        User user = new User();
        user.setUser_id(new Random().nextInt(10000));
        user.setCoins(10);


        rioDao.insertAndGetId(user);//插入操作
        System.out.println("插入后主键为：" + user.getId());
    }

    @Test
    public void testSelect() throws Exception {
        User user = rioDao.findByUserId(1);
        Assert.assertEquals(user.getCoins(), 10);
    }

    @Test
    public void testUpdate() throws Exception {
        User user = new User();
        user.setUser_id(1);
        user.setCoins(20);
        rioDao.doUpdate(user);
        Assert.assertEquals(user.getCoins(), 20);
    }

    @Test
    public void testTransferSucc() throws Exception {

        User fromUser = rioDao.findByUserId(1);
        User toUser = rioDao.findByUserId(4920);
        int coins = 10;

        String result = "";
        if (fromUser == null) {
            result = "From User not exist.";
        } else if (toUser == null) {
            result = "To User not exist.";
        } else if (fromUser.getCoins() < coins) {
            result = "From User's Coins is not enough";
        } else {
            try {
                lock.lock();
                fromUser.setCoins(fromUser.getCoins() - coins);
                rioDao.doUpdate(fromUser);
                toUser.setCoins(toUser.getCoins() + coins);
                rioDao.doUpdate(toUser);
            } finally {
                lock.unlock();
            }
        }

        toUser = rioDao.findByUserId(4920);
        Assert.assertEquals(toUser.getCoins(), 20);
    }
}
