// Charis Elkinton Snake class - moves randomly with no intelligence

class CharisElkintonSnake extends Snake {
  CharisElkintonSnake(int x, int y) {
    super(x, y, "CharisElkintonSnake");
  }
  PVector food;

  void think(ArrayList<Food> food, ArrayList<Snake> snakes) {        //Array list for food and snakes
    Food closeFood = getCloseFood(this, food);                       //calls function to find close food

    PVector head = this.segments.get(0);                             //gets the position of the head

    PVector[] directions = {                                         //array for all directions
      new PVector(0, -1), // Up
      new PVector(0, 1), // Down
      new PVector(-1, 0), // Left
      new PVector(1, 0)    // Right
    };

    ArrayList<PVector> safeD = new ArrayList<PVector>();              //array list from directions that are safe to move

    for (int i = 0; i < directions.length; i++) {                       //for loop to go through all directions
      PVector dir = directions[i];                                      //get direction from array
      PVector nextPos = new PVector(head.x + dir.x, head.y + dir.y);    //next position could move

      if (!edgeDetect(nextPos) && !overlap(nextPos, snakes)) {              //check if next position is safe from edges and other snakes
        safeD.add(dir);                                                   // add to safe directions to safeD
      }
    }
    if (safeD.size() == 0) {                                            //if no safe moves - move in current direction (game freezes without this)
      return;                                                           //snake dies
    }

    PVector bestDir = safeD.get(0);                                    //gets directions that it finds safe
    float min = 1000;                                                  //set min distance large to begin
    
    for (int i = 0; i < safeD.size(); i++) {                              //loop through safe directions
      PVector d = safeD.get(i);                                           //get the safe direction
      PVector nextPos = new PVector(head.x + d.x, head.y + d.y);            //next position after moving that is safe

      float distance = dist(nextPos.x, nextPos.y, closeFood.x, closeFood.y);        //next position that is closest to food

      if (distance < min) {                                              //if this direction is closer than last update min distance
        min = distance;
        bestDir = d;                                                    //best direction is to get safe position and closest to food
      }
    }

    setDirection(bestDir.x, bestDir.y);                                  //set the direction the snake should move based on best direction
  }


  Food getCloseFood (Snake snake, ArrayList<Food> food) {                    //tells us where we want to go next and is there something there
    float min = 1000;                                                        //stores the shortest distance getting shorter every time through for statement
    Food closeFood = null;                                                   //will hold closest food

    PVector head = snake.segments.get(0);                                      //get position of snake head

    for (int i = 0; i < food.size(); i++) {                                     //iterate through food array to find closest food
      Food currentFood = food.get(i);                                           //gets current food position

      PVector pos = new PVector(currentFood.x, currentFood.y);

      float distance = PVector.dist(head, pos);                                  //gets distance from head to food

      if (distance < min) {                                                      //if this food is closer than last update min
        min = distance;
        closeFood = currentFood;
      }
    }
    return closeFood;                                                            //after checking reutrn the closest food
  }
}
