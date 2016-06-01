PImage[] img = new PImage[16];

void setup() {
  int padding = 5;
  int imageWidth = 295;
  
  size(3300, 6000);
  background(0);
  
  for(int i = 0; i < img.length; i++) {
    int num = i+1;
    img[i] = loadImage("tile " + num + ".png");
  }
  
  for(int x = 0; x < 11; x++) {
    for(int y = 0; y < 15; y++) {
      image(img[int(random(img.length))], x*imageWidth, y*imageWidth);
    }
  }
  saveFrame();
}
