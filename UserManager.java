import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;

/**
 * The type User manager.
 */
public class UserManager {
  private Connection connection;

  /**
   * Instantiates a new User manager.
   *
   * @param connection the connection
   */
  public UserManager(Connection connection) {
    this.connection = connection;
  }

  /**
   * User login boolean.
   *
   * @param username the username
   * @param password the password
   * @return the boolean
   * @throws SQLException the sql exception
   */
  public boolean userLogin(String username, String password) throws SQLException {
    String query = "{CALL login(?)}";
    CallableStatement stmt = connection.prepareCall(query);
    stmt.setString(1, username);
    stmt.setString(2, password);
    ResultSet rs = stmt.executeQuery();
    if (rs.next()) {
      if (rs.getString(1).equals(password)) {
        System.out.println("Login successfully!");
        return true;
      }
    }
    return false;
  }

  /**
   * Register user.
   *
   * @param username the username
   * @param password the password
   * @param email    the email
   * @throws SQLException the sql exception
   */
  public void registerUser(String username, String password, String email) throws SQLException {
    // Registration logic here
    String query = "{CALL add_new_user(?)}";
    CallableStatement stmt = connection.prepareCall(query);
    stmt.setString(1, username);
    stmt.setString(2, password);
    stmt.setString(3, email);
    // return ????
    System.out.println("User registered successfully!");
  }
}

