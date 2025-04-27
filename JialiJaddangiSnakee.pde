/*
Jiali Jaddangi
Strategy:
My snake searches for the best food based on a combination of distance and food points.
It uses greedy pathfinding (one step at a time) toward the best option, while checking for safe moves.
When my snake grows large, it becomes defensive focusing on surviving longer and trying to block other snakes.
It avoids dangerous moves like colliding with walls, itself, or other snakes, and tries to outlast opponents.
*/

class JialiJaddangiSnakee extends Snake {
  // constructor for initializing the snake with its position and name
  JialiJaddangiSnakee(int x, int y) {
    super(x, y, "JialiJaddangi");
  }

  @Override
  void think(ArrayList<Food> food, ArrayList<Snake> snakes) {
    if (food.size() == 0) return; // no food? nothing to do

    boolean aggressive = segments.size() < 30; // be aggressive when smaller
    boolean defensive = segments.size() >= 30; // be defensive when large

    Food target = pickBestFood(food, aggressive); // pick the best food to go for

    if (target == null) return; // no valid food found, exit

    float dx = target.x - segments.get(0).x; // calculate horizontal distance to food
    float dy = target.y - segments.get(0).y; // calculate vertical distance to food

    PVector move = new PVector(0, 0); // initialize movement vector

    // simple greedy pathfinding, prioritize either x or y direction
    if (abs(dx) > abs(dy)) {
      move.x = dx > 0 ? 1 : -1; // move right if dx is positive, else left
    } else {
      move.y = dy > 0 ? 1 : -1; // move down if dy is positive, else up
    }

    if (!safeToMove(move, snakes)) { // check if the move is safe
      PVector[] backupMoves = {
        new PVector(1, 0), // move right
        new PVector(-1, 0), // move left
        new PVector(0, 1), // move down
        new PVector(0, -1) // move up
      };
      for (PVector backup : backupMoves) { // try backup moves if initial move is unsafe
        if (safeToMove(backup, snakes)) { // check each backup move
          move = backup; // use first safe move
          break;
        }
      }
    }

    if (defensive) { // if defensive mode, block closest enemy
      Snake closestEnemy = findClosestSnake(snakes); // find the closest enemy snake
      if (closestEnemy != null) {
        float ex = closestEnemy.segments.get(0).x;
        float ey = closestEnemy.segments.get(0).y;

        // block the closest enemy's path if too close
        if (dist(segments.get(0).x, segments.get(0).y, ex, ey) < 10) {
          float blockDx = ex - segments.get(0).x;
          float blockDy = ey - segments.get(0).y;

          if (abs(blockDx) > abs(blockDy)) { // prioritize horizontal block
            move.x = blockDx > 0 ? 1 : -1;
            move.y = 0; // block horizontally
          } else { // prioritize vertical block
            move.y = blockDy > 0 ? 1 : -1;
            move.x = 0; // block vertically
          }

          if (!safeToMove(move, snakes)) { // if blocking move is unsafe, reset move
            move = new PVector(0, 0);
          }
        }
      }
    }

    setDirection(move.x, move.y); // set the final movement direction
  }

  // pick the best food based on distance and points
  Food pickBestFood(ArrayList<Food> foodList, boolean aggressive) {
    Food best = null;
    float bestScore = -1;

    for (Food f : foodList) { // loop through all food
      float d = dist(segments.get(0).x, segments.get(0).y, f.x, f.y); // distance to food
      float value = f.points; // food's points value

      // score food based on whether the snake is aggressive or not
      float score = aggressive ? (value / (d + 1)) : (1 / (d + 1));

      if (score > bestScore) { // choose the food with the best score
        bestScore = score;
        best = f;
      }
    }
    return best; // return the best food found
  }

  // check if a move is safe (no collisions with walls, itself, or other snakes)
  boolean safeToMove(PVector move, ArrayList<Snake> snakes) {
    float nextX = segments.get(0).x + move.x;
    float nextY = segments.get(0).y + move.y;

    if (nextX < 0 || nextX >= width / GRIDSIZE || nextY < 0 || nextY >= height / GRIDSIZE) {
      return false; // outside the grid, unsafe
    }

    for (PVector s : segments) { // check if the snake runs into itself
      if (s.x == nextX && s.y == nextY) {
        return false; // self-collision, unsafe
      }
    }

    for (Snake other : snakes) { // check for collision with other snakes
      if (other == this) continue; // don't check itself
      for (PVector s : other.segments) {
        if (s.x == nextX && s.y == nextY) {
          return false; // collision with another snake, unsafe
        }
      }
    }

    return true; // safe to move
  }

  // find the closest snake to the current snake
  Snake findClosestSnake(ArrayList<Snake> snakes) {
    Snake closest = null;
    float minDist = Float.MAX_VALUE;

    for (Snake other : snakes) { // loop through all snakes
      if (other == this) continue; // skip itself
      float d = dist(segments.get(0).x, segments.get(0).y, other.segments.get(0).x, other.segments.get(0).y);
      if (d < minDist) { // track the closest snake
        minDist = d;
        closest = other;
      }
    }
    return closest; // return the closest snake
  }
}
