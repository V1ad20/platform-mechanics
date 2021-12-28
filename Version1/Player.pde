final int distFromStart = 0, distFromBottom = 1, run = 2, rise = 3;

final int firstDistFromStart = 100, firstDistFromBottom = 100, firstRun = 25, firstRise = 50;
float[] player = {firstDistFromStart, firstDistFromBottom, firstRun, firstRise};
float criticalDistFromStart = 400;
float criticalDistFromBottom = 450;
boolean goingLeft = false, goingRight = false;

byte verticalMovementState = 0;
final byte defaultMovement = 0, heightManuallyIncreasing = 1, heightParabolicallyIncreasing = 2, heightParabolicallyDecreasing = 3, terminalVelocityReached = 4;
final byte timeOfTerminalVelocity = 20;
float downwardVelocity;
float verticalSpeed = 10;
boolean canJump = false;
final float maxFuel = 20;
float fuel = maxFuel;
float t = 0;
float timeOfMax = 10;
float t0 = -timeOfMax;
float initialDistFromBottom = firstDistFromBottom;

PVector prevPoint;
final byte collisionType = 1, componentID = 0;
final byte right=1, left=3, above=4,below=2;


void handlePlayerMovement(){
  canJump = false;
  prevPoint = new PVector(player[distFromStart],player[distFromBottom]);
  
  determineHorizontalMovement();
  determineVerticalMovement();
  
  handleCollision(determineCollisionType(prevPoint, player, components));
  
}


void determineHorizontalMovement(){
  float horizontalSpeed = 2;
    
  if (keyPressed){
    if (goingRight){
      player[distFromStart]+=horizontalSpeed;
    } 
    if (goingLeft && player[distFromStart] > 0){
      player[distFromStart]-=horizontalSpeed;
    }
  }
}

void determineVerticalMovement(){
  switch(verticalMovementState){
    case defaultMovement:
      t++;
      player[distFromBottom] = determineHeight(t, timeOfMax, verticalSpeed, initialDistFromBottom,0);
    break;
    
    case heightManuallyIncreasing:
      canJump = false;
      if (fuel > 0){
        fuel--;
        player[distFromBottom]+=verticalSpeed;
      }else{
        verticalMovementState = heightParabolicallyIncreasing;
        t = -timeOfMax;
        initialDistFromBottom = player[distFromBottom];
      }
    break;
    
    case heightParabolicallyIncreasing:
      t++;
      player[distFromBottom] = determineHeight(t, timeOfMax, verticalSpeed, initialDistFromBottom, t0);
      if (t >= 0){
        verticalMovementState = heightParabolicallyDecreasing;
      }
    break;
    
    case heightParabolicallyDecreasing:
      t++;
      player[distFromBottom] = determineHeight(t,timeOfMax, verticalSpeed, initialDistFromBottom, t0);
      if (t >= timeOfTerminalVelocity){
        verticalMovementState = terminalVelocityReached;
      }
    break;
    
    case terminalVelocityReached:
      t++;
      player[distFromBottom] = determineHeight(t,timeOfMax, verticalSpeed, initialDistFromBottom, t0);
    break;
  }
}

ArrayList<int[]> determineCollisionType(PVector prevPoint, float[] player, ArrayList<float[]> components){
  
  ArrayList<int[]> collidedComponents = new ArrayList<int[]>();
  //interates through components
  for (int i = 0; i < components.size(); i++){
    float[] component = components.get(i);
    
    //checks if there is a collision
    if (abs(player[distFromStart]-component[distFromStart]) <= (player[run]+component[run])/2 && abs(player[distFromBottom]-component[distFromBottom]) <= (player[rise]+component[rise])/2 ){
     
      //checks the angle the player and the component made 
      float angleOfOrigin = atan2(component[distFromBottom]-prevPoint.y, prevPoint.x-component[distFromStart]);
      float criticalAngle = atan2(component[rise]+player[rise], component[run]+player[run]);
      
      /*Checks the kind of collision **relative to player** */
      //Right of player
      if (abs(angleOfOrigin) > radians(180)-criticalAngle){
        println("horizontal collision");
        collidedComponents.add(new int[]{i,right});
      }
      //Left of player
      else if (abs(angleOfOrigin) < criticalAngle){
        println("horizontal collision");
        collidedComponents.add(new int[]{i,left});
      }
      //Above player
      else if (angleOfOrigin >= criticalAngle && abs(prevPoint.x-component[distFromStart]) != (player[run]+component[run])/2){
        println("vertical collision");
        collidedComponents.add(new int[]{i,above});
      }
      //Below Player
      else if (angleOfOrigin >= -radians(180)+criticalAngle && abs(prevPoint.x-component[distFromStart]) != (player[run]+component[run])/2) {
        println("vertical collision");
        collidedComponents.add(new int[]{i,below});
      }
    }
  }
  return collidedComponents;
}

float determineHeight(float t, float timeOfMax, float slope, float initialDistFromBottom, float t0){
  float a = slope/(-timeOfMax*2);
  float k = slope * t0*t0 / (timeOfMax* 2);
  if (t <= timeOfTerminalVelocity){
    return a * t * t + k + initialDistFromBottom;
  }else{
    final float y1 = a * timeOfTerminalVelocity * timeOfTerminalVelocity + k + initialDistFromBottom;
    final float finalSlope = 2*a*timeOfTerminalVelocity;
    final float x1 = timeOfTerminalVelocity;
    return finalSlope*(t-x1)+y1;
  }
}

void handleCollision(ArrayList<int[]> collidedComponents){
  for (int[] collidedComponent: collidedComponents){
    float[] component = components.get(collidedComponent[componentID]);
    
    switch (collidedComponent[collisionType]){
      case right: 
        player[distFromStart] = component[distFromStart] - (component[run]+player[run])/2;
      break;
      
      case left: 
        player[distFromStart] = component[distFromStart] + (component[run]+player[run])/2;
      break;
      
      case above:
        player[distFromBottom] = component[distFromBottom] - (component[rise]+player[rise])/2;
        if (verticalMovementState == heightManuallyIncreasing){
          t = determineTimeAtSlope(-verticalSpeed, timeOfMax, verticalSpeed);
        }
        else if (verticalMovementState == heightParabolicallyIncreasing){
          t = -t;
        }
        t0=t;
        initialDistFromBottom = player[distFromBottom];
        verticalMovementState = heightParabolicallyDecreasing;
      break;
      
      case below:
        player[distFromBottom] = component[distFromBottom] + (component[rise]+player[rise])/2;
        if (verticalMovementState == defaultMovement || verticalMovementState == heightParabolicallyDecreasing || verticalMovementState == terminalVelocityReached){
          t = 0;
          initialDistFromBottom = player[distFromBottom];
          canJump = true;
          t0 = -timeOfMax;
          verticalMovementState = defaultMovement;
          fuel = maxFuel;
        }
      break;
    }  
  }
}

float determineSlopeAtTime (float t, float timeOfMax, float slope){
  float a = slope/(-timeOfMax*2);
  return 2*a*t;
}

float determineTimeAtSlope (float initialSlope, float timeOfMax, float slope){
  float a = slope/(-timeOfMax*2);
  return initialSlope/(2*a);
}
