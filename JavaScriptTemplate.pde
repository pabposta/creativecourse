int WIDTH = 640;
int HEIGHT = 400;
float EXPLOSION_FRAME_INC = 1/3; 

Vehicle v;
ParticleSystem[] accelPs = new ParticleSystem[2];
ParticleSystem[] brakePs = new ParticleSystem[2];
PVector target;

Animation explosion;
PImage bg;

Maxim maxim;
AudioPlayer accelPlayer;
AudioPlayer brakePlayer;
AudioPlayer explosionPlayer;

void setup()
{
  background(0);
  size(WIDTH, HEIGHT);
  
  bg = loadImage("grunge-danger-background-1280x2000.jpg");
  
  // sprite by mattalien
  PImage sprite = loadImage("Ford40GT.png");
  
  maxim = new Maxim(this);
  accelPlayer = maxim.loadFile("engineloop.wav");
  accelPlayer.setLooping(true);
  accelPlayer.volume(0.5);
  brakePlayer = maxim.loadFile("car-brake-01.wav");
  brakePlayer.setLooping(false);
  brakePlayer.volume(0.25);
  explosionPlayer = maxim.loadFile("boom.wav");
  explosionPlayer.setLooping(false);
  explosionPlayer.volume(0.3);
  
  accelPs[0] = new ParticleSystem(3, 255, -12);
  accelPs[1] = new ParticleSystem(3, 255, -12);
  brakePs[0] = new ParticleSystem(1, 15, -1.5);
  brakePs[1] = new ParticleSystem(1, 15, -1.5);

  v = new Vehicle(50, 50, sprite, accelPs, brakePs);
  target = new PVector(WIDTH - 50, HEIGHT - 50);
  
  spritesheet = loadImage("explosion.png");
  explosion = new Animation(spritesheet, 84, 74, 7, EXPLOSION_FRAME_INC, 0, 0);
  
  playing = false;
}

void draw()
{
  // clear screen and draw the background
  fill(0);
  stroke(200);
  strokeWeight(1);
  rect(0, 0, WIDTH - 1, HEIGHT - 1);
  imageMode(CORNER);
  image(bg, 0, 0);
  
  // the car will chase our mouse
  target.x = mouseX;
  target.y = mouseY;
  
  // update the car
  v.seek(target);
  v.update();
  v.display();
  
  // particle engines
  brakePs[0].run();
  brakePs[1].run();
  accelPs[0].run();
  accelPs[1].run();
  
  // draw the "cape"
  stroke(255, 0, 0, 255);
  fill(255, 0, 0, 100);
  ellipse((int) target.x, (int) target.y, 30, 30);
  
  // check for collision
  if (!explosion.playing()) {
    float distance = PVector.sub(v.location, target);
    if (distance.mag() <= 25) {
      distance.normalize();
      distance.mult(15);
      distance.add(target);
      explosion.move(distance);
      explosion.reset();
      explosion.play();
      explosionPlayer.stop();
      explosionPlayer.play();
    }
  }
  else {
    explosion.play();
  }
  
  // sound
  // the engine sound depends on the car's speed
  accelPlayer.speed(v.velocity.mag()/6 + 1);
  
  // engine sound. it takes a while to load, so try making it play until it does
  if (!accelPlayer.isPlaying()) {
    accelPlayer.play();
  }
  
  // start and stop braking sound
  if (!v.isBraking() && brakePlayer.isPlaying()) {
    brakePlayer.stop();
  }
  else if (v.isBraking() && !brakePlayer.isPlaying()) {
    brakePlayer.play();
  }
}

void mouseDragged()
{
// code that happens when the mouse moves
// with the button down
}

void mousePressed()
{
}

void mouseReleased()
{
// code that happens when the mouse button
// is released
}

class Animation {
  
  PImage spritesheet;
  float w;
  float h;
  int frames;
  float frameInc;
  float x;
  float y;
  float current_frame = 0;
  
  Animation(PImage spritesheet_, float w_, float h_, int frames_, float frameInc_, float x_, float y_) {
    w = w_;
    h = h_;
    frames = frames_;
    frameInc = frameInc_;
    x = x_;
    y = y_;
    spritesheet = spritesheet_;
  }
  
  void reset() {
    current_frame = 0;
  }
  
  void move(float x_, float y_) {
    x = x_;
    y = y_;
  }
  
