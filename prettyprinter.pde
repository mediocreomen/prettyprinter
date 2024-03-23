// prettyprinter - A JSON to KenKen puzzle program

void setup() {
  // Get file from filesystem as input
  size(600, 600);
  background(255);
  selectInput("Select a JSON KenKen file", "JSONFileSelected");
  noLoop();
}

// FUN FACT: size() has to be the first line of code in your program, even before variable definitions. Isn't that wonderful...

float cell_size = 0;
int cell_margin = 50;
boolean ready_to_draw = false;
boolean ready_to_save = false;

JSONObject puzzle_data;
String[] puzzle_answers;
String[] puzzle_symbols;
String[] puzzle_quants;
String[] vertical_bars;
String[] horizontal_bars;
boolean draw_answers = false;

String[] get_substrings_until(String input, int from_pos, int amount) {
  // Returns an array of integers made up of all seperate ints from the given input string
  
  String[] output = new String[0];
  int subs_gotten = 0;
  int pos = from_pos;
  char buffer[] = new char[0]; // Assuming there is never going to be an int larger than 99999 in one of these puzzles (which I hope is the case)
  char cur_char = ' ';
  boolean reading_substring = false;
  
  // DO THE THING!!
  while ((subs_gotten < amount) && (pos < input.length())) {
    
    // Read the current char
    cur_char = input.charAt(pos);
    
    // If this character is whitespace, keep seeking
    if ((cur_char == ' ') || (cur_char == '\n') || (cur_char == '\r')) {
      
      // End this string if we were reading a string
      if (reading_substring) {
        reading_substring = false;
        output = append(output, new String(buffer));
        buffer = new char[0];
        subs_gotten += 1;
      }
      // else, Continue, we don't care
      
    } else {
      
      // Get this substring and continue, increasing the amount of substrings we have gotten by one
      reading_substring = true;
      buffer = append(buffer, cur_char);
    }
    
    pos = pos + 1;
    
  }
  
  
  return output;
}

void JSONFileSelected(File file_pos) {
  // Called after a file is selected from call in in setup()
  
  String file_string = new String();
  
  if (file_pos == null) {
    println("Prompt was closed, terminating");
    exit();
  } else {
    file_string = new String(loadBytes(file_pos.getAbsolutePath()));
  }
  
  puzzle_data = parseJSONObject(file_string);
  if (puzzle_data == null) {
    println("JSONObject could not be parsed, terminating");
    exit();
  }
  
  // JSON loaded fine, lets start getting this puzzle processed and then drawn!
  
  // Get puzzle size
  int puzzle_size = puzzle_data.getInt("size");
  
  //Parse data field
  int start_index = 0;
  
  // Answers
  start_index = puzzle_data.getString("data").indexOf("A");
  if (start_index == -1) {
    println("BAD DATA STRING: Terminating");
    exit();
  }
  puzzle_answers = get_substrings_until(puzzle_data.getString("data"), start_index + 1, puzzle_size * puzzle_size);
  
  // quanTifiers
  start_index = puzzle_data.getString("data").indexOf("T");
  if (start_index == -1) {
    println("BAD DATA STRING: Terminating");
    exit();
  }
  puzzle_quants = get_substrings_until(puzzle_data.getString("data"), start_index + 1, puzzle_size * puzzle_size);
  
  // Symbols
  start_index = puzzle_data.getString("data").indexOf("S");
  if (start_index == -1) {
    println("BAD DATA STRING: Terminating");
    exit();
  }
  puzzle_symbols = get_substrings_until(puzzle_data.getString("data"), start_index + 1, puzzle_size * puzzle_size);
  
  // Horizontal lines
  start_index = puzzle_data.getString("data").indexOf("H");
  if (start_index == -1) {
    println("BAD DATA STRING: Terminating");
    exit();
  }
  horizontal_bars = get_substrings_until(puzzle_data.getString("data"), start_index + 1, puzzle_size * (puzzle_size - 1));
  
  // Vertical lines
  start_index = puzzle_data.getString("data").indexOf("V");
  if (start_index == -1) {
    println("BAD DATA STRING: Terminating");
    exit();
  }
  vertical_bars = get_substrings_until(puzzle_data.getString("data"), start_index + 1, puzzle_size * (puzzle_size - 1));
  
  // Pre-processing done, time to draw it
  
  ready_to_draw = true;
  redraw();
}

