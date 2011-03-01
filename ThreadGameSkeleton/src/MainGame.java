import java.awt.*;
import javax.swing.*;
import java.util.*;
import java.awt.event.*;

public class MainGame extends JFrame{

	GraphicsPanel graphics;	//Graphics to draw the map
	public static final int DELAY = 200;  //Indicates how long to delay between moves
	ArrayList<Player> players; // List of players, with human as player 0

	//Main method runs the game
	public static void main(String[] args) {
		MainGame g = new MainGame();
	}

	//Default constructor initializes objects and starts the game
	public MainGame() {
		super("Thread Game");
		// Create the game grid
		graphics = new GraphicsPanel();
		// Create the list of players
		players = new ArrayList<Player>();
		// ADD YOUR PLAYERS HERE! BE SURE THE HUMAN IS THE FIRST IN THE LIST.

		// Grid can be initialized as soon as the players are added
		graphics.initialize(players); 
				
		//Set up the frame
		add(graphics);
		setDefaultCloseOperation( EXIT_ON_CLOSE );
		setSize( 500, 500 );
		setVisible( true );
		// The game screen is not resizable.
		setResizable(false);
		graphics.updateDisplay();

		// The key listener is added to the frame, easier to capture keystrokes
		addKeyListener(new DirListener());
		//Start the controllers and the update loop
		startGame();
		updateLoop();
	}

	//Starts all players.  Each player should be in its own thread.
	private void startGame(){
		for (Player player : players)
		{
			player.start();
		}
	}

	//Updates the display and checks to see if the game is over
	private void updateLoop(){
		boolean end = false;
		while(!end){
			graphics.updateDisplay();
			try{
				Thread.sleep(DELAY);
			}
			catch(InterruptedException e){
			}
			//If there are no more targets, the game is over. Stop the controllers and end the loop
			if(graphics.noMoreTargets()){
				// Final display of game 
				graphics.updateDisplay();
				stopGame();
				end = true;
			}
		}
	}

	//Stops the controllers and checks to see who won
	private void stopGame(){
		for (Player player : players)
			player.stopPlaying();
		checkWin();
	}

	// Determine which player has the most points. Check for tie.
	// Assumes the method to access a player's points is getPoints - you 
	// may change as needed.
	private void checkWin(){
		int maxPoints = players.get(0).getPoints();
		int maxPlayer = 0;
		boolean tie = false;
		for (int i=1; i<players.size(); i++)
		{
			if (players.get(i).getPoints() > maxPoints)
			{
				maxPoints = players.get(i).getPoints();
				maxPlayer = i;
				tie = false;
			} else if (players.get(i).getPoints() == maxPoints)
			{
				tie = true;
			}
		}
		
		// Assume the human player is first in the list.
		if (tie)
			JOptionPane.showMessageDialog(null, "Game ended in a tie");
		else if (maxPlayer == 0)
			JOptionPane.showMessageDialog(null, "Congratulations, you win!");
		else
			JOptionPane.showMessageDialog(null, "Sorry, computer player " + maxPlayer + " won.");		
	}

	// This class updates the player direction based on keyboard input.
	// Assumes the Player method to set the direction is called setDirection. 
	private class DirListener implements KeyListener{
		private DirListener(){
			requestFocus();
		}

		//Change the player direction if one of the arrow keys is pressed
		public void keyPressed(KeyEvent e){
			int keyCode = e.getKeyCode();
			// Assumes human is first player in list
			Player player = players.get(0);
			switch ( keyCode )
			{
			case KeyEvent.VK_LEFT:
				player.setDirection('L');
				break;
			case KeyEvent.VK_RIGHT:
				player.setDirection('R');
				break;
			case KeyEvent.VK_UP:
				player.setDirection('U');
				break;
			case KeyEvent.VK_DOWN:
				player.setDirection('D');
				break;
			}
		}

		public void keyTyped(KeyEvent e){

		}

		public void keyReleased(KeyEvent e){
		}
	}



	
}
