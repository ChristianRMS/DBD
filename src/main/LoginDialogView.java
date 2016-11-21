package main;
import java.awt.Container;
import java.awt.Dimension;
import java.awt.GridBagConstraints;
import java.awt.GridBagLayout;
import java.awt.Insets;
import java.awt.Label;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.WindowAdapter;
import java.awt.event.WindowEvent;
import java.awt.event.WindowListener;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

import javax.swing.JButton;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JOptionPane;
import javax.swing.JPasswordField;
import javax.swing.JTextField;





/*
 * Created on 23.11.2006 by mb
 *
 */

public class LoginDialogView extends JFrame implements ActionListener {
	

	private JTextField usernameField;

	private JTextField passwordField;

	private JButton loginButton;

	private JButton cancelButton;

	private Connection conn;

	private boolean loggedIn;
	


	LoginDialogView() {

		super("Login");

		WindowListener l = new WindowAdapter() {
			public void windowClosing(WindowEvent e) {
				System.exit(0);
			}
		};
		addWindowListener(l);

		setSize(300, 140);
		setLocation(200, 200);
		addControls();
		conn = null;
		loggedIn = false;
		setVisible(true);

		waitForLogin();
		
		setVisible(false);
	
	}

	private void addControls() {

		Container contentPane = this.getContentPane();
		contentPane.setLayout(new GridBagLayout());
		GridBagConstraints c = new GridBagConstraints();

		JLabel label1 = new JLabel("User:", Label.RIGHT);
		c.insets = new Insets(2, 2, 2, 2);
		c.gridx = 0;
		c.gridy = 0;
		contentPane.add(label1, c);
		usernameField = new JTextField("", 60);
		usernameField.setMinimumSize(new Dimension(180, 30));
		c.gridx = 1;
		contentPane.add(usernameField, c);
		JLabel label2 = new JLabel("Password:", Label.RIGHT);
		c.gridx = 0;
		c.gridy = 1;
		contentPane.add(label2, c);
		passwordField = new JPasswordField("", 60);
		passwordField.setMinimumSize(new Dimension(180, 30));
		passwordField.addActionListener(new PasswortFieldListener());
		c.gridx = 1;
		contentPane.add(passwordField, c);
		loginButton = new JButton("Login");
		loginButton.addActionListener(new LoginButtonListener());
		c.gridx = 0;
		c.gridy = 2;
		contentPane.add(loginButton, c);
		cancelButton = new JButton("Cancel");
		cancelButton.addActionListener(new CancelButtonListener());
		c.gridx = 1;
		contentPane.add(cancelButton, c);
	}

	public void actionPerformed(ActionEvent e) {
	}

	private class LoginButtonListener implements ActionListener {
		public void actionPerformed(ActionEvent e) {

			loggedIn = login(usernameField.getText(), passwordField.getText());

			if (!loggedIn) {
				showMessage("Login nicht erfolgreich (Benutzername/Passwort)!");
			}
		}
	}

	private class PasswortFieldListener implements ActionListener {
		public void actionPerformed(ActionEvent e) {
			loginButton.doClick();
		}
	}

	private class CancelButtonListener implements ActionListener {
		public void actionPerformed(ActionEvent e) {
			System.exit(-1);
		}
	}

	public boolean login(String user, String password) {

		try {
			DriverManager.registerDriver(new oracle.jdbc.driver.OracleDriver());
			conn = DriverManager
					.getConnection(
							"jdbc:oracle:thin:@ora14.informatik.haw-hamburg.de:1521:inf14",
							user, password);
		} catch (SQLException ex) {
			System.err.println(ex.getMessage());
			return false;
		}
		return true;
	}

	private boolean waitForLogin() {

		while (!loggedIn) {
			try {
				Thread.sleep(100);
			} catch (Exception x) {
				x.printStackTrace();
			}
		}
		return true;
	}

	/**
	 * @return the conn
	 */
	public synchronized Connection getConn() {
		return conn;
	}

	/**
	 * @param conn
	 *            the conn to set
	 */
	public synchronized void setConn(Connection conn) {
		this.conn = conn;
	}

	private void showMessage(String text) {
		JOptionPane.showMessageDialog(this, text, "Error",
				JOptionPane.ERROR_MESSAGE);
	}
}
