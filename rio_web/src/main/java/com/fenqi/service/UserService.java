package com.fenqi.service;


import com.fenqi.pojo.User;

public interface UserService {

    /**
     * add a user.
     * @param user
     * @return
     */
    public int insertAndGetId(User user);

    /**
     * find user by id.
     * @param id
     * @return
     */
    public User findById(int id);

    /**
     * find user by userId.
     * @param userId
     * @return
     */
    public User findByUserId(int userId);

    /**
     * Update user by userId.
     * @param user
     */
    public void doUpdate(User user);

    /**
     * Delete user by id.
     * @param id
     */
    public void doDelete(int id);

    /**
     * Transfer Coins.
     * @param from_user_id
     * @param to_user_id
     * @param coins
     * @return Result.
     */
    public String transferCoins(int from_user_id, int to_user_id, int coins);
}
