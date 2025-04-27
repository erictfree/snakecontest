/*
BeccaYoungersSnake Strategy:
My snake adapts its behavior based on size. Early on, it seeks food primarily,
prioritizing food value and distance. Once it becomes comfortably big, it switches to defensive
mode, maximizing safety by choosing open spaces. When it becomes very large (score > 20),
it hunts smaller enemy snakes aggressively by targeting their heads, but only if it is much bigger.
The snake features a dynamic rainbow coloring effect, a circular head, a debug aura,
and a sparkle when eating food for extra visual effects!
*/

import java.util.HashSet;

class BeccaYoungersSnake extends Snake {
  // === Victory sparkle effect ===
  int lastVictoryTime = -10000;
  int victoryFlashDuration = 1500; // milliseconds (1.5 seconds)

  BeccaYoungersSnake(int x, int y) {
    super(x, y, "BeccaYoungersSnake");
    this.showName = true;
    this.debug = false; // Enable aura for extra visuals
  }

  void think(ArrayList<Food> food, ArrayList<Snake> snakes) {
    PVector head = segments.get(0);

    boolean defensiveMode = (score > 10 && score <= 20);
    boolean huntingMode = (score > 20);

    PVector target = null;

    if (huntingMode) {
      target = findClosestPrey(head, snakes);
      if (target != null) {
        println(name + " is hunting!");
      }
    }
    if (target == null && !defensiveMode) {
      target = findBestFood(head, food);
    }

    HashSet<String> predictedEnemyTiles = predictEnemyHeadPositions(snakes);
    HashSet<String> selfTiles = getSelfBodyTiles();

    PVector[] dirs = {
      new PVector(1, 0),
      new PVector(-1, 0),
      new PVector(0, 1),
      new PVector(0, -1)
    };

    PVector bestDir = null;
    float bestScore = -99999;

    ArrayList<PVector> fallbackOptions = new ArrayList<PVector>();

    for (PVector dir : dirs) {
      if (dir.x == -direction.x && dir.y == -direction.y) continue; // no 180s

      PVector next = PVector.add(head, dir);
      String key = int(next.x) + "," + int(next.y);

      if (edgeDetect(next) || predictedEnemyTiles.contains(key)) continue;

      if (!selfTiles.contains(key)) {
        float score = 0;

        if (target != null) {
          float distToTarget = dist(next.x, next.y, target.x, target.y);
          score = -distToTarget;
        } else {
          score = countEmptyNeighbors(next, snakes);
        }

        if (score > bestScore) {
          bestScore = score;
          bestDir = dir.copy();
        }
      } else {
        fallbackOptions.add(dir.copy());
      }
    }

    if (bestDir != null) {
      setDirection(bestDir.x, bestDir.y);
    } else if (fallbackOptions.size() > 0) {
      PVector escapeDir = fallbackOptions.get(0);
      setDirection(escapeDir.x, escapeDir.y);
    } else {
      println("No safe moves available. Staying still.");
    }
  }

  // ========== Helper Methods ==========

  PVector findBestFood(PVector head, ArrayList<Food> food) {
    float bestScore = -Float.MAX_VALUE;
    PVector bestFood = null;

    for (Food f : food) {
      float d = dist(head.x, head.y, f.x, f.y);
      float foodValue = f.points;
      float score = foodValue * 10 - d;

      if (score > bestScore) {
        bestScore = score;
        bestFood = new PVector(f.x, f.y);
      }
    }
    return bestFood;
  }

  PVector findClosestPrey(PVector head, ArrayList<Snake> snakes) {
    float closestDist = Float.MAX_VALUE;
    PVector closestPrey = null;

    for (Snake s : snakes) {
      if (!s.alive || s == this) continue;
      if (s.score >= this.score - 8) continue; // Hunt only MUCH smaller snakes

      PVector enemyHead = s.segments.get(0);
      float d = dist(head.x, head.y, enemyHead.x, enemyHead.y);

      if (d < closestDist) {
        closestDist = d;
        closestPrey = new PVector(enemyHead.x, enemyHead.y);
      }
    }
    return closestPrey;
  }

