// KaylieSnake -- The snake initially moves in simple circles until enough snakes have died. Afterwards, it picks up on the nearness of food and moves based on that and snake segments similarly to the hunter snake elements.

class KayliePerezSnake extends Snake {
  KayliePerezSnake(int x, int y) {
    super(x, y, "KayliePerezSnake");
    setDirection(1,0);
  }

  int moveCounter = 0;
  int num = 0;
  int cDir = 0;
  
  void think(ArrayList<Food> food, ArrayList<Snake> snakes) {
    // Define all possible directions: right, left, down, up
   PVector[] possibleDirs = {
      new PVector(1, 0), // Right
      new PVector(0, 1), // Down
      new PVector(-1, 0), // Left
      new PVector(0, -1)  // Up
    };
   
    moveCounter++;
    
    if(moveCounter > ceil(this.segments.size()/2)){ //moves the snake in circles based on its current length
      println(num);
      num++;
      PVector newDir = possibleDirs[num];
      setDirection(newDir.x, newDir.y);
      moveCounter = 0;
      if(num == 3){
        num = -1;
      }
    }
    
    //logic change here: goes after nearest food unless another snake is present
    
    if (countAliveSnakes(snakes) <= 10) { //if there are less than or equal to 10 snakes alive

      Food nearest = null;
      float cDistance = 100000.00; //begin with large distance && initialize nearest food variable
      for (Food foodItem : food) {
        float distance = abs(foodItem.x - segments.get(0).x) + abs(foodItem.y - segments.get(0).y);//calculate distance  based on coords
        if (distance < cDistance) {//updates what is considered the nearest food based on comparison with previous stored value
          cDistance = distance;
          nearest = foodItem;
        }
      }
      if (nearest != null) {
        float xMove = nearest.x > segments.get(0).x ? 1 : (nearest.x < segments.get(0).x ? -1 : 0); //set the x movement right if food is closer to right,  left if food is closer to left
        float yMove = nearest.y > segments.get(0).y ? 1 : (nearest.y < segments.get(0).y ? -1 : 0); //set the y movement up if above, down if below
        if (xMove != 0 && !block(new PVector(segments.get(0).x + xMove, segments.get(0).y), snakes)) {//checks if there are any blockages  before changing direction left or right
          setDirection(xMove, 0);
        } else if (yMove != 0 && !block(new PVector(segments.get(0).x, segments.get(0).y + yMove), snakes)) {//checks if there are any blockages before changing direction up or down
          setDirection(0, yMove);
        } else {
          willCollide(snakes);
        }
      }
    }
  }

  int countAliveSnakes(ArrayList<Snake> snakes) { //sees how many snakes are alive in game
    int aliveCount = 0;
    for (Snake snake : snakes) {
      if (snake.segments.size() > 0) {  // Check if the snake has at least one segment
        aliveCount++;
      }
    }
    return aliveCount;
  }

  boolean block(PVector pos, ArrayList<Snake> snakes) { //tests for possible future collisions
    return edgeDetect(pos) || overlap(pos, snakes);
  }

  void willCollide(ArrayList<Snake> snakes) { //tests each direction to see if there is a possible snake in each direction
    PVector[] possDir = { new PVector(1, 0), new PVector(0, 1), new PVector(-1, 0), new PVector(0, -1) };
    for (PVector dir : possDir) {
      PVector newPos = new PVector(segments.get(0).x + dir.x, segments.get(0).y + dir.y);
      if (!block(newPos, snakes)) { //moves in the first direction where there are no segments detected
        setDirection(dir.x, dir.y);
        return;
      }
    }
  }
}
