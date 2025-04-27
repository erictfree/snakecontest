class NatalieSottekSnake extends Snake {

  NatalieSottekSnake(int x, int y) {
    super(x, y, "NatalieSottekSnake");
  }

  @Override
  void think(ArrayList<Food> food, ArrayList<Snake> snakes) {
    // possible movement directions
    PVector[] possibleDirs = {
      new PVector(1, 0),   // Right
      new PVector(-1, 0),  // Left
      new PVector(0, 1),   // Down
      new PVector(0, -1)   // Up
    };
    
    PVector head = segments.get(0).copy();

    // find closest food
    Food closestFood = null;
    float closestDist = Float.MAX_VALUE;
    for (Food f : food) {
      float d = dist(head.x, head.y, f.x, f.y);
      if (d < closestDist) {
        closestDist = d;
        closestFood = f;
      }
    }

    if (closestFood == null) {
      // move randomly if no food
      PVector randomDir = possibleDirs[(int)random(possibleDirs.length)];
      setDirection(randomDir.x, randomDir.y);
      return;
    }

    // best direction toward food
    PVector bestDir = null;
    float bestScore = Float.MAX_VALUE;
    
    for (PVector dir : possibleDirs) {
      PVector nextPos = head.copy().add(dir);

      // snake collision with wall avoid
      boolean hitsWall = nextPos.x < 0 || nextPos.x >= width/GRIDSIZE || nextPos.y < 0 || nextPos.y >= height/GRIDSIZE;

      // snake collision avoid
      boolean hitsSnake = false;
      for (Snake s : snakes) {
        for (PVector seg : s.segments) {
          if (seg.x == nextPos.x && seg.y == nextPos.y) {
            hitsSnake = true;
            break;
          }
        }
        if (hitsSnake) break;
      }

      if (hitsWall || hitsSnake) {
        continue;  //move if the snake hits a wall
      }

      // distance to food
      float d = dist(nextPos.x, nextPos.y, closestFood.x, closestFood.y);
      if (d < bestScore) {
        bestScore = d;
        bestDir = dir;
      }
    }

    if (bestDir != null) {
      setDirection(bestDir.x, bestDir.y);
    } else {
      // when stuck, move randomly
      PVector randomDir = possibleDirs[(int)random(possibleDirs.length)];
      setDirection(randomDir.x, randomDir.y);
    }
  }
}
