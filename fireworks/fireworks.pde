import ddf.minim.*;

Minim minim;
AudioSample fire1;
AudioSample fire2;

final   float DETAIL = 20;
float   counter = 0;
int wid,hei,N,num,N_0;
float t;
Firework[] firework=new Firework[40];

void setup(){
  
  minim = new Minim(this);
  fire1 = minim.loadSample("f2.wav", 2048);
  fire2 = minim.loadSample("f4.wav", 2048);
  
  N=20;
  N_0=40*30;
  num=19;
  wid=650;
  hei=500;
  t=0;
  size(650,500);
  frameRate(60);
  
  for(int i=0;i<num;i++){
    firework[i]=new Firework();
  }
  
  background(0);
  frameRate(30);
}

void draw(){
  noStroke();
  for(int i=0;i<30;i++){
    fill(255,255,90+i,i);
    ellipse(200,200,50-i,50-i);
  }
  
  fill(0,0,0,15);
  rect(0,0,width,height/2);
  noFill();
  
  
  
  
  for(int i=0;i<num;i++){
    firework[i].drw();
    firework[i].update();
    
  }
  
  t+=0.5;
  
  
  
  loadPixels();
  //water reflection
  for(int x=0;x<width;x++){
    for(int y=0;y<height/2;y++){
      pixels[int((height-1-y) * width + x)]=color((red(pixels[y * width + x])+red(pixels[int(y * width + x+4*cos(sin(t+y/2)))]))/2,(green(pixels[y * width + x])+green(pixels[int(y * width + x+4*cos(sin(t+y/2)))]))/2,(blue(pixels[y * width + x])+blue(pixels[int(y * width + x+4*cos(sin(t+y/2)/1))]))/2);
    }
  }
  updatePixels();
  fill(0,0,0,99);
  rect(0,height/2,width,height);
  
  
}

class Firework{
  float time,life,flag;
  float[] x=new float[N_0];
  float[] y=new float[N_0];
  float[] vx=new float[N_0];
  float[] vy=new float[N_0];
  float[] life_time=new float[N_0];
  float col1,col2;
  float num_fire;

  

  Firework(){
    life=0;
    flag=0;
    num_fire=random(1,30);
    num_fire*=N;
    num_fire=int(num_fire);
    float x_0,y_0;
    
    col1=random(2*PI);
    col2=random(2*PI);
    x_0=random(wid);
    y_0=random(200);
    for(int i=0;i<num_fire;i++){
      x[i]=x_0;
      y[i]=y_0;
      life_time[i]=(random(5,150));
      float v=random(10);
      float theta=random(2*PI);
      vx[i]=v*cos(theta);
      vy[i]=v*sin(theta);
      if(life<life_time[i]){
        life=life_time[i];
      }
      life+=int(random(8));
    }
    time=0;
    if(int(random(2))*2-1==1){
      fire1.trigger();
    }else{
      fire2.trigger();
    }
  }
  
  void drw(){
    noStroke();
    for(int i=0;i<num_fire;i++){   
      for(int j=3;j<7;j++){
        fill(180*j*max(life_time[i]-time,0)/(life)*cos(col1)*sin(col2),180*j*max(life_time[i]-time,0)/(life)*cos(col1)*cos(col2),180*j*max(life_time[i]-time,0)/(life)*sin(col1),(7-j)*15);
        ellipse(x[i],y[i],(7-j),(7-j));
      }
    }
  }
  
  void update(){
    if(life>time){
      time+=3;
      for(int i=0;i<num_fire;i++){
        x[i]+=vx[i];
        y[i]+=vy[i];
        vx[i]*=0.92;
        vy[i]=vy[i]*0.92+0.05;
      }
    }else{
      flag=0;
      life=0;
      time=0;
      num_fire=random(1,5);
      num_fire*=N;
      num_fire=int(num_fire);
      float x_0,y_0;
      x_0=random(wid);
      y_0=random(200);
      for(int i=0;i<num_fire;i++){
        x[i]=x_0;
        y[i]=y_0;
        life_time[i]=int(random(5,250));
        float v=random(10);
        float theta=random(2*PI);
        vx[i]=v*cos(theta);
        vy[i]=v*sin(theta);
        if(life<life_time[i]){
          life=life_time[i];
        }
        life+=int(random(8));
        if(int(random(2))*2-1==1){
          fire1.trigger();
        }else{
          fire2.trigger();
        }
      }
      
    }
  }
    
}
