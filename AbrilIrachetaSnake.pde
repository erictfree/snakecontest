//This snake moves intelligently by always seeking out the nearest piece of food while also avoiding
//collisions with walls and other snakes. First it identifies all possible movement directions,
//sorts them by how close they would get it to the food, and then choose the safest option. 
//If no ideal path is found, the snake will randomly pick a safe move. This strategy focuses
//on survival (avoiding crashes) while progressing toward food to grow.
class AbrilIrachetaSnake extends Snake {

  //Constructor: initializes the snake at position (x, y)
  AbrilIrachetaSnake(int x, int y) {
    super(x, y, "AbrilIrachetaSnake_");
  }

  //Main logic to decide how the snake moves each frame
  void think(ArrayList<Food> food, ArrayList<Snake> snakes) {
    PVector head = segments.get(0);//Get the head position of the snake

    //Find the nearest food........................................
    Food nearest = getClosestFood(this, food);

    //Define possible movement directions......................................
    PVector[] dirs = {
      new PVector(1, 0),
      new PVector(-1, 0),
      new PVector(0, 1), 
      new PVector(0, -1)
    };

    //Sort directions based on which moves closer to the nearest food.............................................
    if (nearest != null) {
      for (int i = 0; i < dirs.length - 1; i++) {
        for (int j = i + 1; j < dirs.length; j++) {
          float di = dist(head.x + dirs[i].x, head.y + dirs[i].y, nearest.x, nearest.y);
          float dj = dist(head.x + dirs[j].x, head.y + dirs[j].y, nearest.x, nearest.y);
          if (dj < di) {
            //Swap directions to prioritize the closer one
            PVector temp = dirs[i];
            dirs[i] = dirs[j];
            dirs[j] = temp;
          }
        }
      }
    }

    //Find the best safe direction to move...............................................
    PVector bestDir = null;
    float bestDist = Float.MAX_VALUE;
    for (PVector dir : dirs) {
      float newX = head.x + dir.x;
      float newY = head.y + dir.y;

      boolean hitSomething = false;

      //Check if new position would go outside the screen
      if (newX < 0 || newX >= width / GRIDSIZE || newY < 0 || newY >= height / GRIDSIZE) {
        hitSomething = true;
      }

      //Check if new position would collide with any snake
      for (Snake snake : snakes) {
        for (PVector segment : snake.segments) {
          if (newX == segment.x && newY == segment.y) {
            hitSomething = true;
            break;
          }
        }
        if (hitSomething) break;
      }

      //If safe, check if it's closer to the food than the previous best
      if (!hitSomething && nearest != null) {
        float newDist = abs(newX - nearest.x) + abs(newY - nearest.y);
        if (newDist < bestDist) {
          bestDist = newDist;
          bestDir = dir;
        }
      }
    }

    //Move the snake....................................................
    if (bestDir != null) {
      //Move towards the best direction found
      setDirection(bestDir.x, bestDir.y);
    } else {
      //No good move found, pick a random safe direction
      shuffleArray(dirs);
      for (PVector dir : dirs) {
        PVector next = new PVector(head.x + dir.x, head.y + dir.y);
        if (!edgeDetect(next) && !overlap(next, snakes)) {
          setDirection(dir.x, dir.y);
          return;
        }
      }
    }
  }

  //Utility method: Find the closest food item to this snake
  Food getClosestFood(Snake snake, ArrayList<Food> food) {
    PVector head = snake.segments.get(0);
    Food closest = null;
    float minDist = Float.MAX_VALUE;
    for (Food f : food) {
      float d = dist(f.x, f.y, head.x, head.y);
      if (d < minDist) {
        minDist = d;
        closest = f;
      }
    }
    return closest;
  }

  //Utility method: Shuffle an array of directions
  void shuffleArray(PVector[] array) {
    for (int i = array.length - 1; i > 0; i--) {
      int j = (int) random(i + 1);
      PVector temp = array[i];
      array[i] = array[j];
      array[j] = temp;
    }
  }

  //Draw each segment of the snake with a multicolor gradient................................................
  void drawSegment(int index, float x, float y, float size) {
    push();
    colorMode(HSB);//Use Hue-Saturation-Brightness color mode
    ellipseMode(CORNER);//Draw ellipses
    int c = int(map(index, 0, this.segments.size(), 0, 255));//Color depends on segment index
    fill(c, 255, 255);//Full saturation and brightness
    ellipse(x, y, size, size);
    pop();
  }
}
