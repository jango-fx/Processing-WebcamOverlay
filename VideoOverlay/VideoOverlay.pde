import controlP5.*;
import processing.video.*;
Capture video;
ControlP5 cp5;

PGraphics pg;
PGraphics m;
PImage mask;
float f = 0.5;

javax.swing.JFrame frame;
javax.swing.JPanel panel;

void setup() {
  fullScreen();
  surface.setSize(200, 200); //Change size here
  surface.setAlwaysOnTop(true);
  surface.setLocation(displayWidth-220, displayHeight-220);
  frame = (javax.swing.JFrame)((processing.awt.PSurfaceAWT.SmoothCanvas) getSurface().getNative()).getFrame();
  frame.removeNotify();
  frame.setUndecorated(true);
  frame.setLayout(null);
  frame.addNotify();

  pg = createGraphics(width, height);


  javax.swing.JPanel panel = new javax.swing.JPanel() {
    @Override
      protected void paintComponent(java.awt.Graphics graphics) {
      if (graphics instanceof java.awt.Graphics2D) {
        java.awt.Graphics2D g2d = (java.awt.Graphics2D) graphics;
        g2d.drawImage(pg.image, 0, 0, null);
      }
    }
  };

  frame.setContentPane(panel);

  printArray(Capture.list());
  video = new Capture(this, "FaceTime HD-Kamera (integriert)");
  video.start();

  //mask = createImage(width, height, ALPHA);
  m = createGraphics(width, height);
  m.beginDraw();
  m.background(0);
  m.noStroke();
  m.fill(255);
  m.ellipse(width/2, height/2, width, height);
  m.endDraw();
  m.getImage();
}

void draw() {
  if (video.available()) {
    video.read();
  }

  PImage mask = m.get();

  PImage img = video.copy(); // Get Video Frame
  img = img.get(int(video.width/2-(width/2)/f), int(video.height/2-(height/2)/f), int(width/f), int(height/f));
  img.resize(width, height);
  img.mask(mask);


  pg.beginDraw();
  pg.background(img);
  //pg.fill(0, 153, 204, frameCount%255);  
  //pg.ellipse(frameCount%width, frameCount%height, 60, 60);
  pg.endDraw();

  frame.setBackground(new java.awt.Color(0, 0, 0, 0));
}
