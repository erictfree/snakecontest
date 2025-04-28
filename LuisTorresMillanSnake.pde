// My strategy is to get lucky and hope for the best (wish I had more time to implement this).
// My snake constantly looks for food and goes to it while at the same time having a 3 in 4 chance of avoiding walls and snakes (by randomly picking a direction)
// I also made it a bit slower in order to try and avoid as much conflict with other snakes as possible and survive a little longer.
// Other than that, I made it blue and black which I think looks really freakin' cool if you ask me.

class LuisTorresMillanSnake extends Snake {
  LuisTorresMillanSnake(int x, int y) {
    super(x, y, "LuisTorresMillanSnake");
    updateInterval = 150;
  }

  void think(ArrayList<Food> food, ArrayList<Snake> snakes) {
    Food closestFood = getClosestFood(this, food);

    PVector head = this.segments.get(0); //  check head of the snake

    float dx = closestFood.x - head.x;  // figure out how far the food is from head
    float dy = closestFood.y - head.y;

    PVector dir = null;

    if (dx > 0) {
      dir = new PVector(1, 0);    // move right
    } else if (dx < 0) {
      dir = new PVector(-1, 0);    // move left
    } else if (dy > 0) {
      dir = new PVector(0, 1);    // move down
    } else if (dy < 0) {
      dir = new PVector(0, -1);   // move up
    }

    PVector newPos = new PVector(head.x + dir.x, head.y + dir.y);    // calculates next grid the snake goes to
    if (edgeDetect(newPos) || overlap(newPos, snakes)) {             // when detecting a wall or snake...
      setDirection(random(dir.x), random(dir.y));                    // choose a random direction and hope for the best...
      //println("danger!");
    }

    setDirection(dir.x, dir.y);
  }

  Food getClosestFood(Snake snake, ArrayList<Food> food) {
    float min = 1000;
    Food closestFood = null;

    PVector head = snake.segments.get(0);

    for (int i = 0; i < food.size(); i++) {         // check every piece of food
      Food currentFood = food.get(i);

      PVector pos = new PVector(currentFood.x, currentFood.y);

      float distance = PVector.dist(head, pos);     // calculate distance between the snake head and food

      if (distance < min) {                    // figure out the closest piece of food in order to go to it
        min = distance;
        closestFood = currentFood;
      }
    }
    return closestFood;
  }

  void drawSegment(int index, float x, float y, float size) {     // made it look cool
    push();
    fill(20, 35, 175);
    stroke(0);
    strokeWeight(2);
    rect(
      x,
      y,
      size,
      size,
      1
      );
    pop();
  }
}
