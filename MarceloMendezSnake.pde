

/*
search for food, first randomly, and then try to follow the path
when food _is_ found

 */
class MarceloMendezSnake extends Snake {
  MarceloMendezSnake(int x, int y ) {
    super(x, y, "Marcelo Mendez");
  }


  void think(ArrayList<Food> food, ArrayList<Snake> snakes) {
    PVector head = segments.get(0);  // current head position
    if (food.isEmpty()) {   // no food? wander
      setDirection((float)(Math.random()*3-1), // random x
                   (float)(Math.random()*3-1)); // random y
      return;    // done this turn
    }

    // loop through all food objects
    Food best = food.get(0);

    // get the distance for the best one close by
    float bestD = abs(best.x - head.x) + abs(best.y - head.y);

    for (Food f : food) {
      // aka |x1 - x2| + |y1 - y2|
      float d = abs(f.x - head.x) + abs(f.y - head.y);
      if (d < bestD) {
        best = f;
        bestD = d;
      }
    }


    
    int dx = (int)Math.signum(best.x - head.x),  
        dy = (int)Math.signum(best.y - head.y);  

    // dx -> horizontal
    // dy -> vertical

    if (dx != 0) {   // try horizontal
      PVector np = new PVector(head.x + dx, head.y);   // new pos x
      if (!edgeDetect(np) && !overlap(np, snakes)) {  // safe?
        setDirection(dx, 0); return;    // go x
      }
    }
    if (dy != 0) { // try vertical
      PVector np = new PVector(head.x, head.y + dy); // new pos y
      if (!edgeDetect(np) && !overlap(np, snakes)) {   // safe?
        setDirection(0, dy); return;    // go y
      }
    }
    setDirection(1, 0);  
  }

  
}
