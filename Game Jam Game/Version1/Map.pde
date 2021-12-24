float[][] components = new float[][]
{
  {0,50,1600,50},
  {200,300,100,100}
};

void drawLevel(){
  background(150);
  
  if (player[distFromStart] < criticalDistFromStart){
    rect(player[distFromStart], 500-player[distFromBottom],player[run], player[rise]);
    for (float[] component: components){
      rect(component[distFromStart], 500-component[distFromBottom],component[run], component[rise]);
    }
  }else{
    rect(criticalDistFromStart, 500-player[distFromBottom],player[run], player[rise]);
    for (float[] component: components){
      rect(component[distFromStart]-player[distFromStart]+criticalDistFromStart, 500-component[distFromBottom],component[run], component[rise]);
    }
  }
}
