float[][] f,g,h;
float s;
float time;
float time_delta;
float frac;


void setup(){
  size(1000,1000);
  background(0);
  h=new float[200][200];
  g=new float[200][200];
  f=new float[200][200];
  time=0;
  frac=1;
  for(int i=0;i<200;i++){
    for(int j=0;j<200;j++){
      h[i][j]=0;
      g[i][j]=0;
      f[i][j]=0;
      
    }
    
    if(i!=0 && i!=199){
      h[i][5]=100;
    }
    if(i!=0 && i!=199){
    //  h[i][195]=-100;
    }
    
  }
  /*
  h[49][49]=1000;
  h[149][149]=-1000;
  */
  
  /*
  for(int i=0;i<10;i++){
    h[int(random(1,199))][int(random(1,199))]=random(-300,300);
  }
  */
  
  
  s=1;
  time_delta=0.1;
  frameRate(90);
}

void draw(){
  background(0);
  for(int i=0;i<200;i++){
    for(int j=0;j<200;j++){
      g[i][j]=h[i][j];
    }
  }
  
  for(int i=1;i<199;i++){
    for(int j=1;j<199;j++){
      h[i][j]=2*g[i][j]-f[i][j]+frac*pow(time_delta/s,2)*( (g[i+1][j]-2*g[i][j]+g[i-1][j]) + (g[i][j+1]-2*g[i][j]+g[i][j-1]) );
      
      
      if(j>=70 && j<=80){
        if((j==70 && 0<=i && i<50) || (j==70 && 70<i && i<200)){
          h[i][70]=2*g[i][70]-f[i][70]+frac*pow(time_delta/s,2)*( (g[i+1][70]-2*g[i][70]+g[i-1][70]) + (g[i][69]-2*g[i][70]) );
        }
        if((j==80 && 0<=i && i<50) || (j==80 && 70<i && i<200)){
          h[i][80]=2*g[i][80]-f[i][80]+frac*pow(time_delta/s,2)*( (g[i+1][80]-2*g[i][80]+g[i-1][80]) + (g[i][81]-2*g[i][80]) );
        }
        if(i==50 && j!=70 && j!=80){
          h[50][j]=2*g[50][j]-f[50][j]+frac*pow(time_delta/s,2)*( (g[51][j]-2*g[50][j]) + (g[50][j+1]-2*g[50][j]+g[50][j-1]) );
        }
        if(i==70 && j!=70 && j!=80){
          h[70][j]=2*g[70][j]-frac*f[70][j]+pow(time_delta/s,2)*( -2*g[70][j]+g[69][j] + (g[70][j+1]-2*g[70][j]+g[70][j-1]) ) ;
        }
        
        
      }
      if(70<i && i<200 && j>70 && j<80){
        h[i][j]=0;
      }
      if(0<=i && i<50 && j>70 && j<80){
        h[i][j]=0;
      }
      
      /*
      h[100][100]=500*sin(time/30);
  */  
    }
    
  }
  
  for(int i=1;i<199;i++){
    h[i][0]=2*g[i][0]-f[i][0]+frac*pow(time_delta/s,2)*( (g[i+1][0]-2*g[i][0]+g[i-1][0]) + (g[i][1]-2*g[i][0]) );
  }
  for(int i=1;i<199;i++){
    h[i][199]=2*g[i][199]-f[i][199]+frac*pow(time_delta/s,2)*( (g[i+1][199]-2*g[i][199]+g[i-1][199]) + (g[i][198]-2*g[i][199]) );
  }
  for(int j=1;j<199;j++){
    h[0][j]=2*g[0][j]-f[0][j]+frac*pow(time_delta/s,2)*( (g[1][j]-2*g[0][j]) + (g[0][j+1]-2*g[0][j]+g[0][j-1]) );
    h[199][j]=2*g[199][j]-frac*f[199][j]+pow(time_delta/s,2)*( -2*g[199][j]+g[198][j] + (g[199][j+1]-2*g[199][j]+g[199][j-1]) ) ;
  }
  
  /*
  if(time%1==0){
    for(int i=0;i<1;i++){
      h[int(random(1,199))][int(random(1,199))]=random(0,30);
    }
  }
  */
  
  
  for(int i=0;i<200;i++){
    for(int j=0;j<200;j++){
      f[i][j]=g[i][j];
      noStroke();
      fill(h[i][j],0,-h[i][j]);
      rect(i*5,j*5,5,5);
    }
  }
  fill(255);
  noStroke();
  rect(0,70*5,50*5,10*5);
  rect(70*5,70*5,130*5,10*5);
  
  time++;
}