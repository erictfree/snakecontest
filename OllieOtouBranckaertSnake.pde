/**
* This snake just wants to stay alive and eat food.
* It looks for the closest snack without running into walls or other snakes.
* It uses a simple search (BFS) to find the safest and shortest way to food.
* If it can't find a safe way, it picks a random safe direction.
* It’s chill and avoids fights—definitely not a fighter.
* tldr: this is the coward snake lol
**/

import java.awt.Point;
import java.util.Queue;
import java.util.LinkedList;

class OllieOtouBranckaertSnake extends Snake {
  
  // Constructor: Initialize the snake at position (x, y) with the name "Olle"
  OllieOtouBranckaertSnake(int x, int y) {
    super(x, y, "OllieOtouBranckaertSnake");
  }

  // Called every frame to decide the snake's next move
  void think(ArrayList<Food> food, ArrayList<Snake> snakes) {
    Direction move = null;
    
    // Step 1: Find the nearest food
    Food target = findNearestFood();
    if (target != null) move = pathTo(new PVector(target.x, target.y)); // Try to find a path to it
    
    // Step 2: If the path is blocked or there is no food available, choose any safe direction
    if (move == null || !isDirectionSafe(move)) {
      move = findSafestDirection();
    }
    
    // Step 3: Prevent invalid 180-degree turns
    if (move.dx == -direction.x && move.dy == -direction.y) {
      return; // Skip direction change; retain current direction
    }
    
    // Step 4: New direction
    setDirection(move.dx, move.dy);
  }
  
  // Find the closest food based on Euclidean distance
  Food findNearestFood() {
    Food nearest = null;
    float minDist = Float.MAX_VALUE;
    
    for (Food f : food) {
      float dist = dist(getHead(this).x, getHead(this).y, f.x, f.y);
      if (dist < minDist) {
        minDist = dist;
        nearest = f;
      }
    }
    
    return nearest;
  }
  
  // Gets the head position of the given snake
  PVector getHead(Snake s) {
    return s.segments.get(0);
  }
  
  // BFS, returns the first step toward the target
  Direction pathTo(PVector target) {
    PVector start = getHead(this);
    
    boolean[][] visited = new boolean[2000][1100];
    PVector[][] cameFrom = new PVector[2000][1100];

    Queue<PVector> queue = new LinkedList<>();
    queue.add(start.copy());
    visited[(int) start.x][(int) start.y] = true;

    while (!queue.isEmpty()) {
      PVector current = queue.poll();
      
      // If the target has been reached, reconstruct the path
      if ((int) current.x == target.x && (int) current.y == target.y) {
        
        // Backtrack until the starting point
        PVector step = current;
        while (cameFrom[(int) step.x][(int) step.y] != null &&
               !cameFrom[(int) step.x][(int) step.y].equals(start)) {
          step = cameFrom[(int) step.x][(int) step.y];
        }
        return new Direction((int) step.x - (int) start.x, (int) step.y - (int) start.y);
      }
      
      // Explore possible directions from the current tile
      for (Direction dir : directions) {
        int nx = (int) current.x + dir.dx;
        int ny = (int) current.y + dir.dy;
        
        // Three conditions:
        // 1. The tile must be within bounds of the board
        // 2. The tile must not have already been visited
        // 3. The tile must be safe (not a wall or occupied by a snake segment)
        if (isInBounds(nx, ny) && !visited[nx][ny] && isTileSafe(nx, ny)) {
          visited[nx][ny] = true;
          cameFrom[nx][ny] = current; // used for backtracking
          queue.add(new PVector(nx, ny));
        }
      }
    }

    return null; // no safe path
  }
  
  // Used over edgeDetect() because ran into out of bounds issues
  boolean isInBounds(int x, int y) {
    return x >= 0 && x < 2000 && y >= 0 && y < 1100;
  }
  
  Direction findSafestDirection() {
    for (Direction dir : directions) {
      if (isDirectionSafe(dir)) {
        return dir;
      }
    }
    return directions[0];
  }

  boolean isDirectionSafe(Direction dir) {
    PVector head = segments.get(0);
    int nextX = (int) head.x + dir.dx;
    int nextY = (int) head.y + dir.dy;
  
    return isTileSafe(nextX, nextY);
  }

  boolean isTileSafe(int x, int y) {
    return isInBounds(x, y) && !overlap(new PVector(x, y), snakes);
  }
  
  // Checks if a given position overlaps with any live snake (excluding own head)
  @Override
  boolean overlap(PVector pos, ArrayList<Snake> snakes) {
    for (Snake snake : snakes) {
      if (!snake.alive) continue;
      // Skip the head of this snake when checking self-collision
      for (int i = 0; i < snake.segments.size(); i++) {
        if (snake == this && i == 0) continue;
  
        PVector segment = snake.segments.get(i);
        if (pos.x == segment.x && pos.y == segment.y) {
          return true;
        }
      }
    }
    return false;
  }
  
  Direction[] directions = {
    new Direction(1, 0),   // right
    new Direction(-1, 0),  // left
    new Direction(0, 1),   // down
    new Direction(0, -1)   // up
  };

  class Direction {
    int dx, dy;
    Direction(int dx, int dy) {
      this.dx = dx;
      this.dy = dy;
    }
  }
}
