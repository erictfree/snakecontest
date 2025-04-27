/* AdamZuberSnake class - constantly moves in a circle. 
Either it dies instantly or it outlasts all other snakes in a battle of attrition.
Unlikely to earn any points but has won many tests by surviving the longest*/

int thoughtNum = 1;

class AdamZuberSnake extends Snake {
  AdamZuberSnake(int x, int y) {
    super(x, y, "AdamZuber");
  }
  
 @Override
  void think(ArrayList<Food> food, ArrayList<Snake> snakes) {
   
 //constantly move in a circle
 if (thoughtNum == 1) {
   setDirection(1,0);
   thoughtNum = 2;
 } else if (thoughtNum == 2) {
   setDirection(0,1);
   thoughtNum = 3;
 } else if (thoughtNum == 3) {
   setDirection(-1,0);
   thoughtNum = 4;
 } else if (thoughtNum == 4){
   setDirection(0,-1);
   thoughtNum =1;
 }
  }
}