  void move(PVector v) {
    x = v.x;
    y = v.y;
  }
  
  boolean playing() {
    if (current_frame == 0 || current_frame >= frames) {
      return false;
    }
    else {
      return true;
    }
  }
  
  void play() {
    if (current_frame < frames) {
      imageMode(CENTER);
      image(spritesheet.get((int)current_frame * w, 0, w, h), x, y);
      current_frame += frameInc;
    }
  }
}
class PVector {
 
  float x;
  float y;
 
  PVector(float x_, float y_) {
    x = x_;
    y = y_;
  }
  
  PVector(PVector v) {
    x = v.x;
    y = v.y;
  }
  
  void add(PVector v) {
    y = y + v.y;
    x = x + v.x;
  }
 
  void sub(PVector v) {
    x = x - v.x;
    y = y - v.y;
  }
  
  static PVector sub(PVector v1, PVector v2) {
    float new_x = v1.x - v2.x;
    float new_y = v1.y - v2.y;
    PVector res = new PVector(new_x, new_y);
    return res;
  }
  
  void mult(float n) {
    x = x * n;
    y = y * n;
  }
  
  void div(float n) {
    x = x / n;
    y = y / n;
  }
  
  float mag() {
    return sqrt(x*x + y*y);
  }
  
  void normalize() {
    float m = mag();
    div(m);
  }
  
  void limit(float max) {
    if (mag() > max) {
      normalize();
      mult(max);
    }
  }
  
  float heading() {
    return atan2(y,x);
  }
  
  float rotate(float angle) {
    float cs = cos(angle);
    float sn = sin(angle);
    float px = x;
    float py = y;
    x = px * cs - py * sn;
    y = px * sn + py * cs;
  }
  
  void set(float x_, float y_) {
    x = x_;
    y = y_;
  }
  
  void copy(PVector v) {
    x = v.x;
    y = v.y;
  }
  
  void angle(PVector v) {
    float angle = v.heading() - heading();
    if (angle < 0) {
      angle += 2 * PI;
    }  
    return angle;
  }
  
  PVector normal() {
    return new PVector(-y, x);  
  }
}
class Particle {
  float INITIAL_LIFE = 255;
  
  PVector location;
  PVector velocity;
  PVector acceleration;
  float lifespan;
  float colour;
  float lifeDelta;
 
  Particle(PVector loc, PVector acc, float colour_, float lifeDelta_) {
    location = new PVector(loc);
    acceleration = new PVector(acc);
    velocity = new PVector(0, 0);
    lifespan = INITIAL_LIFE;
    lifeDelta = lifeDelta_;
    colour = colour_;
  }
 
  void run() {
    update();
    display();
  }
 
  void update() {
    velocity.add(acceleration);
    location.add(velocity);
    lifespan += lifeDelta;
  }
  
  void applyForce(PVector force) {
    acceleration.add(force);
  }
  
  boolean isDead() {
    if (lifespan < 0.0) {
      return true;
    } else {
      return false;
    }
  }
 
  void display() {
    noStroke();
    fill(colour, lifespan);
    rect((int) location.x, (int) location.y, 2, 2);
  }
}

class ParticleSystem {
  ArrayList<Particle> particles;
  PVector origin;

  float spread;
  float colour;
  float lifeDelta;

  ParticleSystem(float spread_, float colour_, float lifeDelta_) {
    particles = new ArrayList<Particle>();
    origin = new PVector(0, 0);
    spread = spread_;
    colour = colour_;
    lifeDelta = lifeDelta_;
  }
  
  void setOrigin(float x, float y) {
    origin.x = x;
    origin.y = y;
  }
  
  void setOrigin(PVector o) {
    origin.x = o.x;
    origin.y = o.y;
  }

  void addParticle(Particle p) {
    particles.add(p);
  }
  
  void addParticles(int nb) {
    PVector acc = new PVector(0, 0);
    PVector loc = new PVector(0, 0);
    for (int i = 0; i < nb; i++) {
      loc.x = origin.x + random(-spread, spread);
      loc.y = origin.y + random(-spread, spread);
      Particle p = new Particle(loc, acc, colour, lifeDelta);
      addParticle(p);
    }
  }

  void run() {
    Iterator<Particle> it =
        particles.iterator();
    while (it.hasNext()) {
      Particle p = it.next();
      p.run();
      if (p.isDead()) {
        particles.remove(p);
      }
    }
  }
}
class Vehicle {
 
