import java.sql.*;

public class JDBCsql {
    public static void main(String[] args) {
        String url = "jdbc:mysql://localhost:3306/mydatabase";
        String user = "root";
        String password = "it123";

        try {
            // Load the driver
            Class.forName("com.mysql.cj.jdbc.Driver");

            // Establish the connection
            Connection connection = DriverManager.getConnection(url, user, password);
            System.out.println("Connected to the database.");

            // Display all data
            System.out.println("\nInitial Data:");
            displayData(connection);

            // Insert a new record
            insertData(connection, 5, "Karan", "Sales");

            // Update a record
            updateData(connection, 2, "Priya Sharma");

            // Delete a record
            deleteData(connection, 3);

            // Display updated data
            System.out.println("\nUpdated Data:");
            displayData(connection);

            // Close the connection
            connection.close();
            System.out.println("\nConnection closed.");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // Display all records
    private static void displayData(Connection connection) throws SQLException {
        String query = "SELECT * FROM mytable";
        try (Statement stmt = connection.createStatement(); ResultSet rs = stmt.executeQuery(query)) {
            while (rs.next()) {
                System.out.printf("ID: %d, Name: %s, Department: %s%n",
                        rs.getInt("column1"), rs.getString("sname"), rs.getString("department"));
            }
        }
    }

    // Insert a record
    private static void insertData(Connection connection, int id, String name, String department) throws SQLException {
        String query = "INSERT INTO mytable (column1, sname, department) VALUES (?, ?, ?)";
        try (PreparedStatement pstmt = connection.prepareStatement(query)) {
            pstmt.setInt(1, id);
            pstmt.setString(2, name);
            pstmt.setString(3, department);
            int rows = pstmt.executeUpdate();
            System.out.println("Inserted " + rows + " record(s).");
        }
    }

    // Update a record
    private static void updateData(Connection connection, int id, String newName) throws SQLException {
        String query = "UPDATE mytable SET sname = ? WHERE column1 = ?";
        try (PreparedStatement pstmt = connection.prepareStatement(query)) {
            pstmt.setString(1, newName);
            pstmt.setInt(2, id);
            int rows = pstmt.executeUpdate();
            System.out.println("Updated " + rows + " record(s).");
        }
    }

    // Delete a record
    private static void deleteData(Connection connection, int id) throws SQLException {
        String query = "DELETE FROM mytable WHERE column1 = ?";
        try (PreparedStatement pstmt = connection.prepareStatement(query)) {
            pstmt.setInt(1, id);
            int rows = pstmt.executeUpdate();
            System.out.println("Deleted " + rows + " record(s).");
        }
    }
}
