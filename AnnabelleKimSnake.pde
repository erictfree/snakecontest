// AnnabelleKimSnake
// My strategy for winning is to have my snake just check with paths are safe to move

class AnnabelleKimSnake extends Snake {
  AnnabelleKimSnake(int x, int y) {
    super(x, y, "AnnabelleKimSnake");
  }
  
  void think(ArrayList<Food> food, ArrayList<Snake> snakes) {

  PVector head = segments.get(0);

  // Find the best food
  Food bestFood = null;
  float bestScore = Float.MAX_VALUE;
  for (Food f : food) {
    float d = dist(head.x, head.y, f.x, f.y);
    float effectiveDist = d - (f.points * 5);

    if (effectiveDist < bestScore) {
      bestScore = effectiveDist;
      bestFood = f;
    }
  }

  int dx = 0;
  int dy = 0;
  if (bestFood != null) {
    if (bestFood.x > head.x) dx = 1;
    else if (bestFood.x < head.x) dx = -1;
    else if (bestFood.y > head.y) dy = 1;
    else if (bestFood.y < head.y) dy = -1;
  }

  PVector nextPos = new PVector(head.x + dx, head.y + dy);

  // Check if moving toward food is safe and leads to safe future paths
  if (!edgeDetect(nextPos) && !overlap(nextPos, snakes) && isSafePath(nextPos, snakes, 5)) {
    setDirection(dx, dy); // Move toward best food on safe path
  } else {
    // Otherwise, try alternative directions
    PVector[] possibleDirs = {
      new PVector(1, 0),  // Right
      new PVector(-1, 0), // Left
      new PVector(0, 1),  // Down
      new PVector(0, -1)  // Up
    };

    ArrayList<PVector> dirList = new ArrayList<PVector>(); //direction list
    for (PVector dir : possibleDirs) {
      dirList.add(dir); //add direction to possible directions snake can go
    }
    java.util.Collections.shuffle(dirList); //randomly pick order of directions to move 

    for (PVector dir : dirList) {
      PVector altNextPos = new PVector(head.x + dir.x, head.y + dir.y);
      if (!edgeDetect(altNextPos) && !overlap(altNextPos, snakes) && isSafePath(altNextPos, snakes, 5)) { //if we are getting close to other snakes/walls and there is a safe way out
        setDirection(dir.x, dir.y); //get safe path
        break;
      }
    }
  }
}

// Lookahead function to check if moving to 'pos' leaves escape routes
boolean isSafePath(PVector pos, ArrayList<Snake> snakes, int depth) {
  if (depth == 0) return true;

  // Simulate snake segments after moving
  ArrayList<PVector> tempSegments = new ArrayList<PVector>();
  tempSegments.add(new PVector(pos.x, pos.y));
  for (int i = 0; i < segments.size() - 1; i++) {
    tempSegments.add(new PVector(segments.get(i).x, segments.get(i).y));
  }

  // Try all future directions
  PVector[] futureDirs = {
    new PVector(1, 0),
    new PVector(-1, 0),
    new PVector(0, 1),
    new PVector(0, -1)
  };
  
  //if the future position gets crossed by other snakes/obstacles, return to the other future directions
  for (PVector dir : futureDirs) {
    PVector futurePos = new PVector(pos.x + dir.x, pos.y + dir.y);
    if (!edgeDetect(futurePos) && !overlapSim(futurePos, tempSegments, snakes)) {
      if (isSafePath(futurePos, snakes, depth - 1)) {
        return true;
      }
    }
  }

  return false; 
}

// Simulated overlap check (with own simulated body + real other snakes)
// just checking for other snakes
boolean overlapSim(PVector pos, ArrayList<PVector> tempSegments, ArrayList<Snake> snakes) {
  for (PVector s : tempSegments) {
    if (s.x == pos.x && s.y == pos.y) {
      return true;
    }
  }

  for (Snake other : snakes) {
    for (PVector s : other.segments) {
      if (s.x == pos.x && s.y == pos.y) {
        return true;
      }
    }
  }

  return false;
}
}
