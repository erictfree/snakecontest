// SissiLaiSnake Class
// Notice: The base code and some functions are adapted from HunterSnake code and some of the code strategies are referenced from the SnakeCompetition (such as time).

class SissiLaiSnake extends Snake {

  SissiLaiSnake(int x, int y) {
    super(x, y, "SissiLai"); // Call the parent constructor to initialize the snake
    updateInterval = 1000; // Set initial slower speed for better survival
  }

  void think(ArrayList<Food> food, ArrayList<Snake> snakes) {
    int currentTime = millis(); // Get the current time

    // Check if more than 2 minutes 55 seconds have passed and if there are still other snakes alive
    if (currentTime > 170000) { // If 170000ms (2 minutes 55 seconds) have passed
      //println("set time have passed.");
      if (otherSnakesAlive(snakes)) { // Check if there are other snakes still alive
        //println("Other snakes are still alive. Increasing speed to 20.");
        updateInterval = 20; // Increase speed to 20 if other snakes are alive
      } else {
        //println("No other snakes alive. Speed remains unchanged.");
      }
    }

    // Define possible directions the snake can move (right, left, down, up)
    PVector[] possibleDirs = {new PVector(1, 0), new PVector(-1, 0), new PVector(0, 1), new PVector(0, -1)};
    PVector safestDirection = null; // Variable to store the safest direction
    float maxSafetyScore = -Float.MAX_VALUE; // Initialize the maximum safety score to a very low number

    // Find the safest direction
    for (PVector dir : possibleDirs) { // Loop through each possible direction
      PVector newPos = segments.get(0).copy().add(dir); // Calculate the new position if the snake moves in the current direction

      // Check if the new position is safe
      if (isSafe(newPos, snakes)) {
        float safetyScore = calculateSafetyScore(newPos, snakes); // Calculate the safety score for this position
        //println("Direction (" + dir.x + ", " + dir.y + ") is safe with safety score: " + safetyScore); // Log the safety score
        if (safetyScore > maxSafetyScore) { // If the safety score is higher than the current max, update it
          maxSafetyScore = safetyScore;
          safestDirection = dir; // Set this direction as the safest
        }
      } else {
        //println("Direction (" + dir.x + ", " + dir.y + ") is NOT safe."); // Log if the direction is not safe
      }
    }

    // Find food in the safest direction
    if (safestDirection != null) { // If a safe direction was found
      //println("Safest direction chosen: (" + safestDirection.x + ", " + safestDirection.y + ")");
      Food targetFood = findClosestFood(food, safestDirection, snakes); // Find the closest food in the safest direction
      if (targetFood != null) { // If food is found
        PVector foodDir = calculateDirectionToFood(targetFood); // Calculate the direction to the food
        //println("Closest food found at (" + targetFood.x + ", " + targetFood.y + "). Moving toward it.");
        if (isSafe(segments.get(0).copy().add(foodDir), snakes)) { // If it's safe to move toward the food
          //println("Moving safely toward food.");
          setDirection(foodDir.x, foodDir.y); // Set the direction towards the food
          return;
        }
      }
      //println("No reachable food. Moving in safest direction.");
      setDirection(safestDirection.x, safestDirection.y); // If no food is reachable, move in the safest direction
    } else {
      //println("No safe direction found. Stopping.");
      setDirection(0, 0); // If no safe direction is found, stop the snake
    }
  }

  // Method to check if a position is safe
  boolean isSafe(PVector position, ArrayList<Snake> snakes) {
    // Check if the position is within the game boundaries
    if (edgeDetect(position)) return false; // If it's out of bounds, return false

    // Check for collisions with other snakes
    if (overlap(position, snakes)) return false; // If it overlaps another snake, return false

    // Check for collisions with itself
    for (int i = 1; i < segments.size(); i++) { // Start at 1 to skip the head
      if (segments.get(i).equals(position)) return false; // If the head collides with its body, return false
    }

    // If all checks pass, the position is safe
    return true;
  }

  // Helper method to check if there are other snakes alive
  boolean otherSnakesAlive(ArrayList<Snake> snakes) {
    for (Snake snake : snakes) { // Iterate through all snakes
      if (!snake.equals(this) && snake.isAlive()) { // Check if the snake is not itself and is alive
        //println("Another snake is alive: " + snake.name);
        return true; // If another snake is alive, return true
      }
    }
    //println("No other snakes are alive.");
    return false; // If no other snakes are alive, return false
  }

  // Helper method to detect if a position is out of bounds
  boolean edgeDetect(PVector position) {
    return position.x < 0 || position.y < 0 || position.x >= width / gridSize || position.y >= height / gridSize;
  }

  // Helper method to check if a position overlaps with other snakes
  boolean overlap(PVector position, ArrayList<Snake> snakes) {
    for (Snake snake : snakes) { // Loop through all snakes
      for (PVector segment : snake.segments) { // Loop through each segment of the snake
        if (segment.equals(position)) return true; // If the position overlaps a snake segment, return true
      }
    }
    return false; // If no overlap, return false
  }

  // Calculate the safety score for a specific position [refereced from HunterSnake]
  float calculateSafetyScore(PVector position, ArrayList<Snake> snakes) {
    float minDistanceToSnake = Float.MAX_VALUE; // Initialize the minimum distance to another snake
    for (Snake snake : snakes) { // Loop through all snakes
      for (PVector segment : snake.segments) { // Loop through each segment of the snake
        minDistanceToSnake = min(minDistanceToSnake, dist(position.x, position.y, segment.x, segment.y)); // Update the minimum distance
      }
    }
    // Calculate the minimum distance to the walls
    float minDistanceToWall = min(
      min(position.x, width / gridSize - position.x - 1), // Left and right walls
      min(position.y, height / gridSize - position.y - 1) // Top and bottom walls
      );

    // Combine distances with weights to calculate the final safety score
    return minDistanceToSnake * 0.7f + minDistanceToWall * 0.3f;
  }

  // Find the closest food that is reachable and safe
  Food findClosestFood(ArrayList<Food> food, PVector direction, ArrayList<Snake> snakes) {
    Food closestFood = null; // Variable to store the closest food
    float minDistance = Float.MAX_VALUE; // Initialize the minimum distance to a very high value
    for (Food f : food) { // Loop through all food items
      float distance = abs(f.x - segments.get(0).x) + abs(f.y - segments.get(0).y); // Calculate the Manhattan distance to the food
      if (distance < minDistance && isSafe(segments.get(0).copy().add(direction), snakes)) { // Check if the food is closer and reachable safely
        minDistance = distance; // Update the minimum distance
        closestFood = f; // Update the closest food
      }
    }
    return closestFood; // Return the closest food
  }

  // Calculate the direction toward a specific food item
  PVector calculateDirectionToFood(Food food) {
    float dx = food.x > segments.get(0).x ? 1 : (food.x < segments.get(0).x ? -1 : 0); // Determine horizontal movement (right or left) [grab from HunterSnake]
    float dy = food.y > segments.get(0).y ? 1 : (food.y < segments.get(0).y ? -1 : 0); // Determine vertical movement (down or up) [grab from HunterSnake]
    return abs(dx) > 0 ? new PVector(dx, 0) : new PVector(0, dy); // Prioritize horizontal movement over vertical
  }
}
