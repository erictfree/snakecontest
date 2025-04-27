//// Melike Kara - Snake Competition for AET310 Competition
//// Strategy:
//// This snake hides in a safe corner at the beginning to avoid early conflict.
//// Once the game stabilizes or no snakes are nearby, it seeks the closest food.
//// If there's danger near (walls or snakes), it changes direction to stay safe.
//// It balances survival with opportunistic food collection and adapts based on the situation.

//class MelikeKaraSnake extends Snake {
//  MelikeKaraSnake(int x, int y) {
//    super(x, y, "MelikeKara");
//  }

//  void think(ArrayList<Food> food, ArrayList<Snake> snakes) {
//    PVector head = segments.get(0);

//    // Step 1: If early game or surrounded → hide in a corner
//    if (millis() < 30000 || isDangerClose(snakes, head)) {
//      moveToward(new PVector(0, 0), head); // top-left corner
//      return;
//    }

//    // Step 2: Otherwise, go for food (default strategy)
//    PVector target = null;
//    float minDist = Float.MAX_VALUE;

//    for (Food f : food) {
//      float d = dist(head.x, head.y, f.pos.x, f.pos.y);
//      if (d < minDist) {
//        minDist = d;
//        target = f.pos;
//      }
//    }

//    if (target != null) {
//      moveToward(target, head);
//    }
//  }

//  void moveToward(PVector target, PVector head) {
//    int dx = (int)Math.signum(target.x - head.x);
//    int dy = (int)Math.signum(target.y - head.y);

//    if (!willCrash(head.x + dx, head.y)) {
//      setDirection(dx, 0);
//    } else if (!willCrash(head.x, head.y + dy)) {
//      setDirection(0, dy);
//    } else {
//      pickSafeDirection(head);
//    }
//  }

//  boolean isDangerClose(ArrayList<Snake> snakes, PVector head) {
//    for (Snake s : snakes) {
//      if (s == this) continue;
//      for (PVector seg : s.segments) {
//        if (dist(head.x, head.y, seg.x, seg.y) < 4) {
//          return true;
//        }
//      }
//    }
//    return false;
//  }

//  boolean willCrash(float x, float y) {
//    return checkWallCollision(x, y) || checkSnakeCollisions(x, y);
//  }

//  void pickSafeDirection(PVector head) {
//    PVector[] dirs = {
//      new PVector(1, 0), new PVector(-1, 0),
//      new PVector(0, 1), new PVector(0, -1)
//    };

//    ArrayList<PVector> safeDirs = new ArrayList<PVector>();
//    for (PVector d : dirs) {
//      if (!willCrash(head.x + d.x, head.y + d.y)) {
//        safeDirs.add(d);
//      }
//    }

//    if (safeDirs.size() > 0) {
//      PVector chosen = safeDirs.get((int)random(safeDirs.size()));
//      setDirection(chosen.x, chosen.y);
//    }
//  }
//}
