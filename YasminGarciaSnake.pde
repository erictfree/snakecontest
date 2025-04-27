// Yasmin Garcia
// Strategy: 
// My snake moves toward the nearest food using Manhattan distance. 
// If moving directly toward food would cause a collision, it picks a safe direction instead. 
// It prioritizes survival over aggression.

class YasminGarciaSnake extends Snake {
  
  YasminGarciaSnake(int x, int y) {
    super(x, y, "YasminGarcia");
    updateInterval = 80; // Optional: Adjusts how fast the snake thinks
  }

  @Override
  void think(ArrayList<Food> food, ArrayList<Snake> snakes) {
    Food targetFood = null;
    float closestDistance = Float.MAX_VALUE;
    
    for (Food f : food) {
      float dist = abs(f.x - segments.get(0).x) + abs(f.y - segments.get(0).y);
      if (dist < closestDistance) {
        closestDistance = dist;
        targetFood = f;
      }
    }
    
    if (targetFood != null) {
      float dx = targetFood.x > segments.get(0).x ? 1 : (targetFood.x < segments.get(0).x ? -1 : 0);
      float dy = targetFood.y > segments.get(0).y ? 1 : (targetFood.y < segments.get(0).y ? -1 : 0);
      
      if (dx != 0 && !isDangerous(new PVector(segments.get(0).x + dx, segments.get(0).y), snakes)) {
        setDirection(dx, 0);
      } else if (dy != 0 && !isDangerous(new PVector(segments.get(0).x, segments.get(0).y + dy), snakes)) {
        setDirection(0, dy);
      } else {
        pickSafeDirection(snakes);
      }
    }
  }
  
  boolean isDangerous(PVector pos, ArrayList<Snake> snakes) {
    return edgeDetect(pos) || overlap(pos, snakes);
  }
  
  void pickSafeDirection(ArrayList<Snake> snakes) {
    PVector[] directions = {
      new PVector(1, 0),
      new PVector(0, 1),
      new PVector(-1, 0),
      new PVector(0, -1)
    };
    
    for (PVector dir : directions) {
      PVector nextPos = new PVector(segments.get(0).x + dir.x, segments.get(0).y + dir.y);
      if (!isDangerous(nextPos, snakes)) {
        setDirection(dir.x, dir.y);
        return;
      }
    }
    // If all moves are dangerous, do nothing and pray!
  }
}
