/*  KIM NGAN NGUYEN
    CHALLENGE #12 - Snake Competition
    
    Explaination:
    I took heavy reference from "Hunter Snake" class and I used ChatGPT to have it explain all the variables and functions, and
    how it is put in order. Then I reorder the code in a way where my snake prioritize validating its safe moves first before
    it targets the nearest food. In my validation, I had my snake detecting wall edges, overlapping, and enclosure to make sure
    my snake does not end up in a deadzone and if all moves are safe, then it can proceed to target after food. There's multiple
    safe moves and it will randomize and choose whichever but if there are no safe zones, then it will randomize and choose then
    the result will still be a loss (figuring this one out still). I also did a simple rainbow customization.
*/

class KimNguyenSnake extends Snake {
  // constructor to initialize the snake with x and y coordinates
  KimNguyenSnake(int x, int y) {
    super(x, y, "KimNguyenSnake");  // call to superclass constructor
    updateInterval = 80;  // set the update interval for the snake's movements
  }

  // 'think' method is where the snake decides on its movements
  void think(ArrayList<Food> foodList, ArrayList<Snake> snakeList) {
    // possible directions the snake can move: Right, Left, Down, Up
    PVector[] possibleDirs = { 
      new PVector(1, 0),  // Right
      new PVector(-1, 0), // Left
      new PVector(0, 1),  // Down
      new PVector(0, -1)  // Up
    };

    // list to store all safe moves
    ArrayList<PVector> safeMoves = new ArrayList<PVector>();
    
    // check each direction to ensure it's safe
    for (PVector dir : possibleDirs) {
      // calculate the potential new head position after moving in this direction
      PVector newHeadPos = new PVector(segments.get(0).x + dir.x, segments.get(0).y + dir.y);
      
      // ensure the new position is safe (not out of bounds or colliding with other snakes)
      if (!isUnsafe(newHeadPos, snakeList)) {
        safeMoves.add(dir);  // add the direction to safe moves if it's valid
      }
    }

    // if there are any safe moves, choose one randomly
    if (safeMoves.size() > 0) {
      PVector chosenDir = safeMoves.get((int) random(safeMoves.size()));
      setDirection(chosenDir.x, chosenDir.y);  // set the snake's direction to the chosen one
    } else {
      // if no safe moves, pick a random safe direction (to avoid dead ends)
      pickRandomSafeDirection(snakeList);
    }

    // check for the closest food item (if any safe moves are available)
    Food closestFood = null;
    float minDistance = Float.MAX_VALUE;
    
    // find the closest food by calculating the distance (huntersnake reference)
    for (Food food : foodList) {
      float distance = abs(food.x - segments.get(0).x) + abs(food.y - segments.get(0).y);
      if (distance < minDistance) {
        minDistance = distance;  // Update the minimum distance
        closestFood = food;      // Update the closest food item
      }
    }

    // move towards the food only if the direction is safe
    if (closestFood != null) {
      float dx = closestFood.x > segments.get(0).x ? 1 : (closestFood.x < segments.get(0).x ? -1 : 0);
      float dy = closestFood.y > segments.get(0).y ? 1 : (closestFood.y < segments.get(0).y ? -1 : 0);

      // Move towards food if it's safe to do so
      if (dx != 0 && !isUnsafe(new PVector(segments.get(0).x + dx, segments.get(0).y), snakeList)) {
        setDirection(dx, 0);  // Set the direction towards food horizontally
      } else if (dy != 0 && !isUnsafe(new PVector(segments.get(0).x, segments.get(0).y + dy), snakeList)) {
        setDirection(0, dy);  // Set the direction towards food vertically
      } else {
        // if food is in danger zone, pick a random safe direction
        pickRandomSafeDirection(snakeList);
      }
    }
  }

  // check if the position is unsafe (either out of bounds or overlapping with another snake)
  boolean isUnsafe(PVector pos, ArrayList<Snake> snakeList) {
    return edgeDetect(pos) || overlap(pos, snakeList);  // Returns true if position is unsafe
  }

  // if no safe move is found, pick a random safe direction from the available ones
  void pickRandomSafeDirection(ArrayList<Snake> snakeList) {
    // possible directions to move: Right, Down, Left, Up
    PVector[] possibleDirs = { new PVector(1, 0), new PVector(0, 1), new PVector(-1, 0), new PVector(0, -1) };
    
    // check each direction to see if it's safe
    for (PVector dir : possibleDirs) {
      PVector newPos = new PVector(segments.get(0).x + dir.x, segments.get(0).y + dir.y);
      
      // if the new position is safe, set the snake's direction to that
      if (!isUnsafe(newPos, snakeList)) {
        setDirection(dir.x, dir.y);
        return;  // return once a valid direction is found
      }
    }
  }

  //  method to draw or customize the snake (use of push and pop)
  void drawSegment(int index, float x, float y, float size) {
    push();
    colorMode(HSB);
    ellipseMode(CENTER);
    int c = int(map(index, 0, this.segments.size(), 0, 255));
    float s = map(index, 0, this.segments.size(), size, size-5);
    noStroke();
    fill(c, 255, 255);
    ellipse(x, y, s, s);
    pop();
  }
}
