// ChiomaAguoruSnake – avoids walls & snakes, speeds up near food
class ChiomaAguoruSnake extends Snake {
  int baseSpeed = 100; //regular speed
  int fastSpeed = 50; //faster speed when near food
  float foodDetectionRadius = 50; //distance before speeding up

  ChiomaAguoruSnake(int x, int y) {
    super(x, y, "ChiomaAguoru");
    updateInterval = baseSpeed;
  }

 
  void think(ArrayList<Food> food, ArrayList<Snake> snakes) {   
    Food closestFood = getClosestFood(this, food); // find the closest food
    PVector head     = segments.get(0);
    PVector foodPos  = new PVector(closestFood.x, closestFood.y);

    //speed up if within detection radius
    float distance = PVector.dist(head, foodPos);
    if (distance < foodDetectionRadius) {
      updateInterval = fastSpeed;
    } else {
      updateInterval = baseSpeed;
    }

    // forward step toward food
    float dx = foodPos.x - head.x;
    float dy = foodPos.y - head.y;
    PVector forward = new PVector(0, 0);

    if (abs(dx) > abs(dy)) {
      if (dx > 0) {
        forward.x = 1;
      } else {
        forward.x = -1;
      }
    } else {
      if (dy > 0) {
        forward.y = 1;
      } else {
        forward.y = -1;
      }
    }

    // directions snake can take --> forward, side1, side2, reverse
    PVector side1   = new PVector(-forward.y, forward.x);
    PVector side2   = new PVector( forward.y, -forward.x);
    PVector reverse = new PVector(-forward.x, -forward.y);
    PVector[] picks = { forward, side1, side2, reverse };

    // pick the first safe direction
    PVector chosen = null;
    for (int i = 0; i < picks.length; i++) {
      PVector d = picks[i];
      PVector testPos = new PVector(head.x + d.x, head.y + d.y);
      if (!edgeDetect(testPos) && !overlap(testPos, snakes)) {
        chosen = d;
        break;
      }
    }

    // if no paths are safe, reverse
    if (chosen == null) {
      chosen = reverse;
    }

    
    setDirection(chosen.x, chosen.y);
  }

 
  Food getClosestFood(Snake snake, ArrayList<Food> food) {
    PVector head = snake.segments.get(0);
    Food closestFood = food.get(0);
    PVector pos0 = new PVector(closestFood.x, closestFood.y);
    float minDistance = PVector.dist(head, pos0);

    for (int i = 1; i < food.size(); i++) {
      Food currentFood = food.get(i);
      PVector pos = new PVector(currentFood.x, currentFood.y);
      float distance = PVector.dist(head, pos);
      if (distance < minDistance) {
        minDistance = distance;
        closestFood = currentFood;
      }
    }
    return closestFood;
  }
}
