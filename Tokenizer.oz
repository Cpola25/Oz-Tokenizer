declare
%Name Lizbeth Trujillo
[File] = {Module.link ['File.ozf']}
[Token]={Module.link ['TokenizerFunctor.ozf']}
Content = {File.readList "C:\\Users\\cstech\\Desktop\\LizbethTrujilloAssignment3\\foo.txt"}
%Tokenization = 
{Browse {Token.tokenizer {Append Content [32]} nil}}