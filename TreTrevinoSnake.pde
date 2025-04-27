// SimpleSnake class - moves randomly with no intelligence

class TreTrevinoSnake extends Snake {
  TreTrevinoSnake(int x, int y) {
    super(x, y, "TreTrevinoSnake");
  }

  void think(ArrayList<Food> food, ArrayList<Snake> snakes) {
    // Define all possible directions: right, left, down, up
    PVector[] possibleDirs = {
      new PVector(1, 0), // Right
      new PVector(-1, 0), // Left
      new PVector(0, 1), // Down
      new PVector(0, -1)   // Up
    };

    // Pick a random direction from all possibilities
    PVector newDir = possibleDirs[(int)random(possibleDirs.length)];
    setDirection(newDir.x, newDir.y);
  }
  
void drawSegment(int index, float x, float y, float size) {
  push();
  colorMode(HSB, 360, 100, 100, 100); // Use 360 for hue for finer control
  noStroke();
  
  // blue colors
  float hueBase = 210;
  float hueVariation = 30;
  float hue = hueBase + (hueVariation * sin(radians(index * 10 + frameCount * 2)));
  
  fill(hue, 80, 100, 80); // transparency
  
  // glow effect
  fill(hue, 80, 100, 30); // Even more transparent
  rect(x - size*0.1, y - size*0.1, size*1.1, size*1.1, 10); 
  
  // main filled rectangle
  fill(hue, 80, 100, 100); // Full opacity for core
  rect(x, y, size, size, 5); // Your original rounded rect
  
  pop();
}
  
}
