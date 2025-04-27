//I wanted to make a snake whos main priorities were to survive and eat. Appearance wise I was inspired by the hognose snake

PImage headImage, bodyImage, tailImage;

class AvaCarzolaSnake extends Snake {
  AvaCarzolaSnake(int x, int y) {
    super(x, y, "AvaCarzolaSnake");
    headImage = loadImage("assets/snakeHead.png");
    bodyImage = loadImage("assets/snakeBody.png");
    tailImage = loadImage("assets/snakeTail.png");
    //file locations for the images
  }

  void think(ArrayList<Food> food, ArrayList<Snake> snakes) {
    Food closestFood = getClosestFood(this, food); //find food

    PVector head = this.segments.get(0); //snake head

    float dx = closestFood.x - head.x; //x distance to food
    float dy = closestFood.y - head.y; //y distance to food

    PVector dir = null;

    if (dx > 0) {
      dir = new PVector(1, 0); // Right
    } else if (dx < 0) {
      dir = new PVector(-1, 0); // Left
    } else if (dy > 0) {
      dir = new PVector(0, 1); // Down
    } else if (dy < 0) {
      dir = new PVector(0, -1); // Up
    } else {
      dir = new PVector(0, 0); // No movement, fixes null issue
    }

    PVector newPos = new PVector(head.x + dir.x, head.y + dir.y); //new position

    boolean hitsWall = edgeDetect(newPos); //hit a wall
    boolean hitsSnake = overlap(newPos, snakes); //hit a snake
    boolean hitsOwnBody = hitsSelf(newPos); //hit self

    if (hitsWall || hitsSnake || hitsOwnBody) { //is there danger?
      dir = moveSafe(head, snakes); //move away from danger
    }
    
    setDirection(dir.x, dir.y); //the direction
  }
  
  boolean edgeDetect(PVector pos) {
    return (pos.x < 0 || pos.y < 0 || pos.x >= 100 || pos.y >= 55); //game walls, there are 100 collomns and 55 rows
  }
  
  boolean overlap(PVector pos, ArrayList<Snake> snakes) {
  for (int i = 0; i < snakes.size(); i++) { //all snakes
    Snake otherSnake = snakes.get(i); //a snake
    for (int j = 0; j < otherSnake.segments.size(); j++) { //all snake bodies
      PVector part = otherSnake.segments.get(j); //enemy snake body location
      if (part.x == pos.x && part.y == pos.y) { //are we hitting the enemy snake?
        return true; //hit enemy snake
      }
    }
  } 
  return false; //no enemy
}
  
  boolean hitsSelf(PVector pos) {
    for (int i = 1; i < segments.size(); i++) { 
      PVector part = segments.get(i); //where is my snake's body
      if (part.x == pos.x && part.y == pos.y) { //are we hitting ourself?
        return true; //hits self
      }
    }
    return false; //does not hit self
  }

  PVector moveSafe(PVector head, ArrayList<Snake> snakes) { //which way is safe?
    PVector right = new PVector(1, 0); //right
    PVector left = new PVector(-1, 0); //left
    PVector down = new PVector(0, 1); //down
    PVector up = new PVector(0, -1); //up

    PVector[] directions = {right, left, down, up}; //choices

    for (int i = 0; i < directions.length; i++) { //goes through choices
      PVector direction = directions[i];
      PVector newPos = new PVector(head.x + direction.x, head.y + direction.y); 
      if (!edgeDetect(newPos) && !overlap(newPos, snakes) && !hitsSelf(newPos)) {//is it safe?
          return direction; //move to safe path
      }
    }
    
    return new PVector(0, 0); //no move
  }

  Food getClosestFood(Snake snake, ArrayList<Food> food) {
    float min = 1000; //1000 is the map size, so there can't be food further
    Food closestFood = null;

    PVector head = snake.segments.get(0); //snake head

    for (int i = 0; i < food.size(); i++) { //every piece of food
      Food currentFood = food.get(i); //go after food

      PVector pos = new PVector(currentFood.x, currentFood.y); //wher is food

      float distance = PVector.dist(head, pos); //how far is food?

      if (distance < min) {
        min = distance; //is it closer?
        closestFood = currentFood; //update
      }
    }
    return closestFood; //go after new closestfood
  }

  //Snake art!
  void drawSegment(int index, float x, float y, float size) {
      push(); //save
      translate(x + size / 2, y + size / 2); //snake is centered
      PVector dir = getSegmentDirection(index); //which way is the snake facing?
      rotateSegment(dir); //rotate the snake parts based on the direction of the snake
      if (index == 0) {
        image(headImage, -size/2, -size/2, size, size); //first segment is the snake head
      } else if (index == segments.size() - 1) {
        image(tailImage, -size/2, -size/2, size, size); //middle segments are the snake body
      } else {
        image(bodyImage, -size/2, -size/2, size, size); //last segment is the snake tail
      }
      pop(); //reset
    }
  
  PVector getSegmentDirection(int index) {
    if (index == 0) {
      return new PVector(direction.x, direction.y); //head is simple, it follows the same direction
    }
    
    int nextIndex = (index == segments.size() - 1) ? index - 1 : index + 1; //body and tail segments lag in direction
    PVector current = segments.get(index); //the segments are based upon the ones that combe before
    PVector next = segments.get(nextIndex);
   
    float dx = next.x - current.x; //x difference, determines direction bellow
    float dy = next.y - current.y; //y difference, determines direction bellow
        
    PVector dir = new PVector(0, 0);
    if (dx > 0) dir = new PVector(1, 0); //right
    if (dx < 0) dir = new PVector(-1, 0); //left
    if (dy > 0) dir = new PVector(0, 1); //down
    if (dy < 0) dir = new PVector(0, -1); //up
    return dir; //the new direction
  }
  
  void rotateSegment(PVector dir) { //rotate the snake parts based on the direction of the snake
    if (dir.x == 1) {
      rotate(radians(0)); //right
    } else if (dir.x == -1) {
      rotate(radians(180)); //left
    } else if (dir.y == -1) {
      rotate(radians(-90)); //up
    } else if (dir.y == 1) {
      rotate(radians(90)); //down
    }
  }
}
