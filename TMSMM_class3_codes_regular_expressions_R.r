

# Load the necessary packages
library(tidyverse)
library(stringr)



# 1. Character variable ----


# Quotation marks - in R there is no difference in behaviour for:
# double quotes ""
# single quotes ''


text <- "String"
text_nested <- 'Single quotation mark with "nested" double quotation'

# When a quote is not closed - press ESC to avoid error
# quote1 <- "" "
# quote2 <- '' '


# How to include a single quotation mark inside a character variable


# a) nesting
one_quote_single <- "'"

one_quote_double <- '"'

one_quote_double
# b) using backslash
one_quote_single <- '\' '
one_quote_double <- "\" "


# Representation of a text string is not the same as string itself
# (because the displayed representation contains backslash):
one_quote_double


# How to see the raw content of the text string?
# Function writeLines() displays exactly stored text string
writeLines(one_quote_single)
writeLines(one_quote_double)


# When a backslash is a part of a text
# write a backslash in front of it
text_backslash1 <- "Short \ long"
text_backslash2 <- "Short \\ long"


text_backslash1
text_backslash2


writeLines(text_backslash1)
writeLines(text_backslash2)



# 2. Character vector ----


character_vector <- c("\" "," \\ ")
character_vector
writeLines(character_vector)


# Most common special characters:
#
# "\n"   newline 
# "\t"   tab
# unicode characters


character_vector2 <- c("separation\ttabulation and jump\ninto a newline")
character_vector2
writeLines(character_vector2)


# examples:
# unicode character PILCROW SIGN   "\u00b6"
# unicode character MICRO SIGN     "\u00b5"
# unicode character RIGHT POINTING "\u00bb"

character_vector3 <- c("\u00b6","\u00b5","\u00bb")
character_vector3
writeLines(character_vector3)


# examples of emoji (pictorial symbols):
# unicode character Music Notes "\u266c"
# unicode character Black Star  "\u2605"
# unicode character Telephone   "\u260f"

character_vector4 <- c("\u266c","\u2605","\u260f")
character_vector4
writeLines(character_vector4)



# 3. Regular expressions - basic examples ----


# the simplest regular expression is a piece of text
expression <- c("international","all", "associations", "intra-organisational", "foundations", "technical", "institutions")

str_view(expression, "national")
str_view(expression, "al")
str_view(expression, "int")
str_view(expression, "tions")


# dot matches any character except newline
str_view(expression, ".a.")
str_view(expression, "a.")
str_view(expression, "t.")
str_view(expression, ".o")


# If dot "." matches any character, how to match the "." itself?
#
# It is the regexp \. 
# Unfortunately backslash is also used as an escape symbol in strings
# So to create the regular expression \. 
# In R we need double backslash \\.
#
# Write regular expression as \. 
# Write string that represents the regular expression as "\\."

dot <- "\\."
writeLines(dot)


expression_short <- c("int.", "assoc.", "intra-org.", "found.", "tech.", "instit.")
str_view(expression_short, "\\.")


# If backslash "\" is used as an escape symbol, how to match the "\" itself?
#
# It is the regexp with a quadruple backslash \\\\
# In R we need four backslashes to match one!


text_backslash2 <- "Short \\ long"
text_backslash2
writeLines(text_backslash2)

str_view(text_backslash2, "\\\\")


x <- "a \\ b"
writeLines(x)
str_view(x, "\\\\")


# ^ matches start of the string
# $ matches end of the string

expression <- c("international", "associations", "intra-organisational", "foundations", "technical", "institutions")

str_view(expression, "^i")
str_view(expression, "^f")

str_view(expression, "al$")
str_view(expression, "tions$")


cake <- c("donut", "custard donut", "donut with plum", "pudding donut")
str_view(cake, "donut")
str_view(cake, "^donut$")


# [abc]  matches a, b or c
# [^abc] matches everything except a, b or c
# | stands for alternation "or"

str_view(c("abc", "a.c", "a*c", "a c", "a8c"), ".[*]c")
str_view(c("abc", "a.c", "a*c", "a c", "a8c"), ".[^*]c")
str_view(c("abc", "a.c", "a*c", "a c", "a8c"), "a[\\.]c")

str_view(c("abc", "a.c", "a*c", "a c", "a8c"), ".(\\.|8)c")

str_view(c("grey", "gray"), "gr(e|a)y")


# \d matches any digit
# \s matches any whitespace (space, tab, newline)

str_view(c("abc", "a.c", "a*c", "a c", "a8c"), "\\d")
str_view(c("abc", "a.c", "a*c", "a c", "a8c"), "\\s")
str_view(c("abc", "a.c", "a*c", "a c", "a8c"), ".(\\.|\\d)c")
str_view(c("abc", "a.c", "a*c", "a c", "a8c"), ".(\\d|\\s)c")



# -------------------------------------------------#
# 1. Exercise ----
# Vector of strings is given

vector <- c("emoticon", ":)", "symbol", "$^$")
writeLines((vector))


# Use the function str_view() and find in vector: 
# a) string of 3 characters with the letter o in the middle
str_view(vector, ".o.")
# b) expression "emoticon"
str_view(vector, "^emoticon$")
# c) expression ":)"
str_view(vector,":\\)")
# d) expression "$^$"
str_view(vector,"\\$\\^\\$")


# -------------------------------------------------#
# 2. Exercise ----
# Corpus of 980 words is given
stringr::words


# Use the function str_view() and find in the corpus:
# a) all words containing the expression "yes" (add the parameter match=T)
# b) all words starting with "w"
# c) all words ending with "x"


# -------------------------------------------------#
# 3. Exercise ----
# Corpus of 980 words is given
stringr::words


# Use the function str_view() and find in the corpus:
# a) all words starting with a vowel
# b) all words that start only with a consonant
# c) all words ending with "ing" or "ise"
# d) all words ending with "ed" but not with "eed"

# -------------------------------------------------#


