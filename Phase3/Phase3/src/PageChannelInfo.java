import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Scanner;

public class PageChannelInfo {
	private Connection conn;
	private Scanner sc;
	private int previousPage;
	private String channelId;

	public PageChannelInfo(Connection conn, Scanner sc) {
		this.conn = conn;
		this.sc = sc;
	}

	public void setPreviousPage(int previousPage) {
		this.previousPage = previousPage;
	}

	public void setChannelId(String channelId) {
		this.channelId = channelId;
	}

	public void print() {
		System.out.println();
		System.out.println("[Channel Info]");

		try (PreparedStatement psChannelInfo = this.conn.prepareStatement(SQL.sqlChannelInfo())) {
			psChannelInfo.setNString(1, channelId);

			try (ResultSet rsChannelInfo = psChannelInfo.executeQuery()) {
				if (rsChannelInfo.next()) {
					String channelId = rsChannelInfo.getString(1);
					String channelName = rsChannelInfo.getString(2);
					String description = rsChannelInfo.getString(3);
					long totalViews = rsChannelInfo.getLong(4);
					long subscriberNum = rsChannelInfo.getLong(5);
					String manager = rsChannelInfo.getString(6);

					System.out.printf("    Channel id: %s\n", channelId);
					System.out.printf("  Channel name: %s\n", channelName);
					System.out.printf("   Description: %s\n", description);
					System.out.printf("   Total views: %d\n", totalViews);
					System.out.printf("Subscriber num: %d\n", subscriberNum);
					System.out.printf("       Manager: %s\n", manager);

					try (PreparedStatement psGenreNames = this.conn.prepareStatement(SQL.sqlGenreNames())) {
						psGenreNames.setString(1, channelId);
						try (ResultSet rsGenreNames = psGenreNames.executeQuery()) {
							ArrayList<String> genreNames = new ArrayList<>();
							while (rsGenreNames.next()) {
								genreNames.add(rsGenreNames.getString(1));
							}
							System.out.printf("   Genre names: %s\n", String.join(", ", genreNames));
						}
					}

					try (PreparedStatement psPerformers = this.conn.prepareStatement(SQL.sqlPerformers())) {
						psPerformers.setString(1, channelId);
						try (ResultSet rsPerformers = psPerformers.executeQuery()) {
							ArrayList<String> performers = new ArrayList<>();
							while (rsPerformers.next()) {
								performers.add(
										String.format("%s(%s)", rsPerformers.getString(1), rsPerformers.getString(2)));
							}
							System.out.printf("    Performers: %s\n", String.join(", ", performers));
						}
					}

					System.out.println();
					System.out.print("Average rating: ");
					try (PreparedStatement psAverageRating = this.conn.prepareStatement(SQL.sqlAverageRating())) {
						psAverageRating.setString(1, channelId);
						try (ResultSet rsAverageRating = psAverageRating.executeQuery()) {
							if (rsAverageRating.next()) {
								double averageRating = rsAverageRating.getDouble(2);
								System.out.println(averageRating);
							} else {
								System.out.println("Not yet evaluated");
							}
						}
					}

					System.out.println();
					System.out.println("      Comments: HEART_NUM MESSAGE");
					System.out.println(
							"                --------- ----------------------------------------------------------------------------------------------------");
					try (PreparedStatement psComments = this.conn.prepareStatement(SQL.sqlComments())) {
						psComments.setString(1, channelId);
						try (ResultSet rsComments = psComments.executeQuery()) {
							while (rsComments.next()) {
								int heartNum = rsComments.getInt(3);
								String message = rsComments.getString(2);

								System.out.printf("                %9d %s\n", heartNum, message);
							}
						}
					}
				}
			}
		} catch (SQLException e) {
			System.err.println("sql error = " + e.getMessage());
			System.exit(1);
		}
	}

	public void menu() throws NumberFormatException {
		System.out.println();
		System.out.println("1. Give rating");
		System.out.println("2. Write comment");
		System.out.println("3. Back");
		System.out.println("4. Exit");
		System.out.print("Select menu: ");

		switch (Integer.parseInt(this.sc.nextLine())) {
		case 1:
			this.giveRating();
			break;
		case 2:
			this.writeComment();
			break;
		case 3:
			Phase3.page = this.previousPage;
			break;
		case 4:
			Phase3.flag = false;
			break;
		default:
			throw new NumberFormatException();
		}
	}

	private void giveRating() throws NumberFormatException {
		System.out.println();
		System.out.println("[Give rating]");
		System.out.print("Enter the rating (1 ~ 10): ");

		double rating = Double.parseDouble(this.sc.nextLine());
		if (rating < 1 || rating > 10)
			throw new NumberFormatException();
		try (PreparedStatement psGiveRating = this.conn.prepareStatement(SQL.sqlGiveRating())) {
			psGiveRating.setString(1, this.channelId);
			psGiveRating.setDouble(2, rating);
			int res = psGiveRating.executeUpdate();
			System.out.println(res + " row updated.");
		} catch (SQLException e) {
			System.err.println("You have already rated this channel.");
		}
	}

	private void writeComment() throws NumberFormatException {
		System.out.println();
		System.out.println("[Write comment]");
		System.out.print("Enter the comment: ");

		String comment = this.sc.nextLine();
		try (PreparedStatement psWriteComment = this.conn.prepareStatement(SQL.sqlWriteComment())) {
			psWriteComment.setString(1, comment);
			psWriteComment.setNString(2, this.channelId);
			int res = psWriteComment.executeUpdate();
			System.out.println(res + " row updated.");
		} catch (SQLException e) {
			System.err.println("sql error = " + e.getMessage());
			System.exit(1);
		}
	}
}
