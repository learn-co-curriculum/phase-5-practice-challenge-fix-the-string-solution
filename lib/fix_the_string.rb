def bad_pair?(char1, char2)
  char1 != char2 && char1.upcase == char2.upcase
end

def fix_the_string(str)
  i = 0
  while i < str.size - 1 && !str.empty?
    if bad_pair?(str[i], str[i + 1])
      str.slice!(i..i + 1)
      i = 0
    else
      i += 1
    end
  end
  str
end
