
public abstract class Player implements Runnable{
	
	final long MOVE_INTERVAL = MainGame.DELAY; 
	
	protected Location location;  // Current location
	protected char direction;     // Current direction
	private int points = 0;     // Number of points
	private volatile Thread thisThread;
	
	public void Player() {
		initalizeLocation();
	}
	
	protected abstract void initalizeLocation();
	
	protected abstract void move();
	
	public abstract void setDirection(char c);
	
	public Location getLocation() {
		return location;
	}
	
	public int getPoints() {
		return points;
	}
	
	public void stopPlaying() {
		thisThread = null;
	}

	public void start() {
		thisThread = new Thread(this);
		thisThread.start();
	}
	
	@Override
	public void run() {
		while( thisThread == Thread.currentThread() ) {
			sleep();
			move();
		}
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
