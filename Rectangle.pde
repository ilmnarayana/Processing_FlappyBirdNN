class Rectangle {
  float x, y, w, h, l, r, t, b;

  Rectangle(float x, float y, float w, float h) {
    this.x=x;
    this.y=y;
    this.w=w;
    this.h=h;
    this.l=x;
    this.r=x+w;
    this.t=y;
    this.b=y+h;
  }

  void move(float dx) {
    x+=dx;
    l+=dx;
    r+=dx;
  }

  boolean collides(Bird bird) {
    float bx=birdX;
    float br=birdD/2;
    float by=bird.y;
    if (bx+br<l || bx-br>r || by+br<t || by-br>b) return false;
    return true;
  }

  void show() {
    rect(x, y, w, h);
  }
}