  int countEmptyNeighbors(PVector pos, ArrayList<Snake> snakes) {
    int count = 0;
    PVector[] dirs = {
      new PVector(1, 0),
      new PVector(-1, 0),
      new PVector(0, 1),
      new PVector(0, -1)
    };

    for (PVector dir : dirs) {
      PVector neighbor = PVector.add(pos, dir);
      if (!edgeDetect(neighbor)) {
        boolean empty = true;
        for (Snake s : snakes) {
          if (!s.alive) continue;
          for (PVector seg : s.segments) {
            if (seg.x == neighbor.x && seg.y == neighbor.y) {
              empty = false;
              break;
            }
          }
          if (!empty) break;
        }
        if (empty) count++;
      }
    }
    return count;
  }

  HashSet<String> predictEnemyHeadPositions(ArrayList<Snake> snakes) {
    HashSet<String> positions = new HashSet<String>();
    for (Snake s : snakes) {
      if (!s.alive || s == this) continue;
      PVector h = s.segments.get(0);
      PVector predicted = PVector.add(h, s.direction);
      if (!edgeDetect(predicted)) {
        positions.add(int(predicted.x) + "," + int(predicted.y));
      }
    }
    return positions;
  }

  HashSet<String> getSelfBodyTiles() {
    HashSet<String> tiles = new HashSet<String>();
    for (int i = 1; i < segments.size(); i++) {
      PVector seg = segments.get(i);
      tiles.add(int(seg.x) + "," + int(seg.y));
    }
    return tiles;
  }

  // ====== Custom Draw to Make Rainbow Snake with Sparkles ======

  @Override
  void drawBody() {
    float sizeMultiplier = map(score, 1, 50, 1, maxMult);
    float segmentSize = gridSize * sizeMultiplier;
    float gap = 2 * sizeMultiplier;
    float offset = (segmentSize - (gridSize - 1)) / 2;

    for (int i = segments.size() - 1; i >= 0; i--) {
      PVector segment = segments.get(i);

      // Dynamic rainbow color!
      float hueValue = (frameCount * 2 + i * 10) % 360; // Animated color trail
      colorMode(HSB, 360, 100, 100);
      color segmentColor = color(hueValue, 80, 100);
      colorMode(RGB, 255);

      fill(segmentColor);
      noStroke();

      float s = segmentSize - gap;

      if (i == 0) {
        // Victory sparkle if recently ate food
        if (millis() - lastVictoryTime < victoryFlashDuration) {
          colorMode(HSB, 360, 100, 100);
          fill((frameCount * 10) % 360, 80, 100, 80);
          colorMode(RGB, 255);
          noStroke();
          float auraSize = segmentSize * 2;
          ellipse(
            segment.x * gridSize + gridSize / 2,
            segment.y * gridSize + gridSize / 2,
            auraSize,
            auraSize
          );
        }

        // Head is a circle
        ellipse(
          segment.x * gridSize + gridSize / 2,
          segment.y * gridSize + gridSize / 2,
          s,
          s
        );
      } else {
        // Body is rounded rectangles
        rect(
          segment.x * gridSize - offset + gap / 2,
          segment.y * gridSize - offset + gap / 2,
          s,
          s,
          8
        );
      }
    }
  }

  @Override
  void checkFood(ArrayList<Food> food) {
    ateFood = false;
    for (int i = food.size() - 1; i >= 0; i--) {
      Food f = food.get(i);
      if (f.x == segments.get(0).x && f.y == segments.get(0).y) {
        food.remove(i);
        score += f.points;
        ateFood = true;

        // 💥 Trigger sparkle on eating food
        lastVictoryTime = millis();

        break;
      }
    }
  }
}
