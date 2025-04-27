/*
Strategy:
 The general strategy of my snake is determined with a point system, 
 every behavior has a point equivalent, the higher the point the higher the 
 value, and with penalties. Food has a high value of priority to go after, 
 while walls and other snakes have penalty points, snakes having higher
 penalty values than walls.
 My snake also has a look ahead safety filter, with every tick the snake has
 a four cardinal directional "copy" ahead of it that moves cells ahead. Any
 move that would collide with a wall or other snake is immediately rejected as a
 possibility.
 The food targeting system works with the points; it calculates the remaining safe
 food and goes towards the nearest food.  The closer the food, the higher the score.
 Finally, it has an adaptive speed function; as it gets longer, it raises
 its frame rate to remain competitive and not slow down immensely.
 If there are no safe moves, the snake will fall back to the first non lethal
 option that it can find, or holds course (death, sad face).
 I'm also last minute adding in an aggressive behavior to target the largest score
 snakes after a certain period of time goes by, this aggressiveness is easily 
 combined with the points system i have for searching out food.
 */

class SarahGruberSnake extends Snake {

  // global variables/tuning variables
  final int LOOK_AHEAD = 4;  // depth of safety check
  final int WALL_PENALTY = 4;
  final int HEAD_NEAR_PENALTY = 8;
  final int FOOD_REWARD_BASE = 100;  // food priority score
  final int SPACE_LIMIT = 400;  // flood fill for helper
  final float SPACE_WEIGHT = 2.0;  // open space score for priority
  final int AGGRO_TIME = 30_000;  // in ms from start of game
  final int AGGRO_LENGTH = 25;  // or when reaching this length
  final int AGGRO_BONUS = 400;  // aggro priority score value

  SarahGruberSnake(int x, int y) {
    super(x, y, "SarahGruber");
    updateInterval = 80;
  }

  void think(ArrayList<Food> food, ArrayList<Snake> snakes) {
    // speed adapting; faster when larger
    if ((score % 10 == 0)&&(score > 0)) {
      updateInterval = max(40, 80 - score);  // caps at 40ms
    }

    // Define all possible directions: right, left, down, up
    PVector[] possibleDirs = {
      new PVector(1, 0), // Right
      new PVector(-1, 0), // Left
      new PVector(0, 1), // Down
      new PVector(0, -1)   // Up
    };

    PVector bestDir = null;
    float bestScore = -Float.MAX_VALUE;

    for (PVector d : possibleDirs) {
      if ((d.x == -direction.x)&&(d.y == -direction.y)) continue;  // no 180 turns

      PVector pos = new PVector(segments.get(0).x + d.x,
        segments.get(0).y + d.y);  // head position

      if (isDangerous(pos, snakes)) continue; // rejectif unsafe

      float scoreDir = 0;

      // food discovery
      int nearestFood = nearestFoodDistance(pos, food);
      if (nearestFood >= 0) { // -1 if no food in arena
        scoreDir += FOOD_REWARD_BASE / (nearestFood + 1);
      }
      scoreDir -= WALL_PENALTY * wallDistancePenalty(pos); // wall penalty
      if (adjacentEnemyHead(pos, snakes)) scoreDir -= HEAD_NEAR_PENALTY; // enemy head prox

      // open space score, prevents loops
      int freeCells = reachableSpace(pos, snakes, SPACE_LIMIT);
      scoreDir += SPACE_WEIGHT * freeCells;
      
      // aggressive score calculation
      if(aggressiveNow()) {
        Snake tgt = pickTarget(snakes); // biggest live snake
        if(tgt != null){
          // chase its head
          PVector h = tgt.segments.get(0);
          int dHead = abs((int)h.x - (int)pos.x) + abs((int)h.y - (int)pos.y);
          scoreDir += AGGRO_BONUS / (dHead + 1);
        }
      }

      // keep the best
      if (scoreDir > bestScore) {
        bestScore = scoreDir;
        bestDir   = d.copy();
      }
    }

    // choose direction
    if (bestDir != null) {  // at least one safe move
      setDirection(bestDir.x, bestDir.y);
    } else {  // cornered – pick first survivable
      for (PVector d : possibleDirs) {
        PVector pos = new PVector(segments.get(0).x + d.x,
          segments.get(0).y + d.y);
        if (!edgeDetect(pos)) {  // may overlap a body – last resort
          setDirection(d.x, d.y);
          break;
        }
      }
    }
  }

  // helper functions -------------

  // agry snake >: ))
  boolean aggressiveNow() {
    return (millis() > AGGRO_TIME || score >= AGGRO_LENGTH);
  }
  
  // true if collides with a wall or snake
  boolean isDangerous(PVector pos, ArrayList<Snake> snakes) {
    return edgeDetect(pos) || overlap(pos, snakes);
  }
  
    // which snake will die a horrible death
  Snake pickTarget(ArrayList<Snake> snakes){
  Snake best = null;
  int   bestScore = -1;
  for(Snake s : snakes){
    if (!s.isAlive() || s == this) continue;   // ignore dead/ourselves
    if (s.getScore() > bestScore){
      bestScore = s.getScore();
      best = s;
    }
  }
  return best;
  }

  // food distance calc
  int nearestFoodDistance(PVector pos, ArrayList<Food> food){
    int best = Integer.MAX_VALUE;
    for (Food f : food){
      int d = abs(f.x - (int)pos.x) + abs(f.y - (int)pos.y);
      if (d < best) best = d;
    }
    return best == Integer.MAX_VALUE ? -1 : best;
  }

  // penalty grows closer snake gets to wall
  int wallDistancePenalty(PVector pos) {
    int wCells = floor(width  / gridSize);
    int hCells = floor(height / gridSize);
    int dx = min((int)pos.x, wCells - 1 - (int)pos.x);
    int dy = min((int)pos.y, hCells - 1 - (int)pos.y);
    return min(dx, dy);  // 0 at wall, larger inside
  }

  // enemy head nearby?
  boolean adjacentEnemyHead(PVector pos, ArrayList<Snake> snakes) {
    for (Snake s : snakes) {
      if (!s.isAlive() || s == this) continue;
      PVector h = s.segments.get(0);
      if (abs(h.x - pos.x) + abs(h.y - pos.y) == 1) return true;
    }
    return false;
  }

  // helper that counts open squares, to prevent committing die with loops
  int reachableSpace(PVector start, ArrayList<Snake> snakes, int limit) {
    int cols = floor(width  / gridSize);
    int rows = floor(height / gridSize);

    boolean[][] visited = new boolean[cols][rows];
    ArrayList<PVector>   q = new ArrayList<PVector>();

    visited[(int)start.x][(int)start.y] = true;
    q.add(start);

    int count   = 0;        // cells traversed
    int qIndex  = 0;        // reads head location

    int[][] N = {{1, 0}, {-1, 0}, {0, 1}, {0, -1}};   // 4-way neighbours
    while(qIndex < q.size() && count < limit){
      PVector p = q.get(qIndex++);   // dequeue
      count++;

      for (int[] d : N) {
        int nx = (int)p.x + d[0];
        int ny = (int)p.y + d[1];
        if (nx < 0 || ny < 0 || nx >= cols || ny >= rows) continue;
        if (visited[nx][ny]) continue;

        PVector np = new PVector(nx, ny);
        if (edgeDetect(np) || overlap(np, snakes)) continue;

        visited[nx][ny] = true;
        q.add(np);                   // enqueue
      }
    }
    return count;                    // capped at limit
  }
}
