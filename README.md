# Phase 5 Fix the String Practice Challenge: Solution

## Scoring Criteria (include?)

While these practice challenges are not scored, the following general guidance
is provided to help you to evaluate your solution.

| Score | Criteria |
| :-: | --- |
| 5 | Solution works; code is clean and understandable; solution has been optimized for space/time efficiency; helper methods may be implemented |
| 3 | The solution works, but the code needs refactoring or optimization |
| 1 | The solution does not work |

## Solutions

Several possible approaches to this problem are provided below, along with their
complexity information.

### Comparing Adjacent Characters

In this challenge, you needed to compare adjacent characters. In the solutions
given below, either approach can be substituted for the other.

The first approach uses Ruby methods; either `upcase` or `downcase` can be used:

```rb
# Ruby upcase (or downcase) method:
str[i] != str[i+1] && str[i].upcase == str[i+1].upcase
```

The second approach uses ASCII math, along with the Ruby `#ord` method, which
returns the numeric ASCII value of a character. See the [ASCII
table][ascii_table] for more info.

```rb
# ASCII math
(str[i].ord - str[i+1].ord).abs != 32
```

### Sample #1: Stack solution

In this solution, we're using the stack to hold characters that aren't "bad". We
iterate through the string and, for each character, compare it the top element
in the stack. If the comparison is "good", we add the character to the stack;
otherwise, we pop the top element off the stack and continue. In this way, we
can compare characters that are newly adjacent (i.e., one or more pairs of "bad"
characters between them have been removed) without iterating through the string
multiple times.

After the iteration is finished, we pop each element off the stack in turn, add
it to our result string, and return that value.

```rb
def fix_the_string(str)
  stack = []
  result = ''
  # Iterate through the string, adding the "good" characters to the stack
  str.each_char do |char|
    if stack.size.zero? || (char.ord - stack[stack.size - 1].ord).abs != 32 
      stack.push(char)
    else
      stack.pop
    end
  end

  # Pop each element off the stack and add it to the result string
  while stack.size.positive?
    result = stack.pop + result
    num_steps += 1
  end

  result
end
```

#### Complexity

```text
Time: O(n)
Space: O(n)
```

Time: The time complexity for both iterating through the string and popping
elements off the stack is O(n), giving us O(2n), which simplifies to O(n).

Space: We create a stack variable to hold the "good" characters and a string
variable to hold the result. In the worst case — no "bad" characters found —
they will both wind up holding all of the characters. This gives a complexity of
O(n) for each or O(2n) total, which reduces to O(n).

### Sample #2: In-place Solution Using Nested Loops

This solution and the ones that follow use what is called an "in-place"
solution. In other words, the input string is manipulated as you go through the
iteration.

Here we use the outer `while` loop to keep iterating as long as changes are
being made to the string. The inner loop iterates through the characters of the
string, identifies adjacent characters to be removed, and updates the string. It
also resets `continue` to `true` so the while loop will continue. The `break`
breaks out of the inner loop so we're back in the outer loop, which then
restarts the inner loop with the new value of `str`.

Once `str` contains no adjacent "bad" characters, the code inside the `if`
statement will not execute and the `while` loop will end.

```rb
def fix_the_string(str)
    continue = true
    while continue
        continue = false
        (0...str.size-1).each do |i|
            # If a pair of "bad" characters is found, remove them from the string,
            # update the boolean to continue the outer loop, and end the inner loop
            if (str[i] != str[i+1]) && (str[i].upcase == str[i+1].upcase)
                str = str[0...i] + str[i+2..-1]
                continue = true
                break
            end
        end
    end
    str
end
```

#### Complexity

- Time: see below
- Space : O(1)

Time: Given that this solution uses nested loops, you might expect the time
complexity to be O(n²). However, because the string is being modified "in
place", the actual number of steps required would never reach n². For our
purposes, it is enough to know that the time complexity will fall somewhere
between O(n) and O(n²). However, for those who are interested, there is a more
complete discussion at the bottom of the page.

Space: The only extra variable we are using here is `i`, which does not grow
with the size of the input. Therefore, the space complexity is O(1).

### Sample #3: In-place Solution Using `slice!`

This solution is basically the same as the one above, but instead of explicitly
using a second loop, it manipulates the value of the counter variable, `i`. The
end result is the same in terms of complexity.

