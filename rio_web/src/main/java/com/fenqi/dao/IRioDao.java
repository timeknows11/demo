package com.fenqi.dao;

import com.fenqi.pojo.User;

/**
 * Created by majun on 2018/1/7.
 */
public interface IRioDao {
    public int insertAndGetId(User user);

    public User findById(int id);

    public User findByUserId(int userId);

    public void doUpdate(User user);

    public void doDelete(int id);
}
