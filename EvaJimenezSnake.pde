// SimpleSnake class - moves randomly with no intelligence
boolean ateFood;
    int maxCounterAmount = 100;
    int counterVariable;
class EvaJimenezSnake extends Snake {
  EvaJimenezSnake(int x, int y) {
    super(x, y, "EvaJimenezSnake");
    updateInterval = 100; //speed of snake
  }


  boolean edgeDetect(PVector pos) {
    int w = floor(width / gridSize);
    int h = floor(height / gridSize);
    return pos.x < 0 || pos.x >= w || pos.y < 0 || pos.y >= h;
  }


  boolean overlap(PVector pos, ArrayList<Snake> snakes) {
    for (Snake snake : snakes) {
      if (!snake.alive) continue;
      for (PVector segment : snake.segments) {
        if (pos.x == segment.x && pos.y == segment.y) {
          return true;
        }
      }
    }
    return false;
  }


  void think(ArrayList<Food> food, ArrayList<Snake> snakes) {
    PVector[] possibleDirs = {
      new PVector(1, 0), // Right
      new PVector(-1, 0), // Left
      new PVector(0, 1), // Down
      new PVector(0, -1)  // Up
    };


    Food closestFood = getClosestFood(this, food);

    PVector head = this.segments.get(0);

    float dx = closestFood.x - head.x;
    float dy = closestFood.y - head.y;

    PVector dir = null;

    if (dx > 0) {
      dir = new PVector(1, 0); //right
    } else if (dx < 0) {
      dir = new PVector(-1, 0); //left
    } else if (dy < 0) {
      dir = new PVector(0, -1); //up
    } else if (dy > 0) {
      dir = new PVector(0, 1); //down
    }

    PVector newPos = new PVector(head.x + dir.x, head.y + dir.y);                                      //change 1000 back to 2000 and 800 back to 1100
    if (edgeDetect(newPos) || overlap(newPos, snakes)) { //hit a wall
      if (head.x > 1000 && head.y < -800) { // collision on right and top
        dir = new PVector(0, 1); // go down
      } else if (head.x > 1000) {//collision on right
        dir = new PVector(0, -1);// go up
      } else if (head.x < 1 && head.y < -800) { // collision at left and top
        dir = new PVector(0, 1); // go down
      } else if (head.x < 1) {//collision at left
        dir = new PVector(0, -1);//go up
      } else if (head.y > 800 && head.x <1) { // collision at bottom and left
        dir = new PVector(1, 0); // go right
      } else if (head.y > 800) { //collision at bottom
        dir = new PVector(-1, 0);// go left
      } else if (head.y < -800 && head.x > 1000) { // collision at top and right
        dir = new PVector(-1, 0); // go left
      } else if (head.y < -800) { // collision at top
        dir = new PVector(1, 0); // go right
      }





      //snake collisions
      //for (int i = 0; i < possibleDirs.length; i++) { // looping through all possible directions
      //  PVector tempDir = possibleDirs[i]; // checking the direction at index i
      //  PVector tempPos = new PVector(head.x + tempDir.x, head.y + tempDir.y); // checking the position this would put us at

      //  if (!edgeDetect(tempPos) || !overlap(tempPos, snakes)) { //if we would not hit a wall or a snake then set the new direction
      //    dir = new PVector (possibleDirs[i].x, possibleDirs[i].y);
      //    break;
      //  }
      //}

      for (Snake snake : snakes) {
        for (PVector segment : snake.segments) {
          if (newPos.x == segment.x && newPos.y == segment.y) {
            if (head.x < segment.x && head.y > segment.y) { // collision on right and top
              dir = new PVector(0, 1); // go down
            } else if (head.x < segment.x) {//collision on right
              dir = new PVector(0, -1);// go up
            } else if (head.x > segment.x && head.y > segment.y) { // collision at left and top
              dir = new PVector(0, 1); // go down
            } else if (head.x > segment.x) {//collision at left
              dir = new PVector(0, -1);//go up
            } else if (head.y < segment.y && head.x > segment.x) { // collision at bottom and left
              dir = new PVector(1, 0); // go right
            } else if (head.y < segment.y) { //collision at bottom
              dir = new PVector(-1, 0);// go left
            } else if (head.y > segment.y && head.x < segment.x) { // collision at top and right
              dir = new PVector(-1, 0); // go left
            } else if (head.y > -segment.y) { // collision at top
              dir = new PVector(1, 0); // go right
            }
          }
        }
      }
    }

    ateFood = false;
    if (newPos.x == closestFood.x && newPos.y == closestFood.y) {
      ateFood = true;
    }


    setDirection(dir.x, dir.y);
  }



  Food getClosestFood(Snake snake, ArrayList<Food> food) {
    float min = 1000;
    Food closestFood = null;

    PVector head = snake.segments.get(0);

    for (int i = 0; i < food.size(); i++) { //going through every piece of food
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

  void drawSegment(int index, float x, float y, float size) {

    push();
    int t = int(map(index, 0, this.segments.size(), size, size-5 ));

    noStroke();
    fill(50, 100, 200, 60);
    ellipseMode(CORNER);
    circle(x, y, t);


    if (ateFood == true) {
      counterVariable++;
      if (counterVariable > maxCounterAmount) {
        counterVariable = 0;
        ateFood = false;
      }
    }

    if (ateFood == true) {
      stroke(255);
      strokeWeight(3);
    } else {
      noStroke();
    }

    pop();
  }
}
