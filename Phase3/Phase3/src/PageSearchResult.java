import java.sql.*;
import java.util.ArrayList;
import java.util.Scanner;
import java.util.StringJoiner;

public class PageSearchResult {
	private Connection conn;
	private Scanner sc;
	private int orderBy;
	private PageSearch pageSearch;

	public PageSearchResult(Connection conn, Scanner sc) {
		this.conn = conn;
		this.sc = sc;
		this.orderBy = Phase3.ORDER_BY_CHANNEL_NAME;
	}

	public void setPageSearch(PageSearch pageSearch) {
		this.pageSearch = pageSearch;
	}

	public void print() {
		System.out.println();
		System.out.println("[Search Results]");
		System.out.println(
				"CHANNEL_ID               SUBSCRIBER_NUM TOTAL_VIEWS MANAGER     GENRE_NAMES                              PERFORMERS                                                    CHANNEL_NAME             \tDESCRIPTION                                                                                                                         ");
		System.out.println(
				"------------------------ -------------- ----------- ----------- ---------------------------------------- ------------------------------------------------------------- -------------------------\t------------------------------------------------------------------------------------------------------------------------------------");

		try {
			PreparedStatement psSearch = this.pageSearch.psSearch(this.orderBy);
			try (ResultSet rsSearch = psSearch.executeQuery()) {
				while (rsSearch.next()) {
					String channelId = rsSearch.getString(1);
					long subscriberNum = rsSearch.getLong(2);
					long totalViews = rsSearch.getLong(3);
					String manager = rsSearch.getString(4);
					System.out.printf("%-24s %14d %11d %-11s ", channelId, subscriberNum, totalViews, manager);

					try (PreparedStatement psGenreNames = this.conn.prepareStatement(Phase3.sqlGenreNames())) {
						psGenreNames.setString(1, channelId);
						try (ResultSet rsGenreNames = psGenreNames.executeQuery()) {
							ArrayList<String> genreNames = new ArrayList<>();
							while (rsGenreNames.next()) {
								genreNames.add(rsGenreNames.getString(1));
							}
							System.out.printf("%-40s ", String.join(", ", genreNames));
						}
					}

					try (PreparedStatement psPerformers = this.conn.prepareStatement(this.sqlPerformers())) {
						psPerformers.setString(1, channelId);
						try (ResultSet rsPerformers = psPerformers.executeQuery()) {
							ArrayList<String> performers = new ArrayList<>();
							while (rsPerformers.next()) {
								performers.add(
										String.format("%s(%s)", rsPerformers.getString(1), rsPerformers.getString(2)));
							}
							System.out.printf("%-61s ", String.join(", ", performers));
						}
					}
					String channelName = rsSearch.getString(5);
					System.out.printf("%-25s\t", channelName);
					String description = rsSearch.getString(6);
					System.out.printf("%s\n", description);
				}
			}
			psSearch.close();
			this.conn.commit();
			System.out.printf("Order by: %s\n", Phase3.strOrderBy(this.orderBy));
		} catch (SQLException e) {
			System.err.println("sql error = " + e.getMessage());
			System.exit(1);
		}
	}

	public void menu() throws NumberFormatException {
		System.out.println();
		System.out.println("1. Change the sort method");
		System.out.println("2. Select channel");
		System.out.println("3. Back");
		System.out.println("4. Exit");
		System.out.print("Select menu: ");

		switch (Integer.parseInt(this.sc.nextLine())) {
		case 1:
			this.changeSortMethod();
			break;
		case 2:
			// TODO 채널 ID 입력하여 선택 후 채널 상세 정보
			break;
		case 3:
			Phase3.page = Phase3.PAGE_SEARCH;
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
			this.orderBy = Phase3.ORDER_BY_CHANNEL_NAME;
			break;
		case 2:
			this.orderBy = Phase3.ORDER_BY_SUBSCRIBER_NUM;
			break;
		case 3:
			this.orderBy = Phase3.ORDER_BY_TOTAL_VIEWS;
			break;
		default:
			throw new NumberFormatException();
		}
	}

	// Type 8
	private String sqlPerformers() {
		StringJoiner sj = new StringJoiner(" ");
		sj.add("SELECT p2.name, p2.character");
		sj.add("FROM channel c, participation p1, performer p2");
		sj.add("WHERE c.channel_id = p1.channel_id");
		sj.add("AND p1.performer_id = p2.performer_id");
		sj.add("AND c.channel_id = ?");
		sj.add("ORDER BY p2.name");
		return sj.toString();
	}
}
