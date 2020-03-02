float[][] T,S;
float time_delta;
float lamda;
float C;
float time;

void setup(){
  size(1000,1000);
  background(0);
  T = new float[1000][1000];
  S = new float[1000][1000];
  
  time_delta=1;
  lamda=0.2;
  C=1;
  time=0;
  for(int i=0;i<1000;i++){
    for(int j=0;j<1000;j++){
      if(i==0 || i==99){
        T[i][j]=20;
      }else if(j==0){
        T[i][j]=20;
      }else if(j==99){
        T[i][j]=130;
      }else{
        T[i][j]=random(-1000,1000);
      }
      
      T[49][49]=10000;
      T[40][40]=-10000;
      
      T[50][80]=10000;
      
      S[i][j]=T[i][j];
    }
  }
  frameRate(60);
}

void draw(){
  background(100);
  for(int i=0;i<100;i++){
    for(int j=0;j<100;j++){
      S[i][j]=T[i][j];
    }
  }
  
  for(int i=1;i<99;i++){
    for(int j=1;j<99;j++){
      T[i][j]=S[i][j]+lamda * time_delta / C *( (S[i+1][j]-2*S[i][j]+S[i-1][j]) + (S[i][j+1]-2*S[i][j]+S[i][j-1]) );
      //if(i==24 && j==49){
      //  T[i][j]=-500*sin(time/1000);
      //}
      noStroke();
      fill(255*(T[i][j]/100),0,-255*(T[i][j]/100));
      rect(10*i,10*j,10,10);
    }
  }
 /* if(time%100 == 0){
    T[int(random(1,99))][int(random(1,99))]=random(-10000,10000);

    T[int(random(1,99))][int(random(1,99))]=random(-10000,10000);

    T[int(random(1,99))][int(random(1,99))]=random(-10000,10000);
    T[int(random(1,99))][int(random(1,99))]=random(-10000,10000);

    T[int(random(1,99))][int(random(1,99))]=random(-10000,10000);

    T[int(random(1,99))][int(random(1,99))]=random(-10000,10000);

}*/
  
  time++;
  text(time,0,900);
}