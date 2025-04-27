// my snake class that extends/inherits the main snake class
class JovannaMolinaSnake extends Snake 
{
// this sets up my own snake, and this is a constructor
  JovannaMolinaSnake(int x, int y) {
    super(x, y, "JovannaMolina");
  }

// this decides where my snake should move 
  void think(ArrayList<Food> food, ArrayList<Snake> snakes) {
    
    // head position of my snake
    PVector head = segments.get(0);

    // this finds the food to go after
    Food bestFood = null;
    float bestScore = Float.MAX_VALUE;
    for (Food f : food) {
      float d = dist(head.x, head.y, f.x, f.y);
      
      // take in high-point food
      float effectiveDist = d - (f.points * 5); 
      // this saves the food so far
      if (effectiveDist < bestScore) {
        bestScore = effectiveDist;
        bestFood = f;
      }
    }

    // this is all direction, like where my snake should go
    int dx = 0;
    int dy = 0;
    if (bestFood != null) {
      if (bestFood.x > head.x) dx = 1;
      else if (bestFood.x < head.x) dx = -1;
      else if (bestFood.y > head.y) dy = 1;
      else if (bestFood.y < head.y) dy = -1;
    }

   // next moves for the head
    PVector nextPos = new PVector(head.x + dx, head.y + dy);

    // this detects if my snake crashes into something like a wall or another snake
    if (!edgeDetect(nextPos) && !overlap(nextPos, snakes)) {
      setDirection(dx, dy); // Move toward best food
    } else {
      // this makes my snake move backwards
      PVector[] possibleDirs = {
        new PVector(1, 0),  // Right
        new PVector(-1, 0), // Left
        new PVector(0, 1),  // Down
        new PVector(0, -1)  // Up
      };
// all of this puts the possible paths into an arraylist
      ArrayList<PVector> dirList = new ArrayList<PVector>();
      for (PVector dir : possibleDirs) {
        dirList.add(dir);
      }
      java.util.Collections.shuffle(dirList);

// this tries all possible direction until reaching the safest one
      for (PVector dir : dirList) {
        PVector altNextPos = new PVector(head.x + dir.x, head.y + dir.y);
        if (!edgeDetect(altNextPos) && !overlap(altNextPos, snakes)) {
          setDirection(dir.x, dir.y);
          break;
        }
      }
    }
  }
}
