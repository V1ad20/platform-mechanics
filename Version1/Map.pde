ArrayList<float[]> components = new ArrayList<float[]>();


void determineComponents(){
  addComponent(1600,25,3200,50);
  addComponent(100,250,50,50);
  addComponents(400,250,50,50,75,3);
}
void addComponents(float distFromStart, float distFromBottom, float run, float rise, float spaceBetween, int numComponents){
  for (int i = 0; i < numComponents; i++){
    components.add(new float[]{distFromStart+(run+spaceBetween)*i,distFromBottom,run,rise});
  }
}
void addComponent(float distFromStart, float distFromBottom, float run, float rise){
    components.add(new float[]{distFromStart,distFromBottom,run,rise});
}

void drawLevel(){
  background(150);
  
  PVector playerPoint = new PVector(player[distFromStart],500-player[distFromBottom]);
  //Horizontal Offset
  byte hO = 0;
  if (player[distFromStart] >= criticalDistFromStart){
    hO = 1;
    playerPoint.x = criticalDistFromStart; 
  }
  
  //Vertical Offset
  byte vO = 0;
  if (player[distFromBottom] >= criticalDistFromBottom){
    vO = 1;
    playerPoint.y = 500-criticalDistFromBottom; 
  }
  
  rect(playerPoint.x, playerPoint.y,player[run], player[rise]);
  for (float[] component: components){
    strokeWeight(1);
    rect(component[distFromStart]+(-player[distFromStart]+criticalDistFromStart)*hO, 500-(component[distFromBottom]-(player[distFromBottom]-criticalDistFromBottom)*vO),component[run], component[rise]);
    strokeWeight(2);
    point(component[distFromStart]+(-player[distFromStart]+criticalDistFromStart)*hO, 500-(component[distFromBottom]+(-player[distFromBottom]+criticalDistFromBottom)*vO));
  }

}
