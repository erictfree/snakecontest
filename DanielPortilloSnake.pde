class DanielPortilloSnake extends Snake {
  DanielPortilloSnake(int x, int y) {
    super(x, y, "DanielPortillo");
  }

  void think(ArrayList<Food> food, ArrayList<Snake> snakes) {
    // How far the snake will look ahead for danger
    int lookAheadDist = 2;
    
    // Define all possible directions: right, left, down, up
    PVector left = new PVector(-1, 0);
    PVector right = new PVector(1, 0);
    PVector up = new PVector(0, -1);
    PVector down = new PVector(0, 1);
    
    PVector dir = this.direction;
    
    // turn away if snake is within lookAheadDist units in front
    if (testSafe(lookAheadDist, dir) == false) {
      boolean unsafe = true;
      int testDist = lookAheadDist;
      while (unsafe && testDist > 0) {
        if (testSafe(testDist, getLeftDir(dir))) {
          // turn left
          //println("TURN LEFT");
          dir = getLeftDir(this.direction);
          unsafe = false;
        } else if (testSafe(testDist, getRightDir(dir))) {
          // turn right
          //println("TURN RIGHT");
          dir = getRightDir(this.direction);
          unsafe = false;
        } else if (testSafe(testDist, dir)) {
          // stay steady
          //println("STEADY");
          unsafe = false;
        }
        testDist -= 1;
      }
      
      //if (testSafe(lookAheadDist, getLeftDir(dir))) {
      //  // turn left
      //  println("TURN LEFT");
      //  dir = getLeftDir(this.direction);
      //} else {
      //  // turn right
      //  println("TURN RIGHT");
      //  dir = getRightDir(this.direction);
      //}
    } else {
      // if safe, search for food
      
      PVector face = this.segments.get(0);
      PVector nearestFood = getNearestFood(face);
      PVector foodDiff = PVector.sub(nearestFood, face);
      //println(foodDiff);
      
      PVector directionToFood;
      if (abs(foodDiff.x) > abs(foodDiff.y)) {
        if (nearestFood.x > face.x) {
          // right
          directionToFood = turnTowardsDir(dir, right);
        } else {
          // left
          directionToFood = turnTowardsDir(dir, left);
        }
      } else {
        if (nearestFood.y > face.y) {
          // down
          directionToFood = turnTowardsDir(dir, down);
        } else {
          // up
          directionToFood = turnTowardsDir(dir, up);
        }
      }
      
      if (testSafe(1, directionToFood)) {
        dir = directionToFood;
      }
    }
    
    setDirection(dir.x, dir.y);
  }
  
  PVector getLeftDir(PVector dir) {
    PVector left = new PVector(-1, 0);
    PVector right = new PVector(1, 0);
    PVector up = new PVector(0, -1);
    PVector down = new PVector(0, 1);
    
    if (vectorsEqual(dir, left)) {
      return down;
    } else if (vectorsEqual(dir, down)) {
      return right;
    } else if (vectorsEqual(dir, right)) {
      return up;
    } else {
      return left;
    }
  }
  
  PVector getRightDir(PVector dir) {
    PVector left = new PVector(-1, 0);
    PVector right = new PVector(1, 0);
    PVector up = new PVector(0, -1);
    PVector down = new PVector(0, 1);
    
    if (vectorsEqual(dir, left)) {
      return up;
    } else if (vectorsEqual(dir, up)) {
      return right;
    } else if (vectorsEqual(dir, right)) {
      return down;
    } else {
      return left;
    }
  }
  
  boolean testSafe(int dist, PVector dir) {
    for (int i = 1; i <= dist; i++) {
      for (int snake = 0; snake < snakes.size(); snake++) { 
        for (int seg = 0; seg < snakes.get(snake).segments.size(); seg++) {
          PVector segment = snakes.get(snake).segments.get(seg);
          PVector face_pos = this.segments.get(0);
          PVector test_pos = PVector.add(face_pos, PVector.mult(dir, i));
          if (segment.x == test_pos.x && segment.y == test_pos.y) {
            //println("SNAKE");
            return false;
          }
        }
      }
    }
    
    PVector farTestPos = PVector.add(this.segments.get(0), PVector.mult(dir, dist));
    if (farTestPos.x < 0 || farTestPos.x >= width/20 || farTestPos.y < 0 || farTestPos.y >= height/20) {
      //println("WALL");
      return false;
    }
    
    return true;
  }
  
  PVector getNearestFood(PVector pos) {
    PVector nearestFood = new PVector(0, 0);
    float foodDist = 999999;
    
    for (int i = 0; i < food.size(); i++) {
      Food currentFood = food.get(i);
      PVector foodPos = new PVector(currentFood.x, currentFood.y);
      float distance = dist(pos.x, pos.y, foodPos.x, foodPos.y);
      if (distance < foodDist) {
        nearestFood = foodPos;
        foodDist = distance;
      }
    }
    
    return nearestFood;
  }
  
  PVector turnTowardsDir(PVector curr, PVector tgt) {
    PVector left = new PVector(-1, 0);
    PVector right = new PVector(1, 0);
    PVector up = new PVector(0, -1);
    PVector down = new PVector(0, 1);
    
    if (vectorsEqual(curr, right)) {
      // facing right
      if (vectorsEqual(tgt, right)) {
        return right;
      } else if (vectorsEqual(tgt, down)) {
        return down;
      } else if (vectorsEqual(tgt, left)) {
        return down;
      } else {
        return up;
      }
      
    } else if (vectorsEqual(curr, down)) {
      // facing down
      if (vectorsEqual(tgt, right)) {
        return right;
      } else if (vectorsEqual(tgt, down)) {
        return down;
      } else if (vectorsEqual(tgt, left)) {
        return left;
      } else {
        return left;
      }
      
    } else if (vectorsEqual(curr, left)) {
      // facing left
      if (vectorsEqual(tgt, right)) {
        return up;
      } else if (vectorsEqual(tgt, down)) {
        return down;
      } else if (vectorsEqual(tgt, left)) {
        return left;
      } else {
        return up;
      }
      
    } else {
      // facing up
      if (vectorsEqual(tgt, right)) {
        return right;
      } else if (vectorsEqual(tgt, down)) {
        return right;
      } else if (vectorsEqual(tgt, left)) {
        return left;
      } else {
        return up;
      }
      
    }
  
  //return newDir;
  }
  
  boolean vectorsEqual(PVector vec1, PVector vec2) {
    if (vec1.x != vec2.x) {
      return false;
    } else if (vec1.y != vec2.y) {
      return false;
    } else {
      return true;
    }
  }
}
