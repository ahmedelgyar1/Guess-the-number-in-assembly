![](/photo_project/Untitled_design.png)
# Guess the number
 "Guess the Number" is an interactive game implemented in x86 Assembly Language using emu 8086. It challenges the user to think algorithmically as the program attempts to guess a number chosen by the user using the [binary search algorithm](https://www.geeksforgeeks.org/binary-search/).

 # Features
 - Binary Search Algorithm:
   The program implements a binary search to guess the user's chosen number efficiently.
It narrows down the range of possible numbers using comparisons (min, max, and mid values).

- Custom Input Handling:
A PROC to read user input ensures robust number entry and allows dynamic inputs,
Input validation ensures only positive numbers are accepted and right inputs.

- Time efficiency:
  We use in our project an Efficient algorithm with logarithmic time complexity O(logn).
  and it's better than the normal liner search the takes O(n).

  # challenges
  - Reading Numbers:
      Creating a reusable input procedure (PROC) for reading numbers from the user was difficult because:
          1-The program had to read multi-digit numbers character by character.
          2-Converting ASCII characters into a numerical value required precise handling of each digit while avoiding overflow.
          3-Ensuring the procedure worked correctly across different inputs, like leading zeros or invalid characters, added further complexity.
  - Outputting Numbers:
        Displaying numbers involved reversing the process:
            1-Dividing the number by 10 repeatedly to extract digits in reverse order.
            2-Storing and then printing digits in the correct sequence was a meticulous task in assembly, especially while avoiding unnecessary memory usage

  - Maximizing Time Efficiency:
      Implementing the binary search algorithm in assembly was conceptually straightforward, but optimizing it for time efficiency was challenging with such a low programming language using memory access and manageing registers.

# Examples
![](/photo2_project/0_riJmHbxu2CZlF6Ad.png)
