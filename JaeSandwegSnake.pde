/* the biggest danger for any snake is not other players or the wall, but trapping themselves 
within themselves. This risk only gets larger as the snake grows. To avoid this outcome, my 
snake moves very slow, resulting in it growing very slowly, and also giving it time to change
direction before it can trap itself. I also made it so that the snake goes after a scewed 
coordinate when serching for food, increasing the closests food coordinate by 3, so that 
while it is still seraching for food, it will usually miss it, making it groweven slower*/


class JaeSandwegSnake extends Snake {
  JaeSandwegSnake(int x, int y) {
    super(x, y, "Jae Sandweg");
    
    updateInterval = 1000;
  
  }
Food getClosestFood(Snake snake, ArrayList<Food> food) {
    float min = 1000;
    Food closestFood = null;

    PVector head = snake.segments.get(0);

    for (int i = 0; i < food.size(); i++) { 
      Food currentFood = food.get(i);

      PVector pos = new PVector((currentFood.x+3) , (currentFood.y+3));

      float distance = PVector.dist(head, pos);

      if (distance < min) {
        min = distance;
        closestFood = currentFood;
      }
    }
    return closestFood;
  }
  
    void think(ArrayList<Food> food, ArrayList<Snake> snakes) {
    Food closestFood = getClosestFood(this, food);

    PVector head = this.segments.get(0); 
    
     PVector[] possibleDirs = {
      new PVector(1, 0),  // Right
      new PVector(-1, 0), // Left
      new PVector(0, 1),  // Down
      new PVector(0, -1)  // Up
    };
    
        //println(head.x, head.y);
    
    PVector bestDir = null;
    float bestDist = Float.MAX_VALUE;

    for (PVector dir : possibleDirs) {
      float newX =  head.x + dir.x;  
      float newY =  head.y + dir.y;  
      
      boolean collision = false;
       if (head.x <= 5 && head.x >= 95 && head.y <= 5 && head.y >= 45) {
        if (dir.x == -1) {
          setDirection(0, 1);
        } else {
        if (dir.x == 1) {
         setDirection(0, -1);
        } else {
        if(dir.y == -1) {
         setDirection(-1, 0);
        } else {
        if(dir.y == 1) {
         setDirection(1, 0);
        }
        }
        }
        }
        }
      if (newX < 0 || newX >= width/GRIDSIZE || newY < 0 || newY >= height/GRIDSIZE) {
        collision = true;
      }
      
      for (Snake snake : snakes) {
        for (PVector segment : snake.segments) {
          if (newX == segment.x && newY == segment.y) {
            if (dir.x == -1) {
          setDirection(0, 1);
        } else {
        if (dir.x == 1) {
         setDirection(0, -1);
        } else {
        if(dir.y == -1) {
         setDirection(-1, 0);
        } else {
        if(dir.y == 1) {
         setDirection(1, 0);
        }
        }
        }
        }
        
            collision = true;
            break; 
          }
        }
        if (collision == true) break;   
      }

      if (!collision) {
        if (closestFood != null) {
          float newDist = abs(newX - closestFood.x) + abs(newY - closestFood.y);
          if (newDist < bestDist) {
            bestDist = newDist;
            bestDir = dir;
          }
         }
        }
      
    
  
    if (bestDir != null) {
      setDirection(bestDir.x, bestDir.y); 
     }
    } 
    }
   
  
   void drawSegment(int index, float x, float y, float size) {
   int c = int(map(index, 0, this.segments.size(), 152, 243));
   int trans = int(map(index, 0, this.segments.size(), 250, 0));
   noStroke();
   fill(c, 246, 109, trans);
   rect(
      x,
      y,
      size,
      size,
      5  // Fixed roundness
      );
   }
  }
