

// My snake's tactic is to stay along the edge to outlast everyone else in the tournament, if it comes in contact with a snake in the process it may deviate from the edge for a little before it returns to the wall again


class NicoleCainSnake extends Snake {
  int index;
  int random;
  PVector preDir;
  NicoleCainSnake(int x, int y) {
    super(x, y, "NicoleCainSnake");

    index = 0;
    random = 0;
    preDir = new PVector(0, -1);
  }



  void think(ArrayList<Food> food, ArrayList<Snake> snakes) {
    Food closestFood = getClosestFood(this, food); //
    PVector[] possibleDirs = { // all possible directions to choose from
      new PVector(-1, 0), // Left
      new PVector(0, 1), // Down
      new PVector(1, 0), // Right
      new PVector(0, -1)   // Up

    };


    //println("closest food" + closestFood.x + " " + closestFood.y);

    PVector head = this.segments.get(0);

    float dx = closestFood.x - head.x;
    float dy = closestFood.y - head.y;


    PVector dir = preDir;


    PVector newPos = new PVector(head.x + dir.x, head.y + dir.y);

    if (overlap(newPos, snakes)) { // hit a snake
      for (int i = 0; i < 4; i++) {
        dir = possibleDirs [i];  // iterate through directions
        newPos = new PVector(head.x + dir.x, head.y + dir.y);
        if (overlap(newPos, snakes) || (edgeDetect(newPos))) { // to avoid hitting snakes
          continue;
        } else {
          setDirection(dir.x, dir.y);
          return;
        }
      } 
      dir = preDir;
    }


      if (edgeDetect(newPos)) { //hit a wall
        //println("hit wall!");


        dir = possibleDirs [index]; //cycles through which movement is best outcome
        index = (index +1);
        if (index == 4) {
          index = 0;
        }
        //println("turn" + head.x + head.y);
      }




      preDir = dir;
      setDirection(dir.x, dir.y);
    }


    Food getClosestFood(Snake snake, ArrayList<Food> food) {
      float min = 1000;
      Food closestFood = null;
      PVector head = snake.segments.get(0);

      for (int i = 0; i < food.size(); i++) { // code to eat food
        Food currentFood = food.get(i);

        PVector pos = new PVector(currentFood.x, currentFood.y);

        float distance = PVector.dist(head, pos);

        if (distance < min) {
          min = distance;
          closestFood = currentFood;
        }
      }

      if (min < 5) {
        updateInterval = 60;
      } else {
        updateInterval = 100;
      }
      return closestFood;
    }
    void drawSegment(int index, float x, float y, float size) {
      push();
      
      colorMode(HSB); // makes snake have a rainbow border with a gray gradient inside
      int c = int(map(index, 0, this.segments.size(), 0, 255));
      fill(c, c, c);
      stroke(c, 255, 255);
      rect(
        x,
        y,
        size,
        size,
        5  // Fixed roundness
        );
      pop();
    }
  }
