//hello! I got the logic in office hours
//After countless hours of staring at the snake game, I realized that my snake is typically more likely to collide with itself than with other snakes. Because of this, my strategy is to have the snake avoid everything including food, which would let it stay as small as possible and avoid self-collision. I also thought it would be really funny to make it look a little bit like food since it's going to stay so small, and I'd like to excuse that by saying it is avoiding eating its friends.



class AllysonSalasSnake extends Snake {
  PVector[] possibleDirs = {
    new PVector(1, 0), // Right
    new PVector(-1, 0), // Left
    new PVector(0, 1), // Down
    new PVector(0, -1)  // Up
  };

  PVector lastDir= null;

  AllysonSalasSnake(int x, int y) {
    super(x, y, "AllysonSalas");
  }

  void think(ArrayList<Food> food, ArrayList<Snake> snakes) {
    Food closestFood = getClosestFood(this, food);

    PVector head = this.segments.get(0); // snake head :p

    float dx = closestFood.x - head.x;  // how far is the food?
    float dy = closestFood.y - head.y;  // in x and y

    // where r we going
    PVector dir = null;

    //go AWAY from food,, EW!!!!
    if (dx > 0) {
      dir = new PVector(-1, 0); // left
    } else if (dx < 0) {
      dir = new PVector(1, 0); // right
    } else if (dy > 0) {
      dir = new PVector(0, -1); // up
    } else if (dy < 0) {
      dir = new PVector(0, 1); // down
    }

    // wall?
    PVector newPos = new PVector(head.x + dir.x, head.y + dir.y);
    if (edgeDetect(newPos) || overlap(newPos, snakes)) {  // wall or snake
      // wall collisions
      if (head.x > 2000) { // collision on right
        dir = new PVector(0, -1); // go up!!!
      } else if (head.x < 1) { // collision at left
        dir = new PVector(0, 1); // go down!!!!
      } else if (head.y > 1100) { // collision at bottom
        dir = new PVector(1, 0); // go right!!
      } else if (head.y < -1100) { // collision at top
        dir = new PVector(-1, 0); // go left!!
      }

      //snake collisions!!!
      for (int i = 0; i < possibleDirs.length; i++) { // looking thru dir
        PVector tempDir = possibleDirs[i]; //check @ index
        PVector tempPos = new PVector(head.x + tempDir.x, head.y + tempDir.y); //check pos it would put us @

        if (lastDir == null) {
          lastDir = dir;
        }

        if (!edgeDetect(tempPos)&& !overlap(tempPos, snakes)&& ((tempDir.x == 0) || (tempDir.x != -lastDir.x)) && ((tempDir.y == 0) || (tempDir.y != -lastDir.y))) { //would not hit or is opposite
          dir = new PVector(possibleDirs[i].x, possibleDirs[i].y); //new dir 
          break;
        }//otherwise we are doomed.
      }
    }

    // move
    setDirection(dir.x, dir.y);
  }

  // food closest
  Food getClosestFood(Snake snake, ArrayList<Food> food) {
    float min = 1000;
    Food closestFood = null;

    PVector head = snake.segments.get(0);

    for (int i = 0; i < food.size(); i++) { // Every piece of food
      Food currentFood = food.get(i);

      PVector pos = new PVector(currentFood.x, currentFood.y); //where the food is

      float distance = PVector.dist(head, pos); //how far is the food

      if (distance < min) {
        min = distance;
        closestFood = currentFood;
      }
    }
    return closestFood;
  }
  void drawSegment(int index, float x, float y, float size) {
    push();
    color[] palette = {#ff7b00, #ff9500, #ffaa00, #ffc300, #ffdd00} ; //colors to choose frommmm
    color c;
    int colorindex = floor(random(palette.length)); //choosing a color from the array + rounding down
    c = palette[colorindex];
    ellipseMode(CORNER);
    float s = map(index, 0, this.segments.size(), size, size);
    noStroke();
    fill(c);
    ellipse(
      x,
      y,
      s-10,
      s-10
      ); // looks kind of like a food hehe
  
      pop();
  }
}
