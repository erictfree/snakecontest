//Sebastian Nieto's Challenge #12

//Paragraph Explaining Strategy:
//My strategy for winning with my snake revolves around prioritizing survival through effective collision avoidance and intelligent food targeting.
//The snake continuously scans its environment for the closest food, adjusting its movement to head toward it while avoiding self-collisions and walls.
//By examining potential moves ahead, it ensures that each direction is safe and will not trap itself in tight spots, enabling consistent growth.
//In cases where no safe move is immediately available, the snake defaults to a fallback system that explores all available directions to avoid stalling or crashing.
//This approach combines reactive behavior with forward-thinking decision-making, ensuring that the snake can grow efficiently while minimizing risk of elimination.

class SebastianNietoSnake extends Snake
{
  SebastianNietoSnake(int x, int y)
  {
    super(x, y, "SebastianNietoSnake");
  }

  void think(ArrayList<Food> food, ArrayList<Snake> snakes)
  {
    // Get the closest food
    Food closestFood = getClosestFood(food);

    // Get the current head position
    PVector head = this.segments.get(0);

    // Define the possible directions (Right, Left, Down, Up)
    PVector[] possibleDirs = {
      new PVector(1, 0), // Right
      new PVector(-1, 0), // Left
      new PVector(0, 1), // Down
      new PVector(0, -1)  // Up
    };

    // ---------------------------------------------------
    // Self-collision check (and avoidance of tight spots)
    // ---------------------------------------------------

    // Create a list to store the potential moves and their scores
    ArrayList<PVector> validDirs = new ArrayList<PVector>();

    for (PVector dir : possibleDirs)
    {
      // Predict the new position
      PVector newPos = new PVector(head.x + dir.x, head.y + dir.y);

      // Flag to check if the move is valid
      boolean isValid = true;

      // Check for wall collisions
      if (edgeDetect(newPos))
      {
        isValid = false;  // Wall collision detected
      }

      // Check for self-collisions (excluding the head)
      if (isSelfCollision(newPos))
      {
        isValid = false;  // Self-collision detected
      }

      // Check if the new position is near any other snakes
      if (isSnakeNear(newPos, snakes))
      {
        isValid = false; // Snake collision detected
      }

      // If the move is valid, add the direction to validDirs list
      if (isValid)
      {
        validDirs.add(dir);
      }
    }

    // -------------------------------------------
    // Lookahead system to avoid curling into self
    // -------------------------------------------

    // Create a list of safe future moves
    ArrayList<PVector> safeMoves = new ArrayList<PVector>();

    // It looks ahead up to 1 step to predict if the snake will trap itself
    for (PVector dir : validDirs)
    {
      PVector tempHead = new PVector(head.x + dir.x, head.y + dir.y);
      boolean isSafe = true;

      // Check the next step ahead
      PVector futurePos = new PVector(tempHead.x + dir.x, tempHead.y + dir.y);

      // Check if the future position leads to a self-collision or wall
      if (edgeDetect(futurePos) || isSelfCollision(futurePos))
      {
        isSafe = false;
      }

      if (isSafe)
      {
        safeMoves.add(dir);
      }
    }

    // ---------------
    // Decision Making
    // ---------------

    // If we have safe future moves, prioritize them
    if (safeMoves.size() > 0) {
      // Prioritize food if possible
      PVector bestDir = safeMoves.get(0);  // Default to first safe direction

      if (closestFood != null)
      {
        float bestDist = Float.MAX_VALUE;
        for (PVector dir : safeMoves)
        {
          // Calculate the potential new position for each valid direction
          PVector newPos = new PVector(head.x + dir.x, head.y + dir.y);
          float foodDist = PVector.dist(newPos, new PVector(closestFood.x, closestFood.y));

          // Prioritize the direction that leads closer to food
          if (foodDist < bestDist)
          {
            bestDist = foodDist;
            bestDir = dir;  // Set the best direction towards the food
          }
        }

        // Update the direction towards the best food-related move
        setDirection(bestDir.x, bestDir.y);
      } else
      {
        // If no food is found, just pick a random safe direction
        bestDir = safeMoves.get((int) random(safeMoves.size()));
        setDirection(bestDir.x, bestDir.y);
      }
    } else
    {
      // If no valid safe moves are available, stop the snake
      println("No safe moves available, stopping snake.");
    }
  }
  
