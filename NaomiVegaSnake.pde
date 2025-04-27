class NaomiVegaSnake extends Snake {
  NaomiVegaSnake(int x, int y) {
    // Call the superclass constructor to initialize the snake
    super(x, y, "NaomiVegaSnake");
  }

  @Override
  void think(ArrayList<Food> food, ArrayList<Snake> snakes) {
    // Find the safest food to target
    Food targetFood = findSafestFood(food, snakes);

    if (targetFood != null) {
      // Determine the direction to move toward the target food
      int dx = Integer.compare(targetFood.x, (int) segments.get(0).x); // Horizontal direction
      int dy = Integer.compare(targetFood.y, (int) segments.get(0).y); // Vertical direction

      // Check if moving in this direction would cause a collision
      if (!checkWallCollision(dx, dy) && !checkSnakeCollisions(dx, dy, snakes)) {
        // Safe to move in the desired direction
        setDirection(dx, dy);
      } else {
        // If the path is blocked, choose a safe alternative direction
        chooseSafeDirection(snakes);
      }
    }
  }

  @Override
  void drawSegment(int index, float x, float y, float size) {
    // Create a pink and purple gradient for my snake only
    float gradientFactor = (float) index / (segments.size() - 1); // Calculate gradient based on segment position
    color segmentColor = lerpColor(color(255, 105, 180), color(128, 0, 128), gradientFactor); // Interpolate colors

    // Draw the segment with the gradient color
    fill(segmentColor);
    noStroke();
    rect(x, y, size, size, 5); // Draw a rounded rectangle for the segment
  }

  /**
   * Finds the safest food to target based on distance and safety.
   * @param food List of all food items in the game.
   * @param snakes List of all snakes in the game.
   * @return The safest Food object, or null if no safe food is available.
   */
  private Food findSafestFood(ArrayList<Food> food, ArrayList<Snake> snakes) {
    Food safestFood = null;
    float bestScore = Float.NEGATIVE_INFINITY;

    // Iterate through all food items
    for (Food f : food) {
      // Calculate Manhattan distance from the snake's head to the food
      float distance = Math.abs(f.x - segments.get(0).x) + Math.abs(f.y - segments.get(0).y);
      boolean safe = !isDangerous(f.x, f.y, snakes);

      // Scoring: prioritize safe and nearby food
      float score = (safe ? 100 : 0) - distance; // Safe food gets high priority
      if (score > bestScore) {
        bestScore = score;
        safestFood = f;
      }
    }
    return safestFood; // Return the safest food found
  }

  /**
   * Determines if a position is dangerous (near walls or other snakes).
   * @param x The x-coordinate of the position.
   * @param y The y-coordinate of the position.
   * @param snakes List of all snakes in the game.
   * @return True if the position is dangerous, false otherwise.
   */
  private boolean isDangerous(int x, int y, ArrayList<Snake> snakes) {
    // Check if the position is near a hazard (e.g., walls or other snakes)
    return checkWallCollision(x - (int) segments.get(0).x, y - (int) segments.get(0).y) || 
           checkSnakeCollisions(x - (int) segments.get(0).x, y - (int) segments.get(0).y, snakes);
  }

  /**
   * Chooses a safe direction to move if the intended direction is blocked.
   * @param snakes List of all snakes in the game.
   */
  private void chooseSafeDirection(ArrayList<Snake> snakes) {
    // Define all possible movement directions
    int[][] directions = { {1, 0}, {0, 1}, {-1, 0}, {0, -1} };

    // Check each direction for safety
    for (int[] dir : directions) {
      int newDx = dir[0];
      int newDy = dir[1];
      // Ensure the direction is safe (no wall or snake collisions)
      if (!checkWallCollision(newDx, newDy) && !checkSnakeCollisions(newDx, newDy, snakes)) {
        // Move in the first safe direction found
        setDirection(newDx, newDy);
        return;
      }
    }
  }

  /**
   * Checks if moving in the specified direction would result in a wall collision.
   * @param dx Horizontal direction to move (-1, 0, or 1).
   * @param dy Vertical direction to move (-1, 0, or 1).
   * @return True if the next position is outside the grid, false otherwise.
   */
  private boolean checkWallCollision(int dx, int dy) {
    // Calculate the next position of the snake's head
    int nextX = (int) segments.get(0).x + dx;
    int nextY = (int) segments.get(0).y + dy;

    // Check if the next position is outside the grid boundaries
    return nextX < 0 || nextX >= width / gridSize || nextY < 0 || nextY >= height / gridSize;
  }

  /**
   * Checks if moving in the specified direction would result in a collision with another snake.
   * @param dx Horizontal direction to move (-1, 0, or 1).
   * @param dy Vertical direction to move (-1, 0, or 1).
   * @param snakes List of all snakes in the game.
   * @return True if the next position overlaps with another snake, false otherwise.
   */
  private boolean checkSnakeCollisions(int dx, int dy, ArrayList<Snake> snakes) {
    // Calculate the next position of the snake's head
    int nextX = (int) segments.get(0).x + dx;
    int nextY = (int) segments.get(0).y + dy;

    // Check if the next position overlaps with any snake's segments
    for (Snake snake : snakes) {
      for (PVector segment : snake.segments) {
        if (segment.x == nextX && segment.y == nextY) {
          return true; // Collision detected
        }
      }
    }
    return false; // No collision detected
  }
}
