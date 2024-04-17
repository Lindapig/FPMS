import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;

/**
 * The type Database connector.
 */
public class DatabaseConnector {
  private static final String serverName = "localhost";
  private static final int portNumber = 3306;
  private static final String dbName = "fpms";
  private Connection connection;

  /**
   * Gets connection.
   *
   * @param sqlUsername the sql username
   * @param sqlPassword the sql password
   * @return the connection
   * @throws SQLException the sql exception
   */
  public Connection getConnection(String sqlUsername, String sqlPassword) throws SQLException {
    Properties connectionProps = new Properties();
    connectionProps.put("user", sqlUsername);
    connectionProps.put("password", sqlPassword);
    connection = DriverManager.getConnection("jdbc:mysql://" + serverName + ":" + portNumber + "/" + dbName
            + "?characterEncoding=UTF-8&useSSL=false", connectionProps);
    return connection;
  }
}

