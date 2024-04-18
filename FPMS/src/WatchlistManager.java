import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Scanner;

/**
 * The type Watchlist manager.
 */
public class WatchlistManager {
  private Connection connection;

  private Scanner scanner;

  /**
   * Instantiates a new Watchlist manager.
   *
   * @param connection the connection
   */
  public WatchlistManager(Connection connection, Scanner scanner) {
    this.connection = connection;
    this.scanner = scanner;
  }

  private void showWatchList() throws SQLException {
    Utility utility = new Utility(connection, scanner);
    String query = "{CALL show_watchlist(?)}";
    CallableStatement stmt = connection.prepareCall(query);
    stmt.setString(1, utility.getUsername());
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

  private void deleteFromWatchlist(int securityID) throws SQLException {
    String query = "{CALL delete_from_watchlist(?)}";
    CallableStatement stmt = connection.prepareCall(query);
    stmt.setInt(1, securityID);
    String message = "Security" + securityID + "is deleted from the watchlist successfully!";
    System.out.println(message);
  }

  /**
   * Watchlist menu.
   *
   * @throws SQLException the sql exception
   */
  public void watchlistMenu() throws SQLException {
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
          SecurityManager securityManager = new SecurityManager(connection, scanner);
          securityManager.historicalPrice(securityID);
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
}
