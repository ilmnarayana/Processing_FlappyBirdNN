import java.util.Scanner;

float birdX=50;
float birdD=20;
float pipeGap=100;
float pipeWidth=80;
float pipesBWGap=200;
int score=0;

int bgCol;

//Population pop;

Bird b;

ArrayList<Pipe> pipes;

void setup() {
  size(400, 400);
  pipes=new ArrayList<Pipe>();
  pipes.add(new Pipe());
  bgCol=color(255);

  JSONObject json=loadJSONObject("dataOfBests/100,80,200/BestBird3.json");
  Network nn=networkFromJSON(json);
  b=new Bird(nn);

  //pop=new Population(100);
}

Matrix matrixFromJSON(JSONObject json) {
  int rows=json.getInt("rows");
  int cols=json.getInt("cols");
  String s=json.getString("data");
  Scanner scan=new Scanner(s);
  float[][] data=new float[rows][cols];
  for (int i=0; i<rows; ++i) {
    for (int j=0; j<cols; ++j) {
      data[i][j]=scan.nextFloat();
    }
  }
  scan.close();
  return new Matrix(rows, cols, data);
}

//Multi Hidden Layer
Network networkFromJSON(JSONObject json) {
  int numInputs=json.getInt("numInputs");
  int numOutputs=json.getInt("numOutputs");
  Matrix wih=matrixFromJSON(json.getJSONObject("weights_IH"));
  Matrix who=matrixFromJSON(json.getJSONObject("weights_HO"));
  Matrix bo=matrixFromJSON(json.getJSONObject("bias_O"));
  JSONArray hiddenLayers=json.getJSONArray("hiddenLayers");
  int len=hiddenLayers.size();
  int[] numHiddens=new int[len];
  Matrix[] bh=new Matrix[len];
  for (int i=0; i<len; ++i) {
    JSONObject hljson=hiddenLayers.getJSONObject(i);
    numHiddens[i]=hljson.getInt("numHiddens");
    bh[i]=matrixFromJSON(hljson.getJSONObject("bias_H"));
  }
  Matrix[] whh;
  if (len==1) whh=null;
  else {
    whh=new Matrix[len-1];
    JSONArray whharr=json.getJSONArray("weights_HH");
    for (int i=0; i<len-1; ++i) {
      whh[i]=matrixFromJSON(whharr.getJSONObject(i));
    }
  }
  return new Network(numInputs, numHiddens, numOutputs, wih, whh, who, bh, bo);
}

//void keyPressed() {
//  if (keyCode == ' ') {
//    Bird best=pop.getBestFromRunning();
//    if (best!=null) {
//      JSONObject jsonbest=best.brain.getJSON();
//      saveJSONObject(jsonbest, "data/BestBird.json");
//      println("SAVED!!!!");
//    }
//  }
//}

//void mousePressed() {
//  Bird best=pop.getBestFromRunning();
//  if (best!=null) {
//    JSONObject jsonbest=best.brain.getJSON();
//    saveJSONObject(jsonbest, "data/BestBird.json");
//    println("SAVED!!!!");
//  }
//}

void draw() {
  background(bgCol);
  //int spd=(int)map(mouseX, 0, width, 1, 100);
  int spd=(int)map(mouseX, 0, width, 1, 16);
  for (int i=0; i<spd; ++i) {
    for (Pipe p : pipes) {
      p.update();
    }

    //pop.play();

    b.update();
    for (Pipe p : pipes) {
      if (b.collides(p)) {
        bgCol=color(255, 0, 0);
        score=0;
        break;
      } else bgCol=color(255);
    }

    if (pipes.get(pipes.size()-1).x<pipesBWGap) pipes.add(new Pipe());
    if (pipes.get(0).x<-pipeWidth) {
      pipes.remove(0);
      score++;
    }
  }
  for (Pipe p : pipes) {
    p.show();
  }

  //for (Bird b : pop.birds) {
  //  b.show();
  //}

  b.show();
  fill(255);
  rect(20, 20, 80, 20);
  fill(0);
  textAlign(LEFT, TOP);
  text("score: "+score, 20, 20);
}