  // -------------------
  // Collision Detection
  // -------------------

  boolean isSelfCollision(PVector futurePos)
  {
    // Loop through all segments (except the head) to check for self-collision
    for (int i = 1; i < this.segments.size(); i++) // Start at 1 to skip the head
    {
      PVector segment = this.segments.get(i);
      if (futurePos.x == segment.x && futurePos.y == segment.y)
      {
        return true;  // Collision detected with self
      }
    }
    return false;  // No collision with self
  }

  // Check if the new position is near any other snake
  boolean isSnakeNear(PVector pos, ArrayList<Snake> snakes) {
    for (Snake otherSnake : snakes) {
      for (PVector segment : otherSnake.segments) {
        if (pos.x == segment.x && pos.y == segment.y) {
          return true;  // Collision detected with another snake
        }
      }
    }
    return false;  // No collision with another snake
  }

  // -------------
  // Food Handling
  // -------------

  // Function to get the closest food to the snake
  Food getClosestFood(ArrayList<Food> food)
  {
    float min = Float.MAX_VALUE;
    Food closestFood = null;

    // Get the head of the snake
    PVector head = this.segments.get(0);

    // Loop through all food to find the closest one
    for (Food currentFood : food)
    {
      PVector pos = new PVector(currentFood.x, currentFood.y);
      float distance = PVector.dist(head, pos);

      if (distance < min)
      {
        min = distance;
        closestFood = currentFood;
      }
    }

    // Return the closest food
    return closestFood;
  }

  // Function to handle fallback when no valid direction is available (similar to HunterSnake's xx)
  void xx(ArrayList<Snake> snakes)
  {
    PVector[] oa = { new PVector(1, 0), new PVector(0, 1), new PVector(-1, 0), new PVector(0, -1) };
    for (PVector dir : oa)
    {
      PVector newPos = new PVector(segments.get(0).x + dir.x, segments.get(0).y + dir.y);
      if (!yy(newPos, snakes))
      {
        setDirection(dir.x, dir.y);
        return;
      }
    }
  }

  // Function to check if a position is invalid (self-collision or wall collision)
  boolean yy(PVector pos, ArrayList<Snake> snakes)
  {
    return edgeDetect(pos) || isSelfCollision(pos);
  }

  // ----------
  // Appearance
  // ----------

  // Global variables for color code
  color c;

  // Color palette with hex values
  color[] pallete = {
    #00FF1F, // Bright Green
    #00DF79, // Soft Green
    #00BA9F, // Teal
    #0900FF, // Bright Blue
    #00B4EB, // Light Blue
    #0096FF, // Medium Blue
    #0074FF, // Dark Blue
    #FF4000, // Bright Red-Orange
    #FF0045, // Hot Pink
    #FF0059, // Fuchsia
    #F6FF00, // Bright Yellow
    #FF7100, // Orange
    #FF0071, // Magenta
    #EC00B8   // Violet
  };

  // Function to draw the snake's body with color and spikes
  void drawSegment(int index, float x, float y, float size)
  {
    // Assign color from the palette based on the index
    c = pallete[floor(index % pallete.length)];

    push();

    // Outer glow effect
    color glowColor = color(red(c), green(c), blue(c), 128);  // Semi-transparent glow
    noStroke();
    fill(glowColor);
    ellipse(x, y, size + 6, size + 6);  // Draw outer glow

    // Main body as an ellipse
    fill(c);
    ellipse(x, y, size, size);

    // Add spikes (small triangles on the side of each segment)
    float spikeLength = 4;
    float spikeWidth = 2;

    // Position the spikes
    float spikeX1 = x + size / 4;
    float spikeX2 = x + 3 * size / 4;
    float spikeY = y + size / 2;

    // Left spike
    triangle(spikeX1, spikeY, spikeX1 - spikeWidth, spikeY - spikeLength, spikeX1 - spikeWidth, spikeY + spikeLength);

    // Right spike
    triangle(spikeX2, spikeY, spikeX2 + spikeWidth, spikeY - spikeLength, spikeX2 + spikeWidth, spikeY + spikeLength);

    pop();
  }
}