void draw() {
  
  // Reset it all!
  fill(255);
  stroke(255);
  rect(0,0,600,600);
  ready_to_save = false;
  
  // Draw backing grid of cells
  // Make light gray
  strokeWeight(1);
  stroke(50);
  
  if (ready_to_draw == false) {return;}
  
  // Get puzzle size and make window size out of that
  int puzzle_size = puzzle_data.getInt("size");
  cell_size = ((600 - (cell_margin * 2)) / puzzle_size);
  
  // Draw backing grid
  for (int x = 0; x <= puzzle_size; x = x + 1) {
    line((x * cell_size) + cell_margin, cell_margin, (x * cell_size) + cell_margin, (puzzle_size * cell_size) + cell_margin);
  }
  for (int y = 0; y <= puzzle_size; y = y + 1) {
    line(cell_margin, (y * cell_size) + cell_margin, (puzzle_size * cell_size) + cell_margin, (y * cell_size) + cell_margin);
  }
  
  // Draw outside square in thicker lines
  strokeWeight(4);
  stroke(0);
  line(cell_margin, cell_margin, cell_margin, (puzzle_size * cell_size) + cell_margin);
  line(cell_margin, cell_margin, (puzzle_size * cell_size) + cell_margin, cell_margin);
  line((puzzle_size * cell_size) + cell_margin, (puzzle_size * cell_size) + cell_margin, (puzzle_size * cell_size) + cell_margin, cell_margin);
  line((puzzle_size * cell_size) + cell_margin, (puzzle_size * cell_size) + cell_margin, cell_margin, (puzzle_size * cell_size) + cell_margin);
  
  // Draw rule text (+1, 3, etc.)
  textAlign(LEFT, TOP);
  if (puzzle_size < 6) {
    textSize(20);
  }
  else {
    textSize(16);
  }
  fill(50);
  
  String symbol = "";
  
  for (int x = 0; x < puzzle_size; x = x + 1) {
    for (int y = 0; y < puzzle_size; y = y + 1) {
      // If quant is zero we draw nothing
      
      if (puzzle_quants[(x % puzzle_size) + (y * puzzle_size)].equals("0")) {}
      else {
        
        // Dont print constant indicators
        if (puzzle_symbols[(x % puzzle_size) + (y * puzzle_size)].equals("1")) {symbol = "";} else {symbol = puzzle_symbols[(x % puzzle_size) + (y * puzzle_size)];}
        text(puzzle_quants[(x % puzzle_size) + (y * puzzle_size)] + symbol, 5 + cell_margin + (cell_size * x), 5 + cell_margin + (cell_size * y));
      }
    }
  }
  
  // Draw vertical and horizontal lines (oh boy, this is going to be fun)
  
  // Horizontal
  for (int x = 0; x <= puzzle_size - 1; x = x + 1) { // Iterate over x puzzle_size times
    for (int y = 0; y < puzzle_size - 1; y = y + 1) { // Iterate over y puzzle_size-1 times
      if (horizontal_bars[(x * (puzzle_size - 1)) + y].equals("0")) {} else {
        line((x * cell_size) + cell_margin, ((y+1) * cell_size) + cell_margin, ((x+1) * cell_size) + cell_margin, ((y+1) * cell_size) + cell_margin);
      }
    }
  }
  
  // Vertical
  for (int y = 0; y <= puzzle_size - 1; y = y + 1) { // Iterate over x puzzle_size times
    for (int x = 0; x < puzzle_size - 1; x = x + 1) { // Iterate over y puzzle_size-1 times
      if (vertical_bars[(y * (puzzle_size - 1)) + x].equals("0")) {} else {
        line(((x+1) * cell_size) + cell_margin, (y * cell_size) + cell_margin, ((x+1) * cell_size) + cell_margin, ((y+1) * cell_size) + cell_margin);
      }
    }
  }
  
  textAlign(CENTER, CENTER);
  fill(100,0,0);
  if (puzzle_size <= 5) {
    textSize(56);
  }
  else {
    textSize(36);
  }
  
  // Draw answers (only if setting is toggled)
  if (draw_answers) {
    for (int x = 0; x < puzzle_size; x = x + 1) {
      for (int y = 0; y < puzzle_size; y = y + 1) {
        //Draw solution in middle of cell
        text(puzzle_answers[(x % puzzle_size) + (y * puzzle_size)], cell_margin + (cell_size * x) + (cell_size / 2), cell_margin + (cell_size * y) + (cell_size / 2));
      }
    }
  }
  
  // Ready to save now, image is done!
  ready_to_save = true;
  
}

void keyPressed() {
  // Called whenever a key is pressed
  // Used to toggle the answer showing or not
  
  if ((key == 'a') || (key == 'A')) {
    draw_answers = ! draw_answers;
    redraw();
  }
  
  if ((key == 's') || (key == 'S')) {
    selectOutput("Select a file to save this image as: (saved as .png)", "saveImage");
  }
}

void saveImage(File savefile) {
  // Called when the user wants to save an image
  
  // Only let this be called if there is a fully drawn image
  if (savefile != null) {
  get().save(savefile + ".png");
  }
  
}
