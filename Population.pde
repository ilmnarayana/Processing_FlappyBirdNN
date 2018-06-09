class Population {
  ArrayList<Bird> birds;
  ArrayList<Bird> backUp;
  int size;
  int gen=0;
  int bestScore=-1;

  Population(int len) {
    birds=new ArrayList<Bird>();
    size=len;
    for (int i=0; i<len; ++i) {
      birds.add(new Bird());
    }
    backUp=new ArrayList<Bird>();
  }

  Bird pickOne() {
    float r=random(1);
    int index=0;
    while (r>0) {
      r-=backUp.get(index).fitness;
      index++;
    }
    index--;
    return backUp.get(index);
  }

  void calcFitness() {
    float sum=0;
    for (Bird b : backUp) {
      sum+=exp(b.score);
    }
    for (Bird b : backUp) {
      b.fitness=(float)exp(b.score)/sum;
    }
  }

  void newGeneration() {
    calcFitness();
    for (int i=0; i<backUp.size(); ++i) {
      Bird temp=pickOne();
      Network nn=temp.brain.mutate(0.1);
      temp=new Bird(nn);
      birds.add(temp);
    }
    pipes.clear();
    pipes.add(new Pipe());
    gen++;
    println("gen: "+gen+" score: "+score);
    score=0;
  }

  Bird getBest() {
    float scr=0;
    Bird ans=backUp.get(0);
    for (Bird b : backUp) {
      if (scr<b.score) {
        scr=b.score;
        ans=b;
      }
    }
    return ans;
  }

  Bird getBestFromRunning() {
    float scr=0;
    Bird ans=null;
    for (Bird b : birds) {
      if (scr<b.score) {
        scr=b.score;
        ans=b;
      }
    }
    return ans;
  }

  void play() {
    for (int i=birds.size()-1; i>=0; --i) {
      Bird b=birds.get(i);
      b.update();
      for (Pipe p : pipes) {
        if (b.collides(p)) {
          backUp.add(b);
          birds.remove(i);
        }
      }
    }
    if (birds.size()==0) {
      newGeneration();
      if (score>bestScore) {
        Bird best=getBest();
        JSONObject jsonbest=best.brain.getJSON();
        saveJSONObject(jsonbest, "data/BestBird.json");
        bestScore=score;
      }
      backUp.clear();
    }
  }
}
