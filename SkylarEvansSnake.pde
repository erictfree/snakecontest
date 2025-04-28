// SimpleSnake class - moves randomly with no intelligence

class SkylarEvansSnake extends Snake {
  SkylarEvansSnake(int x, int y) {
    super(x, y, "SkylarEvansSnake");
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
}
