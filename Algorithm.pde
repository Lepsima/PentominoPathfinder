
void solve() {
  // Clear all the arrays
  pieceIndex = 1;
  board = new byte[boardX][boardY];
  path = new byte[boardX][boardY];
  used = new ArrayList<Byte>();

  int hardPieceLimit = 4;

  for (int x = 0; x < boardX; x++) {
    for (int y = 0; y < boardY; y++) {
      
      // Try place every single piece in this position, place the first one found
      tryPlace(x, y);
      
      // Stop if the piece limit was reached
      if (pieceIndex > hardPieceLimit) {
        break;
      }
    }
    
    // Stop if the piece limit was reached
    if (pieceIndex > hardPieceLimit) {
      break;
    }
  }
  
  calculateShortestPath();
}
