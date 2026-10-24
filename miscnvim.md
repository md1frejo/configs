# different neovim commands

## regexs

| regexs | |
| :--: | :--: | 
| Character | Matches	Notes |
| . | Any single character	Except a newline. |
| \w | Word character	Letters, numbers, and underscores (_). |
| \W | Non-word character	Spaces, punctuation, symbols. |
| \d | Digit	Any number 0-9. |
| \D | Non-digit	Any character that is not a number. |
| \s | Whitespace	Spaces, tabs, and newlines. |
| \S | Non-whitespace	Visible characters. |
| \a | Alphabetic	Letters only (no numbers or underscores). |
| Default | Mode	Very Magic Mode (\v)	Notes |
| 0 | or more times	*	*	Greedy (matches as much as possible). |
| 1 | or more times	\+	+	Greedy. |
| 0 | or 1 time	\= or \?	?	Makes the preceding character optional. |
| 0 | or more (Lazy)	\{-}	{-}	Non-greedy (stops at the first match). |
| Exact | count	\{n}	{n}	Matches exactly n times (e.g., \d{3}). |
| ^ | Start of a line	^function matches "function" only at line-start. |
| $ | End of a line	;$ matches a semicolon at the very end of a line. |
| \< | Start of a word	\<cat matches "cat" but not "bobcat". |
| \> | End of a word	cat\> matches "cat" but not "catapult". |
| \v< | / \v>	Word boundaries in \v	Cleaner syntax used inside Very Magic mode. |
| Meaning | Default Mode	Very Magic Mode (\v)	Example |
| Character | Set	[abc]	[abc]	Matches a, b, or c. |
| Negated | Set	[^abc]	[^abc]	Matches anything except a, b, or c. |
| Alternation | (OR)	|	|	apple|banana or \vapple|banana. |
| Capture | Group	\(...\)	(...)	Saves the match into a register like \1. |
