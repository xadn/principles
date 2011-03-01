
public abstract class Player implements Runnable{
	
	final long MOVE_INTERVAL = MainGame.DELAY; 
	
	private Location location; // Current location
	private char direction;     // Current direction
	private int points = 0;    // Number of points
	Thread thisThread = new Thread(this);
	
	public void Player() {
		initalizeLocation();
	}
	
	protected abstract void initalizeLocation();
	
	public abstract void setDirection(char c);
	
	
	public Location getLocation() {
		return location;
	}
	
	public int getPoints() {
		return points;
	}
	
	public void stopPlaying() {
		
	}

	public void start() {
		this.start();
	}
	
	@Override
	public void run() {
		sleep();
	}
	
	private void sleep()
	{
		try {
			Thread.sleep(MOVE_INTERVAL);
		} catch (InterruptedException e) {
			e.printStackTrace();
		}		
	}



}
