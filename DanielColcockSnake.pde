/*
DanielColcocksnake Simple Strategy:
Moves toward closest food safely. If not possible, picks a safe direction that leaves room.
*/

class DanielColcockSnake extends Snake {

  // Initialize the snake at the given position (x, y)
  DanielColcockSnake(int x, int y) {
    super(x, y, "DanielColcock"); // Call parent constructor
  }

  // Decide the next move based on food and surroundings
  void think(ArrayList<Food> food, ArrayList<Snake> snakes) {
    PVector head = segments.get(0); // Get the snake's head position

    // Find the closest food
    Food closest = null;
    float closestDist = Float.MAX_VALUE; // Start with a large distance
    for (Food f : food) {
      // Calculate the distance to the food
      float d = abs(f.x - head.x) + abs(f.y - head.y);
      if (d < closestDist) {
        closestDist = d; // Update the closest food distance
        closest = f; // Store the closest food
      }
    }

    // Define possible move directions (right, down, left, up)
    PVector[] moves = {
      new PVector(1, 0),  // Right
      new PVector(0, 1),  // Down
      new PVector(-1, 0), // Left
      new PVector(0, -1)  // Up
    };

    PVector bestMove = null;
    float bestScore = -10000; // Start with a low score

    // Check each possible move
    for (PVector move : moves) {
      float newX = head.x + move.x; // New x position
      float newY = head.y + move.y; // New y position

      // Check if the move is safe (no walls or collisions)
      if (isSafe(newX, newY, snakes)) {
        float score = 0;

        // Bonus for getting closer to food
        if (closest != null) {
          float newDist = abs(closest.x - newX) + abs(closest.y - newY);
          score -= newDist; // Closer food is better
        }

        // Bonus for staying closer to the center (avoiding walls)
        score -= 0.1 * (abs(width / 20 - newX) + abs(height / 20 - newY));

        // If this move is better, remember it
        if (score > bestScore) {
          bestScore = score;
          bestMove = move;
        }
      }
    }

    // Move toward the best option
    if (bestMove != null) {
      setDirection(bestMove.x, bestMove.y);
    } else {
      // If no safe move, do nothing (snake might be stuck)
    }
  }

  // Check if the move is safe (no collisions or out of bounds)
  boolean isSafe(float x, float y, ArrayList<Snake> snakes) {
    PVector pos = new PVector(x, y); // New position
    return !edgeDetect(pos) && !overlap(pos, snakes); // Check if it's safe
  }
}
