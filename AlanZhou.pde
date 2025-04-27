class AlanZhouSnake extends Snake {
  AlanZhouSnake(int x, int y) {
    super(x, y, "AlanZhou");
  }

  void think(ArrayList<Food> food, ArrayList<Snake> snakes) {
    if (food == null || food.isEmpty()) return;

    // Get current head position
    PVector head = segments.get(0);

    // Find the closest food
    Food closest = null;
    float minDist = Float.MAX_VALUE;
    for (Food f : food) {
      float dist = PVector.dist(head, new PVector(f.x, f.y));
      if (dist < minDist) {
        minDist = dist;
        closest = f;
      }
    }

    if (closest == null) return;

    // Calculate direction toward the food
    float dx = closest.x - head.x;
    float dy = closest.y - head.y;

    // Create possible move directions
    PVector[] possibleDirs = {
      new PVector(1, 0),  // Right
      new PVector(-1, 0), // Left
      new PVector(0, 1),  // Down
      new PVector(0, -1)  // Up
    };

    // Rank directions based on closeness to the food
    ArrayList<PVector> orderedDirs = new ArrayList<PVector>();
    if (abs(dx) > abs(dy)) {
      orderedDirs.add(dx > 0 ? new PVector(1, 0) : new PVector(-1, 0));
      orderedDirs.add(dy > 0 ? new PVector(0, 1) : new PVector(0, -1));
    } else {
      orderedDirs.add(dy > 0 ? new PVector(0, 1) : new PVector(0, -1));
      orderedDirs.add(dx > 0 ? new PVector(1, 0) : new PVector(-1, 0));
    }

    // Add remaining directions not already in the list
    for (PVector dir : possibleDirs) {
      boolean alreadyAdded = false;
      for (PVector added : orderedDirs) {
        if (dir.equals(added)) {
          alreadyAdded = true;
          break;
        }
      }
      if (!alreadyAdded) {
        orderedDirs.add(dir);
      }
    }

    // Try the best direction that isn't a 180-degree turn and doesn't hit anything
    for (PVector dir : orderedDirs) {
      PVector candidate = new PVector(head.x + dir.x, head.y + dir.y);
      // Check for 180-degree turn
      if (direction.x == -dir.x && direction.y == -dir.y) continue;
      // Check collision with other snakes or self
      if (!edgeDetect(candidate) && !overlap(candidate, snakes)) {
        setDirection(dir.x, dir.y);
        return;
      }
    }

    // If all else fails, stay in current direction
    setDirection(direction.x, direction.y);
  }
}