  float MAXSPEED = 5;
  float MINSPEED = 1;
  float MAXSTEER = PI/32;
  float ACCEL_FORCE = 0.06;
  float BRAKE_FORCE = -0.15;
  
  PVector location;
  PVector velocity;
  PVector acceleration;
  PVector orientation;
  PImage sprite;
  ParticleSystem[] accelPs;
  ParticleSystem[] brakePs;
  
  boolean braking;
 
  Vehicle(float x, float y, PImage sprite_, ParticleSystem[] accelPs_, ParticleSystem[] brakePs_) {
    orientation = new PVector(1, 0);
    acceleration = new PVector(0,0);
    velocity = new PVector(0, 0);
    location = new PVector(x,y);
    sprite = sprite_;
    accelPs = accelPs_;
    brakePs = brakePs_;
    braking = false;
  }
 
  void update() {
    velocity.add(acceleration);
    velocity.limit(MAXSPEED);
    location.add(velocity);
    acceleration.mult(0);
    if (velocity.mag() != 0) {
      orientation.copy(velocity);
      orientation.normalize();
    }
  }
 
  void seek(PVector target) {
    PVector desired = PVector.sub(target, location);
    float angle = orientation.angle(desired);
    
    braking = false;
    
    if (angle < PI/4 || angle > 7*PI/4) {
      // accelerate and steer in the direction of the target
      steer(angle);
      accelerate();
    }
    else if (angle < PI/2) {
      // just steer as hard as possible
      steer(MAXSTEER);
    }
    else if (angle > 3*PI/2) {
      // just steer as hard as possible
      steer(2*PI - MAXSTEER);
    }
    else if (angle < PI) {
      // brake and steer as hard as possible
      steer(MAXSTEER);
      if (velocity.mag() > MINSPEED) {
        brake();
      }
    }
    else {
      // brake and steer as hard as possible
      steer(2*PI - MAXSTEER);
      brake();
    }
    if (!braking && velocity.mag() + ACCEL_FORCE < MINSPEED) {
      accelerate();
    }
  }
  
  void accelerate() {
    acceleration.copy(orientation);
    acceleration.mult(ACCEL_FORCE);
    
    if (velocity.mag() < MAXSPEED) {
      // first wheel smoke
      float originx = location.x - 16 * orientation.x - 5.5 * orientation.y;
      float originy = location.y - 16 * orientation.y + 5.5 * orientation.x;
      accelPs[0].setOrigin(originx, originy);
      accelPs[0].addParticles(3);
      // second wheel smoke
      originx = location.x - 16 * orientation.x + 5.5 * orientation.y;
      originy = location.y - 16 * orientation.y - 5.5 * orientation.x;
      accelPs[1].setOrigin(originx, originy);
      accelPs[1].addParticles(3);
    }
  }
  
  void brake() {
    acceleration.copy(orientation);
    acceleration.mult(BRAKE_FORCE);
    // first wheel skid
    float originx = location.x - 16 * orientation.x - 5.5 * orientation.y;
    float originy = location.y - 16 * orientation.y + 5.5 * orientation.x;
    brakePs[0].setOrigin(originx, originy);
    brakePs[0].addParticles(6);
    // second wheel skid
    originx = location.x - 16 * orientation.x + 5.5 * orientation.y;
    originy = location.y - 16 * orientation.y - 5.5 * orientation.x;
    brakePs[1].setOrigin(originx, originy);
    brakePs[1].addParticles(6);
    braking = true;
  }
  
  void steer(float angle) {
    if (angle < PI/2) {
      if (angle > MAXSTEER) {
        angle = MAXSTEER;
      }
    }
    else {
      if (2*PI - angle > MAXSTEER) {
        angle = 2*PI - MAXSTEER;
      }
    }
    
    if (angle <= PI) {
      velocity.rotate(angle/2);
    }
    else {
      velocity.rotate(2*PI + (angle - 2*PI) / 2);
    }
  }
 
  void display() {
    float theta = velocity.heading() + PI/2;
    fill(175);
    stroke(0);
    pushMatrix();
    translate(location.x, location.y);
    rotate(theta);
    imageMode(CENTER);
    image(sprite, 0, 0, 19, 32);
    popMatrix();
  }
  
  boolean isBraking() {
    return braking;
  }
}

