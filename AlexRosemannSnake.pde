// Strategy:
// This snake prioritizes survival first by checking for safe moves that also lead to further safe options (looking 2 moves ahead).
// If possible, it moves safely toward the closest food. If no food is reachable, it moves safely in any available direction.
// It avoids collisions with walls and other snakes, aiming to stay alive as long as possible while opportunistically gathering food.
//This inadvertantly makes my snake its own biggest enemy
//Finally, my snake design is meant to resemble a skeleton

class AlexRosemannSnake extends Snake {
  
  AlexRosemannSnake(int x, int y) {
    super(x, y, "AlexRosemanSnake");
  }

  // Main decision making
  void think(ArrayList<Food> food, ArrayList<Snake> snakes) {
    
    Food target = findClosestFood(food); // Loacate closest food
    
    if (target != null) {
      //println("Found closest food at (" + target.x + ", " + target.y + ")");
      PVector move = safeMoveToward(target, snakes); // Try to go safely toward food
      if (move != null) {
        //println("Moving toward food with move (" + move.x + ", " + move.y + ")");
        setDirection(move.x, move.y);
        return;
      } else {
        //println("No safe move directly toward food. Looking for safest move instead.");
      }
    } else {
      //println("No food found! Looking for safest move.");
    }

    PVector safeMove = findSafestMove(snakes); // If can't go to food, just survive
    if (safeMove != null) {
      //println("Found safe move: (" + safeMove.x + ", " + safeMove.y + ")");
      setDirection(safeMove.x, safeMove.y);
    } else {
      //println("No safe moves available! Staying still (could die soon!)");
    }
  }


  //Determining where the closest food it
  Food findClosestFood(ArrayList<Food> foodList) {
    Food closest = null;
    float minDist = Float.MAX_VALUE;
    for (Food f : foodList) {
      float dist = abs(f.x - head().x) + abs(f.y - head().y);
      if (dist < minDist) {
        minDist = dist;
        closest = f;
      }
    }
    return closest;
  }

  // Try to move safely toward the food
  PVector safeMoveToward(Food target, ArrayList<Snake> snakes) {
    PVector head = head();
    float dx = target.x > head.x ? 1 : target.x < head.x ? -1 : 0;
    float dy = target.y > head.y ? 1 : target.y < head.y ? -1 : 0;
    
    if (dx != 0 && safeNowAndFuture(new PVector(head.x + dx, head.y), snakes)) 
      return new PVector(dx, 0);
    if (dy != 0 && safeNowAndFuture(new PVector(head.x, head.y + dy), snakes)) 
      return new PVector(0, dy);
    
    return null; // No safe path toward food
  }

  // If food is unsafe, find other safe move
  PVector findSafestMove(ArrayList<Snake> snakes) {
    for (PVector dir : directions()) {
      PVector next = new PVector(head().x + dir.x, head().y + dir.y);
      if (safeNowAndFuture(next, snakes)) 
        return dir;
    }
    return null; // No safe options
  }

  // Checks if the position is currently safe
  boolean isSafe(PVector pos, ArrayList<Snake> snakes) {
    return !edgeDetect(pos) && !overlap(pos, snakes);
  }

  // Checks if the move is safe now *and* leads to a safe position after
  boolean safeNowAndFuture(PVector pos, ArrayList<Snake> snakes) {
    if (!isSafe(pos, snakes)) return false;
    for (PVector dir : directions()) {
      PVector next = new PVector(pos.x + dir.x, pos.y + dir.y);
      if (isSafe(next, snakes)) return true;
    }
    return false;
  }

  PVector head() {
    return segments.get(0);  // Assuming segments is a list from the Snake class
  }

  //Movement directions
  PVector[] directions() {
    return new PVector[]{
      new PVector(1, 0), new PVector(0, 1),
      new PVector(-1, 0), new PVector(0, -1)
    };
  }

  //Snake segments
  void drawSegments() {
    for (int i = 0; i < segments.size(); i++) {
      PVector segment = segments.get(i); // Get the segment's position
      drawSegment(i, segment.x, segment.y, 10); // Draw each segment with size 10
    }
  }

  //Skeleton snake
  // Draw the snake white with alternating squares and smaller circles
void drawSegment(int index, float x, float y, float size) {
    push();
    stroke(0);
    fill(255);
    // Alternating between circles and squares
    if (index % 2 == 0) {
        // Draw a square
        rect(x, y, size, size, 5);
    } else {
        // Draw a circle
        ellipse(x + size / 2, y + size / 2, size/1.5, size/1.5);  // Smaller circle
    }
    pop();
  }
}
