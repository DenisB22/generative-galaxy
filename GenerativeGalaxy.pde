from pathlib import Path

code = r'''import java.util.ArrayList;
import java.io.File;

ArrayList<Star> stars;
ArrayList<Nebula> nebulae;
ArrayList<Planet> planets;
ArrayList<Asteroid> asteroids;
ArrayList<Comet> comets;

int seedValue;
float galaxyX, galaxyY;
float asteroidBeltRadius;

color[] planetPalette;

void setup() {
  size(1000, 1000);
  smooth(8);
  frameRate(30);

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
}

void draw() {
  randomSeed(seedValue);
  noiseSeed(seedValue);

  drawBackgroundGradient();
  drawCosmicDust();
  drawNebulae();
  drawGalaxyCore();
  drawStars();
  drawComets();
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
  comets = new ArrayList<Comet>();

  // Generate a random star field.
  int starCount = int(random(450, 750));
  for (int i = 0; i < starCount; i++) {
    float x = random(width);
    float y = random(height);
    float s = random(1, 4);
    float a = random(100, 255);
    boolean glow = random(1) < 0.18;
    float twinkleSpeed = random(0.015, 0.045);
    float twinkleOffset = random(TWO_PI);
    stars.add(new Star(x, y, s, a, glow, twinkleSpeed, twinkleOffset));
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
    float driftSpeed = random(0.002, 0.006);

    nebulae.add(new Nebula(x, y, r, c, dots, localSeed, driftSpeed));
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
    float orbitSpeed = random(0.001, 0.004);

    if (random(1) < 0.5) {
      orbitSpeed *= -1;
    }

    planets.add(new Planet(orbitR, angle, radius, base, hasRing, moonCount, tilt, patternType, pSeed, orbitSpeed));
  }

  // Generate an asteroid belt around the galaxy core.
  asteroidBeltRadius = random(260, 360);
  int asteroidCount = int(random(180, 320));

  for (int i = 0; i < asteroidCount; i++) {
    float angle = random(TWO_PI);
    float r = asteroidBeltRadius + random(-22, 22);
    float s = random(1.5, 4.5);
    float speed = random(0.0008, 0.0025);

    if (random(1) < 0.5) {
      speed *= -1;
    }

    asteroids.add(new Asteroid(angle, r, s, speed));
  }

  // Generate one or two comets with random position, direction and tail length.
  int cometCount = int(random(1, 3));

  for (int i = 0; i < cometCount; i++) {
    float x = random(width * 0.15, width * 0.85);
    float y = random(height * 0.10, height * 0.65);
    float angle = random(-0.9, 0.9);
    float tailLength = random(120, 220);
    float headSize = random(10, 18);
    float localSeed = random(10000);
    float speed = random(0.4, 1.0);

    color cometColor;
    if (random(1) < 0.5) {
      cometColor = color(120, 220, 255);
    } else {
      cometColor = color(255, 220, 160);
    }

    comets.add(new Comet(x, y, angle, tailLength, headSize, cometColor, localSeed, speed));
  }
}

void keyPressed() {
  if (key == 'r' || key == 'R') {
    generateGalaxy();
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

  float timeOffset = frameCount * 0.002;

  for (int x = 0; x < width; x += 8) {
    for (int y = 0; y < height; y += 8) {
      float n = noise(x * 0.008, y * 0.008, seedValue * 0.0001 + timeOffset);

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

  float pulse = sin(frameCount * 0.035) * 10;

  for (int i = 180; i > 0; i -= 6) {
    float alpha = map(i, 180, 0, 8, 90);
    fill(255, 220, 170, alpha);
    ellipse(galaxyX, galaxyY, (i + pulse) * 2.0, (i + pulse) * 1.2);
  }

  for (int i = 90; i > 0; i -= 4) {
    float alpha = map(i, 90, 0, 10, 100);
    fill(255, 255, 220, alpha);
    ellipse(galaxyX, galaxyY, (i + pulse * 0.4) * 1.2, (i + pulse * 0.4) * 1.2);
  }
}

void drawStars() {
  for (Star s : stars) {
    s.display();
  }
}

void drawComets() {
  for (Comet c : comets) {
    c.update();
    c.display();
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
  float twinkleSpeed;
  float twinkleOffset;

  Star(float x, float y, float size, float alpha, boolean glow, float twinkleSpeed, float twinkleOffset) {
    this.x = x;
    this.y = y;
    this.size = size;
    this.alpha = alpha;
    this.glow = glow;
    this.twinkleSpeed = twinkleSpeed;
    this.twinkleOffset = twinkleOffset;
  }

  void display() {
    noStroke();

    float twinkle = map(sin(frameCount * twinkleSpeed + twinkleOffset), -1, 1, 0.55, 1.25);
    float currentAlpha = constrain(alpha * twinkle, 40, 255);
    float currentSize = size * twinkle;

    if (glow) {
      fill(255, currentAlpha * 0.18);
      ellipse(x, y, currentSize * 5, currentSize * 5);
    }

    fill(255, currentAlpha);
    ellipse(x, y, currentSize, currentSize);
  }
}

class Nebula {
  float x, y, radius;
  color c;
  int dots;
  float localSeed;
  float driftSpeed;

  Nebula(float x, float y, float radius, color c, int dots, float localSeed, float driftSpeed) {
    this.x = x;
    this.y = y;
    this.radius = radius;
    this.c = c;
    this.dots = dots;
    this.localSeed = localSeed;
    this.driftSpeed = driftSpeed;
  }

  void display() {
    randomSeed((int)localSeed);
    noStroke();

    float driftX = sin(frameCount * driftSpeed + localSeed) * 8;
    float driftY = cos(frameCount * driftSpeed + localSeed) * 5;

    for (int i = 0; i < dots; i++) {
      float angle = random(TWO_PI);
      float dist = radius * sqrt(random(1));
      float px = x + driftX + cos(angle) * dist;
      float py = y + driftY + sin(angle) * dist * 0.7;
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
  float orbitSpeed;

  Planet(float orbitRadius, float angle, float radius, color baseColor, boolean hasRing, int moonCount, float tilt, int patternType, float patternSeed, float orbitSpeed) {
    this.orbitRadius = orbitRadius;
    this.angle = angle;
    this.radius = radius;
    this.baseColor = baseColor;
    this.hasRing = hasRing;
    this.moonCount = moonCount;
    this.tilt = tilt;
    this.patternType = patternType;
    this.patternSeed = patternSeed;
    this.orbitSpeed = orbitSpeed;
  }

  void display() {
    float animatedAngle = angle + frameCount * orbitSpeed;

    float px = galaxyX + cos(animatedAngle) * orbitRadius;
    float py = galaxyY + sin(animatedAngle) * orbitRadius * 0.55;

    // Draw planet moons.
    for (int i = 0; i < moonCount; i++) {
      float ma = frameCount * 0.025 + TWO_PI * i / max(1, moonCount) + patternSeed * 0.001;
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
  float speed;

  Asteroid(float angle, float orbitRadius, float size, float speed) {
    this.angle = angle;
    this.orbitRadius = orbitRadius;
    this.size = size;
    this.speed = speed;
  }

  void display() {
    float animatedAngle = angle + frameCount * speed;

    float px = galaxyX + cos(animatedAngle) * orbitRadius;
    float py = galaxyY + sin(animatedAngle) * orbitRadius * 0.55;

    noStroke();
    fill(180, 160);
    ellipse(px, py, size, size * 0.8);
  }
}

class Comet {
  float x, y;
  float angle;
  float tailLength;
  float headSize;
  color cometColor;
  float localSeed;
  float speed;

  Comet(float x, float y, float angle, float tailLength, float headSize, color cometColor, float localSeed, float speed) {
    this.x = x;
    this.y = y;
    this.angle = angle;
    this.tailLength = tailLength;
    this.headSize = headSize;
    this.cometColor = cometColor;
    this.localSeed = localSeed;
    this.speed = speed;
  }

  void update() {
    x += cos(angle) * speed;
    y += sin(angle) * speed;

    // Wrap the comet around the screen to keep the animation continuous.
    if (x > width + tailLength) {
      x = -tailLength;
    }
    if (x < -tailLength) {
      x = width + tailLength;
    }
    if (y > height + tailLength) {
      y = -tailLength;
    }
    if (y < -tailLength) {
      y = height + tailLength;
    }
  }

  void display() {
    pushMatrix();
    translate(x, y);
    rotate(angle);

    randomSeed((int)localSeed);
    noStroke();

    // Draw the glowing tail using many transparent particles.
    int tailParticles = 45;

    for (int i = tailParticles; i >= 0; i--) {
      float t = i / float(tailParticles);

      float px = -t * tailLength;
      float py = random(-12, 12) * t;

      float particleSize = map(t, 0, 1, headSize * 0.7, headSize * 2.8);
      float alpha = map(t, 0, 1, 90, 0);

      fill(red(cometColor), green(cometColor), blue(cometColor), alpha);
      ellipse(px, py, particleSize, particleSize * 0.65);
    }

    // Draw the outer glow around the comet head.
    fill(red(cometColor), green(cometColor), blue(cometColor), 60);
    ellipse(0, 0, headSize * 4.0, headSize * 4.0);

    // Draw the bright comet head.
    fill(255, 240);
    ellipse(0, 0, headSize, headSize);

    fill(red(cometColor), green(cometColor), blue(cometColor), 160);
    ellipse(0, 0, headSize * 1.8, headSize * 1.8);

    popMatrix();
  }
}
'''

