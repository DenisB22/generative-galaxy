import java.util.ArrayList;
import java.io.File;

ArrayList<Star> stars;
ArrayList<Nebula> nebulae;
ArrayList<Planet> planets;
ArrayList<Asteroid> asteroids;

int seedValue;
float galaxyX, galaxyY;
float asteroidBeltRadius;

color[] planetPalette;

void setup() {
  size(1000, 1000);
  smooth(8);

  // Create the screenshots folder if it does not exist.
  File screenshotsDir = new File(sketchPath("screenshots"));
  if (!screenshotsDir.exists()) {
    screenshotsDir.mkdirs();
  }

  planetPalette = new color[] {
    color(90, 160, 255),
    color(255, 140, 100),
    color(180, 120, 255),
    color(255, 210, 90),
    color(120, 255, 180),
    color(255, 120, 180),
    color(220, 220, 255)
  };

  generateGalaxy();
  noLoop();
}

void draw() {
  randomSeed(seedValue);
  noiseSeed(seedValue);

  drawBackgroundGradient();
  drawCosmicDust();
  drawNebulae();
  drawGalaxyCore();
  drawStars();
  drawOrbits();
  drawAsteroidBelt();
  drawPlanets();

  drawInstructions();
}

void generateGalaxy() {
  seedValue = int(random(1000000));

  randomSeed(seedValue);
  noiseSeed(seedValue);

  galaxyX = width / 2 + random(-60, 60);
  galaxyY = height / 2 + random(-40, 40);

  stars = new ArrayList<Star>();
  nebulae = new ArrayList<Nebula>();
  planets = new ArrayList<Planet>();
  asteroids = new ArrayList<Asteroid>();

  // Generate a random star field.
  int starCount = int(random(450, 750));
  for (int i = 0; i < starCount; i++) {
    float x = random(width);
    float y = random(height);
    float s = random(1, 4);
    float a = random(100, 255);
    boolean glow = random(1) < 0.18;
    stars.add(new Star(x, y, s, a, glow));
  }

  // Generate colorful nebula clouds.
  int nebulaCount = int(random(3, 6));
  for (int i = 0; i < nebulaCount; i++) {
    float x = random(width * 0.15, width * 0.85);
    float y = random(height * 0.15, height * 0.85);
    float r = random(120, 260);

    color c;
    int choice = int(random(4));
    if (choice == 0) {
      c = color(90, 120, 255);
    } else if (choice == 1) {
      c = color(255, 90, 180);
    } else if (choice == 2) {
      c = color(80, 255, 220);
    } else {
      c = color(180, 100, 255);
    }

    int dots = int(random(180, 320));
    float localSeed = random(10000);

    nebulae.add(new Nebula(x, y, r, c, dots, localSeed));
  }

  // Generate planets with different orbits, colors, sizes and surface patterns.
  int planetCount = int(random(4, 8));
  float orbitR = 120;

  for (int i = 0; i < planetCount; i++) {
    orbitR += random(45, 70);

    float angle = random(TWO_PI);
    float radius = random(18, 42);
    color base = planetPalette[int(random(planetPalette.length))];
    boolean hasRing = random(1) < 0.35;
    int moonCount = int(random(0, 3));
    float tilt = random(-0.7, 0.7);
    int patternType = int(random(2));
    float pSeed = random(10000);

    planets.add(new Planet(orbitR, angle, radius, base, hasRing, moonCount, tilt, patternType, pSeed));
  }

  // Generate an asteroid belt around the galaxy core.
  asteroidBeltRadius = random(260, 360);
  int asteroidCount = int(random(180, 320));

  for (int i = 0; i < asteroidCount; i++) {
    float angle = random(TWO_PI);
    float r = asteroidBeltRadius + random(-22, 22);
    float s = random(1.5, 4.5);

    asteroids.add(new Asteroid(angle, r, s));
  }
}

void keyPressed() {
  if (key == 'r' || key == 'R') {
    generateGalaxy();
    redraw();
    println("New galaxy generated.");
  }

  if (key == 's' || key == 'S') {
    saveScreenshot();
  }
}

void saveScreenshot() {
  String filename = "screenshots/galaxy-" 
    + year() + "-" 
    + nf(month(), 2) + "-" 
    + nf(day(), 2) + "_" 
    + nf(hour(), 2) + "-" 
    + nf(minute(), 2) + "-" 
    + nf(second(), 2) 
    + ".png";

  PImage screenshot = get();
  screenshot.save(sketchPath(filename));

  println("Screenshot saved here:");
  println(sketchPath(filename));
}

void drawBackgroundGradient() {
  for (int y = 0; y < height; y++) {
    float inter = map(y, 0, height, 0, 1);
    color c = lerpColor(color(5, 5, 20), color(0, 0, 0), inter);
    stroke(c);
    line(0, y, width, y);
  }
}

void drawCosmicDust() {
  strokeWeight(1);

  for (int x = 0; x < width; x += 8) {
    for (int y = 0; y < height; y += 8) {
      float n = noise(x * 0.008, y * 0.008, seedValue * 0.0001);

      if (n > 0.62) {
        stroke(120 + n * 120, 40);
        point(x, y);
      }
    }
  }
}

void drawNebulae() {
  for (Nebula n : nebulae) {
    n.display();
  }
}

void drawGalaxyCore() {
  noStroke();

  for (int i = 180; i > 0; i -= 6) {
    float alpha = map(i, 180, 0, 8, 90);
    fill(255, 220, 170, alpha);
    ellipse(galaxyX, galaxyY, i * 2.0, i * 1.2);
  }

  for (int i = 90; i > 0; i -= 4) {
    float alpha = map(i, 90, 0, 10, 100);
    fill(255, 255, 220, alpha);
    ellipse(galaxyX, galaxyY, i * 1.2, i * 1.2);
  }
}

