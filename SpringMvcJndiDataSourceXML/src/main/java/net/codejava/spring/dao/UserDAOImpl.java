package net.codejava.spring.dao;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

import javax.sql.DataSource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;

import net.codejava.spring.model.User;

public class UserDAOImpl implements UserDAO {
	private DataSource dataSource;
	
	@Autowired
	public UserDAOImpl(DataSource dataSource) {
		this.dataSource = dataSource;
	}
	
	@Override
	public List<User> list() {
		JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource);
		String sql = "SELECT * from users";
		List<User> listUser = jdbcTemplate.query(sql, this::mapUser);
		return listUser;
	}

	
	private User mapUser(ResultSet rs, int row) throws SQLException{
		User user = new User();
		user.setId(rs.getInt("user_id"));
		user.setUsername(rs.getString("username"));
		user.setEmail(rs.getString("email"));
		return user;
	}
}
