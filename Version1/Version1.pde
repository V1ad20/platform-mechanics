import java.util.ArrayList;
import java.util.List;
import java.util.HashSet;

void setup(){
  size(800,500);
  rectMode(CENTER);
  ellipseMode(CENTER);
  determineComponents();
  //frameRate(1);
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
  if (keyCode == UP && canJump){
    verticalMovementState = heightManuallyIncreasing;
  }
  
}

void keyReleased(){
  if (keyCode == LEFT){
    goingLeft = false;
  }
  if (keyCode == RIGHT){
    goingRight = false;
  }
  if (keyCode == UP && verticalMovementState == heightManuallyIncreasing){
    verticalMovementState = heightParabolicallyIncreasing;
    t = -timeOfMax;
    initialDistFromBottom = player[distFromBottom];
  }
}
