// SimpleSnake class - moves randomly with no intelligence

class MichaelGameSnake extends Snake {
  boolean movingRight = true;
  
  MichaelGameSnake(int x, int y) {
    super(x, y, "MichaelGame");
    debug=true;
  }

  void think(ArrayList<Food> food, ArrayList<Snake> snakes) {
    Food closestFood = getClosestFood(food, this);
    
    PVector head = this.segments.get(0);
    
    float dx = closestFood.x - head.x;
    float dy = closestFood.y - head.y;
    
    move(dx, dy, head);
  }
  
  Food getClosestFood(ArrayList<Food> food, Snake snake) 
  {
    float min = 1000;
    Food closestFood = null;
    PVector head = snake.segments.get(0);
    
    for (int i = 0; i < food.size(); i++)
    {
      Food currentFood = food.get(i);
      
      PVector pos = new PVector (currentFood.x, currentFood.y);
      
      float distance = PVector.dist(head, pos);
      
      if (distance < min)
      {
        min = distance;
        closestFood = currentFood;
      }
    }
    return closestFood;
  }
  
  void move(float x, float y, PVector head)
  {
    // Cardinal Directions
    PVector east = new PVector(head.x - 1,  head.y);
    PVector west = new PVector(head.x + 1,  head.y);
    PVector north = new PVector(head.x, head.y - 1);
    PVector south = new PVector(head.x, head.y + 1);
    
    // At edge turn around
    if (edgeDetect(west))
    {
      // If edge north go south
      if (edgeDetect(north))
      {
        setDirection(0, 1);
        movingRight = false;
      }
      // If edge south go north
      else if (edgeDetect(south))
      {
        setDirection(0, -1);
        movingRight = false;
      }
      // If snake north go south
      else if (overlap(north, snakes))
      {
        setDirection(0, 1);
        movingRight = false;
      }
      // If snake south go north
      else if (overlap(south, snakes))
      {
        setDirection(0, -1);
        movingRight = false;
      }
      else
      {
        setDirection(0, -1);
        movingRight = false;
      }
    }
    else if (edgeDetect(east))
    {
      if (edgeDetect(north))
      {
        setDirection(0, 1);
        movingRight = true;
      }
      else if (edgeDetect(south))
      {
        setDirection(0, -1);
        movingRight = true;
      }
      else if (overlap(north, snakes))
      {
        setDirection(0, 1);
        movingRight = true;
      }
      else if (overlap(south, snakes))
      {
        setDirection(0, -1);
        movingRight = true;
      }
      else
      {
        setDirection(0, 1);
        movingRight = true;
      }
    }
    
    // To move from end to end
    if (x != 0 || abs(y) > 5)
    {
      if (movingRight)
      {
        setDirection(1, 0); // East   
        // If snake change direction
        if (overlap(west, snakes))
        {
          if (overlap(south, snakes))
          {
            setDirection(0, -1); // North
          }
          setDirection(0, 1); // South
        }
      }
      else
      {
        setDirection(-1, 0); // West
        // If snake change direction
        if (overlap(east, snakes))
        {
          if (overlap(south, snakes))
          {
            setDirection(0, -1); // North
          }
          setDirection(0, 1); // South
        }
      }
    }
    else
    {
      // To grab food
      if (y > 0)
      {
        setDirection(0, 1); // South
        // If snake change direction
        if (overlap(south, snakes))
        {
          if (overlap(east, snakes))
          {
            setDirection(-1, 0); // West
          }
          setDirection(1, 0); // East
        }
      }
      else if (y < 0)
      {
        setDirection(0, -1); // North
        // If snake change direction
        if (overlap(north, snakes))
        {
          if (overlap(east, snakes))
          {
            setDirection(-1, 0); // West
          }
          setDirection(1, 0); // East
        }
      }
    }
  }
}
