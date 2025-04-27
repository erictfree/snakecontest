//This snake avoids conflict until 5 snakes remain
//It will then look for food or try to intercept other snakes, which ever is closer
class MarcoHurtadoSnake extends Snake {
	MarcoHurtadoSnake(int x, int y) {
		super(x, y, "Marco Hurtado");
		updateInterval = 60;
	}
	
	void think(ArrayList<Food> food, ArrayList<Snake> snakes) {
		float targetx = 0, targety = 0; //Store coords for point of interest 
		Food closestFood = null;
		Snake closestSnake = null;
		float minDist = Float.MAX_VALUE;//Will store the distance to the target
		
		//Find the nearest food 
		for (Food snack : food) {
			float foodDist = abs(snack.x - segments.get(0).x) + abs(snack.y - segments.get(0).y);
			if (foodDist < minDist) {//Set new closest 
				minDist = foodDist;
				closestFood = snack;
				targetx = snack.x;
				targety = snack.y;
			}
		}
		
		//Now do the same for snakes 
		for (Snake snake : snakes) {
			float snakeDist = abs(snake.segments.get(0).x - segments.get(0).x) + abs(snake.segments.get(0).y - segments.get(0).y);
			if (snakeDist < minDist) {
				minDist = snakeDist;
				//Set target ahead of snake 
				targetx = snake.segments.get(0).x+2*snake.direction.x;
				targety = snake.segments.get(0).y+2*snake.direction.y;
			}
		}
		
		if (snakes.size() > 3){//Avoid conflict until there are only 4 snakes
			scan(snakes);
		} else if (closestFood != null || closestSnake != null) {//Move to target 
			float dx = targetx > segments.get(0).x ? 1 : (targetx < segments.get(0).x ? -1 : 0);//Set x direction toward target 
			float dy = targety > segments.get(0).y ? 1 : (targety < segments.get(0).y ? -1 : 0);//Set y direction twoard target
			if (dx != 0 && !willCrash(new PVector(segments.get(0).x + dx, segments.get(0).y), snakes)) {//x collision guard 
				setDirection(dx, 0);
			} else if (dy != 0 && !willCrash(new PVector(segments.get(0).x, segments.get(0).y + dy), snakes)) {//y collision guard 
				setDirection(0, dy);
			}
		} else {//Just avoid conflict anyway 
			scan(snakes);
		}
	}//End of think()
	
	//This function returns true if collision is detected 
	boolean willCrash(PVector pos, ArrayList<Snake> snakes) {
		return edgeDetect(pos) || overlap(pos, snakes);
	}//End of willCrash()
	
	//This function scans clockwise around the head for an available direction to move 
	void scan(ArrayList<Snake> snakes) {
		PVector[] dirs = { new PVector(1, 0), new PVector(0, 1), new PVector(-1, 0), new PVector(0, -1) };
		for (PVector dir : dirs) {//Check collision 
			PVector newPos = new PVector(segments.get(0).x + dir.x, segments.get(0).y + dir.y);//Look ahead 
			if (!willCrash(newPos, snakes)) {
				setDirection(dir.x, dir.y);
				return;
			}
		}
	}//End of scan()
}//End of subclass 
