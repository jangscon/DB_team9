import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Scanner;

public class Phase3 {
	public static final String URL = "jdbc:oracle:thin:@localhost:1521:orcl";
	public static final String USER_UNIVERSITY = "university";
	public static final String USER_PASSWD = "comp322";

	public static final int PAGE_MAIN = 0;
	public static final int PAGE_SEARCH = 1;
	public static final int PAGE_SEARCH_RESULT = 2;
	public static final int PAGE_CHANNEL_INFO = 3;

	public static boolean flag = true;
	public static int page = 0;

	public static void main(String[] args) {
		try {
			Class.forName("oracle.jdbc.driver.OracleDriver");
		} catch (ClassNotFoundException e) {
			System.err.println("error = " + e.getMessage());
			System.exit(1);
		}

		try (Connection conn = DriverManager.getConnection(URL, USER_UNIVERSITY, USER_PASSWD);
				Statement stmt = conn.createStatement();
				Scanner sc = new Scanner(System.in)) {
			PageMain pageMain = new PageMain(conn, stmt, sc);
			PageSearch pageSearch = new PageSearch(conn, sc);
			PageSearchResult pageSearchResult = new PageSearchResult(conn, sc);
			PageChannelInfo pageChannelInfo = new PageChannelInfo(conn, sc);

			pageMain.setPageSearch(pageSearch);
			pageMain.setPageChannelInfo(pageChannelInfo);
			pageSearchResult.setPageSearch(pageSearch);
			pageSearchResult.setPageChannelInfo(pageChannelInfo);
			conn.setAutoCommit(false);

			while (flag) {
				try {
					switch (page) {
					case PAGE_MAIN:
						pageMain.print();
						pageMain.menu();
						break;
					case PAGE_SEARCH:
						pageSearch.print();
						pageSearch.menu();
						break;
					case PAGE_SEARCH_RESULT:
						pageSearchResult.print();
						pageSearchResult.menu();
						break;
					case PAGE_CHANNEL_INFO:
						pageChannelInfo.print();
						pageChannelInfo.menu();
						break;
					}
				} catch (NumberFormatException e) {
					System.err.println("Please enter a valid value.");
				}
			}
		} catch (SQLException e) {
			System.err.println("sql error = " + e.getMessage());
			System.exit(1);
		}
	}
}
