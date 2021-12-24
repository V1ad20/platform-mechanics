import java.util.ArrayList;
import java.util.List;
import java.util.HashSet;

void setup(){
  size(800,500);
  rectMode(CORNER);
  ellipseMode(CENTER);
}

void draw(){
  handlePlayerMovement();
  drawLevel();
}

void keyPressed(){
  if (keyCode == LEFT){
    goingLeft = true;
  }
  if (keyCode == RIGHT){
    goingRight = true;
  }
  if (keyCode == UP && jumpingState == 0){
    jumpingState = 1;
  }
  
}

void keyReleased(){
  if (keyCode == LEFT){
    goingLeft = false;
  }
  if (keyCode == RIGHT){
    goingRight = false;
  }
  if (keyCode == UP && jumpingState == 1){
    jumpingState = 2;
    t = -timeOfMax;
    initialDistFromBottom = player[distFromBottom];
  }
}
