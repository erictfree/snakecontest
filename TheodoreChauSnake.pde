/*
My strategy is to make my snake move faster when it is close to food and slower when it is not
 close to food. My snake always moves toward the closest food and avoids colliding with the
 edge of the screen or other snakes.
 */

// TheodoreChauSnake class

class TheodoreChauSnake extends Snake {
  TheodoreChauSnake(int x, int y) {
    super(x, y, "TheodoreChau");
  }

  void think(ArrayList<Food> food, ArrayList<Snake> snakes) {
    Food closestFood = getClosestFood(this, food);  //get the closest food to the snake
    PVector head = this.segments.get(0);  //get the position of the head of the snake

    PVector[] possibleDirs = {  //define all possible directions: right, left, down, up
      new PVector(1, 0), //right
      new PVector(-1, 0), //left
      new PVector(0, 1), //down
      new PVector(0, -1)  //up
    };

    PVector bestDir = null;  //best direction
    float shortestDist = 1000;  //shortest distance

    for (int i = 0; i < possibleDirs.length; i++) {  //for each possible direction
      PVector dir = possibleDirs[i];  //get the direction
      PVector newPos = new PVector(head.x + dir.x, head.y + dir.y);  //calculate the new possible position

      if (!edgeDetect(newPos) && !overlap(newPos, snakes)) {  //check if the new possible position is not on the edge of the screen and not colliding with other snakes
        float distToFood = PVector.dist(newPos, new PVector(closestFood.x, closestFood.y));  //calculate the distance to closest food

        if (distToFood < shortestDist) {  //if this moves the snake closer to food
          shortestDist = distToFood;  //update the shortest distance
          bestDir = dir;  //update the best direction
        }
      }
    }

    if (bestDir != null) {  //if there is a best direction, set the direction
      setDirection(bestDir.x, bestDir.y);
    } else {  //if there is not a best direction, it's so over (because it's stuck)
      println("it's so over :(");
    }
  }

  Food getClosestFood(Snake snake, ArrayList<Food> food) {  //gets the closest food to the snake
    float min = 1000;  //minimum distance
    Food closestFood = null;  //closest food

    PVector head = snake.segments.get(0);  //get the position of the head of the snake

    for (int i = 0; i < food.size(); i++) {  //every piece of food
      Food currentFood = food.get(i);  //get the current food

      PVector pos = new PVector(currentFood.x, currentFood.y);  //position of the current food

      float distance = PVector.dist(head, pos);  //calculate the distance from the head of the snake to the current food

      if (distance < min) {  //if this is closer than the previous closest food
        min = distance;  //update the minimum distance
        closestFood = currentFood;  //update the closest food
      }
    }

    if (min < 5) {  //if the snake is close to food, make the snake update faster
      updateInterval = 60;
    } else {  //if the snake is not close to food, make the snake update slower
      updateInterval = 200;
    }
    return closestFood;  //return the closest food
  }

  void drawSegment(int index, float x, float y, float size) {  //changes the look of the snake
    push();
    colorMode(HSB);  //set color mode to hsb
    ellipseMode(CORNER);  //set ellipse mode to corner
    int c = int(map(index, 0, this.segments.size(), 200, 225));  //map the index of the segment to a color range
    float s = map(index, 0, this.segments.size(), size, size - 5);  //map the index of the segment to a size range
    noStroke();  //no stroke
    fill(c, 255, 255);  //set the fill color
    ellipse(  //draw the ellipse for the segment
      x,
      y,
      s,
      s
      );
    pop();
  }
}
