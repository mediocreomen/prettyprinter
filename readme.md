# prettyprinter
A GUI application for displaying KenKen puzzles gotten from kenkenpuzzle.com

This application is written in [Processing 4.3](https://processing.org/), though it should work with Processing 3 if that is already installed in your system.

## Executing the program
If you are on **Windows**, you will have to run the prettyprinter.pde file through the Processing 3/4 IDE. (Which can be downloaded from https://processing.org/ if you do not have it)

If you are on **Linux/UNIX**, you can unzip the linux-amd64.7z file to get an executable version of the program along with the needed source code. If that fails, try running it through the Processing IDE like you would with Windows.

*(NOTE: I would have included a compiled version for Windows, but the filesize was very big and GitHub refused to store it. If you wish, you can Export a Windows version from the Processing IDE yourself)*

## Getting KenKen JSON files
I have included a shell script, fetch, that was provided by my professor to obtain puzzle JSON files from kenkenpuzzle.com. Simply run the program as follows in a bash terminal to get a puzzle JSON file.
`./fetch.sh <puzzle id> > <output_file>`

## Using prettyprinter
When you open prettyprinter, you will see an empty square window pop up and be promted to select a JSON file with a file selection window. Select the JSON file you wish to use and the puzzle it represents should be displayed in the once empty window.

### Keyboard Controls
'A' - Toggle (A)nswer
'S' - Open (S)ave prompt (Image will be saved as .png exactly how it is shown on screen)

## Credits
- Made with [Processing 4.3](https://processing.org/), an open source project
- fetch.sh provided by Bruce Kapron