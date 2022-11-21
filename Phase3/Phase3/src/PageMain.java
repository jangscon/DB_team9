import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.Scanner;

public class PageMain {
	private Connection conn;
	private Statement stmt;
	private Scanner sc;
	private int orderBy;
	private PageSearch pageSearch;
	private PageChannelInfo pageChannelInfo;

	public PageMain(Connection conn, Statement stmt, Scanner sc) {
		this.conn = conn;
		this.stmt = stmt;
		this.sc = sc;
		this.orderBy = SQL.ORDER_BY_CHANNEL_NAME;
	}

	public void setPageSearch(PageSearch pageSearch) {
		this.pageSearch = pageSearch;
	}

	public void setPageChannelInfo(PageChannelInfo pageChannelInfo) {
		this.pageChannelInfo = pageChannelInfo;
	}

	public void print() {
		System.out.println();
		System.out.println("[YouTube Channel Recommendations]");
		System.out.println(
				"CHANNEL_ID               SUBSCRIBER_NUM TOTAL_VIEWS GENRE_NAMES                              CHANNEL_NAME             ");
		System.out.println(
				"------------------------ -------------- ----------- ---------------------------------------- -------------------------");

		try (ResultSet rsMain = this.stmt.executeQuery(SQL.sqlMain(this.orderBy))) {
			while (rsMain.next()) {
				String channelId = rsMain.getString(1);
				long subscriberNum = rsMain.getLong(2);
				long totalViews = rsMain.getLong(3);
				System.out.printf("%-24s %14d %11d ", channelId, subscriberNum, totalViews);

				try (PreparedStatement psGenreNames = this.conn.prepareStatement(SQL.sqlGenreNames())) {
					psGenreNames.setString(1, channelId);
					try (ResultSet rsGenreNames = psGenreNames.executeQuery()) {
						ArrayList<String> genreNames = new ArrayList<>();
						while (rsGenreNames.next()) {
							genreNames.add(rsGenreNames.getString(1));
						}
						System.out.printf("%-40s ", String.join(", ", genreNames));
					}
				}
				String channelName = rsMain.getString(4);
				System.out.printf("%s\n", channelName);
			}
			System.out.printf("Order by: %s\n", SQL.strOrderBy(this.orderBy));
			this.conn.commit();
		} catch (SQLException e) {
			System.err.println("sql error = " + e.getMessage());
			System.exit(1);
		}
	}

	public void menu() throws NumberFormatException {
		System.out.println();
		System.out.println("1. Change the sort method");
		System.out.println("2. Select channel");
		System.out.println("3. Search channel");
		System.out.println("4. Exit");
		System.out.print("Select menu: ");

		switch (Integer.parseInt(this.sc.nextLine())) {
		case 1:
			this.changeSortMethod();
			break;
		case 2:
			Phase3.page = Phase3.PAGE_CHANNEL_INFO;
			this.selectChannel();
			break;
		case 3:
			Phase3.page = Phase3.PAGE_SEARCH;
			pageSearch.clear();
			break;
		case 4:
			Phase3.flag = false;
			break;
		default:
			throw new NumberFormatException();
		}
	}

	private void changeSortMethod() throws NumberFormatException {
		System.out.println();
		System.out.println("[Change the sort method]");
		System.out.println("1. Channel name");
		System.out.println("2. Number of subscribers");
		System.out.println("3. Total views");
		System.out.print("Select menu: ");

		switch (Integer.parseInt(this.sc.nextLine())) {
		case 1:
			this.orderBy = SQL.ORDER_BY_CHANNEL_NAME;
			break;
		case 2:
			this.orderBy = SQL.ORDER_BY_SUBSCRIBER_NUM;
			break;
		case 3:
			this.orderBy = SQL.ORDER_BY_TOTAL_VIEWS;
			break;
		default:
			throw new NumberFormatException();
		}
	}

	private void selectChannel() {
		System.out.println();
		System.out.println("[Select channel]");
		System.out.print("Enter the channel id: ");

		this.pageChannelInfo.setPreviousPage(Phase3.PAGE_MAIN);
		this.pageChannelInfo.setChannelId(this.sc.nextLine());
	}
}
