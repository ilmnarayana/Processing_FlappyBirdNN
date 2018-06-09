class Pipe {
  float y;
  float x;
  Rectangle r1, r2;

  Pipe() {
    y=random(pipeGap, height-(2*pipeGap));
    x=width+pipeWidth;
    r1=new Rectangle(x, 0, pipeWidth, y);
    r2=new Rectangle(x, y+pipeGap, pipeWidth, height-y-pipeGap);
  }

  void update() {
    x-=2;
    r1.move(-2);
    r2.move(-2);
  }

  void show() {
    fill(0);
    r1.show();
    r2.show();
  }
}