void drawStars() {
  for (Star s : stars) {
    s.display();
  }
}

void drawOrbits() {
  noFill();
  stroke(255, 40);
  strokeWeight(1.2);

  for (Planet p : planets) {
    ellipse(galaxyX, galaxyY, p.orbitRadius * 2, p.orbitRadius * 1.1);
  }

  stroke(220, 30);
  ellipse(galaxyX, galaxyY, asteroidBeltRadius * 2, asteroidBeltRadius * 1.1);
}

void drawAsteroidBelt() {
  for (Asteroid a : asteroids) {
    a.display();
  }
}

void drawPlanets() {
  for (Planet p : planets) {
    p.display();
  }
}

void drawInstructions() {
  fill(255, 120);
  textSize(16);
  text("Press R to generate a new galaxy | Press S to save screenshot", 25, height - 25);
}

class Star {
  float x, y, size, alpha;
  boolean glow;

  Star(float x, float y, float size, float alpha, boolean glow) {
    this.x = x;
    this.y = y;
    this.size = size;
    this.alpha = alpha;
    this.glow = glow;
  }

  void display() {
    noStroke();

    if (glow) {
      fill(255, alpha * 0.18);
      ellipse(x, y, size * 5, size * 5);
    }

    fill(255, alpha);
    ellipse(x, y, size, size);
  }
}

class Nebula {
  float x, y, radius;
  color c;
  int dots;
  float localSeed;

  Nebula(float x, float y, float radius, color c, int dots, float localSeed) {
    this.x = x;
    this.y = y;
    this.radius = radius;
    this.c = c;
    this.dots = dots;
    this.localSeed = localSeed;
  }

  void display() {
    randomSeed((int)localSeed);
    noStroke();

    for (int i = 0; i < dots; i++) {
      float angle = random(TWO_PI);
      float dist = radius * sqrt(random(1));
      float px = x + cos(angle) * dist;
      float py = y + sin(angle) * dist * 0.7;
      float d = random(radius * 0.07, radius * 0.24);
      float a = random(8, 28);

      fill(red(c), green(c), blue(c), a);
      ellipse(px, py, d, d);
    }
  }
}

class Planet {
  float orbitRadius;
  float angle;
  float radius;
  color baseColor;
  boolean hasRing;
  int moonCount;
  float tilt;
  int patternType;
  float patternSeed;

  Planet(float orbitRadius, float angle, float radius, color baseColor, boolean hasRing, int moonCount, float tilt, int patternType, float patternSeed) {
    this.orbitRadius = orbitRadius;
    this.angle = angle;
    this.radius = radius;
    this.baseColor = baseColor;
    this.hasRing = hasRing;
    this.moonCount = moonCount;
    this.tilt = tilt;
    this.patternType = patternType;
    this.patternSeed = patternSeed;
  }

  void display() {
    float px = galaxyX + cos(angle) * orbitRadius;
    float py = galaxyY + sin(angle) * orbitRadius * 0.55;

    // Draw planet moons.
    for (int i = 0; i < moonCount; i++) {
      float ma = angle * 1.7 + TWO_PI * i / max(1, moonCount) + patternSeed * 0.001;
      float md = radius * 2.2 + i * 10;

      noStroke();
      fill(220, 200);
      ellipse(px + cos(ma) * md, py + sin(ma) * md * 0.55, radius * 0.35, radius * 0.35);
    }

    // Draw a ring around some planets.
    if (hasRing) {
      pushMatrix();
      translate(px, py);
      rotate(tilt);

      noFill();
      stroke(230, 180);
      strokeWeight(2);
      ellipse(0, 0, radius * 3.2, radius * 1.2);

      stroke(255, 70);
      ellipse(0, 0, radius * 3.6, radius * 1.4);

      popMatrix();
    }

    // Draw the planet body.
    noStroke();
    fill(baseColor);
    ellipse(px, py, radius * 2, radius * 2);

    // Draw a soft highlight.
    fill(255, 40);
    ellipse(px - radius * 0.35, py - radius * 0.35, radius * 0.8, radius * 0.8);

    // Draw a soft shadow.
    fill(0, 60);
    ellipse(px + radius * 0.30, py + radius * 0.10, radius * 1.5, radius * 1.8);

    if (patternType == 0) {
      drawSpots(px, py);
    } else {
      drawStripes(px, py);
    }
  }

  void drawSpots(float px, float py) {
    randomSeed((int)patternSeed);

    for (int i = 0; i < 6; i++) {
      float a = random(TWO_PI);
      float d = random(radius * 0.15, radius * 0.55);
      float sx = px + cos(a) * d;
      float sy = py + sin(a) * d;
      float sr = random(radius * 0.12, radius * 0.28);

      fill(255, 35);
      ellipse(sx, sy, sr, sr);
    }
  }

  void drawStripes(float px, float py) {
    stroke(255, 40);
    strokeWeight(2);

    for (int i = -2; i <= 2; i++) {
      float yy = py + i * radius * 0.25;
      line(px - radius * 0.7, yy, px + radius * 0.7, yy);
    }

    noStroke();
  }
}

class Asteroid {
  float angle;
  float orbitRadius;
  float size;

  Asteroid(float angle, float orbitRadius, float size) {
    this.angle = angle;
    this.orbitRadius = orbitRadius;
    this.size = size;
  }

  void display() {
    float px = galaxyX + cos(angle) * orbitRadius;
    float py = galaxyY + sin(angle) * orbitRadius * 0.55;

    noStroke();
    fill(180, 160);
    ellipse(px, py, size, size * 0.8);
  }
}
