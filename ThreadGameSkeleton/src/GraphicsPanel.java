import java.awt.*;
import java.awt.geom.*;
import javax.swing.*;
import java.util.*;
public class GraphicsPanel extends JPanel{

	/**
	 * Method GraphicsPanel
	 * This class keeps track of the player and computer locations and directions
	 * and draws the map
	 */
	public static final int MAX_X = 10;		//Maximum x-coordinate
	public static final int MAX_Y = 10;		//Maximum y-coordinate
	public static final int SIZE = 30;		//Size of player dots in pixels
	public static final int NUMBER_BLOCKS = 30;//Number of blocked spaces
	public static final int NUMBER_TARGETS = 10;//Number of target spaces
	ArrayList<Location> blockedLocs;	 //Array list to store blocked locations
	ArrayList<Location> targetLocs;		 //Array list to store target locations
	ArrayList<Player> players;

	//Default constructor
	public GraphicsPanel()
	{
	}

	//Initializes the map, including blocked locations and target locations. Calls validate map to
	//ensure the map is valid
	public void initialize(ArrayList<Player> players){
		// Store list of players created by MainGame
		this.players = players;
		// Loop until you have a valid board configuration
		do 
		{
			//Initialize lists of targets and blocks
			blockedLocs = new ArrayList<Location>();
			targetLocs = new ArrayList<Location>();
			// call addItem to add blocks, checkTargets is false (no targets yet)
			addItem(NUMBER_BLOCKS, blockedLocs, false);
			// call addItem to add targets, checkTargets is true (don't want 2 targets at
			// same location.
			addItem(NUMBER_TARGETS, targetLocs, true);
		} while(!validateMap());		
	}

	// Adds a number of items to the game
	private void addItem(int numToAdd, ArrayList<Location> locations, boolean checkTargets)
	{
		Random rand = new Random(); //Random number generate to determine locations of spaces randomly		
		for(int i = 0; i < numToAdd; i++)
		{
			//Generate random location
			Location newItem = new Location(rand.nextInt(MAX_X),rand.nextInt(MAX_Y));
			// Start by assuming no conflicts with a block or target
			boolean conflict = false;
			//Check to see if this location is already blocked
			for(int j = 0; j < blockedLocs.size(); j++){
				if(newItem.equals(blockedLocs.get(j))){
					conflict = true;
				}
			}
			// blocks are added first, don't need to check targets
			if (checkTargets)
			{
				//Check to see if this location is already a target
				for(int j = 0; j < targetLocs.size(); j++){
					if(newItem.equals(targetLocs.get(j))){
						conflict = true;
					}
				}
			}
			// Add the location only if it is not already blocked and is not the starting location 
			// for one of the players
			for (Player player : players)
			{
				if (newItem.equals(player.getLocation()))
					conflict = true;
			}
			// If any conflict, we did not add an item, so redo this attempt 
			if(conflict){
				i--;
			}
			else{
				locations.add(newItem);
			}
		}
	}

	// Verifies that the map that has been generated is valid, i.e., that all players can get to 
	// every target. Calls getPossibleLocs to get all of the locations the player
	// can reach. The map is valid if each player can reach all targets.
	private boolean validateMap(){
		for (Player player : players)
		{
			ArrayList<Location> possibleLocs = getPossibleLocs(player.getLocation(),new ArrayList<Location>());
			for(int i = 0; i < targetLocs.size(); i++){
				boolean foundTarget = false;
				for(int j = 0; j < possibleLocs.size(); j++){
					if(targetLocs.get(i).equals(possibleLocs.get(j))){
						foundTarget = true;
					}
				}
				if(!foundTarget){
					return false;
				}
			}			
		}

		return true;
	}

	//Returns an ArrayList containing all of the locations that can be reached from the
	//location l by making recursive calls to getPossibleLocs. The ArrayList visitedLocs
	//contains all locations that have been visited already in previous calls to
	//getPossibleLocs.
	private ArrayList getPossibleLocs(Location l, ArrayList<Location> visitedLocs){
		//If this location is blocked, it cannot be reached. Return an empty ArrayList
		// For this call we don't consider a square to be blocked just because it is 
		// occupied
		if (isBlocked(l, false))
		{
			return new ArrayList<Location>();
		}
		// If this location has already been visited, return an empty ArrayList (so
		// we don't recurse infinitely
		for(int i = 0; i < visitedLocs.size(); i++){
			if(l.equals(visitedLocs.get(i))){
				return new ArrayList<Location>();
			}
		}
		//Create a new ArrayList to add all new locations visited by this call
		ArrayList<Location> newLocs = new ArrayList<Location>();
		//Add this location to visitedLocs
		visitedLocs.add(l);
		//Add this location to newLocs
		newLocs.add(l);
		//Add all locations that can be visited from this location that have not
		//already been visited to newLocs by making recursive calls to getPossibleLocs
		newLocs.addAll(getPossibleLocs(new Location(l.getX()-1,l.getY()), visitedLocs));
		newLocs.addAll(getPossibleLocs(new Location(l.getX()+1,l.getY()), visitedLocs));
		newLocs.addAll(getPossibleLocs(new Location(l.getX(),l.getY()-1), visitedLocs));
		newLocs.addAll(getPossibleLocs(new Location(l.getX(),l.getY()+1), visitedLocs));
		return newLocs;
	}



