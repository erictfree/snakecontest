//Strategy: So WEVE EVOLVED not much whats contructed is a hodgepodge of the discord, lectures, suffering, processing reference, and reddit posts, -its held together by staples
//anywhos strategy is still mainly being slow bc im loyal to my first attempt
//but now also we have COLLISION avoidance anit that dandy it only took me like 9 straight hours after I GOT OFF WORK
//ANYWHOS um thats kinda it ...but yes *THUMBS UP *FINGER GUNS AS I EXIT MOONWALKING
//(ill be honest i dont know how much of this i processed (ba dum shhh) but seriously would love like a chat )

class RosalindaJoachimSnake extends Snake {//extends means it uses another definition as the base of this class it this case Snake
    RosalindaJoachimSnake(int x, int y) {//calls teh snake we extend from and runs its contructor
        super(x, y, "RosalindaJoachimSnake");
        updateInterval = 700; // slowwwwwwwwwww
    }

    void think(ArrayList<Food> food, ArrayList<Snake> snakes) {
        Food closestFood = getClosestFood(this, food);

 PVector head = this.segments.get(0);//comparison of EVERYTHING IS TO OUR HEAD

  float dx = closestFood.x - head.x;
  float dy = closestFood.y - head.y;

   PVector dir = null;
        if (dx > 0) { //if food is to the right of the snake
          dir = new PVector(1, 0); // move right
        } else if (dx < 0) {//same but to th eleft
          dir = new PVector(-1, 0); // move left
        }else if (dy > 0) {//you get the gist by now
          dir = new PVector(0, 1); // following refers to moving up or down
        } else if (dy < 0) {//last but not least
          dir = new PVector(0, -1); 
        }
PVector newPos = new PVector(head.x + dir.x, head.y + dir.y);

        // see if there are CollisioNS # thank you for giving us this code
        if (edgeDetect(newPos) || overlap(newPos, snakes)) {
            println("Uh Oh-That's-welp.");
            dir = dontdieDecentArea(head, snakes);//consideration of terrible obstacles and collisions in reference to direction casue otherwise would be un connected
        }

        setDirection(dir.x, dir.y);
    }
    
//yall are getting the whole storytime casue WOAF
//for the longest time i coudlnt figure out how to avodi other snakes
//so i knew i needed possible directions based off #discord chat but when i tried teach's code - i kept gettign errors so i tried another way made another array
   
    PVector dontdieDecentArea(PVector head, ArrayList<Snake> snakes) {//avoiding DEATH, IT TOOK ME FOREVER TO TRY PVECTOR HEAD AS THE FIRST VARIBLE I KEPT DOING ITERATIONS OF SNAKE
        ArrayList<PVector> possibleDirections = new ArrayList<>();// making new array list but for posssible directions # based off bestie slash #1hater processing references 
        possibleDirections.add(new PVector(1, 0));  // right
        possibleDirections.add(new PVector(-1, 0)); // eft
        possibleDirections.add(new PVector(0, 1));  // down
        possibleDirections.add(new PVector(0, -1)); // up
//with direction outta the way now i gotta do dir and snake connection ando f course it puttin it into the calULATIONS for direction
      //this is the part where *shrug
        for (PVector dir : possibleDirections) {//as written below tryed and worked so i let it be could not explain why
            PVector newPos = new PVector(head.x + dir.x, head.y + dir.y); //repeated pvector cuase head y dir needed again
            if (!edgeDetect(newPos) && !overlap(newPos, snakes)) {//dont know why its not || but my snake kept running itno peeps
                return dir; // responds with area (direction) that seems to not cause immideiate death
            }
        }

        // no potential good options might as well get food
        return new PVector(0, 0);
    }
Food getClosestFood(Snake snake, ArrayList<Food> food) {//tells us where/which is the closest food
 float minDistance = 100; // 100 blocks away
 Food closestFood = null;

 PVector head = snake.segments.get(0); // makes snake head teh comparsion point

for (Food currentFood : food) {//was explained in lecture and i didnt really get it in practice but i tryed it casue #desperate and it worked so i aint knockin it
// for(int i = 0; i < food.size(); i++) {
//  Food currentFood= food.get(i); //gets food at said index
   PVector pos = new PVector(currentFood.x, currentFood.y);
   float distance = PVector.dist(head, pos);

   if (distance < minDistance) {//finds closest food by comparnig each option below 100 to each and seeign whats smallest
     minDistance = distance; // reset min to be that distance
    closestFood = currentFood; 
        }
    }

    return closestFood; // Return the closest food
}

}
