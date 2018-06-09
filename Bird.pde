class Bird {
  float y;
  float yvel;
  float yacc;
  Network brain;
  float score;
  float fitness;

  Bird() {
    y=width/2;
    yvel=0;
    yacc=0;
    int[] hl={10};
    brain=new Network(6, hl, 1);
  }

  Bird(Network nn) {
    y=width/2;
    yvel=0;
    yacc=0;
    brain=nn;
  }

  void update() {
    float inputs[]=new float[6];
    inputs[0]=y/height;
    inputs[1]=yvel/20;
    inputs[2]=pipes.get(0).x/width;
    inputs[3]=pipes.get(0).y/height;
    inputs[4]=(pipes.get(0).x+pipeWidth)/width;
    inputs[5]=(pipes.get(0).y+pipeGap)/height;
    float[] guess=brain.predict(inputs);
    if (guess[0]>0.5) up();
    yvel+=0.3;
    yvel+=yacc;
    y+=yvel;
    isOut();
    yacc=0;
    score+=0.1;
  }

  void isOut() {
    if (y<=0) {
      y=0;
      yvel=0;
      yacc=0;
    }
    if (y>=height) {
      y=height;
      yvel=0;
      yacc=0;
    }
  }

  void up() {
    yvel=-6;
  }

  boolean collides(Pipe p) {
    return p.r1.collides(this)||p.r2.collides(this);
  }

  void show() {
    fill(0, 100);
    ellipse(birdX, y, birdD, birdD);
    fill(255);
    textAlign(CENTER, CENTER);
    text(score, birdX, y);
  }
}