If a pair of characters is removed, `i` is reset to `0` so that, in the next
iteration of the loop, the string is checked from the beginning again. This
ensures that newly adjacent "bad" characters are found. Otherwise, `i` is
incremented and the loop continues.

The loop ends if either `i` reaches the end of the string or if all the
characters have been removed from the string.

```rb
def fix_the_string(str)
  return str if str.size < 2

  i = 0
  continue = true
  while continue
    if str[i] != str[i+1] && str[i].upcase == str[i+1].upcase
      str.slice!(i..i+1)
      i = 0
    else 
      i += 1
    end
    continue = false if i == str.size - 1 || str.size.zero?
  end
  str
end
```

#### Complexity

See discussion for Sample #2

### **Challenging** Sample #4: In-place Solution using Two Pointers

This solution uses a "two-pointer" approach. The first pointer (`i`) is simply
used to iterate through the input string. Modifications are made to the string
as we go, "behind" `i`, to overwrite "bad" characters.

The second pointer, `p`, keeps track of where we are in the modified version of
the string, i.e., the location where the last "good" character is. `p` is only
advanced if we know the current character is good, and "bad" characters are
overwritten at the location of `p`. This ensures that everything up to `p` is
good and should be returned at the end of the method.

Note that we aren't removing characters as we go, so the string will still be
its original length by the end of the method. We use `p` to return just the
portion of the string we know is good.

```rb
def fix_the_string(str)
  p = 0
  i = 0
  while i < str.size
    # If we find a pair that needs to be removed, we want to "back up" p and not include
    # the current character in the modified version of the string
    if p > 0 && (str[i].ord - str[p - 1].ord).abs == 32
      p -= 1
    else
      # otherwise, we set the character at p to the "good" character at the current value of i
      str[p] = str[i]
      p += 1
    end
    i += 1
  end
  # We return the portion of the string up to p - 1, the location of the last "good" character
  str[0..p-1]
end
```

#### Complexity

```text
Time: O(n)
Space: O(n)
```

Time: We just have a single iteration through the string, which gives complexity
of O(n)

Space: The only extra variable we are using here is `i`, which does not grow
with the size of the input. Therefore, the space complexity is O(1).

## Optional: Discussion of Time Complexity for Samples #2 and #3

The outer loop for this solution will only execute once if the string is already
good. If there are "bad" pairs, it will execute one additional time for each
pair found. Therefore, in the worst case, the number of times the outer loop
will run is n/2 + 1, since a string of length n can only have n/2 matching
pairs.

For example, given the string `aAbBcCdDeE`, the loop will execute 6 times. (In
the last iteration, all that will happen is the boolean value will be updated to
end the loop).

Within each outer loop, the inner loop will execute until the first "bad" pair
is found. Once that happens, the inner loop is "short-circuited". If the first
"bad" pair is at the front of the string, it will only execute once in that
iteration of the outer loop.

For example, given the same string, `aAbBcCdDeE`, the inner loop will execute
once for each iteration through the outer loop except the last one, for a total
of 5.

The worst case scenario would be something like the following:
`abcdefghHGFEDCBA`. This string contains the maximum possible number of matches,
so the outer loop will execute the maximum number of times (n/2 = 8). For the
inner loop, given that all the characters are part of a "bad" pair, the inner
loop has to go the maximum possible distance to find each match: m/2, where m is
the current length of the string. This breaks down to the following:

| Outer Loop | m | Inner Loop steps (m/2) |
| :-: | :-: | :-: |
| 1 | 16 | 8 |
| 2 | 14 | 7 |
| 3 | 12 | 6 |
| 4 | 10 | 5 |
| 5 | 8 | 4 |
| 6 | 6 | 3 |
| 7 | 4 | 2 |
| 8 | 2 | 1 |

The total number of steps, therefore, is:

```text
8 + 7 + 6 ... + 1 = 36
```

This value is what's known as the [Triangular Number][triangular-number],
T<sub>n</sub>. In this case, we are calculating it based on n/2, so the actual
worst-case time complexity would be O(T<sub>n/2</sub>). This value is greater
than O(n) but well short of O(n²).

[ascii_table]: https://theasciicode.com.ar/
[triangular-number]: https://en.wikipedia.org/wiki/Triangular_number
