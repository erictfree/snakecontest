// SimpleSnake class - moves randomly with no intelligence

class HoangMNguyenSnake extends Snake {
  HoangMNguyenSnake(int x, int y) {
    super(x, y, "HoangMNguyenSnake");
  }
// so bascially my strategy is go real fast at the begin until like 15 segments, then go normal speed until I get really long or the snake count is low, I freeze because I think if I survive this long 
// the other snakes probably are long too, so I freeze to wait for them to make mistake. When there is two I think it all comes down to luck so I go normal speed again
  void think(ArrayList<Food> food, ArrayList<Snake> snakes) {
    float dx;
    float dy;
    PVector head = this.segments.get(0);
    if (snakes.size()>5) { // when the population is high
      if (this.segments.size() <15) { //when less than 15 segments, burst speed
        updateInterval = 20;
      } else if (this.segments.size() >=10 && this.segments.size() <=60  ) { // if my snake is in between 10 to 50 segments move normal speed
        updateInterval = 100;
      }
         else if ( this.segments.size() > 60 || snakes.size()<= 5  || snakes.size()>= 3){ // if more than that, and the population is less than 5 and larger than 3, go real slow
        updateInterval = 5000;
    }
    }
    else if (snakes.size()<= 5 && snakes.size()>= 3 ) 
   // if the population is less than 5 and larger than 3, go real slow
    {
      updateInterval = 5000;
    } //when there are 2, go normal
    else{ updateInterval = 100; 
    }
    

    Food closestFood = getClosestFood(this, food);



    dx = closestFood.x - head.x;  // figure out how far the food is
    dy = closestFood.y - head.y;  // in x and y distances
    //println ("closet food: " + dx + "_____" +dy);

    PVector dir = null;
    if (dy > 0) {
      dir = new PVector(0, 1);
    } else if (dy < 0) {
      dir = new PVector(0, -1);
    } else if (dx > 0) {
      dir = new PVector(1, 0);
    } else if (dx < 0) {
      dir = new PVector(-1, 0);
    }

    PVector newPos = new PVector(head.x + dir.x, head.y + dir.y);

    if (edgeDetect(newPos) || overlap(newPos, snakes)) {
      if (dir.x == 0) { // which mean the move that kills the skake is either up or down
        dir = new PVector(1, 0); // force it to go left
        newPos = new PVector(head.x + dir.x, head.y + dir.y); // update detection
        if (edgeDetect(newPos) || overlap(newPos, snakes)) { // this will be true if it kills the snake
          dir = new PVector(-1, 0);// force it to right
        }
       
      } else if (dir.y == 0)  // which mean the move that kills the skake is either left or right
      {
        dir = new PVector(0, 1); // force it to go up
        newPos = new PVector(head.x + dir.x, head.y + dir.y); // update detection
        if (edgeDetect(newPos) || overlap(newPos, snakes)) { // this will be true if it kills the snake
          dir = new PVector(0, -1);// force it to down
        }
      }
    }


    setDirection(dir.x, dir.y);
  }

  Food getClosestFood(Snake snake, ArrayList<Food> food) {
    float min = 1000;
    Food closestFood = null;

    PVector head = snake.segments.get(0);

    for (int i = 0; i < food.size(); i++) { // every piece of food
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

}
