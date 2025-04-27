// KalebAzizSnake: Starts with a burst of speed to collect food quickly, then slows down to minimize risk of death. 
// Attempts to eliminate possibilty of making a 180 degree turn;

class KalebAzizSnake extends Snake {
  KalebAzizSnake(int x, int y) {
    super(x, y, "KalebAziz");
    
    updateInterval = 1; //sets the super for the class and starts with a very low update interval
  }

  Food getClosestFood(ArrayList<Food> food, Snake snake) {
    Food closestFood = null;
    float minDistance = 1000;  // initalizes variables

    
    for (int i = 0; i < food.size(); i++) { //for each food
      Food currentFood = food.get(i);  // get the food
      PVector snakePos = snake.segments.get(0); // find the snake's head
      PVector foodPos = new PVector(currentFood.x, currentFood.y); // find the position of the food
      float distance = PVector.dist(snakePos, foodPos); // calculate the distance to the food

      if (distance < minDistance) { // if it's the closest food
        minDistance = distance;
        closestFood = currentFood; // make the closest food so far the food to go to 
      }
    }

    return closestFood; // return the closest food
  }

  void think(ArrayList<Food> food, ArrayList<Snake> snakes) {

    PVector[] possibleDirs = { // list the possible directions
      new PVector(1, 0), // Right
      new PVector(-1, 0), // Left
      new PVector(0, 1), // Down
      new PVector(0, -1)   // Up
    };

    //PVector randomDir = possibleDirs[(int)random(possibleDirs.length)];
    PVector head = this.segments.get(0); // get the head
    PVector bestDir = null; // currently no best direction
    float minDistance = Float.MAX_VALUE; // set a high min distance

    for (PVector dir : possibleDirs) { // for each direction,

      float newX = head.x + dir.x;
      float newY = head.y + dir.y; // the new x and y is the new position

      boolean collision = false; // set collision to false
      if (newX < 0 || newX >= width/GRIDSIZE || newY < 0 || newY >= height/GRIDSIZE) { // if you collide with the edge of the grid
        collision = true; // you have collided
      }

      for (Snake snake : snakes) { // for each snake
        for (PVector segment : snake.segments) { // for each snake segment
          if (newX == segment.x && newY == segment.y) { //if the new position the snake would be at is the same as a segment of an existing snake
            collision = true; // you have collided
            break;
          }
        }
        if (collision == true) break;
        
      }

      if (!collision) { // if there is no position
        Food closestFood = getClosestFood(food, this); // find the closest food
        if (closestFood != null) {
          float distance = abs(newX - closestFood.x) + abs(newY - closestFood.y); // find the distance to the closest food
            if (distance < minDistance) { // if the distance is closest
              if (dir.x != -direction.x || dir.y != -direction.y) { // if the direction isn't opposite (supposedly stops 180 degree turns but fials?
            minDistance = distance; // the smallest distance is the new distance
            bestDir = dir; // the best direction is the direction to the food
              }
          }
        }
      }
    }

    if (bestDir != null) { // if there is a best direction
      setDirection(bestDir.x, bestDir.y); // set the direction to the best direction
      updateInterval += 1; // slow down a lil
    }
  }
  void drawSegment(int index, float x, float y, float size) {
    for (int s = segments.size() - 1; s >= 0; s -= 1) { // for each segment on the snake
      if ((s % 2) != 0) { // if there isn't a remainder when split into 2
        snakeColor = (color(50));    // set snake color to low transparency
      } else {
        snakeColor = (color(500)); // set snake color to high transparency
      }
      stroke(0, 0, 0);
      rect(
        x,
        y,
        size,
        size,
        5  
        );
    }
  }
}
