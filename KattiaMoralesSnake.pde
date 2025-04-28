//MY snakes strategy muahahahah...My snake is Malibu Barbie so shes not trying to eliminate everyone but rather take the longer way to her crown.
//The strategy is to get the closest food/points (all of them) and move little by little not slow but not boosting either. My snake is more of trying to avoid everyone
//and getting all the food/points she can. Malibu Barbie avoids trouble but slays the floor with her pretty pink colors. My snake is not shy and hiding but more 
//like trying to get any points in her way in order to grow and win by having the most points, she is smart, and she will avoid causing her own death.



class KattiaMoralesSnake extends Snake {
  KattiaMoralesSnake(int x, int y) {
    super(x, y, "KattiaMoralesSnake");

  }
  
  void think(ArrayList<Food> food, ArrayList<Snake> snakes) {
    PVector head = this.segments.get(0);
    Food closestFood = getClosestFood(this, food);
    
    // All possible directions
    PVector[] possibleMoves = {
      new PVector(1, 0),   // right
      new PVector(-1, 0),  // left
      new PVector(0, 1),   // down
      new PVector(0, -1)   // up
    };
    
    float[] moveScores = {1000, 1000, 1000, 1000};        // Start with a high score for moves that would result in collision
    

    for (int i = 0; i < possibleMoves.length; i++) {
      PVector move = possibleMoves[i];
      PVector newPos = new PVector(head.x + move.x, head.y + move.y);
      
      boolean willHitWall = edgeDetect(newPos);          // Checka if this move would hit a wall or snake
      boolean willHitSnake = overlap(newPos, snakes);
      
      if (!willHitWall && !willHitSnake) {
        // Calculate distance to food from this position
        float distanceToFood = PVector.dist(newPos, new PVector(closestFood.x, closestFood.y));
        
        moveScores[i] = distanceToFood;
        
        PVector lookAheadPos = new PVector(newPos.x + move.x, newPos.y + move.y);        // make snake smarter by adding looking ahead 2 moves to prevent future collisions
        boolean futureCollision = edgeDetect(lookAheadPos) || overlap(lookAheadPos, snakes);
        if (futureCollision) {

          moveScores[i] += 50;  //keeps dying in dead ends so ignore moves that lead to dead end
        }
      }
    }
    
    int bestMoveIndex = 0;              // Find direction with lowest score (best move)
    for (int i = 1; i < moveScores.length; i++) {
      if (moveScores[i] < moveScores[bestMoveIndex]) {
        bestMoveIndex = i;
      }
    }
    
    PVector bestMove = possibleMoves[bestMoveIndex];     // in order to get the best directionsss
    
    setDirection(bestMove.x, bestMove.y);
  }
  
  boolean overlap(PVector pos, ArrayList<Snake> snakes) {
    for (Snake s : snakes) {          // Checks collision with other snakes
      for (int i = 0; i < s.segments.size(); i++) {
        PVector segment = s.segments.get(i);
        if (pos.x == segment.x && pos.y == segment.y) {
          return true;
        }
      }
    }
    
    for (int i = 0; i < this.segments.size() - 1; i++) {       // Check collision with self, try to not die right away because of its own body
      PVector segment = this.segments.get(i);
      if (pos.x == segment.x && pos.y == segment.y) {
        return true;
      }
    }
    
    return false;
  }
  
  Food getClosestFood(Snake snake, ArrayList<Food> food) {
    float min = 1000;
    Food closestFood = null;
    PVector head = snake.segments.get(0);
    for (int i = 0; i < food.size(); i++) {  //every piece of food
      Food currentFood = food.get(i);
      PVector pos = new PVector(currentFood.x, currentFood.y);
      float distance = PVector.dist(head, pos);
      if (distance < min) {
        min = distance;
        closestFood = currentFood;
      }
    }
    return closestFood;
  }
  
  void drawSegment(int index, float x, float y, float size) {
    push();
    colorMode(HSB, 360, 100, 100, 100); //pinkkkkkkkkk (malibu barbie)
    ellipseMode(CORNER);
    
   //cycle pink overtime
    float hue = map(index + frameCount*0.1, 0, this.segments.size(), 300, 350) % 50 + 300;
    float saturation = 80 + sin(index * 0.2 + frameCount * 0.05) * 20;
    float brightness = 90 + sin(index * 0.3 + frameCount * 0.07) * 10;
    float s = map(index, 0, this.segments.size(), size, size-8);
    fill(hue, saturation, brightness);
    ellipse(x, y, s, s);
    pop();
  }
}
