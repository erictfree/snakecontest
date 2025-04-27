class ChelseaLeeSnake extends Snake {
  ChelseaLeeSnake(int x, int y) {
    super(x, y, "ChelseaLeeSnake");
  }

  void think(ArrayList<Food> food, ArrayList<Snake> snakes) {
    PVector head = segments.get(0);
    PVector[] directions = {
      new PVector(1, 0), new PVector(-1, 0),
      new PVector(0, 1), new PVector(0, -1)
    };
    
//find the closest safe food 
    Food target = getClosestSafeFood(food, snakes);

    PVector bestDir = null;
    float bestDist = Float.MAX_VALUE;

    for (PVector dir : directions) {
      PVector next = PVector.add(head, dir);

      if (edgeDetect(next) || overlap(next, snakes)) continue;
//if there is any obstacle, skip the directions 

      if (target != null) {
        float dist = abs(next.x - target.x) + abs(next.y - target.y);
//gpt calculated this distance for when we have a target food 
        if (dist < bestDist) {
          bestDist = dist;
          bestDir = dir;
        }
      } else {
        // no target, just pick the first safe direction
        if (bestDir == null) bestDir = dir;
      }
    }

    if (bestDir != null) {
      setDirection(bestDir.x, bestDir.y); //new movement
    }
  }
  
//function that finds the closest safe food  
  Food getClosestSafeFood(ArrayList<Food> foodList, ArrayList<Snake> snakes) {
    PVector myHead = segments.get(0);
    Food closest = null;
    float minDist = Float.MAX_VALUE;

    for (Food f : foodList) {
      if (f.points > 2) continue; //skip food with more than two points

      float myDist = abs(myHead.x - f.x) + abs(myHead.y - f.y);
      boolean someoneCloser = false;

//loop through other snakes
      for (Snake s : snakes) {
        if (s == this) continue;
        PVector otherHead = s.segments.get(0);
        float otherDist = abs(otherHead.x - f.x) + abs(otherHead.y - f.y);
        if (otherDist <= myDist) {
          someoneCloser = true;
          break;
        }
      }
//if no one is closer and it's the closest, this will be the best choice
      if (!someoneCloser && myDist < minDist) {
        minDist = myDist;
        closest = f;
      }
    }

    return closest;
  }


  void drawSegment(int index, float x, float y, float size) {
    push();
    translate(x + size / 2, y + size / 2);
    colorMode(RGB, 255);
    noStroke();

    // use the color pallete that looks like lollipop
    color[] colors = {
      color(#D3F8E2), // light Green
      color(#E4C1F9), // light Purple
      color(#F694C1), // light Pink
      color(#EDE7B1), // light Yellow
      color(#A9DEF9)  // light Blue
    };
    
 //I used ChatGPT how to make this colored layer rings 
 
    int layers = colors.length; // number of colored rings
    float step = size / layers;

    for (int i = 0; i < layers; i++) {
      float diameter = size - i * step;
      fill(colors[i]); // use the specific color for the layer
      ellipse(0, 0, diameter, diameter);
    }

    pop();
  }
}
