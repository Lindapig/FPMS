import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Scanner;

/**
 * The type Utility.
 */
public class Utility {
  private Scanner scanner;
  private Connection connection;
  private String sqlUserName;
  private String sqlPassword;

  private String username;

  private String password;

  /**
   * Sets sql username.
   *
   * @param sqlUsername the sql username
   */
  public void setSQLUsername(String sqlUsername) {
    sqlUserName = sqlUsername;
  }

  /**
   * Sets sql password.
   *
   * @param sqlPassword the sql password
   */
  public void setSQLPassword(String sqlPassword) {
    sqlPassword = sqlPassword;
  }

  /**
   * Gets sql username.
   *
   * @return the sql username
   */
  public String getSQLUsername() {
    return sqlUserName;
  }

  /**
   * Gets sql password.
   *
   * @return the sql password
   */
  public String getSQLPassword() {
    return sqlPassword;
  }

  /**
   * Sets username.
   *
   * @param userName the user name
   */
  public void setUsername(String userName) {
    username = userName;
  }

  /**
   * Sets password.
   *
   * @param password the password
   */
  public void setPassword(String password) {
    password = password;
  }

  /**
   * Gets username.
   *
   * @return the username
   */
  public String getUsername() {
    return username;
  }

  /**
   * Gets password.
   *
   * @return the password
   */
  public String getPassword() {
    return password;
  }

  /**
   * Gets login.
   */
  public void getLogin() {
    System.out.println("Please enter your MySQL username");
    if (scanner.hasNext()) {
      setSQLUsername(scanner.next());
    }
    System.out.println("Please enter your MySQL password");
    if (scanner.hasNext()) {
      setSQLPassword(scanner.next());
    }
  }

  /**
   * Instantiates a new Utility.
   *
   * @param connection the connection
   */
  public Utility(Connection connection) {
    this.connection = connection;
  }

  /**
   * Welcome message.
   */
  public void welcomeMessage() {
    System.out.println("Welcome to the Financial Portfolio Management System.");
  }

  /**
   * Login or register int.
   *
   * @return the int
   */
  public int loginOrRegister() {
    System.out.println("1. Login 2. Register");
    System.out.print("Enter your choice: ");
    if (scanner.hasNext()) {
      return scanner.nextInt();
    }
    return 3;
  }

  /**
   * Display main menu int.
   *
   * @return the int
   */
  public int displayMainMenu() {
    System.out.println("============== Main Menu ==============");
    System.out.println("1. Securities");
    System.out.println("2. Watchlist");
    System.out.println("3. Portfolio");
    System.out.println("4. My Account");
    System.out.println("5. Logout");
    System.out.println("6. Exit");
    System.out.print("Enter your choice: ");
    return scanner.nextInt();
  }

  /**
   * Check balance.
   *
   * @throws SQLException the sql exception
   */
  public void checkBalance() throws SQLException {
    String query = "{CALL check_balance(?)}";
    CallableStatement stmt = connection.prepareCall(query);
    stmt.setString(1, getUsername());
    ResultSet rs = stmt.executeQuery();
    System.out.println("Below is your account balance:");
    System.out.printf("%-10s %-15s%n", "accountID", "accountBalance");
    if (rs.next()) {
      System.out.printf("%-10s %-15s%n",
              rs.getInt(1),
              rs.getFloat(2)
      );
    }
  }
}
