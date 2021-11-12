# Phase 5 Fix the String DS&A Assessment: Instructor Resources

## General Guidelines

Below is some general guidance to help you in scoring a student's Assessment.
Note that these guidelines are provided as a resource — the score to be awarded
is ultimately up to your judgment.

| Score | Criteria |
| :-: | --- |
| 5 | Solution works; code is clean and understandable; solution has been optimized for space/time efficiency; helper methods may be implemented |
| 3 | The student submitted a working solution, but the code needs refactoring or optimization |
| 1 | The solution does not work |

## Specific Guidelines for Fix the String

Below are a few different ways students may approach this challenge, along with
the complexity information for each.

### Comparing Adjacent Characters

In their solution, students can use either of the following approaches for
comparing each adjacent pair of characters.

```rb
# Ruby upcase (or downcase) method:
str[i] != str[i+1] && str[i].upcase == str[i+1].upcase

# Ascii math:
(str[i].ord - str[i+1].ord).abs != 32
```

### Sample Solutions

#### Stack solution

```rb
def fix_the_string(str)
  stack = []
  result = ''
  str.each_char do |char|
    if stack.size.zero? || (char.ord - stack[stack.size - 1].ord).abs != 32 
      stack.push(char)
    else
      stack.pop
    end
  end

  while stack.size.positive?
    result = stack.pop + result
    num_steps += 1
  end

  result
end
```

Complexity:

- Time: O(n)
- Space : O(n)

#### In-place Solution Using Nested Loops

```rb
def fix_the_string(str)
    continue = true
    while continue
        continue = false
        (0...str.size-1).each do |i|
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

Complexity:

- Time: O(n)
- Space : O(n)

#### In-place Solution Using `slice!`

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

Complexity:

- Time: O(n)
- Space : O(1)

#### In-place Solution using Two Pointers

```rb
def fix_the_string(str)
  p = 0
  i = 0
  while i < str.size
    if p > 0 && (str[i].ord - str[p - 1].ord).abs == 32
      p -= 1
    else
      str[p] = str[i]
      p += 1
    end
    i += 1
  end
  str[0..p-1]
end
```

Complexity:

- Time: O(n)
- Space : O(1)
