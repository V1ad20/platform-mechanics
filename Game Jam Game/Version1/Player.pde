final int distFromStart = 0, distFromBottom = 1, run = 2, rise = 3;

final int firstDistFromStart = 220, firstDistFromBottom = 450, firstRun = 50, firstRise = 50;
float[] player = {firstDistFromStart, firstDistFromBottom, firstRun, firstRise};
float criticalDistFromStart = (800-player[run])/2;
boolean goingLeft = false, goingRight = false, goingUp = false;

byte jumpingState = 0;
final float maxFuel = 15;
float fuel = maxFuel;
float t = 0;
float timeOfMax = 10;
float initialDistFromBottom = 0;


void handlePlayerMovement(){
  float horizontalSpeed = 3;
  float verticalSpeed = 10;
  int[] collisionData;

  if (keyPressed){
    if (goingRight){
      player[distFromStart]+=horizontalSpeed;
      collisionData = horizontalCollision('r', player, components);
      if(collisionData[0] == 1){
        player[distFromStart] = components[collisionData[1]][distFromStart] - player[run];
      }
    } 
    if (goingLeft && player[distFromStart] > 0){
      player[distFromStart]-=horizontalSpeed;
      collisionData = horizontalCollision('l', player, components);
      if(collisionData[0] == 1){
        player[distFromStart] = components[collisionData[1]][distFromStart] + components[collisionData[1]][run];
      }
    }
  }
  
  if (jumpingState == 0){
    int componentIndex = determinePlatform(player,components);
    if (componentIndex > -1){
      player[distFromBottom] = components[componentIndex][distFromBottom] + player[rise];
    }
    else{
      jumpingState = 3;
    }
  }
  else if (jumpingState == 1){
    if (fuel > 0){
      fuel--;
      player[distFromBottom]+=verticalSpeed;
    }else{
      jumpingState = 2;
      t = -timeOfMax;
      initialDistFromBottom = player[distFromBottom];
    }
    collisionData = verticalCollision('u',player,components);
    if (collisionData[0] == 1){
      player[distFromBottom] = components[collisionData[1]][distFromBottom] - components[collisionData[1]][rise];
      jumpingState = 4;
    }
  }
  else if (jumpingState == 2){
    t++;
    player[distFromBottom] = determineHeight(t,timeOfMax, verticalSpeed, initialDistFromBottom);
    collisionData = verticalCollision('u',player,components);
    if (collisionData[0] == 1){
      player[distFromBottom] = components[collisionData[1]][distFromBottom] - components[collisionData[1]][rise];
      t = -t;
      jumpingState = 3;
    }
    if (t >= 0){
      jumpingState = 3;
    }
  }
  else if (jumpingState == 3){
    t++;
    player[distFromBottom] = determineHeight(t,timeOfMax, verticalSpeed, initialDistFromBottom);
    
    collisionData = verticalCollision('d',player,components);
 
    if (collisionData[0] == 1){
      player[distFromBottom] = components[collisionData[1]][distFromBottom] + player[rise];
      jumpingState = 0;
      fuel = maxFuel;
      t=0;
    }
    if (t >= timeOfMax+30){
      jumpingState = 4;  
    }
  }
  else{
     player[distFromBottom] -= verticalSpeed;
     collisionData = verticalCollision('d',player,components);
     if (collisionData[0] == 1){
        player[distFromBottom] = components[collisionData[1]][distFromBottom] + player[rise];
        jumpingState = 0;
        fuel = maxFuel;
        t=0;
     }
  }
}

int[] horizontalCollision(char option, float[] player, float[][] components){
  byte right = 0;
  byte left = 0;
  if (option == 'r'){
     right = 1;
     left = 0;
  }
  if (option == 'l'){
    right = 0;
    left = 1;
  }
  for (int i = 0; i < components.length; i++){
    float[] component = components[i];
    if (abs(player[distFromBottom]-component[distFromBottom]+(player[rise]-component[rise])/2) < (player[rise]+component[rise])/2)
      if (abs(component[distFromStart]-player[distFromStart]) < player[run]*right + component[run]*left){
          return new int[]{1, i};
      }
  }
  return new int[]{0, -1};
}

int[] verticalCollision(char option, float[] player, float[][] components){
  byte down = 0;
  byte up = 0;
  if (option == 'u'){
     up = 1;
     down = 0;
  }
  if (option == 'd'){
    up = 0;
    down = 1;
  }
  for (int i = 0; i < components.length; i++){
    float[] component = components[i];
    if (abs(player[distFromStart]-component[distFromStart]+(player[run]-component[run])/2) < (player[run]+component[run])/2)
      if (abs(component[distFromBottom]-player[distFromBottom]) < player[rise]*down + component[rise]*up){
          return new int[]{1, i};
      }
  }
  return new int[]{0, -1};
}

float determineHeight(float t, float timeOfMax, float slope, float initialDistFromBottom){
  float a = slope/(-timeOfMax*2);
  float k = slope * timeOfMax / 2;
  return a * t * t + k + initialDistFromBottom;
}

int determinePlatform(float[] player, float[][] components){
  float theoreticalDistFromBottom = player[distFromBottom]-2;
  for (int i = 0; i < components.length; i++){
      float[] component = components[i];
      if (abs(theoreticalDistFromBottom-component[distFromBottom]+(player[rise]-component[rise])/2) < (player[rise]+component[rise])/2)
        if (abs(component[distFromStart]-player[distFromStart]) < player[run]){
            return  i;
        }
    }
    return -1;
}
