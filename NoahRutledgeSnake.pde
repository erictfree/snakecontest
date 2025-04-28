// SimpleSnake class - moves randomly with no intelligence

class NoahRutledgeSnake extends Snake {
  NoahRutledgeSnake(int x, int y) {
    super(x, y, "NoahRutledge");
 
  }

  @Override
  void think(ArrayList<Food> food, ArrayList<Snake> snakes) {
    PVector head = segments.get(0);
    PVector target = findClosestFood(head, food);

    // Priority: move toward food if it's safe, otherwise move safely
    if (target != null) {
      PVector move = bestDirectionToward(head, target, snakes);
      if (move != null) {
        setDirection(move.x, move.y);
        return;
      }
    }

    // No food found or no safe path to it; pick a safe direction
    PVector safe = findSafeDirection(snakes);
    if (safe != null) {
      setDirection(safe.x, safe.y);
    }
  }

  PVector findClosestFood(PVector head, ArrayList<Food> food) {
    Food closest = null;
    float minDist = Float.MAX_VALUE;
    for (Food f : food) {
      float d = dist(head.x, head.y, f.x, f.y);
      if (d < minDist) {
        minDist = d;
        closest = f;
      }
    }
    return closest != null ? new PVector(closest.x, closest.y) : null;
  }

  PVector bestDirectionToward(PVector from, PVector to, ArrayList<Snake> snakes) {
    PVector[] directions = {
      new PVector(0, -1), // up
      new PVector(0, 1),  // down
      new PVector(-1, 0), // left
      new PVector(1, 0)   // right
    };

    PVector bestDir = null;
    float bestDist = Float.MAX_VALUE;

    for (PVector dir : directions) {
      PVector next = new PVector(from.x + dir.x, from.y + dir.y);
      if (!edgeDetect(next) && !overlap(next, snakes)) {
        float d = dist(next.x, next.y, to.x, to.y);
        if (d < bestDist) {
          bestDist = d;
          bestDir = dir;
        }
      }
    }

    return bestDir;
  }

  PVector findSafeDirection(ArrayList<Snake> snakes) {
    PVector[] directions = {
      new PVector(0, -1), new PVector(0, 1),
      new PVector(-1, 0), new PVector(1, 0)
    };

    for (PVector dir : directions) {
      PVector next = new PVector(segments.get(0).x + dir.x, segments.get(0).y + dir.y);
      if (!edgeDetect(next) && !overlap(next, snakes)) {
        return dir;
      }
    }
    return null; // No safe direction found
  }

}
