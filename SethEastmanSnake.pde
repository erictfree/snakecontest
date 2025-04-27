class SethEastmanSnake extends Snake {
    
    SethEastmanSnake(int x, int y) {
        super(x, y, "SethEastmanSnake");
    }


void think(ArrayList<Food> food, ArrayList<Snake> snakes) {
    PVector head = segments.get(0); // Get the head position

    // Find the closest food
    Food closestFood = null;
    float minDist = Float.MAX_VALUE;
    
    for (Food f : food) {
        float d = dist(head.x, head.y, f.x, f.y);
        if (d < minDist) {
            minDist = d;
            closestFood = f;
        }
    }

    // Move toward the closest food
    if (closestFood != null) {
        float dx = closestFood.x - head.x;
        float dy = closestFood.y - head.y;
        
        if (abs(dx) > abs(dy)) {
            if (dx > 0) {
                setDirection(1, 0); // Move right
            } else {
                setDirection(-1, 0); // Move left
            }
        } else {
            if (dy > 0) {
                setDirection(0, 1); // Move down
            } else {
                setDirection(0, -1); // Move up
            }
        }
    }
  }
} 
