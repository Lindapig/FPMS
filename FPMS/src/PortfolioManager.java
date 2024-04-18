import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Scanner;

/**
 * The type Portfolio manager.
 */
public class PortfolioManager {
  private Connection connection;

  private Scanner scanner;

  /**
   * Instantiates a new Portfolio manager.
   *
   * @param connection the connection
   */
  public PortfolioManager(Connection connection, Scanner scanner) {
    this.connection = connection;
    this.scanner = scanner;
  }

  private void showPortfolio() throws SQLException {
    String query = "{CALL all_portfolios}";
    PreparedStatement stmt = connection.prepareStatement(query);
    ResultSet rs = stmt.executeQuery();
    System.out.println("------------------ Below are your portfolios ------------------");
    System.out.printf("%-10s %-20s %-15s %-15s%n", "portfolioID", "portfolioName", "quantity", "gain/loss");
    while (rs.next()) {
      System.out.printf("%-10s %-20s %-15s %-15s%n",
              rs.getInt(1),
              rs.getString(2),
              rs.getFloat(3),
              rs.getFloat(4)
      );
    }
    rs.close();
    stmt.close();
  }

  private void selectedPortfolioMenu(int portfolioID) throws SQLException {
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
          SecurityManager securityManager = new SecurityManager(connection, scanner);
          securityManager.sellSecurity(securityID, portfolioID);
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

  private void selectPortfolio(int portfolioID) throws SQLException {
    String query = "{CALL select_portfolio(?)}";
    PreparedStatement stmt = connection.prepareStatement(query);
    stmt.setInt(1, portfolioID);
    ResultSet rs = stmt.executeQuery();
    System.out.printf("%-10s %-20s %-15s %-15s%n", "securityID",
            "securityName", "quantity", "gain/loss");
    while (rs.next()) {
      System.out.printf("%-10s %-20s %-15s %-15s%n",
              rs.getInt(1),
              rs.getString(2),
              rs.getInt(4),
              rs.getFloat(8)
      );
    }
    rs.close();
    stmt.close();
  }

  /**
   * Portfolio menu.
   */
  public void portfolioMenu() {
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
          selectedPortfolioMenu(portfolioID);
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
}

