// HeatherKimSnake class - moves towards food but avoids collisions with snakes and walls

class HeatherKimSnake extends Snake {
  HeatherKimSnake(int x, int y) {
    super(x, y, "HeatherKim"); 
    this.updateInterval = 150;
  }

  void think(ArrayList<Food> food, ArrayList<Snake> snakes) {
    // get the closest food to the snake's head
    Food closestFood = getClosestFood(this, food);
    PVector head = this.segments.get(0);
    
    // calculate direction towards food
    float dx = closestFood.x - head.x;
    float dy = closestFood.y - head.y;
    PVector dir = null;

    // determine direction based on the relative position of the food
    if (dx > 0) {
      dir = new PVector(1, 0); //  right
    } else if (dx < 0) {
      dir = new PVector(-1, 0); //  left
    } else if (dy > 0) {
      dir = new PVector(0, 1); //  down
    } else if (dy < 0) {
      dir = new PVector(0, -1); //  up
    }

    // check if the next position would hit a wall or snake
    PVector newPos = new PVector(head.x + dir.x, head.y + dir.y);
    if (edgeDetect(newPos)) { // hit wall
      dir = avoidWall(head); // find a direction to avoid wall
    }
    if (overlap(newPos, snakes)) { // hit another snake
      dir = avoidSnake(head, snakes); // find direction to avoid snake
    }

    // set the new direction for the snake
    setDirection(dir.x, dir.y);
  }
  
  // method to avoid walls
  PVector avoidWall(PVector head) {
    PVector[] possibleDirs = {
      new PVector(1, 0),  // right
      new PVector(-1, 0), // left
      new PVector(0, 1),  // down
      new PVector(0, -1)  // up
    };
    
    // try possible directions to avoid wall
    for (PVector dir : possibleDirs) {
      PVector newPos = new PVector(head.x + dir.x, head.y + dir.y);
      
      // check if this new position hits the wall, if not, it's a safe direction
      if (!edgeDetect(newPos)) {
        return dir; // return safe direction
      }
    }
    
    // if no safe direction is found, just move randomly (fallback)
    return new PVector(0, 0); // Return a neutral direction as a fallback
  }
  
  // method to avoid other snakes
  PVector avoidSnake(PVector head, ArrayList<Snake> snakes) {
    // define all possible directions: right, left, down, up
    PVector[] possibleDirs = {
      new PVector(1, 0),  // right
      new PVector(-1, 0), // left
      new PVector(0, 1),  // down
      new PVector(0, -1)  // up
    };

    // try all directions and check for snake collisions
    for (PVector dir : possibleDirs) {
      PVector newPos = new PVector(head.x + dir.x, head.y + dir.y);

      // if this direction doesn't overlap with another snake, it's safe
      if (!overlap(newPos, snakes)) {
        return dir; // Safe direction
      }
    }

    // if no safe direction is found, just move randomly (fallback)
    return new PVector(0, 0); // Neutral fallback direction
  }

  // find the closest food to the snake's head
  Food getClosestFood(Snake snake, ArrayList<Food> food) {
    float min = 1000;
    Food closestFood = null; // fixing the typo here
  
    PVector head = snake.segments.get(0);
    
    // Iterate through all food items and find the closest one
    for (int i = 0; i < food.size(); i++) {
      Food currentFood = food.get(i);
      
      PVector pos = new PVector(currentFood.x, currentFood.y);
      float distance = PVector.dist(head, pos);
      
      // update closest food if we find a closer one
      if (distance < min) {
        min = distance;
        closestFood = currentFood;
      }
    }

    // adjust update interval based on proximity to food
    if (min < 5) {
      updateInterval = 50; // speed up if very close to food, normal speed otherwise
    } else {
      updateInterval = 150; 
    }

    return closestFood;
  }

  // override to draw the snake with pastel colors
  void drawSegment(int index, float x, float y, float size) {
    colorMode(HSB);
    
    // pastel cute colorssss
    float hue = map(index, 0, this.segments.size(), 0, 255);
    float saturation = map(index, 0, this.segments.size(), 100, 200); // lighter pastel shades
    fill(hue, saturation, 255);  // light pastel colors
    
    rect(
      x,
      y,
      size,
      size,
      5  
    );
  }
}
