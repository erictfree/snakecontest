// Wesley Kuykendall
// "The Mildly Hungry Caterpillar"
// This snake is EXTREMELY unconventional, but its strategy has proved incredibly successful.
// It has a complete collision prevention algorithm.
// When the game begins, the snake immediately seeks out the closest piece of food, as usual.
// However, the moment that the snake gains a second segment, it's behavior immediately changes.
// It starts avoiding every single piece of food like the plague in an effort to remain as small as possible.
// From there, it's (hopefully) just a matter of time before every other snake makes a mistake and dies.
// The only possible fail state I've observed is if the snake somehow moves head-first into a single-cell gap surrounded by segments, which has a very low chance of occuring in-game.

class WesleyKuykendallSnake extends Snake {
  WesleyKuykendallSnake(int x, int y) {
    super(x, y, "WesleyKuykendall");
  }

  void think(ArrayList<Food> food, ArrayList<Snake> snakes) {
    Food closestFood = getClosestFood(this, food);

    PVector head = this.segments.get(0);
    PVector myFood = new PVector(closestFood.x, closestFood.y);
    
    PVector dirInput = new PVector(myFood.x - head.x, myFood.y - head.y);
    
    PVector[] allDir = new PVector[4];
    allDir[0] = new PVector (-1, 0); // LEFT
    allDir[1] = new PVector (1, 0); // RIGHT
    allDir[2] = new PVector (0, 1); // UP
    allDir[3] = new PVector (0, -1); // DOWN
    
    PVector dir = allDir[int(random(4))];
    PVector previousDir = dir;
    
    PVector newPos = new PVector(head.x + dir.x, head.y + dir.y);
    
    ArrayList<PVector> safeDirections = new ArrayList<PVector>();
    
    // Collision prevention
    for (PVector oneDir : allDir) {
      dir = oneDir;
      newPos = new PVector(head.x + dir.x, head.y + dir.y);
      
      if (!edgeDetect(newPos) && !overlap(newPos, snakes)) {
        for (int i = 0; i < this.segments.size(); i ++) {
          if (newPos == this.segments.get(i)) {
            //println("DANGER");
          }
          else {
            //println("SAFE");
            safeDirections.add(dir);
          }
        }
      }
    }
    if (safeDirections.size() != 0) {
      int roll = int(random(safeDirections.size()));
      dir = safeDirections.get(roll);
      
      if (-dir.x == previousDir.x || -dir.y == previousDir.y) {
        safeDirections.remove(roll);
        roll = int(random(safeDirections.size()));
        dir = safeDirections.get(roll);
      }
    }
    
    // If snake is 1 segment, search for food
    if (this.segments.size() <= 1) {
      PVector suggestedDir = dir;
      // Pointing Towards Food
      if (dirInput.x > 0) {
        suggestedDir = new PVector(1, 0);
      } else if (dirInput.x < 0) {
        suggestedDir = new PVector(-1, 0);
      } else if (dirInput.y > 0) {
        suggestedDir = new PVector(0, 1);
      } else if (dirInput.y < 0) {
        suggestedDir = new PVector(0, -1);
      }
      
      if (safeDirections.contains(suggestedDir)) {
        dir = suggestedDir;
      }
    }
    // If the snake is 2+ segments, avoid food
    else {
      PVector suggestedDir = dir;
      // Pointing Towards Food
      if (dirInput.x > 0) {
        suggestedDir = new PVector(-1, 0);
      } else if (dirInput.x < 0) {
        suggestedDir = new PVector(1, 0);
      } else if (dirInput.y > 0) {
        suggestedDir = new PVector(0, -1);
      } else if (dirInput.y < 0) {
        suggestedDir = new PVector(0, 1);
      }
      
      if (safeDirections.contains(suggestedDir)) {
        dir = suggestedDir;
      }
    }

    setDirection(dir.x, dir.y);
  }

  Food getClosestFood(Snake snake, ArrayList<Food> food) {
    float min = 1000;
    Food closestFood = null;

    PVector head = snake.segments.get(0);

    for (int i = 0; i < food.size(); i++) { // every piece of food
      Food currentFood = food.get(i);

      PVector pos = new PVector(currentFood.x, currentFood.y);

      float distance = PVector.dist(head, pos);

      if (distance < min) {
        min = distance;
        closestFood = currentFood;
      }
    }
    return closestFood;
  }
  
  // override to change look of snake
  void drawSegment(int index, float x, float y, float size) {
    if (this.segments.size() <= 1) {
      fill(#6eff30);
    }
    else {
      fill(random(255), 0, 0);
    }
    stroke(255);
    println(size);
    rect(x, y, size, size, 5);
  }
}
