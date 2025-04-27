class ZahraMehdiSnake extends Snake {
  ZahraMehdiSnake(int x, int y) {
    super(x, y, "ZahraMehdiSnake");
  }

  void think(ArrayList<Food> food, ArrayList<Snake> snakes) {
    PVector head = segments.get(0);

    //Find best food
    Food bestFood = null;
    float bestScore = Float.MAX_VALUE;
    for (Food f : food) {
      float d = dist(head.x, head.y, f.x, f.y);
      float effectiveDist = d - (f.points * 5);
      if (effectiveDist < bestScore) {
        bestScore = effectiveDist;
        bestFood = f;
      }
    }

    if (bestFood != null) {
      int dx = 0;
      int dy = 0;
      if (bestFood.x > head.x) dx = 1;
      else if (bestFood.x < head.x) dx = -1;
      else if (bestFood.y > head.y) dy = 1;
      else if (bestFood.y < head.y) dy = -1;

      PVector nextPos = new PVector(head.x + dx, head.y + dy);

      //Try to move toward food if safe
      if (isSafe(nextPos, snakes)) {
        setDirection(dx, dy);
        return;
      } else {
        //Try slight adjustments (turns) toward food
        PVector[] foodBiasDirs = getFoodBiasDirections(bestFood, head);
        for (PVector dir : foodBiasDirs) {
          PVector altNextPos = new PVector(head.x + dir.x, head.y + dir.y);
          if (isSafe(altNextPos, snakes)) {
            setDirection(dir.x, dir.y);
            return;
          }
        }
      }
    }

    //If can't safely reach food, fallback: move to biggest open area
    PVector[] possibleDirs = {
      new PVector(1, 0),   //Right
      new PVector(-1, 0),  //Left
      new PVector(0, 1),   //Down
      new PVector(0, -1)   //Up
    };

    PVector bestMove = null;
    float bestOpenScore = -1;

    for (PVector dir : possibleDirs) {
      PVector nextPos = new PVector(head.x + dir.x, head.y + dir.y);

      if (isSafe(nextPos, snakes)) {
        float openScore = openAreaScore(nextPos, snakes);
        if (openScore > bestOpenScore) {
          bestOpenScore = openScore;
          bestMove = dir;
        }
      }
    }

    if (bestMove != null) {
      setDirection(bestMove.x, bestMove.y);
    }
  }

  //Returns directions biased toward food (try straight first, then sideways)
  PVector[] getFoodBiasDirections(Food food, PVector head) {
    ArrayList<PVector> dirs = new ArrayList<PVector>();

    if (abs(food.x - head.x) >= abs(food.y - head.y)) {
      if (food.x > head.x) dirs.add(new PVector(1, 0));  //Right
      else if (food.x < head.x) dirs.add(new PVector(-1, 0)); //Left

      if (food.y > head.y) dirs.add(new PVector(0, 1)); //Down
      else if (food.y < head.y) dirs.add(new PVector(0, -1)); //Up
    } else {
      if (food.y > head.y) dirs.add(new PVector(0, 1)); //Down
      else if (food.y < head.y) dirs.add(new PVector(0, -1)); //Up

      if (food.x > head.x) dirs.add(new PVector(1, 0));  //Right
      else if (food.x < head.x) dirs.add(new PVector(-1, 0)); //Left
    }

    //Add all possible dirs just in case
    dirs.add(new PVector(1, 0));
    dirs.add(new PVector(-1, 0));
    dirs.add(new PVector(0, 1));
    dirs.add(new PVector(0, -1));

    return dirs.toArray(new PVector[0]);
  }

  boolean isSafe(PVector pos, ArrayList<Snake> snakes) {
    return !edgeDetect(pos) && !overlap(pos, snakes);
  }

  float openAreaScore(PVector pos, ArrayList<Snake> snakes) {
    int score = 0;
    int scanRadius = 5;
    for (int dx = -scanRadius; dx <= scanRadius; dx++) {
      for (int dy = -scanRadius; dy <= scanRadius; dy++) {
        if (dx == 0 && dy == 0) continue;
        PVector scanPos = new PVector(pos.x + dx, pos.y + dy);
        if (!edgeDetect(scanPos) && !overlap(scanPos, snakes)) {
          score++;
        }
      }
    }
    return score;
  }
}
