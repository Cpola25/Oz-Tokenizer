The following repo contains my tokenizer project written in OZ. The project parameters and key words were as follows: 

Tokenizer: a program that accepts a sequence of characters and returns a sequence of tokens

Compiler: a program that translates a sequence of characters, which represent a program, into a sequence of low-level instructions. 

Compiler 3 Parts: 
 
1. Tokenizer: reads a sequence of characters and outputs a sequence of tokens. 
2. Parser: reads a sequence of tokens and outputs an abstract syntax tree (parse tree). 
3. Code generator: traverses the syntax tree and generates low-level instructions for a real machine or an abstract machine. 

The keywords are: program, void, bool, int, float, true, false, if, then, else, local, in, end, assign, call
Operators: [ =  +  -  *  /  ==  !=  >  <  <=  >= ]
Separators: [ ;   ,  (   )  {   } ]
Atom: 
1.Starts with a lowercase character 
2.Followed by any number of letters (cannot be a keyword) 

Goal: 

Read a character sequence and output token list.
Program returns illegal token error if unknown token is entered. 

Example Input: “local x in x=10 end” 
Example Output: [ ‘local’ x ‘in’ x ‘=’ 10 ‘end’ ]

My approach: 

I split my program into a few unique methods each in charge of "collecting" different tokens. For example I had a collect word function that 
would be called when a letter was identified in the input string. 

For example: 
12 apples = X

When the program hits the letter a it will send the string into my collect word function and split the string into a list with the following
anatomy: "apples"# " = X". The left side of the list will be appended to the accumulator of the tokenizor function and the right side will be used to 
recursively call the tokenizor function. 

A simple way to understand my approach is that I am chopping off peices of the input string in each recursive call until the string is null. 
