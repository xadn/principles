
public class Location {
	int myX;
	int myY;
	/**
	 * Method Location
	 * This class represents an individual location on the map
	 * Stores the x and y coordinates
	 */
	//Constructor accepts an x and y value and stores them
	public Location(int x, int y) {
	   myX=x;
	   myY=y;
	}

	//Getters and setters for x and y
	public int getX(){
		return myX;
	}

    public int getY(){
    	return myY;
    }

    public void setX(int x){
    	myX = x;
    }

    public void setY(int y){
    	myY = y;
    }

	//Returns true if the x and y coordinate of this location are equal to location l's x and y coordinates
	//Returns false
    public boolean equals(Location l){
    	if(l.getX() == myX && l.getY() == myY){
    		return true;
    	}
    	return false;
    }
}
