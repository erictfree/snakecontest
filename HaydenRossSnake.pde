// SimpleSnake class - moves randomly with no intelligence

class HaydenRossSnake extends Snake {
  HaydenRossSnake(int x, int y) {
    super(x, y, "HaydenRossSnake");
  }

  void think(ArrayList<Food> food, ArrayList<Snake> snakes) {
    Food closestFood = getClosestFood(this, food);
    //Snake closestEnemy = getClosestSnake(Snake, snakes); trying to detect other snakes

    PVector head = this.segments.get(0);
    //PVector body = this.segments.get(0);//my snakes body

    float dx = closestFood.x - head.x;
    float dy = closestFood.y - head.y;
    //float bx = body.x - head.x;//my snakes body
    //float by = body.y - head.y;

    PVector dir = null;
    if (dx > 0) {
      dir = new PVector(1, 0);
    } else if (dx < 0) {
      dir = new PVector(-1, 0);
    } else if (dy > 0) {
      dir = new PVector(0, 1);
    } else if (dy < 0) {
      dir = new PVector(0, -1);
    }
    
    //if (bx > 0) { //attempting to see if this will stop myself colliding into myself
    //  dir = new PVector(1, 0);
    //} else if (bx < 0) {
    //  dir = new PVector(-1, 0);
    //} else if (by > 0) {
    //  dir = new PVector(0, 1);
    //} else if (by < 0) {
    //  dir = new PVector(0, -1);
    //} welp that didnt work
    




    PVector newPos = new PVector(head.x + dir.x, head.y + dir.y);

    if (edgeDetect(newPos)) {
      newPos = new PVector(-1, 0);// if it hits the edge it should go to the side/up or down
    } else if (edgeDetect(newPos)) {
      newPos = new PVector(0, -1);
    }

    if (overlap(newPos, snakes)) {
      newPos = new PVector(-1, 0);// if it hits a snake it should go to the side/up or down
    } else if (overlap(newPos, snakes)) {
      newPos = new PVector(0, -1);
    }


    setDirection(dir.x, dir.y);
  }

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

  //Snake getClosestSnake(Snake snake, ArrayList<Snake> snakes) { //trying to not hit enemy snakes
  //  float max = 3; // how far away the other snake is, 3 units away seems far enough
  //  Snake closestSnake = null;
  //  PVector head = snake.segments.get(0);//i think sees where my head is
  //  PVector body = snake.segments.get(0);//i think sees where enemys body is

  //  for (int i = 0; i > body; i--) { //keeps saying its mismatched or that <, >, and = are undefined
    
  //  closestSnake = snakes.get(i);
    
  //  float nDist = PVector.dist(head, body);
    
  //  PVector dir = null;
  //  if (nDist < max) {
  //     dir = new PVector(1, 0);
  //  } 
  //  }
  //}
}
