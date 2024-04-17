import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Scanner;

/**
 * The type Account manager.
 */
public class AccountManager {
  private Connection connection;

  private Scanner scanner;

  /**
   * Instantiates a new Account manager.
   *
   * @param connection the connection
   */
  public AccountManager(Connection connection) {
    this.connection = connection;
  }

  private void deposit() throws SQLException {
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

  private void withdraw() throws SQLException {
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

  private void searchTransactions() throws SQLException {
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

  private void showTransactions() throws SQLException {
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

  /**
   * Account menu.
   */
  public void accountMenu() {
    while (true) {
      System.out.println("\nAccount Menu: 1. Check balance 2. Deposit 3. Withdraw "
              + "4. Search transaction 5. Back to main menu");
      System.out.print("Enter your choice: ");
      int choice = scanner.nextInt();
      if (choice == 1) {
        // Logic to check account balance
        try {
          Utility utility = new Utility(connection);
          utility.checkBalance();
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
}
