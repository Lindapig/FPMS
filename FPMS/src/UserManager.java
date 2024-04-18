import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Scanner;

/**
 * The type User manager.
 */
public class UserManager {
  private Connection connection;

  private Scanner scanner;

  /**
   * Instantiates a new User manager.
   *
   * @param connection the connection
   */
  public UserManager(Connection connection, Scanner scanner) {
    this.connection = connection;
    this.scanner = scanner;
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
    String query = "{CALL get_password(?)}";
    CallableStatement stmt = connection.prepareCall(query);
    stmt.setString(1, username);
    ResultSet rs = stmt.executeQuery();
    if (rs.next()) {
      if (rs.getString(1).equals(password)) {
        System.out.println("Login successfully!");
        return true;
      }
    }
    System.out.println("Cannot Login.");
    return false;
  }

  /**
   * Register user.
   *
   * @throws SQLException the sql exception
   */
  public void registerUser() throws SQLException {
    try {
      System.out.println("Please enter username:");
      String username = scanner.next();
      System.out.println(username);
      System.out.println("Please enter password:");
      String password = scanner.next();
      System.out.println(password);
      System.out.println("Please enter email:");
      String email = scanner.next();
      System.out.println(email);
      // Registration logic here
      String query = "{CALL add_new_user(?, ?, ?)}";
      CallableStatement stmt = connection.prepareCall(query);
      stmt.setString(1, username);
      stmt.setString(2, email);
      stmt.setString(3, password);
      stmt.execute();
      stmt.close();
      System.out.println("User registered successfully!");
    } catch (SQLException e) {
      System.out.println(e.getMessage());
    }
  }
}