readme = '''# Generative Galaxy

## Overview

Generative Galaxy is an algorithmic visualization project created with Processing. The program generates a unique animated space scene containing stars, colorful nebula clouds, planets, orbital paths, a glowing galaxy core, an asteroid belt, and randomly generated comets.

The visualization is based on a generative approach. Random values are used to create different positions, sizes, colors, shapes, orbits, and visual compositions each time the scene is generated. The `noise()` function is also used to create a more organic cosmic dust effect.

The current version extends the project with animation. Stars twinkle, the galaxy core pulses, nebula clouds drift slightly, planets orbit around the galaxy core, asteroids move around the belt, and comets travel through the scene.

## Current Features

- Procedurally generated galaxy scene
- Random star field
- Animated twinkling stars
- Colorful drifting nebula clouds
- Glowing animated galaxy core
- Randomly generated planets
- Animated planetary orbits
- Planet rings
- Planet moons
- Planet surface patterns
- Orbital paths
- Animated asteroid belt
- Cosmic dust generated with `noise()`
- Randomly generated moving comets with glowing particle tails
- Screenshot saving functionality

## Controls

- Press `R` to generate a new galaxy.
- Press `S` to save the current visualization as a PNG image.

Saved screenshots are stored inside the `screenshots` folder.

## Software

This project was created with:

- Processing
- Java mode

## Project Purpose

The purpose of this project is to demonstrate algorithmic visualization through a generative approach. The generated images are not manually drawn. Instead, they are produced by algorithms that use randomness and procedural rules to create multiple unique versions of the same visual concept.

The project also demonstrates step-by-step development. The first version contained the main galaxy structure, the second version introduced randomly generated comets, and the current version adds animated activity to the generated galaxy.

## Screenshots Plan

The project should include at least six screenshots. The screenshots should demonstrate both the base version and the improved animated version of the visualization:

1. Initial generated galaxy from the first version
2. Regenerated galaxy after pressing `R` in the first version
3. Extended galaxy version with comet effect
4. Regenerated galaxy version with comet effect
5. Animated galaxy state after a few seconds
6. Another animated galaxy state after pressing `R` or waiting a few more seconds

More screenshots may be added as the project is extended with additional visual elements.

## Suggested Commit History

A clean GitHub history for the project may look like this:

1. `Initial generative galaxy version`
2. `Add comet effect`
3. `Add animated galaxy activity`

## Planned Improvements

Future versions may include:

- Falling stars
- More detailed planets
- Additional glow effects
- Improved galaxy composition
- Black hole effect

## Author

Course project for algorithmic visualization through a generative approach.
'''

base = Path("/mnt/data/generative_galaxy_v3")
base.mkdir(exist_ok=True)

pde_path = base / "GenerativeGalaxy.pde"
readme_path = base / "README.md"

pde_path.write_text(code, encoding="utf-8")
readme_path.write_text(readme, encoding="utf-8")

print(f"Created: {pde_path}")
print(f"Created: {readme_path}")
