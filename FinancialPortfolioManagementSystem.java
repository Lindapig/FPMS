import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;
import java.util.Scanner;

/**
 * The type Financial portfolio management system.
 */
public class FinancialPortfolioManagementSystem {
  private Scanner scanner;
  private Connection connection;
  private static final String serverName = "localhost";
  private static final int portNumber = 3306;
  private static final String dbName = "fpms";

  private String sqlUserName;
  private String sqlPassword;

  public static String userName;


  /**
   * Instantiates a new Financial portfolio management system.
   *
   * @param scanner    the scanner
   * @param connection the connection
   */
  public FinancialPortfolioManagementSystem(Scanner scanner, Connection connection) {
    this.scanner = scanner;
    this.connection = connection;
  }

  /**
   * Sets sql username.
   *
   * @param username the sql username
   */
  public void setSQLUsername(String username) {
    sqlUserName = username;
  }

  /**
   * Sets sql password.
   *
   * @param password the sql password
   */
  public void setSQLPassword(String password) {
    sqlPassword = password;
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

  public void getConnection() throws SQLException {
    Properties connectionProps = new Properties();
    connectionProps.put("user", this.sqlUserName);
    connectionProps.put("password", this.sqlPassword);
    this.connection = DriverManager.getConnection("jdbc:mysql://"
            + serverName + ":" + portNumber
            + "/" + dbName
            + "?characterEncoding=UTF-8&useSSL=false", connectionProps);
  }

  private void run() throws SQLException {
    try {
      // login to the database system
      getLogin();
      getConnection();
    } catch (Exception e) {
      System.out.println(e.getMessage());
    }
    Utility utility = new Utility(connection, scanner);
    UserManager userManager = new UserManager(connection, scanner);
    SecurityManager securityManager = new SecurityManager(connection, scanner);
    PortfolioManager portfolioManager = new PortfolioManager(connection, scanner);
    WatchlistManager watchlistManager = new WatchlistManager(connection, scanner);
    AccountManager accountManager = new AccountManager(connection, scanner);

    boolean loggedIn = false;
    while (true) {
      utility.welcomeMessage();
      if (!loggedIn) {
        int choice = utility.loginOrRegister();
        if (choice == 1) {
          try {
            utility.setUsername();
            utility.setPassword();
            userName = utility.getUsername();
            loggedIn = userManager.userLogin(userName, utility.getPassword());
          } catch (Exception e) {
            System.out.println(e.getMessage());
          }
        } else if (choice == 2) {
          try {
            userManager.registerUser();
          } catch (Exception e) {
            System.out.println(e.getMessage());
          }
        } else if (choice == 3) {
          System.out.println("Thank you for using FPMS, see you around.");
          connection.close();
          scanner.close();
          break;
        } else {
          System.out.println("Invalid choice. Please try again.");
        }
      } else {
        int menuChoice = utility.displayMainMenu();
        if (menuChoice == 1) {
          try {
            // Securities menu
            securityManager.securitiesMenu();
          } catch (Exception e) {
            System.out.println(e.getMessage());
          }
        } else if (menuChoice == 2) {
          try {
            // Watchlist menu
            watchlistManager.watchlistMenu();
          } catch (Exception e) {
            System.out.println(e.getMessage());
          }
        } else if (menuChoice == 3) {
          try {
            // Portfolio menu
            portfolioManager.portfolioMenu();
          } catch (Exception e) {
            System.out.println(e.getMessage());
          }
        } else if (menuChoice == 4) {
          try {
            // Account menu
            accountManager.accountMenu();
          } catch (Exception e) {
            System.out.println(e.getMessage());
          }
        } else if (menuChoice == 5) {
          loggedIn = false;
        } else if (menuChoice == 6) {
          System.out.println("Thank you for using FPMS, see you around.");
          connection.close();
          scanner.close();
          break;
        } else {
          System.out.println("Invalid choice. Please try again.");
        }
      }
    }
  }

  /**
   * The entry point of application.
   *
   * @param args the input arguments
   */
  public static void main(String[] args) {
    Scanner scanner = new Scanner(System.in);
    FinancialPortfolioManagementSystem fms = new FinancialPortfolioManagementSystem(scanner, null);
    try {
      fms.run();
      scanner.close();
    } catch (SQLException e) {
      System.out.println(e.getMessage());
    }
  }
}

