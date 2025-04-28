// Devon Voyles Snake 
// 
// I chose to make my snake use a primary color scheme (red, blue, yellow) because I ended up 
// playing a lot with primary colors this semester, and it felt like a fun way to finish it all off.
// I wanted the colors to be bold, clean, and kind of joyful, something simple but striking and look a little unique. 
// As for the snake's strategy: I wanted it to stay alive as long as possible, but also to 
// actively go after food instead of just wandering around randomly. So the snake looks for 
// directions that are safe (doesn't hit a wall, itself, or another snake) and also tries to 
// move closer to the nearest food when it can. If it's trapped, it does a "hail mary" move 
// and just keeps moving in a safe random direction. 
// The goal was for it to feel smart enough to survive but still a little unpredictable
// like it's doing its best out there. :)

class DevonVoylesSnake extends Snake {

  DevonVoylesSnake(int x, int y) {
    super(x, y, "DevonVoylesSnake");
     
  }

  void think(ArrayList<Food> food, ArrayList<Snake> snakes) {
    // possible directions: right, left, down, up
    PVector[] possibleDirs = {
      new PVector(1, 0),   // right
      new PVector(-1, 0),  // left
      new PVector(0, 1),   // down
      new PVector(0, -1)   // up
    };

    PVector head = segments.get(0); // current head position
    ArrayList<PVector> safeDirs = new ArrayList<PVector>();

    // find all safe directions
    for (PVector dir : possibleDirs) {
      float newX = head.x + dir.x;
      float newY = head.y + dir.y;

      // stay inside bounds and avoid collisiion
      if (newX >= 0 && newX < width / gridSize && newY >= 0 && newY < height / gridSize) {
        if (!willCollide(newX, newY, snakes)) {
          safeDirs.add(dir);
        }
      }
    }

    // if there are safe directions
    if (safeDirs.size() > 0) {
      // try to move toward the closest food
      PVector bestDir = findFoodDirection(head, safeDirs, food);
      setDirection(bestDir.x, bestDir.y);
    } else {
      // if stuck, stay in current direction
      setDirection(direction.x, direction.y);
    }
  }

  // helper function to check if moving to (newX, newY) will cause collision
  boolean willCollide(float newX, float newY, ArrayList<Snake> snakes) {
    // Check own body
    for (PVector segment : segments) {
      if (segment.x == newX && segment.y == newY) {
        return true;
      }
    }

    // check other snakes
    for (Snake s : snakes) {
      if (s == this) continue; // Skip self
      for (PVector segment : s.segments) {
        if (segment.x == newX && segment.y == newY) {
          return true;
        }
      }
    }

    return false;
  }

  // helper function to pick the safest direction toward the nearest food
  PVector findFoodDirection(PVector head, ArrayList<PVector> safeDirs, ArrayList<Food> food) {
    if (food.size() == 0) {
      // No food, move randomly among safe directions
      return safeDirs.get((int)random(safeDirs.size()));
    }

    // find closest food
    Food closest = null;
    float closestDist = Float.MAX_VALUE;

    for (Food f : food) {
      float d = dist(head.x, head.y, f.x, f.y);
      if (d < closestDist) {
        closestDist = d;
        closest = f;
      }
    }

    // Now choose the direction that gets us closer to the closest food
    PVector bestDir = safeDirs.get(0);
    float bestDist = Float.MAX_VALUE;

    for (PVector dir : safeDirs) {
      float newX = head.x + dir.x;
      float newY = head.y + dir.y;
      float d = dist(newX, newY, closest.x, closest.y);
      if (d < bestDist) {
        bestDist = d;
        bestDir = dir;
      }
    }

    return bestDir;
  }
  @Override
void draw() {
  color[] colors = {
    color(255, 0, 0),   // Red
    color(0, 0, 255),   // Blue
    color(255, 255, 0)  // Yellow
  };

  rectMode(CENTER); // draw from center
  stroke(0); // black outline
  strokeWeight(1); // thin border

  for (int i = 0; i < segments.size(); i++) {
    PVector segment = segments.get(i);

    color c = colors[i % colors.length]; // alternate red → blue → yellow
    fill(c);

    float centerX = segment.x * gridSize + gridSize / 2;
    float centerY = segment.y * gridSize + gridSize / 2;
    float size = gridSize * 0.8; // 80% of grid size so they don't touch edges

    rect(centerX, centerY, size, size);
  }

  // draw the name above the head
PVector head = segments.get(0);
fill(255); // white text
textAlign(CENTER, BOTTOM);
textSize(12); // smaller text size to match others
text(name, head.x * gridSize + gridSize / 2, head.y * gridSize);

  rectMode(CORNER); // reset back to normal after drawing
}
}
