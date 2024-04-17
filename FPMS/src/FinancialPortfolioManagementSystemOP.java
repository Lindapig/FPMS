import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Properties;
import java.util.Scanner;

public class FinancialPortfolioManagementSystemOP {
  /*
   * The name of the MySQL account to use
   */
  private String sqlUserName;
  private String username;

  /*
   * The password for the MySQL account
   */
  private String sqlPassword;

  /*
   * The name of the computer running MySQL
   */
  private final String serverName = "localhost";

  /*
   * The port of the MySQL server (default is 3306)
   */
  private final int portNumber = 3306;

  /*
   * The name of the database we are testing with
   */
  private final String dbName = "";

  /**
   * The Connection.
   */
  public Connection connection = null;

  /**
   * The Scanner.
   */
  public Scanner scanner = null;

  /**
   * The Spell type list.
   */
  public static List<String> securityList = new ArrayList<>();

  /**
   * Sets sqlUsername.
   *
   * @param sqlUsername the userName
   */
  public void setSQLUsername(String sqlUsername) {
    this.sqlUserName = sqlUsername;
  }

  /**
   * Sets userName.
   *
   * @param userName the userName
   */
  public void setUsername(String userName) {
    this.username = userName;
  }

  public String getUsername() {
    return this.username;
  }

  /**
   * Sets password.
   *
   * @param sqlPassword the password
   */
  public void setSQLPassword(String sqlPassword) {
    this.sqlPassword = sqlPassword;
  }

  /*
   * Prompt user for the MySQL username and the MySQL password
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
   * Use the user provided username and password to connect to the database
   *
   * @return
   * @throws SQLException the sql exception
   */
  public void getConnection() throws SQLException {
    Properties connectionProps = new Properties();
    connectionProps.put("user", sqlUserName);
    connectionProps.put("password", sqlPassword);

    this.connection = DriverManager.getConnection("jdbc:mysql://"
            + this.serverName + ":" + this.portNumber
            + "/" + this.dbName
            + "?characterEncoding=UTF-8&useSSL=false", connectionProps);
  }

  private void welcomeMessage() {
    System.out.println("Welcome to the Financial Portfolio Management System.");
  }

  private int loginOrRegister() {
    System.out.println("1. Login 2. Register");
    System.out.print("Enter your choice: ");
    if (scanner.hasNext()) {
      return scanner.nextInt();
    }
    return 3;
  }
  public void userLogin() throws SQLException {
    String username = "";
    String password = "";
    System.out.print("\nPlease enter username:");
    if (scanner.hasNext()) {
      username = scanner.next();
    }
    System.out.print("\nPlease enter password");
    if (scanner.hasNext()) {
      password = scanner.next();
    }
    String query = "{CALL login(?)}";
    CallableStatement stmt = connection.prepareCall(query);
    stmt.setString(1, username);
    stmt.setString(2, password);
    ResultSet rs = stmt.executeQuery();
    if (rs.next()) {
      if (rs.getString(1).equals(password)) {
        System.out.println("Login successfully!");
        this.setUsername(username);
      }
    }
  }
  public void getRegistered() throws SQLException {
    String username = "";
    String password = "";
    String email = "";
    System.out.print("\nPlease enter username:");
    if (scanner.hasNext()) {
      username = scanner.next();
    }
    System.out.print("\nPlease enter password");
    if (scanner.hasNext()) {
      password = scanner.next();
    }
    System.out.print("\nPlease enter email:");
    if (scanner.hasNext()) {
      email = scanner.next();
    }
    String query = "{CALL add_new_user(?)}";
    CallableStatement stmt = connection.prepareCall(query);
    stmt.setString(1, username);
    stmt.setString(2, password);
    stmt.setString(3, email);
    // return ????
    System.out.println("User registered successfully!");
  }

