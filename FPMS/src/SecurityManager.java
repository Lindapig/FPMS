import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Scanner;

/**
 * The type Security manager.
 */
public class SecurityManager {
  private Connection connection;

  private Scanner scanner;

  /**
   * Instantiates a new Security manager.
   *
   * @param connection the connection
   */
  public SecurityManager(Connection connection, Scanner scanner) {
    this.connection = connection;
    this.scanner = scanner;
  }

  private void getAllSecurities() throws SQLException {
    PreparedStatement ps = connection.prepareStatement("SELECT * FROM security");
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

  private void addToWatchlist(int userID, int securityID) throws SQLException {
    String query = "{CALL add_to_watchlist(?, ?)}";
    PreparedStatement stmt = connection.prepareStatement(query);
    stmt.setInt(1, userID);
    stmt.setInt(2, securityID);
    stmt.executeUpdate();
    String message = "Security " + securityID + " is added to watchlist successfully!";
    System.out.println(message);
    stmt.close();
  }

  private void buySecurity(int securityID, int portfolioID) throws SQLException {
    Utility utility = new Utility(connection, scanner);
    float amount = 0;
    utility.checkBalance();
    System.out.print("\nPlease enter how many securities do you want to buy?");
    if (scanner.hasNext()) {
      amount = scanner.nextFloat();
    }
    String query = "{CALL buy(?, ?, ?)}";
    CallableStatement stmt = connection.prepareCall(query);
    stmt.setInt(1, securityID);
    stmt.setInt(2, portfolioID);
    stmt.setFloat(3, amount);
    String message = "Bought security " + securityID + " successfully!";
    System.out.println(message);
  }

  private void checkWithholdingSecurity(int securityID, int portfolioID) throws SQLException {
    String query = "{CALL check_withholding_security(?, ?)}";
    PreparedStatement stmt = connection.prepareStatement(query);
    stmt.setInt(1, securityID);
    stmt.setInt(2, portfolioID);
    ResultSet rs = stmt.executeQuery();
    System.out.println("---------- Below is withholding status for this security ----------");
    System.out.printf("%-10s %-10s %-10s %-15s %-15s %-15s%n", "securityID", "portfolioID",
            "quantity", "costBase", "marketValue", "gain/loss");
    if (rs.next()) {
      System.out.printf("%-10s %-10s %-10s %-15s %-15s %-15s%n",
              rs.getInt(1),
              rs.getInt(2),
              rs.getInt(3),
              rs.getFloat(4),
              rs.getFloat(5),
              rs.getFloat(6)
      );
    }
    rs.close();
    stmt.close();
  }

  /**
   * Sell security.
   *
   * @param securityID  the security id
   * @param portfolioID the portfolio id
   * @throws SQLException the sql exception
   */
  void sellSecurity(int securityID, int portfolioID) throws SQLException {
    checkWithholdingSecurity(securityID, portfolioID);
    int quantity = 0;
    System.out.print("\nPlease enter how many securities do you want to sell? ");
    if (scanner.hasNext()) {
      quantity = scanner.nextInt();
    }
    String query = "{CALL sell(?, ?, ?)}";
    CallableStatement stmt = connection.prepareCall(query);
    stmt.setInt(1, securityID);
    stmt.setInt(2, portfolioID);
    stmt.setInt(3, quantity);
    String message = "Sold security " + securityID + " successfully!";
    System.out.println(message);
  }

  /**
   * Historical price.
   *
   * @param securityID the security id
   * @throws SQLException the sql exception
   */
  public void historicalPrice(int securityID) throws SQLException {
    String query = "{CALL historical_price(?)}";
    PreparedStatement stmt = connection.prepareStatement(query);
    stmt.setInt(1, securityID);
    ResultSet rs = stmt.executeQuery();
    System.out.printf("%-10s %-20s %-15s%n", "dataID", "date", "marketPrice");
    if (rs.next()) {
      System.out.printf("%-10s %-20s %-15s%n",
              rs.getInt(1),
              rs.getString(2),
              rs.getFloat(3)
      );
    }
    rs.close();
    stmt.close();
  }

  private void selectedSecurityMenu(int securityID) {
    int choice = 0;
    int portfolioID = 0;
    int userID = 0; // Initialize user id variable
    while (true) {
      System.out.println("1. Add to watchlist 2. Buy 3. Sell 4. View historical price 5. Back");
      System.out.print("Enter your choice: ");
      if (scanner.hasNext()) {
        choice = scanner.nextInt();
      }
      if (choice == 1) {
        // Prompt user to enter user id
        System.out.print("Enter the amount to add to the watchlist");
        if (scanner.hasNextInt()) {
          userID = scanner.nextInt();
        } else {
          System.out.println("Invalid input for amount. Please enter a valid number.");
          continue; // Continue to the next iteration of the loop
        }
        try {
          addToWatchlist(userID, securityID);
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

  /**
   * Securities menu.
   *
   * @throws SQLException the sql exception
   */
  public void securitiesMenu() throws SQLException {
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
}


