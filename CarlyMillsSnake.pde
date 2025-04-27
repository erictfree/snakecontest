//For my snake code, I copied the movements of the hunter snake, given that it has more intelligence than the humble simple snake. However, I did add comments to explain my understanding of the contents of the code to the best of my ability.

class CarlyMillsSnake extends Snake {
  CarlyMillsSnake(int x, int y) {
    super(x, y, "CARLYSNAKE");
  }

  void think(ArrayList<Food> food, ArrayList<Snake> snakes) {
    
    //calculates the closest piece of food to the snake
Food zz = null;
    float ___z = Float.MAX_VALUE;
    for (Food ww : food) {
      float fdd = abs(ww.x - segments.get(0).x) + abs(ww.y - segments.get(0).y);
      if (fdd < ___z) {
        ___z = fdd;
        zz = ww;
      }
    }
    //moves towards the cloesest piece of food 
    if (zz != null) {
      float jj = zz.x > segments.get(0).x ? 1 : (zz.x < segments.get(0).x ? -1 : 0);
      float dy = zz.y > segments.get(0).y ? 1 : (zz.y < segments.get(0).y ? -1 : 0);
     
     //checks if the move is safe to avoid edges and other snakes
      if (jj != 0 && !yy(new PVector(segments.get(0).x + jj, segments.get(0).y), snakes)) {
        setDirection(jj, 0); //moves horizontally
      } else if (dy != 0 && !yy(new PVector(segments.get(0).x, segments.get(0).y + dy), snakes)) {
        setDirection(0, dy); //moves vertically
      } else {
        xx(snakes); 
      }
    }
  }
  
  //checks whether there is an edge and the move if safe
  boolean yy(PVector pos, ArrayList<Snake> snakes) {
    return edgeDetect(pos) || overlap(pos, snakes);
  }
  
  //moves away from the edge in a safe direction
  void xx(ArrayList<Snake> dd) {
    PVector[] oa = { new PVector(1, 0), new PVector(0, 1), new PVector(-1, 0), new PVector(0, -1) };
    for (PVector dir : oa) {
      PVector newPos = new PVector(segments.get(0).x + dir.x, segments.get(0).y + dir.y);
      if (!yy(newPos, snakes)) {
        setDirection(dir.x, dir.y);
        return;
      }
    }
  }
}
