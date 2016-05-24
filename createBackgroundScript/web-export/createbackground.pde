PImage[] img = new PImage[64];

void setup() {
  int padding = 10;
  int imageWidth = 300;
  
  size(6000, 9000);
  background(0);
  
  for(int i = 0; i < img.length; i++) {
    int num = i+1;
    img[i] = loadImage("tile " + num + ".png");
  }
  
  for(int x = 0; x < 20; x++) {
    for(int y = 0; y < 30; y++) {
      image(img[int(random(img.length))], x*imageWidth, y*imageWidth);
    }
  }
  saveFrame();
}

