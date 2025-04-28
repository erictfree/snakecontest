PVector[] possibleDirs = {
  new PVector(1, 0),  // Right
  new PVector(-1, 0), // Left
  new PVector(0, 1),  // Down
  new PVector(0, -1)  // Up
};


// This snake class uses an ai to find food and avoid obstacles like walls and other snakes. It calculates the safest and 
// most efficient move by analyzing its surroundings, targeting the closest food while steering clear of traps. As the snake 
// grows longer, its speed increases slightly to keep the gameplay engaging!


class TanmayeeBharadwajSnake extends Snake {

  private int lastLengthCheck = 0; // keeps track of the snake's last checked length

  TanmayeeBharadwajSnake(int x, int y) {
    super(x, y, "TanmayeeBharadwajSnake");
    this.updateInterval = 100;
  }

  @Override
  void think(ArrayList<Food> food, ArrayList<Snake> snakes) {
    PVector head = segments.get(0);
    Food target = findClosestFood(food, head);

    // if no food is found, skip the move
    if (target == null) {
      return;
    }

    // make the snake faster every time its length grows by 5
    if (segments.size() - lastLengthCheck >= 5) {
      updateInterval -= 3; // make the interval shorter
      lastLengthCheck = segments.size(); // reset the last checked length
    }

    int gridWidth = floor(width / gridSize);
    int gridHeight = floor(height / gridSize);

    PVector bestDir = selectBestDirection(possibleDirs, head, target, gridWidth, gridHeight, snakes);

    if (bestDir != null) {
      setDirection(bestDir.x, bestDir.y);
    } else {
      PVector randomDir = getRandomSafeDirection(possibleDirs, head, gridWidth, gridHeight, snakes);
      if (randomDir != null) {
        setDirection(randomDir.x, randomDir.y);
      }
    }
  }

  // finds the food closest to the snake's head
  Food findClosestFood(ArrayList<Food> food, PVector head) {
    Food closestFood = null;
    float minDist = Float.MAX_VALUE;

    for (Food f : food) {
      float d = dist(head.x, head.y, f.x, f.y);
      if (d < minDist) {
        minDist = d;
        closestFood = f;
      }
    }

    return closestFood;
  }

  // picks the best direction to move toward the target food
  PVector selectBestDirection(PVector[] possibleDirs, PVector head, Food target, int gridWidth, int gridHeight, ArrayList<Snake> snakes) {
    PVector bestDir = null;
    float minDist = Float.MAX_VALUE;

    for (PVector dir : possibleDirs) {
      PVector nextPos = PVector.add(head, dir);

      // avoid dangerous moves that trap the snake
      if (isSafe(nextPos, gridWidth, gridHeight, snakes) && !isSelfTrapped(nextPos, dir, snakes)) {
        float d = dist(nextPos.x, nextPos.y, target.x, target.y);
        if (d < minDist) {
          minDist = d;
          bestDir = dir;
        }
      }
    }

    return bestDir;
  }

  // checks if the snake might trap itself with no escape options
  boolean isSelfTrapped(PVector nextPos, PVector dir, ArrayList<Snake> snakes) {
    PVector head = segments.get(0);
    PVector oppositeDir = new PVector(-dir.x, -dir.y);

    PVector testPos = PVector.add(head, dir);

    int safeDirections = 0;
    for (PVector testDir : possibleDirs) {
      PVector newPos = PVector.add(testPos, testDir);
      if (isSafe(newPos, floor(width / gridSize), floor(height / gridSize), snakes) && !newPos.equals(PVector.add(testPos, oppositeDir))) {
        safeDirections++;
      }
    }

    return safeDirections == 0;
  }

  // checks if the next move is safe and avoids collisions
  boolean isSafe(PVector nextPos, int gridWidth, int gridHeight, ArrayList<Snake> snakes) {
    if (nextPos.x < 0 || nextPos.x >= gridWidth || nextPos.y < 0 || nextPos.y >= gridHeight) {
      return false;
    }

    for (PVector s : segments) {
      if (nextPos.equals(s)) {
        return false;
      }
    }

    for (Snake other : snakes) {
      if (other == this || !other.alive) continue;
      for (PVector s : other.segments) {
        if (nextPos.equals(s)) {
          return false;
        }
      }
    }

    return true;
  }

  // picks a random safe direction if no best direction is available
  PVector getRandomSafeDirection(PVector[] possibleDirs, PVector head, int gridWidth, int gridHeight, ArrayList<Snake> snakes) {
    ArrayList<PVector> safeDirs = new ArrayList<>();

    for (PVector dir : possibleDirs) {
      PVector nextPos = PVector.add(head, dir);
      if (isSafe(nextPos, gridWidth, gridHeight, snakes) && !isSelfTrapped(nextPos, dir, snakes)) {
        safeDirs.add(dir);
      }
    }

    if (safeDirs.size() > 0) {
      return safeDirs.get((int) random(safeDirs.size()));
    }
    return null;
  }
}
