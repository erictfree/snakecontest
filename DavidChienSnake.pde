// My snake is called "Diamond Frost."
// The strategy is stutter step. The snake will move lightning quick and grab as much food as 
// it can in a limited amount of time, and then pause for a long moment.
// Then it will grab more food again at fast pace, and pause. This strategy combines
// a good balance of a high dose of passiveness at one time, and then a high
// dose of aggression at another. In essence, my battle tactic lies
// in trusting that the other snakes will destroy themselves and essentially
// leans towards fighting a war of attrition, while gaining points to make sure 
// I can still win in case the results are determined by points.


class DavidChienSnake extends Snake {
  int score = 0;
  boolean isFrozen = true;
  long freezeStartTime = 0;
  
 DavidChienSnake(int x, int y) {
    super(x, y, "DavidChienSnake");
    this.updateInterval = 160; // How fast the snake moves initially.
  }
  

  void think(ArrayList<Food> food, ArrayList<Snake> snakes) {
  
    
    Food closestFood = getClosestFood(this, food); // The closest food is...?
    PVector head = this.segments.get(0); // Get the head of the snake...

    float dx = closestFood.x - head.x;
    float dy = closestFood.y - head.y;
    PVector dir = null;
   
// Responsible for directional movement of the snake.

    if (dx > 0) {
      dir = new PVector(1, 0); // Move right
    } else if (dx < 0) {
       dir = new PVector(-1, 0); // Move left
    } else if (dy > 0) {
     dir = new PVector(0, 1); // Move down
    } else if (dy < 0) {
    dir = new PVector(0, -1); // Move up
    }
    
    PVector newPos = new PVector(head.x + dir.x, head.y + dir.y);  // Takes the new direction 

    if (!overlap(newPos, snakes) && !edgeDetect(newPos)) { 
    // Move in current direction as it's safe
    
    setDirection(dir.x, dir.y); // Go back to the direction, north, east, south, or west.
  
  } else {
    
    PVector[] options = { // Avoid other snakes and move in a different direction if possible.
      new PVector(1, 0),
      new PVector(-1, 0),
      new PVector(0, 1),
      new PVector(0, -1)
    };
    
    for (PVector option : options){ // This code is extra insurance to make sure the snake
                                    // doesn't hit other snakes or the edge! If so, then
                                    // this code will break as a safety rail.
                                    
      PVector tryPos = new PVector(head.x + option.x, head.y + option.y);
      if (!overlap(tryPos, snakes) && !edgeDetect(tryPos)){
        setDirection(option.x, option.y);
        break;
      }
  }
  }
  }
  
  boolean overlap(PVector newPos, ArrayList<Snake> snakes){
    
    // Will this new position overlap with any segment of this snake?
    
    for (int i = 0; i < this.segments.size(); i++){
      PVector segment = this.segments.get(i);
      if (newPos.x == segment.x && newPos.y == segment.y){
      return true; // If true, then the snake will collide with itself...
    }
  }
  
  for (Snake otherSnake : snakes){ // In charge of managing the snake regarding collisions
                                   // with other snakes. 
    if (otherSnake == this) continue;
    
    for (int i = 0; i < otherSnake.segments.size(); i++){ // Makes sure the snake doesn't hit
                                                          // another snake by taking the current
                                                          // position of the segment.
      PVector otherSegment = otherSnake.segments.get(i);
      if(newPos.x == otherSegment.x && newPos.y == otherSegment.y){
      return true; // Collide with another snake...
    }
  }
  }
  return false;
}
  
  boolean edgeDetect(PVector pos){ // Responsible for detecting the edge and avoiding it.
    return pos.x < 0 || pos.x >= width || pos.y < 0 || pos.y >= height;
  }
  
  
  Food getClosestFood(Snake snake, ArrayList<Food> food) { // In charge of getting the closest food.
    float min = 100;
    Food closestFood = null; // Null cause we don't have it yet
    PVector head = snake.segments.get(0);

    for (int i = 0; i < food.size(); i++) { // We are going through every piece of food.
      Food currentFood = food.get(i);

      PVector pos = new PVector(currentFood.x, currentFood.y);

      float distance = PVector.dist(head, pos); //Distance from the head to the position of food?

      if (distance < min) { // Responsible for deciding that it will be "min" in charge of determining
                            // how far food should be for the snake to boost towards it.
        min = distance;
        closestFood = currentFood;
      }
    }
    
  
    if (min < 7){ // The lower this number, the closer food has to be to the snake in order for the snake to move towards it and boost.
     updateInterval = 90;  // How fast the snake's boost is.

    } else {
      updateInterval = 9100;  // The higher this number, the longer the snake pauses.
    }
    return closestFood;
  }
  
  
  
  void drawSegment(int index, float x, float y, float size){ // Draw special effects of the snake.
   push();
   float wavePeriod = 2.5; // Makes that ripple effect on the snake, making the first segment part
                           // slightly smaller before reverting to normal size. The second segment
                           // part shrinks as the first segment part reverts to normal size, and the
                           // pattern continues. It also looks like the snake is changing colors though,
                           // which is the intended effect!
                           
   float phase = (frameCount + index * wavePeriod) % (wavePeriod * 2); // Frequent the ripple is?
   boolean shrink = phase > wavePeriod;
   
   colorMode(HSB);
    shapeMode(CORNER);
    int c = int(map(index, 0, this.segments.size(), 0, 255));
    float s = map(index, 0, this.segments.size(), size-3, size+4);
    
    // Responsible for mapping colors and the shape to the snake.
                                                                 
    if (shrink){
     s *= 0.02; // How small will the segment part be when it ripples?
    }

    fill(random(100, 140), random(200, 255), random(150, 255)); // The overall color of the snake.
    
translate(x + size/2, y + size/2); // Makes sure the color is aligned right.

beginShape(); // Responsible for that icy frosty looking shape of the snake. It may also look like
              // a diamond.
vertex(0, -s/2);
vertex(s/10, -s/3);
vertex(s/5, -s/2.5);
vertex(s/4, -s/5);
vertex(s/2.5, 6);
vertex(s/2, s/0);
vertex(s/2.5, s/6);
vertex(s/4, s/5);
vertex(s/5, s/2.5);
vertex(s/10, s/3);
vertex(0, s/2);
vertex(-s/10, s/3);
vertex(-s/5, s/2.5);
vertex(-s/4, s/5);
vertex(-s/2.5, s/6);
vertex(-s/2, 0);
vertex(-s/2.5, -s/6);
vertex(-s/2.5, -s/6);
endShape(CLOSE);

int rays = 48; // How many rays are shooting from the snake
float baseRayLength = 2; // How long the ray is
float rayOffset = 32; // How far are the rays shooting from the snake
float time = frameCount * 56; // How frequent do the rays pulsate?
float rayLength = baseRayLength + sin(time) * 5; // Ray length

for (int i = 0; i < rays; i++){ // This code is in charge of managing the offset of the rays
                                // the angle, and what direction they point in.
                                
  float angle = map(i, 0, rays, 0, 360);
  float rayX = (rayLength + rayOffset) * cos(angle);
  float rayY = (rayLength + rayOffset) * sin(angle);
  
  if (i % 2 == 0){ // Overall responsible for changing the colors of the rays.
    stroke(random(110, 150), random(50, 240), 255, random(1, 80));
  } else {
    stroke(random(140, 190), random(50, 240), 255, random(1, 80));
  }
  strokeWeight(2); // How fuzzy and thin the lines look
  
  line(0, 0, rayX, rayY);
}
  pop();
  }
  }
  
