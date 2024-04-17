import java.sql.Connection;
import java.sql.SQLException;
import java.util.Scanner;

/**
 * The type Financial portfolio management system.
 */
public class FinancialPortfolioManagementSystem {
  private Scanner scanner;
  private Connection connection;

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

  private void run() {
    try {
      Utility utility = new Utility(connection);
      // login to the database system
      utility.getLogin();
      DatabaseConnector connector = new DatabaseConnector();
      connection = connector.getConnection(utility.getSQLUsername(), utility.getSQLPassword());
      UserManager userManager = new UserManager(connection);
      SecurityManager securityManager = new SecurityManager(connection);
      PortfolioManager portfolioManager = new PortfolioManager(connection);
      WatchlistManager watchlistManager = new WatchlistManager(connection);
      AccountManager accountManager = new AccountManager(connection);

      boolean loggedIn = false;
      while (true) {
        utility.welcomeMessage();
        if (!loggedIn) {
          int choice = utility.loginOrRegister();
          if (choice == 1) {
            System.out.println("Please enter your username");
            utility.setUsername(scanner.next());
            System.out.println("Please enter your password");
            utility.setPassword(scanner.next());
            loggedIn = userManager.userLogin(utility.getUsername(), utility.getPassword());
          } else if (choice == 2) {
            System.out.println("Please enter username:");
            String username = scanner.next();
            System.out.println("Please enter password:");
            String password = scanner.next();
            System.out.println("Please enter email:");
            String email = scanner.next();
            userManager.registerUser(username, password, email);
          } else {
            System.out.println("Invalid choice. Please try again.");
          }
        } else {
          int menuChoice = utility.displayMainMenu();
          if (menuChoice == 1) {
            // Securities menu
            securityManager.securitiesMenu();
          } else if (menuChoice == 2) {
            // Watchlist menu
            watchlistManager.watchlistMenu();
          } else if (menuChoice == 3) {
            // Portfolio menu
            portfolioManager.portfolioMenu();
          } else if (menuChoice == 4) {
            // Account menu
            accountManager.accountMenu();
          } else if (menuChoice == 5) {
            loggedIn = false;
            System.out.println("Thank you for using FPMS, see you around.");
          } else if (menuChoice == 6) {
            break;
          } else {
            System.out.println("Invalid choice. Please try again.");
          }
        }
      }
    } catch (SQLException e) {
      System.out.println("Failed to load the program. Please try again.");
      e.printStackTrace();
    } finally {
      try {
        if (connection != null && !connection.isClosed()) {
          connection.close();
        }
      } catch (SQLException e) {
        e.printStackTrace();
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
    fms.run();
    scanner.close();
  }
}

