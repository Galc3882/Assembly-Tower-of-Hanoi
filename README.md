# Assembly Tower of Hanoi

## Introduction
This project implements the classic game of Tower of Hanoi in Assembly language, along with a solver to find the optimal solution to the puzzle. The Tower of Hanoi is a mathematical game that consists of three rods and a number of disks of different sizes, which can slide onto any rod. The objective of the puzzle is to move the entire stack to another rod, obeying the following simple rules:
- Only one disk can be moved at a time.
- Each move consists of taking the upper disk from one of the stacks and placing it on top of another stack or an empty rod.
- No disk may be placed on top of a smaller disk.

The game can be played interactively, or the solver can be run to determine the optimal solution.

## Table of Contents
- [Explanation of project/technology and code](#explanation-of-projecttechnology-and-code)
- [Examples](#examples)
- [Requirements and file architecture](#requirements-and-file-architecture)
- [Next steps](#next-steps)

## Explanation of project/technology and code
The Tower of Hanoi game is implemented using Assembly language, specifically the x86 architecture. The code is split into multiple files:
- h.asm: the main file that contains the code for the game and solver.
- dseg.h: header file that contains declarations for the data segment.
- drawB.h: header file that contains functions for drawing the game board.

The game is played by moving disks from one rod to another, as described in the Introduction. The solver uses a recursive algorithm to determine the optimal solution for any number of disks.

## Examples
To play the game interactively, run the h.exe file.
![image](https://user-images.githubusercontent.com/86870298/124348869-29d18700-dbf5-11eb-865c-ddcbdcbf8a5f.png)
![image](https://user-images.githubusercontent.com/86870298/124348880-30f89500-dbf5-11eb-904b-1e390eb7a4ab.png)
![image](https://user-images.githubusercontent.com/86870298/124348884-35bd4900-dbf5-11eb-9826-058b31f3b084.png)
![image](https://user-images.githubusercontent.com/86870298/124348888-3a81fd00-dbf5-11eb-8d63-83464ae59210.png)


## Requirements and file architecture
The only requirement for this project is a system capable of running x86 Assembly code. The file architecture is as follows:
```
├── README.md
├── h.asm
├── h.obj
├── h.exe
├── dseg.h
├── drawB.h
```

## Next steps
- [ ] Add more advanced graphics to the game.
- [ ] Improve the solver algorithm to handle larger numbers of disks.
