/* This snake moves toward the nearest food one wiggle at a time. 
It always picks the closest snack and heads straight for it. 
The snake knows it's ways around weird places, 
but struggles when their are obstacles in the way 
which may lead to a loss :( 
*/

class FridaBalderasSnake extends Snake { // Add snake name here
  FridaBalderasSnake(int x, int y) {  
  super(x, y, "FridaBalderasSnake"); // Calls the Snake constructor using new snake name
}
  void think(ArrayList<Food> food, ArrayList<Snake> snakes) { // Decide where to go
  Food closestFood = getClosestFood(this, food); // Find the nearest food
      if (closestFood == null) return; // Stop if there's no food
      PVector head = segments.get(0); // Get the position of the snake's head
      
          float dx = closestFood.x - head.x; // Difference in horizontal position
          float dy = closestFood.y - head.y; // Difference in vertical position
          PVector dir = null; // Direction to move
              if (dx > 0) {
                dir = new PVector(1, 0); // Moves right
              } else if (dx < 0) {
                dir = new PVector(-1, 0); // Moves left
              } else if (dy > 0) {
                dir = new PVector(0, 1); // Moves down
              } else if (dy < 0) {
                dir = new PVector(0, -1); // Moves up
              }
              
if (dir == null) return; // Stop if no direction is set
   PVector newPos = new PVector(head.x + dir.x, head.y + dir.y); // Get next position
if (edgeDetect(newPos)) { // Detects the edges
   println("hit wall"); // Print if it hits the wall
}
if (overlap(newPos, snakes)) {
    println("hit snake!"); // Print if it hits another snake
}
setDirection((int) dir.x, (int) dir.y); // Move the snake
}
Food getClosestFood(Snake snake, ArrayList<Food> food) { // Find the closest food
    float min = 1000; // Start with a big number
    Food closestFood = null; // No closest food yet
    PVector head = snake.segments.get(0); // Get the head of this snake
    for (int i = 0; i < food.size(); i++) { // Check all
      Food currentFood = food.get(i); // Get one food item
      PVector pos = new PVector(currentFood.x, currentFood.y); // Its position
      float distance = PVector.dist(head, pos); // How far from head
      if (distance < min) {  
        min = distance; // Update if closer
        closestFood = currentFood; // Save as closest
}
}
    return closestFood; // Return the closest food
 }
}
