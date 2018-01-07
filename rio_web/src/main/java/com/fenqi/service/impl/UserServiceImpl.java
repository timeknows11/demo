package com.fenqi.service.impl;

import com.fenqi.dao.IRioDao;
import com.fenqi.pojo.User;
import com.fenqi.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import java.util.concurrent.locks.Lock;
import java.util.concurrent.locks.ReentrantLock;

@Service
public class UserServiceImpl implements UserService {

    @Autowired
    private IRioDao rioDao;

    private Lock lock = new ReentrantLock();


    public int insertAndGetId(User user) {
        int userId = user.getUser_id();
        User findedUser = rioDao.findByUserId(userId);
        // 防止相同userId重复插入,也可做抛出异常处理
        if (findedUser != null) {
            return findedUser.getId();
        }
        rioDao.insertAndGetId(user);
        return user.getId();
    }

    public User findById(int id) {
        return rioDao.findById(id);
    }

    public User findByUserId(int userId) {
        return rioDao.findByUserId(userId);
    }

    public void doUpdate(User user) {
        rioDao.doUpdate(user);
    }

    public void doDelete(int id) {
        rioDao.doDelete(id);
    }

    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public String transferCoins(int from_user_id, int to_user_id, int coins) {
        User fromUser = rioDao.findById(from_user_id);
        User toUser = rioDao.findById(to_user_id);
        if (fromUser == null) {
            return "From User not exist.";
        } else if (toUser == null) {
            return "To User not exist.";
        } else if (fromUser.getCoins() < coins) {
            return "From User's Coins is not enough";
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

        return "Transfer Success.";
    }
}
