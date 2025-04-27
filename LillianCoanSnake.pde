// My snake for the Snake Competition

class LillianCoanSnake extends Snake {
  LillianCoanSnake(int x, int y) {
    super(x, y, "LillianCoanSnake");
  }

  void think(ArrayList<Food> food, ArrayList<Snake> snakes) {
        PVector head = this.segments.get(0); //head of snake first segment

    Food targetFood = getClosestSafeFood(food, snakes); //closest, safest food

    PVector[] directions = { // Define all possible directions: right, left, down, up
      new PVector(1, 0), 
      new PVector(-1, 0),
      new PVector(0, 1), 
      new PVector(0, -1)
    };

    PVector bestDir = null; //best direction to move
    float minDist = Float.MAX_VALUE; //minimum distance to food snake can go

    for (PVector dir : directions) { //try diff directions to find the fastest, safest way to food in any direction
      PVector newPos = new PVector(head.x + dir.x, head.y + dir.y);
      if (!edgeDetect(newPos) && !overlap(newPos, snakes) && !hitsSelf(newPos)) { //make sure it is in bounds, away from snakes, and doesn't overlap myself
        float dist = targetFood != null ? PVector.dist(newPos, new PVector(targetFood.x, targetFood.y)) : 0; //distance to food needed
        if (dist < minDist) { //if move closer, mark as best way to get the food
          minDist = dist;
          bestDir = dir;
        }
      }
    }

    if (bestDir == null) bestDir = new PVector(0, 1); // default safe move down 
    setDirection(bestDir.x, bestDir.y); //direction snake will move next
  }

  Food getClosestSafeFood(ArrayList<Food> food, ArrayList<Snake> snakes) { //safest food safe to approach
    float min = Float.MAX_VALUE;
    Food safest = null;
    PVector head = this.segments.get(0); //current first segment position

    for (Food f : food) { //loop for each food item
      PVector pos = new PVector(f.x, f.y); //position food
      float dist = PVector.dist(head, pos); //distance from head of snake

      //direction from head to available food
      PVector direction = new PVector(Math.signum(pos.x - head.x), Math.signum(pos.y - head.y));
      PVector testPos = new PVector(head.x + direction.x, head.y + direction.y);

      //check if the food is okay to get without hitting wall, snakes, itself 
      if (!edgeDetect(testPos) && !overlap(testPos, snakes) && !hitsSelf(testPos)) {
        if (dist < min) {
          min = dist;
          safest = f; //update safest food, and closest
        }
      }
    }
    return safest;
  }

  boolean hitsSelf(PVector newPos) { //checks if snake will collide with itself
    for (int i = 0; i < segments.size(); i++) {
      PVector segment = segments.get(i); 
      if (segment.equals(newPos)) { //check if each body segment has new position
        return true; //collide itself
      }
    } 
    return false; //no collsion with self
  }
}
