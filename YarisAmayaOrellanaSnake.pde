/*
  Strategy - 
  My snake moves toward the closest piece of food while carefully avoiding walls and other snakes. 
  If there isn't a safe path directly to the food, it will randomly choose another safe direction to keep moving.
  This helps it survive longer and stay flexible!
*/

class YarisAmayaOrellanaSnake extends Snake {
  PImage segmentImage; // Image used on segments 

  YarisAmayaOrellanaSnake(int x, int y) {
    super(x, y, "YarisAmayaOrellana");
    segmentImage = loadImage("assets/segment.jpg"); // Load the custom segment image
  }

  void think(ArrayList<Food> food, ArrayList<Snake> snakes) {
    // Find the closest food to chase after
    Food closestFood = getClosestFood(this, food);

    PVector head = this.segments.get(0);

    // How far are we from the food in x and y directions
    float dx = closestFood.x - head.x;
    float dy = closestFood.y - head.y;

    // Define all four possible directions we could move
    PVector[] directions = {
      new PVector(1, 0),  // Right
      new PVector(-1, 0), // Left
      new PVector(0, 1),  // Down
      new PVector(0, -1)  // Up
    };

    // We'll prefer some directions based on where the food is
    ArrayList<PVector> preferredDirections = new ArrayList<PVector>();

    // Prioritize moving horizontally or vertically, depending on which distance is bigger
    if (abs(dx) > abs(dy)) { 
      if (dx > 0) preferredDirections.add(new PVector(1, 0));  // Prefer right
      else preferredDirections.add(new PVector(-1, 0));        // Prefer left

      if (dy > 0) preferredDirections.add(new PVector(0, 1));  // Then down
      else if (dy < 0) preferredDirections.add(new PVector(0, -1)); // Then up
    } else {
      if (dy > 0) preferredDirections.add(new PVector(0, 1));  // Prefer down
      else if (dy < 0) preferredDirections.add(new PVector(0, -1)); // Prefer up

      if (dx > 0) preferredDirections.add(new PVector(1, 0));  // Then right
      else if (dx < 0) preferredDirections.add(new PVector(-1, 0)); // Then left
    }

    // Add any remaining directions we didn't already prefer
    for (PVector dir : directions) {
      boolean found = false;
      for (PVector pref : preferredDirections) {
        if (dir.x == pref.x && dir.y == pref.y) {
          found = true;
          break;
        }
      }
      if (!found) preferredDirections.add(dir);
    }

    // Try moving in a preferred direction if it's safe
    for (PVector dir : preferredDirections) {
      PVector newPos = new PVector(head.x + dir.x, head.y + dir.y);
      if (!edgeDetect(newPos) && !overlap(newPos, snakes)) {
        setDirection(dir.x, dir.y);
        return; // Found a safe move, done thinking for now
      }
    }

    // If no preferred moves are safe, just pick any random safe move
    ArrayList<PVector> safeMoves = new ArrayList<PVector>();
    for (PVector dir : directions) {
      PVector newPos = new PVector(head.x + dir.x, head.y + dir.y);
      if (!edgeDetect(newPos) && !overlap(newPos, snakes)) {
        safeMoves.add(dir);
      }
    }

    if (safeMoves.size() > 0) {
      PVector randomMove = safeMoves.get((int)random(safeMoves.size()));
      setDirection(randomMove.x, randomMove.y);
    } else {
      setDirection(0, 0); // No moves available, stay put (probably about to die)
    }
  }

  // Find the closest piece of food to the snake's current head position
  Food getClosestFood(Snake snake, ArrayList<Food> food) {
    float min = 1000;
    Food closestFood = null;
    PVector head = snake.segments.get(0);

    for (int i = 0; i < food.size(); i++) {
      Food currentFood = food.get(i);
      PVector pos = new PVector(currentFood.x, currentFood.y);
      float distance = PVector.dist(head, pos);

      if (distance < min) {
        min = distance;
        closestFood = currentFood;
      }
    }
    return closestFood;
  }

  // Draw the snake using our custom image for each segment
  void draw() {
    for (PVector segment : segments) {
      image(segmentImage, segment.x * gridSize, segment.y * gridSize, gridSize, gridSize);
    }
  }
}
