// KeeganBeardSnake class - My stradegy is simple: Get food, avoid snakes, avoid wall. //<>//

class KeeganBeardSnake extends Snake {
  KeeganBeardSnake(int x, int y) {
    super(x, y, "KeeganBeard");
    updateInterval = 80;
  }

  void think(ArrayList<Food> food, ArrayList<Snake> snakes) {
    PVector[] directions = {
      new PVector(1, 0), // Right
      new PVector(-1, 0), // Left
      new PVector(0, 1), // Down
      new PVector(0, -1)   // Up
    };

    Food closestFood = getClosestFood(this, food);
    PVector head = this.segments.get(0);

    float dx = closestFood.x - head.x;  // How far is the closest food from my snake is in the x direction
    float dy = closestFood.y - head.y;  // How far is the closest food from my snake is in the y direction

    PVector dir = null;

    if (dx > 0) {  // if the food is in the positive x direction, then go right
      dir = directions[0];
    } else if (dx < 0) {  // else, if it's in the negative x direction, go left
      dir = directions[1];
    } else if (dy > 0) {  // and if the food is in the positive y direction, go down
      dir = directions[2];
    } else if (dy < 0) {  // if in the negative y direction, go up
      dir = directions[3];
    } else { // default right
      dir = directions[0];
    }

    PVector newPos = new PVector(head.x + dir.x, head.y + dir.y);

    if (edgeDetect(newPos)) { //if my snake is about to hit a wall given its current direction
      for (PVector eachDir : directions) { // check every possible direction
        println("Wall Avoided"); // If they don't hit the wall in 3 steps ahead, then it's safe to go the original direction
        dir = eachDir;
      }
    }

    if (overlap(newPos, snakes)) { //if my snake is about to hit a snake given its current direction
      for (PVector eachDir : directions) { // check every possible direction
        println("Snake Avoided"); // If they don't hit a snake in 3 steps ahead, then it's safe to go the original direction
        dir = eachDir;
      }
    }

    setDirection(dir.x, dir.y);
  }
  Food getClosestFood(Snake snake, ArrayList<Food> food) { // Find out what the closest food to my snake is
  float min = 1000;
  Food closestFood = null;

  PVector head = snake.segments.get(0);

  for (int i = 0; i < food.size(); i++) {
    Food currentFood= food.get(i);

    PVector pos = new PVector(currentFood.x, currentFood.y);

    float distance = PVector.dist(head, pos);

    if (distance < min) {
      min = distance;
      //println("distance is " + distance);
      closestFood = currentFood;
    }
  }
  return closestFood;
}
}
