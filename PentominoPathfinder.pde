import java.math.BigDecimal;
import java.text.DecimalFormat;
import java.util.Iterator; 
import java.util.LinkedList; 
import java.util.Queue;

// Board size, edit these to change the board size, WARNING! non square boards have not been tested
static int boardX = 7;
static int boardY = 7;
static int maxPieceCount = 3;
static int threadCount = Runtime.getRuntime().availableProcessors(); // Remove this and set to '1' to disable multithreading

// Enables the animation of the flood algorithm, used for debugging
boolean showAnim = false;

// Color correction, this multiplies the hue of the pentominos, only affects the visuals
int cc1 = 50;

// Color correction, this multiplies the color of the biggest flood, only affects the visuals
int cc2 = 5;

long timerStart = 0;
Queue<LayoutData> topLayouts = new LinkedList<LayoutData>();

public static Queue<LayoutData> bestLayouts = new LinkedList<LayoutData>();
public static byte[][] bestBoard;
public static byte[][] bestDepth;
public static int bestScore;
public static int bestScoreThreads;

void setup() {  
  size(1024, 1024); 
  
  bestBoard = new byte[boardX][boardY];
  bestDepth = new byte[boardX][boardY];
  
  setupMinesweeper();
  runMinesweeper();
}

void startTimer() {
  timerStart = System.nanoTime();
}

void endTimer(String message) {
  double t = NanoToMillis(System.nanoTime() - timerStart);
  DecimalFormat df = new DecimalFormat("#");
  df.setMaximumFractionDigits(100);
  println(df.format(t) + message);
}

double NanoToMillis(long nano) {
  return ((double)nano) / 1000000;
}

int skips = 0;

void draw() { 
 
  /*
  int size = bestBoard[0].length;
  int cellSize = height / size;
  int mx = floor(mouseX / cellSize);
  int my = floor(mouseY / cellSize);
  rect(mx * cellSize, my * cellSize, cellSize, cellSize); 
  */
  
  
 
  
  
  
  if (frameCount % 50 != 0) {
    return;
  } 
  
  background(0);
  
  int size = bestBoard[0].length;
  int cellSize = height / size;
  /*
  int sk = skips;
  
  int bl = newPieces.length;
  for (int b = 0; b < bl; b++) {
     
    int cl = newPieces[b].length;
    for (int c = 0; c < cl; c++) {
      
      
      if (sk > 0) {
        sk--;
        continue;
      }
      
      int dl = newPieces[b][c].length;
      for (int d = 0; d < dl; d += 2) {
        int x = newPieces[b][c][d] + 4;
        int y = newPieces[b][c][d + 1] + 4;
  
        colorMode(HSB, 255);
        fill(255, 128, 128);
        stroke(0);
        strokeWeight(2);
        rect(x * cellSize, y * cellSize, cellSize, cellSize);      
      }
      
      int el = bounds[b][c].length;
      for (int e = 0; e < el; e += 2) {
        int x = bounds[b][c][e] + 4;
        int y = bounds[b][c][e + 1] + 4;
  
        colorMode(HSB, 255);
        fill(255, 128, 128);
        stroke(0);
        strokeWeight(2);
        rect(x * cellSize + 5, y * cellSize + 5, cellSize - 10, cellSize - 10);      
      }
      
      return;
    }
  }
  */
  /*
  int iter = 100;
  
  for (int k = 0; k < iter; k++) {
    for (int i = 0; i < layouts.size(); i++) {
      layouts.get(i).run();
    }
    
    
  }
  */
  while (bestLayouts.size() > 0) {
    LayoutData data = bestLayouts.poll();
    
    if (data.score > bestScore) {
      bestBoard = data.board;
      bestDepth = data.depth;
      bestScore = data.score;
      
      topLayouts.add(data);
      
      if (topLayouts.size() > 10) {
        topLayouts.remove();
      }
    }
  }
    
  if (bestBoard == null) {
    return;
  }
  
  for (int x = 0; x < boardX; x++) {
    for (int y = 0; y < boardY; y++) {
      if (bestBoard[x][y] < 1) {
        continue;
      }
      
      colorMode(HSB, pieceCount());
      fill(bestBoard[x][y] - 1, pieceCount() / 2, pieceCount() / 2);
      rect(x * cellSize, y * cellSize, cellSize, cellSize);
    }
  }
  
  for (int x = 0; x < boardX; x++) {
    for (int y = 0; y < boardY; y++) {
      if (bestDepth[x][y] == 0) {
        continue;
      }     
      
      colorMode(RGB, 255);
      fill(bestDepth[x][y] * cc2, bestDepth[x][y] * cc2, bestDepth[x][y] * cc2);
      rect(x * cellSize, y * cellSize, cellSize, cellSize);
    }
  }
  /*
  // Get draw parameters
  int size = board[0].length;
  int cellSize = height / size;
  
  pieceIndex = 3;
  
  
  if (frameCount % 100 == 0) {
    //allQbits[qBitIndex].use(false);
    //qBitIndex = (qBitIndex + 1) % allQbits.length;
    //allQbits[qBitIndex].use(true);
  }
  
  // Draw pieces
  for (int x = 0; x < size; x++) {
    for (int y = 0; y < size; y++) {
      if (board[x][y] == 0) {
        continue;
      }
      
      colorMode(HSB, 255);
      fill(board[x][y] * cc1, 128, 128);
      rect(x * cellSize, y * cellSize, cellSize, cellSize);
    }
  }
   
  // Draw path
  for (int x = 0; x < size; x++) {
    for (int y = 0; y < size; y++) {
      if (depth[x][y] == 0) {
        continue;
      }     
      
      colorMode(RGB, 255);
      fill(depth[x][y] * cc2, depth[x][y] * cc2, depth[x][y] * cc2);
      rect(x * cellSize, y * cellSize, cellSize, cellSize);
    }
  }
  
  if (showAnim) {
    if (frameCount % 15 == 0) {
      animIndex = (animIndex + 1) % animation.size();
    }
    
    Node node = animation.get(animIndex);
    colorMode(RGB, 255);
    fill(255);
    rect(node.x * cellSize + 5, node.y * cellSize + 5, cellSize - 10, cellSize - 10);
  }
  */
}
