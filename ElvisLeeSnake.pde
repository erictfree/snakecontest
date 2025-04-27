class ElvisLeeSnake extends Snake {
  float avoidanceRadius = 10; //radius of avoidance range
  int bigEnoughLength = 20; //length the snake needs to reach before it starts trying to kill enemie

  ElvisLeeSnake(int x, int y) {
    super(x, y, "ElvisLee");
  }

  void think(ArrayList<Food> food, ArrayList<Snake> snakes) {
    PVector head = segments.get(0).copy();
    PVector[] possibleDirs = { 
      new PVector(1, 0),
      new PVector(-1, 0),
      new PVector(0, 1),
      new PVector(0, -1)
    };

    PVector bestDir = null; //best direction to move
    float closestEnemyDist = Float.MAX_VALUE; // cloest enemy head when large
    PVector closestEnemyHeadPos = null; // closest enemy head
    boolean enemyNearby = false; //flag for avoidance range

    //go thru all snakes proximity
    for (Snake other : snakes) {
      if (other != this && other.isAlive()) {
        PVector otherHead = other.segments.get(0).copy(); //get the head position of the other snake.
        float distToEnemy = PVector.dist(head, otherHead);
        if (distToEnemy < closestEnemyDist) { 
          closestEnemyDist = distToEnemy;
          closestEnemyHeadPos = otherHead;
        }
        if (distToEnemy < avoidanceRadius) { //set the flag if enemy is in avoiding tange
          enemyNearby = true;
        }
      }
    }

    Food closestFood = getClosestFood(this, food); 
    
    //when snake is small
    if (segments.size() < bigEnoughLength) {
      if (enemyNearby) { //prioritize avoiding the enemy
        PVector bestAvoidDir = null;
        float maxDistAfterMove = -1;

        //find the safest move
        for (PVector dir : possibleDirs) {
          PVector nextHead = PVector.add(head, dir); // Calculate the potential next head position.
          boolean collisionImminent = false;

          //check if the next move would lead to an immediate head-on collision with an enemy.
          for (Snake other : snakes) {
            if (other != this && other.isAlive()) {
              if (PVector.dist(nextHead, other.segments.get(0)) < 1) {
                collisionImminent = true;
                break;
              }
            }
          }

          //safety evaluation code
          if (!collisionImminent) {
            PVector awayVector = new PVector(0, 0);
            if (closestEnemyHeadPos != null) {
              awayVector = PVector.sub(nextHead, closestEnemyHeadPos); 
            }
            float distAfterMove = PVector.dist(nextHead, closestEnemyHeadPos); //calculate distance to enemy

            //pick the move that maximize closing the enemy
            if (distAfterMove > maxDistAfterMove) {
              maxDistAfterMove = distAfterMove;
              bestAvoidDir = dir;
            }
          }
        }
        bestDir = bestAvoidDir; //best avoiding direction
      } else if (closestFood != null) {
        PVector dirToFood = PVector.sub(new PVector(closestFood.x, closestFood.y), head);
        if (abs(dirToFood.x) > abs(dirToFood.y)) {
          bestDir = new PVector(sign(dirToFood.x), 0);
        } else if (abs(dirToFood.y) > 0) { 
          bestDir = new PVector(0, sign(dirToFood.y));
        }
      } else { //move randomly when nothing nearby
        bestDir = possibleDirs[(int)random(possibleDirs.length)];
      }
    }
    //kill behaviro
    else {
      PVector closestEnemyHead = getClosestEnemyHead(snakes); //find closest head
      if (closestEnemyHead != null) { // if enemy is clost move close to its head
        PVector dirToEnemy = PVector.sub(closestEnemyHead, head);
        if (abs(dirToEnemy.x) > abs(dirToEnemy.y)) { 
          bestDir = new PVector(sign(dirToEnemy.x), 0);
        } else if (abs(dirToEnemy.y) > 0) { 
          bestDir = new PVector(0, sign(dirToEnemy.y));
        }
      } else if (closestFood != null) { //if no enemy go fofr food
        PVector dirToFood = PVector.sub(new PVector(closestFood.x, closestFood.y), head);
        if (abs(dirToFood.x) > abs(dirToFood.y)) { // move horizonally to the food
          bestDir = new PVector(sign(dirToFood.x), 0);
        } else if (abs(dirToFood.y) > 0) { //move vertiaclly towards the food
          bestDir = new PVector(0, sign(dirToFood.y));
        }
      } else { // If no enemies or food, move randomly.
        bestDir = possibleDirs[(int)random(possibleDirs.length)];
      }
    }

    // Set the calculated best direction for the snakes movement
    if (bestDir != null) {
      setDirection(bestDir.x, bestDir.y);
    }
  }

  //helper function that finds food
  Food getClosestFood(Snake self, ArrayList<Food> foodList) {
    PVector head = self.segments.get(0);
    Food closest = null;
    float closestDistSq = Float.MAX_VALUE;
    for (Food f : foodList) {
      float dSq = PVector.dist(head, new PVector(f.x, f.y));
      if (dSq < closestDistSq) {
        closestDistSq = dSq;
        closest = f;
      }
    }
    return closest;
  }

  // helper function - find enemy head (closte)
  PVector getClosestEnemyHead(ArrayList<Snake> snakes) {
    PVector head = segments.get(0).copy();
    PVector closestEnemyHead = null;
    float closestDistSq = Float.MAX_VALUE;

    for (Snake other : snakes) {
      if (other != this && other.isAlive()) {
        PVector otherHead = other.segments.get(0).copy();
        float dSq = PVector.dist(head, otherHead);
        if (dSq < closestDistSq) {
          closestDistSq = dSq;
          closestEnemyHead = otherHead;
        }
      }
    }
    return closestEnemyHead;
  }

  //helper function to get the sign
  int sign(float n) {
    if (n > 0) return 1;
    if (n < 0) return -1;
    return 0;
  }
}
