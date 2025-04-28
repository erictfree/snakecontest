//Helen Radza - Challenge 12
//My plan for the snake challenge was to create a snake with a pretty simple algorthm that allows it to go to the nearest food and avoid other snakes and walls, but make it go super fast to start while other enemies are small, and after its become decently big to slow way down and camp out
//I also included corresponding colors so the snake is red when it is in its fast mode and blue in its slow mode

class HelenRadzaSnake extends Snake {
  HelenRadzaSnake(int x, int y) {
    super(x, y, "HelenRadza");
  }

  void think(ArrayList<Food> food, ArrayList<Snake> snakes) {
    //if score is below 55 go fast, if above go slow
    if (getScore() < 55) {
      updateInterval = 50;
    } else {
      updateInterval = 200;
    }
    
    //gets head location
    PVector head = this.segments.get(0);

    //list of possible directions
    PVector[] possibleDirections = {
      new PVector(1, 0),
      new PVector(-1, 0),
      new PVector(0, 1),
      new PVector(0, -1)
    };

    PVector bestDirection = null;
    float shortestDistance = Float.MAX_VALUE;

    //checks each possible direction
    for (PVector direction : possibleDirections) {
      float dx = direction.x + head.x; // x val after directional movement
      float dy = direction.y + head.y; //y val after directional movement

      //if nothing will collide
      if (!detectCollision(head, direction)) {
        //find closest food and check distance from snake
        Food closestFood = getClosestFood(this, food);
        float newDistance = abs(dx - closestFood.x) + abs(dy - closestFood.y);
        //if its the lowest distance that has been checked, save the value
        if (newDistance < shortestDistance) {
          bestDirection = direction;
          shortestDistance = newDistance;
        }
      }
    }
    //if there is no best direction keep going in the same direction
    if (bestDirection != null) {
      setDirection(bestDirection.x, bestDirection.y);
    }
  }

  //check if the snake will hit another player or the walls using edgeDetect and overlap functions
  boolean detectCollision(PVector head, PVector direction) {
    PVector newPos = new PVector(head.x + direction.x, head.y + direction.y);

    if (edgeDetect(newPos)) {
      return true;
    }
    if (overlap(newPos, snakes)) {
      return true;
    }

    return false;
  }
  
  void drawSegment(int index, float x, float y, float size) {
    push();
    colorMode(HSB);
    //maps colors to number of segments, range of h value changes based on score
    int c;
    if (score < 55) {
      c = int(map(index,0,this.segments.size(), 0, 40));
    } else {

      c = int(map(index,0,this.segments.size(), 140, 180));
    }
    fill(c,255,255);
    strokeWeight(3);
    stroke(c,180,255);
    rect(
      x,
      y,
      size,
      size,
      5 
      );
      pop();
  }
  Food getClosestFood(Snake snake, ArrayList<Food> food) {
  float min = 1000;
  Food closestFood = null;
  PVector head = snake.segments.get(0);
   
  //go through array of all food
  for (int i = 0; i < food.size(); i++) {
    Food currentFood = food.get(i);
    PVector pos = new PVector(currentFood.x, currentFood.y);
    //find the distance of the food from the head
    float distance = PVector.dist(head, pos);
    //if the distance is less than the smallest distance found so far save the distance and which food it is
    if (distance < min) {
      min = distance;
      closestFood = currentFood;
    }
  }
  return closestFood;
}
}