	//Return true if the given location is blocked or occupied by a player
	//Return false otherwise
	public boolean isBlocked(Location l, boolean playersBlock){
		if (playersBlock)
		{
			//Return true if occupied by any player
			for (Player player : players)
			{
				if (l.equals(player.getLocation()))
					return true;
			}
		}

		//Return true if the location is beyond the edge of the map
		if(l.getX() >= MAX_X || l.getX() < 0 || l.getY() >= MAX_Y || l.getY() < 0){
			return true;
		}

		//Return true if the location is blocked
		for(int i = 0; i < blockedLocs.size(); i++){
			if(l.equals(blockedLocs.get(i))){
				return true;
			}
		}
		//Otherwise return false
		return false;
	}

	//Return true if the given location is a target. Return false otherwise
	public boolean isTarget(Location l){
		//Return true if the location is a target
		for(int i = 0; i < targetLocs.size(); i++){
			if(l.equals(targetLocs.get(i))){
				return true;
			}
		}
		//Return false otherwise
		return false;
	}

	//Return true if the parameter is in targetLocs.  Removes the target.
	//Return false otherwise
	//This method is synchronized because it accesses the map, which is
	//a shared resource (and some other player may attempt to check this location.)
	public synchronized boolean checkForPoint(Location theLoc){
		//If playLoc is in targetLocs, return true and remove playLoc from targetLocs
		for(int i = 0; i < targetLocs.size(); i++){
			if(theLoc.equals(targetLocs.get(i))){
				targetLocs.remove(i);
				return true;
			}
		}
		return false;
	}

	//Returns true if there are no remaining targets. Returns false otherwise
	public boolean noMoreTargets(){
		//If targetLocs.size() is equal to 0, there are no remaining targets. Return true.
		if(targetLocs.size() == 0){
			return true;
		}
		return false;
	}

	//Updates the display. 
	public void updateDisplay()
	{
		repaint();
	}

	//Calls the update function
	public void paintComponent(Graphics g)
	{
		// Need to call a synchronized method. 
		update(g);
	}

	//Updates the map display
	public synchronized void update(Graphics g)
	{
		Graphics2D graphics2D = ( Graphics2D ) g;
		// Clear the field
		graphics2D.setColor(Color.white);
		graphics2D.fill(new Rectangle2D.Double(0,0,MAX_X*SIZE,MAX_Y*SIZE));
		// Draw the human player dot, assume human is first in players list.
		graphics2D.setColor(Color.blue);
		graphics2D.fill(new Ellipse2D.Double(players.get(0).getLocation().getX()*SIZE,
				players.get(0).getLocation().getY()*SIZE,SIZE,SIZE));
		// Draw the computer player dots
		graphics2D.setColor(Color.red);	
		for (int i=1; i<players.size(); i++)
		{
			Player p = players.get(i);
			graphics2D.fill(new Ellipse2D.Double(p.getLocation().getX()*SIZE,
					p.getLocation().getY()*SIZE,SIZE,SIZE));			
		}
		// Draw the grid
		graphics2D.setColor(Color.black);
		for(int i = 0; i < MAX_X; i++){
			for(int j = 0; j < MAX_Y;j++){
				graphics2D.draw( new Rectangle2D.Double(i*SIZE,j*SIZE,SIZE,SIZE) );
			}
		}
		// Draw the blocked locations
		for(int i = 0; i < blockedLocs.size(); i++){
			Location l = blockedLocs.get(i);
			graphics2D.fill(new Rectangle2D.Double(l.getX()*SIZE,l.getY()*SIZE,SIZE,SIZE));
		}
		// Draw the targets
		graphics2D.setColor(Color.green);
		for(int i = 0; i < targetLocs.size(); i++){
			Location l = targetLocs.get(i);
			graphics2D.fill(new Ellipse2D.Double(l.getX()*SIZE + 10, l.getY()*SIZE + 10, SIZE - 20, SIZE - 20));
		}
	}
}
