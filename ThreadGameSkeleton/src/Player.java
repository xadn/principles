
public class Player implements Runnable{
	
	public enum DIR {N, S, E, W};
	
	//keeps track of current location
	private Location location; 
	
	//keeps track of current direction: 0 is up,1 is right,2 is down,3 is left
	private DIR direction; 
	
	//keeps track of number of points
	private int points;
	
	// Getter for the current location
	public Location getLocation() {
		return location;
	}

	@Override
	public void run() {
		// TODO Auto-generated method stub
		
	}

}