  private int displayMainMenu() {
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

  public void getAllSecurities() throws SQLException {
    PreparedStatement ps = connection.prepareStatement("SELECT all FROM security");
    ResultSet rs = ps.executeQuery();
    System.out.println("---------------------- Printing Securities ----------------------");
    System.out.printf("%-10s %-25s %-25s%n", "id", "name", "type");
    while (rs.next()) {
      System.out.printf("%-10s %-25s %-25s%n",
              rs.getInt(1),
              rs.getString(2),
              rs.getString(3)
      );
    }
    rs.close();
    ps.close();
  }

  private void addToWatchlist(int securityID) throws SQLException {
    String query = "{CALL add_to_watchlist(?)}";
    CallableStatement stmt = connection.prepareCall(query);
    stmt.setInt(1, securityID);
    String message = "Security" + securityID + "is added to watchlist successfully!";
    System.out.println(message);
  }

  public void checkBalance() throws SQLException {
    String query = "{CALL check_balance(?)}";
    CallableStatement stmt = connection.prepareCall(query);
    stmt.setString(1, this.getUsername());
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

  public void buySecurity(int securityID, int portfolioID) throws SQLException {
    float amount = 0;
    checkBalance();
    System.out.print("\nPlease enter how many securities do you want to buy?");
    if (scanner.hasNext()) {
      amount = scanner.nextFloat();
    }
    String query = "{CALL buy(?)}";
    CallableStatement stmt = connection.prepareCall(query);
    stmt.setInt(1, securityID);
    stmt.setInt(2, portfolioID);
    stmt.setFloat(3, amount);
    String message = "Bought security " + securityID + " successfully!";
    System.out.println(message);
  }

  public void checkWithholdingSecurity(int securityID) throws SQLException {
    String query = "{CALL check_withholding_security(?)}";
    CallableStatement stmt = connection.prepareCall(query);
    stmt.setInt(1, securityID);
    ResultSet rs = stmt.executeQuery();
    System.out.println("Below is withholding status for this security:");
    System.out.printf("%-10s %-20s %-15s %-10s %-20s %-20s %-20s%n", "securityID", "securityName",
            "securityType", "quantity", "costBase", "marketValue", "gain/loss");
    if (rs.next()) {
      System.out.printf("%-10s %-20s %-15s %-10s %-20s %-20s %-20s%n",
              rs.getInt(1),
              rs.getString(2),
              rs.getString(3),
              rs.getFloat(4),
              rs.getFloat(5),
              rs.getFloat(6),
              rs.getFloat(7)
      );
    }
  }

  public void sellSecurity(int securityID, int portfolioID) throws SQLException {
    checkWithholdingSecurity(securityID);
    float amount = 0;
    System.out.print("\nPlease enter how many securities do you want to sell? ");
    if (scanner.hasNext()) {
      amount = scanner.nextFloat();
    }
    String query = "{CALL sell(?)}";
    CallableStatement stmt = connection.prepareCall(query);
    stmt.setInt(1, securityID);
    stmt.setFloat(2, portfolioID);
    stmt.setFloat(3, amount);
    String message = "Sold security " + securityID + " successfully!";
    System.out.println(message);
  }

  public void historicalPrice(int securityID) throws SQLException {
    String query = "{CALL historical_price(?)}";
    CallableStatement stmt = connection.prepareCall(query);
    stmt.setInt(1, securityID);
    ResultSet rs = stmt.executeQuery();
    System.out.printf("%-10s %-20s %-15s%n", "dataID", "date",
            "marketPrice");
    if (rs.next()) {
      System.out.printf("%-10s %-20s %-15s%n",
              rs.getInt(1),
              rs.getString(2),
              rs.getFloat(3)
      );
    }
  }

  private void selectedSecurityMenu(int securityID) {
    int choice = 0;
    int portfolioID = 0;
    while (true) {
      System.out.println("1. Add to watchlist 2. Buy 3. Sell 4. View historical price 5. Back");
      System.out.print("Enter your choice: ");
      if (scanner.hasNext()) {
        choice = scanner.nextInt();
      }
      if (choice == 1) {
        try {
          addToWatchlist(securityID);
        } catch (SQLException e) {
          System.out.println("Failed to add to the watchlist.");
          System.out.println(e.getMessage());
        }
      } else if (choice == 2) {
        System.out.print("\nPlease enter the portfolioID to put the security in? ");
        if (scanner.hasNext()) {
          portfolioID = scanner.nextInt();
        }
        try {
          buySecurity(securityID, portfolioID);
        } catch (SQLException e) {
          System.out.println("Failed to buy the security.");
          System.out.println(e.getMessage());
        }
      } else if (choice == 3) {
        System.out.print("\nPlease enter the portfolioID to sell the security from? ");
        if (scanner.hasNext()) {
          portfolioID = scanner.nextInt();
        }
        try {
          sellSecurity(securityID, portfolioID);
        } catch (SQLException e) {
          System.out.println("Failed to sell the security.");
          System.out.println(e.getMessage());
        }
      } else if (choice == 4) {
        try {
          historicalPrice(securityID);
        } catch (SQLException e) {
          System.out.println("Failed to review the historical price for the security.");
          System.out.println(e.getMessage());
        }
      } else if (choice == 5) {
        break;
      } else {
        System.out.println("Invalid choice. Please try again.");
      }
    }
  }

  private void selectSecurity(int securityID) throws SQLException {
    String query = "{CALL select_security(?)}";
    CallableStatement stmt = connection.prepareCall(query);
    stmt.setInt(1, securityID);
    ResultSet rs = stmt.executeQuery();
    System.out.printf("%-10s %-20s %-20s %-20s %-10s %-20s %-20s %-20s%n", "id", "name", "type",
            "withholdingQuantity", "portfolioID", "costBase", "marketValue", "Gain/loss");
    if (rs.next()) {
      System.out.printf("%-10s %-20s %-20s %-20s %-10s %-20s %-20s %-20s%n",
              rs.getInt(1),
              rs.getString(2),
              rs.getString(3),
              rs.getFloat(4),
              rs.getInt(5),
              rs.getFloat(6),
              rs.getFloat(7),
              rs.getFloat(8)
      );
    }
    try {
      selectedSecurityMenu(securityID);
    } catch (Exception e) {
      System.out.println(e.getMessage());
    }
  }

  private void securitiesMenu() throws SQLException {
    int menuChoice = 0;
    int securityID = 0;
    while (true) {
      getAllSecurities();
      System.out.println("Securities Menu: 1. Select a security 2. Return to main menu");
      System.out.print("Enter your choice: ");
      if (scanner.hasNext()) {
        menuChoice = scanner.nextInt();
      }
      if (menuChoice == 2) {
        // exit the loop back to the main menu
        break;
      } else if (menuChoice == 1) {
        // implement select security
        System.out.print("Enter the securityID: ");
        if (scanner.hasNext()) {
          securityID = scanner.nextInt();
        }
        try {
          selectSecurity(securityID);
        } catch (SQLException e) {
          System.out.println("Failed to select the security.");
          System.out.println(e.getMessage());
        }
      } else {
        // invalid input continues the loop
        System.out.println("Invalid choice. Please try again.");
      }
    }
  }


  public void showWatchList() throws SQLException {
    String query = "{CALL show_watchlist}";
    CallableStatement stmt = connection.prepareCall(query);
    ResultSet rs = stmt.executeQuery();
    System.out.println("-------- Below is your watchlist --------");
    System.out.printf("%-10s %-20s %-20s%n", "securityID", "securityName", "securityType");
    if (rs.next()) {
      System.out.printf("%-10s %-20s %-20s%n",
              rs.getInt(1),
              rs.getString(2),
              rs.getString(3)
      );
    }
  }

  public void deleteFromWatchlist(int securityID) throws SQLException {
    String query = "{CALL delete_from_watchlist(?)}";
    CallableStatement stmt = connection.prepareCall(query);
    stmt.setInt(1, securityID);
    String message = "Security" + securityID + "is deleted from the watchlist successfully!";
    System.out.println(message);
  }

  private void watchlistMenu() throws SQLException {
    int securityID = 0;
    while (true) {
      showWatchList();
      System.out.println("Watchlist Menu: 1. Select a security 2. Delete a security 3. Back to main menu");
      System.out.print("Enter your choice: ");
      int choice = scanner.nextInt();
      if (choice == 1) {
        // Logic to select security from watchlist to show the historical price
        try {
          System.out.print("Enter the securityID: ");
          if (scanner.hasNext()) {
            securityID = scanner.nextInt();
          }
          historicalPrice(securityID);
        } catch (SQLException e) {
          System.out.println(e.getMessage());
        }
      } else if (choice == 2) {
        // Logic to delete security from watchlist
        try {
          System.out.print("Enter the securityID to be deleted: ");
          if (scanner.hasNext()) {
            securityID = scanner.nextInt();
          }
          deleteFromWatchlist(securityID);
        } catch (SQLException e) {
          System.out.println(e.getMessage());
        }
      } else if (choice == 3) {
        // back the main menu
        break;
      } else {
        System.out.println("Invalid choice. Please try again.");
      }
    }
  }

  public void showPortfolio() throws SQLException {
    String query = "{CALL all_portfolios}";
    CallableStatement stmt = connection.prepareCall(query);
    ResultSet rs = stmt.executeQuery();
    System.out.println("-------- Below are your portfolios --------");
    System.out.printf("%-10s %-20s %-15s %-15s%n", "portfolioID", "portfolioName", "quantity", "gain/loss");
    if (rs.next()) {
      System.out.printf("%-10s %-20s %-15s %-15s%n",
              rs.getInt(1),
              rs.getString(2),
              rs.getFloat(3),
              rs.getFloat(4)
      );
    }
  }

  public void selectedPortfolioMenu(int portfolioID) throws SQLException {
    int choice = 0;
    int securityID = 0;
    while (true) {
      System.out.println("1. Sell 2. Back");
      System.out.print("Enter your choice: ");
      if (scanner.hasNext()) {
        choice = scanner.nextInt();
      }
      if (choice == 1) {
        // Logic to select security
        try {
          System.out.print("Enter the securityID: ");
          if (scanner.hasNext()) {
            securityID = scanner.nextInt();
          }
          sellSecurity(securityID, portfolioID);
        } catch (Exception e) {
          System.out.println("Not able to sell the security.");
          System.out.println(e.getMessage());
        }
      } else if (choice == 2) {
        break;
      } else {
        System.out.println("Invalid choice. Please try again.");
      }
    }
  }

  public void selectPortfolio(int portfolioID) throws SQLException {
    String query = "{CALL select_portfolio(?)}";
    CallableStatement stmt = connection.prepareCall(query);
    stmt.setInt(1, portfolioID);
    ResultSet rs = stmt.executeQuery();
    System.out.printf("%-10s %-20s %-15s %-15s %-10s%n", "securityID",
            "securityName", "quantity", "gain/loss");
    if (rs.next()) {
      System.out.printf("%-10s %-20s %-15s %-15s %-10s%n",
              rs.getInt(1),
              rs.getString(2),
              rs.getFloat(3),
              rs.getFloat(4)
      );
    }
    try {
      selectedPortfolioMenu(portfolioID);
    } catch (SQLException e) {
      System.out.println("Could not proceed with the portfolio with sell/back.");
      System.out.println(e.getMessage());
    }
  }

  private void portfolioMenu() {
    while (true) {
      try {
        showPortfolio();
      } catch (SQLException e) {
        System.out.println(e.getMessage());
      }
      int portfolioID = 0;
      System.out.println("\nPortfolio Menu: 1. Select a portfolio 2. Back to main menu");
      System.out.print("Enter your choice: ");
      int choice = scanner.nextInt();
      if (choice == 1) {
        // Logic to select portfolio
        try {
          System.out.print("Enter the portfolioID: ");
          if (scanner.hasNext()) {
            portfolioID = scanner.nextInt();
          }
          selectPortfolio(portfolioID);
        } catch (Exception e) {
          System.out.println(e.getMessage());
        }
      } else if (choice == 2) {
        break;
      } else {
        System.out.println("Invalid choice. Please try again.");
      }
    }
  }

  public void deposit() throws SQLException {
    float amount = 0;
    System.out.print("\nHow much money($) do you want to deposit in your account? ");
    if (scanner.hasNext()) {
      amount = scanner.nextFloat();
    }
    String query = "{CALL deposit(?)}";
    CallableStatement stmt = connection.prepareCall(query);
    stmt.setFloat(1, amount);
    String message = "Deposit " + amount + " in your account successfully!";
    System.out.println(message);

  }

  public void withdraw() throws SQLException {
    float amount = 0;
    System.out.print("\nHow much money($) do you want to withdraw from your account? ");
    if (scanner.hasNext()) {
      amount = scanner.nextFloat();
    }
    String query = "{CALL withdraw(?)}";
    CallableStatement stmt = connection.prepareCall(query);
    stmt.setFloat(1, amount);
    String message = "Withdraw " + amount + " from your account successfully!";
    System.out.println(message);
  }

  public void searchTransactions() throws SQLException {
    int transactionID = 0;
    System.out.print("\nEnter the transactionID that you want to review? ");
    if (scanner.hasNext()) {
      transactionID = scanner.nextInt();
    }
    String query = "{CALL select_transaction(?)}";
    CallableStatement stmt = connection.prepareCall(query);
    stmt.setInt(1, transactionID);
    ResultSet rs = stmt.executeQuery();
    System.out.printf("%-10s %-15s %-15s %-15s %-20s %-10s %-20s%n", "transactionID", "transactionDate",
            "transactionType", "transactionAmount", "securityName", "securityID", "securityType");
    if (rs.next()) {
      System.out.printf("%-10s %-15s %-15s %-15s %-20s %-10s %-20s%n",
              rs.getInt(1),
              rs.getString(2),
              rs.getString(3),
              rs.getFloat(4),
              rs.getString(5),
              rs.getInt(6),
              rs.getString(7)
      );
    }
  }

  public void showTransactions() throws SQLException {
    String query = "{CALL all_transactions}";
    CallableStatement stmt = connection.prepareCall(query);
    ResultSet rs = stmt.executeQuery();
    System.out.println("-------- Below are all the transactions --------");
    System.out.printf("%-10s %-20s %-20s %-20s%n", "transactionID", "transactionDate",
            "transactionType", "transactionAmount");
    if (rs.next()) {
      System.out.printf("%-10s %-20s %-20s %-20s%n",
              rs.getInt(1),
              rs.getString(2),
              rs.getString(3),
              rs.getFloat(4)
      );
    }
  }
  private void accountMenu() {
    while (true) {
      System.out.println("\nAccount Menu: 1. Check balance 2. Deposit 3. Withdraw "
              + "4. Search transaction 5. Back to main menu");
      System.out.print("Enter your choice: ");
      int choice = scanner.nextInt();
      if (choice == 1) {
        // Logic to check account balance
        try {
          checkBalance();
        } catch (SQLException e) {
          System.out.println("Failed to check the balance.");
          System.out.println(e.getMessage());
        }
      } else if (choice == 2) {
        // Logic for deposit
        try {
          deposit();
        } catch (SQLException e) {
          System.out.println("Failed to deposit.");
          System.out.println(e.getMessage());
        }
      } else if (choice == 3) {
        // Logic for withdrawal
        try {
          withdraw();
        } catch (SQLException e) {
          System.out.println("Failed to withdraw.");
          System.out.println(e.getMessage());
        }
      } else if (choice == 4) {
        // Logic to search transactions
        try {
          showTransactions();
        } catch (SQLException e) {
          System.out.println("Failed to show all transactions.");
          System.out.println(e.getMessage());
        }
        try {
          searchTransactions();
        } catch (SQLException e) {
          System.out.println("Failed to search transactions.");
          System.out.println(e.getMessage());
        }
      } else if (choice == 5) {
        // Logic to return back to main menu
        break;
      } else {
        System.out.println("Invalid choice. Please try again.");
      }
    }
  }


  /**
   * Run the methods defined above.
   */
  public void run() throws SQLException {
    try {
      getConnection();
    } catch (SQLException e) {
      System.out.println("Fail to load the program, please try again.");
      e.printStackTrace();
    }
    boolean loggedIn = false;
    while (true) {
      welcomeMessage();
      if (!loggedIn) {
        int choice = loginOrRegister();
        if (choice == 1) {
          // Logic for login
          userLogin();
          loggedIn = true;
        } else if (choice == 2) {
          // Logic for registration
          getRegistered();
          userLogin();
          loggedIn = true;
        } else {
          System.out.println("Invalid choice. Please try again.");
        }
      } else {
        int menuChoice = displayMainMenu();
        if (menuChoice == 1) {
          securitiesMenu();
        } else if (menuChoice == 2) {
          watchlistMenu();
        } else if (menuChoice == 3) {
          portfolioMenu();
        } else if (menuChoice == 4) {
          accountMenu();
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

  }

  /**
   * Start the application program
   *
   * @param args the input arguments
   */
  public static void main(String[] args) throws Exception {
    FinancialPortfolioManagementSystemOP fmsp = new FinancialPortfolioManagementSystemOP();
    try {
      fmsp.run();
    } catch (Exception e) {
      e.printStackTrace();
    }
  }
}
