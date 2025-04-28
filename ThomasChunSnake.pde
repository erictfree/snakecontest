class ThomasChunSnake extends Snake {
  ThomasChunSnake(int x, int y) {
    super(x, y, "ThomasChun");

  }

  void think(ArrayList<Food> food, ArrayList<Snake> snakes) {
    if (food.isEmpty()) {
      trySafeMove(snakes);
      return;
    }

    PVector head = segments.get(0); // Current head position
    Food nearestFood = null;
    float minDist = Float.MAX_VALUE;

    // Find the nearest food
    for (Food f : food) {
      float d = dist(f.x, f.y, head.x, head.y);
      if (d < minDist) {
        minDist = d;
        nearestFood = f;
      }
    }

    if (nearestFood == null) {
      trySafeMove(snakes);
      return;
    }

    float dx = 0;
    float dy = 0;

    // First try to move horizontally toward the food
    if (nearestFood.x > head.x) {
      dx = 1;
    } else if (nearestFood.x < head.x) {
      dx = -1;
    } else if (nearestFood.y > head.y) {
      dy = 1;
    } else if (nearestFood.y < head.y) {
      dy = -1;
    }

    // Try preferred horizontal/vertical move
    if (isSafeMove(head.x + dx, head.y + dy, snakes)) {
      setDirection(dx, dy);
      return;
    }

    // If horizontal move is not safe, try vertical toward food
    if (dx != 0) {
      dx = 0;
      if (nearestFood.y > head.y) {
        dy = 1;
      } else if (nearestFood.y < head.y) {
        dy = -1;
      }
      if (isSafeMove(head.x + dx, head.y + dy, snakes)) {
        setDirection(dx, dy);
        return;
      }
    }

    // If vertical move is not safe, try horizontal again (other side)
    if (dy != 0) {
      dy = 0;
      if (nearestFood.x > head.x) {
        dx = 1;
      } else if (nearestFood.x < head.x) {
        dx = -1;
      }
      if (isSafeMove(head.x + dx, head.y + dy, snakes)) {
        setDirection(dx, dy);
        return;
      }
    }

    // No good moves toward food: pick any safe move
    trySafeMove(snakes);
  }

  boolean isSafeMove(float newX, float newY, ArrayList<Snake> snakes) {
    PVector pos = new PVector(newX, newY);
    return !edgeDetect(pos) && !overlap(pos, snakes);
  }

  void trySafeMove(ArrayList<Snake> snakes) {
    PVector[] dirs = {
      new PVector(1, 0),
      new PVector(0, 1),
      new PVector(-1, 0),
      new PVector(0, -1)
    };

    PVector head = segments.get(0);

    for (PVector dir : dirs) {
      float newX = head.x + dir.x;
      float newY = head.y + dir.y;
      if (isSafeMove(newX, newY, snakes)) {
        setDirection(dir.x, dir.y);
        return;
      }
    }

    // No safe moves: stay in current direction
  }
}
