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

  private String username;

  private String password;

  /**
   * Sets username.
   *
   *
   */
  public void setUsername() {
    System.out.println("Please enter your username");
    if (scanner.hasNext()) {
      username = scanner.next().toLowerCase();
    }
  }

  /**
   * Sets password.
   *
   *
   */
  public void setPassword() {
    System.out.println("Please enter your password");
    if (scanner.hasNext()) {
      password = scanner.next();
    }
  }

  /**
   * Gets username.
   *
   * @return the username
   */
  public String getUsername() {
    return this.username;
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
   * Instantiates a new Utility.
   *
   * @param connection the connection
   */
  public Utility(Connection connection, Scanner scanner) {
    this.connection = connection;
    this.scanner = scanner;
  }

  /**
   * Welcome message.
   */
  public void welcomeMessage() {
    System.out.println("=====================================================");
    System.out.println("Welcome to the Financial Portfolio Management System.");
  }

  /**
   * Login or register int.
   *
   * @return the int
   */
  public int loginOrRegister() {
    System.out.println("1. Login 2. Register 3. Exit");
    System.out.println("Enter your choice: ");
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
    stmt.setString(1, FinancialPortfolioManagementSystem.userName);
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
