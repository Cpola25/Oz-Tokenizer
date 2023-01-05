functor
   %Name: Lizbeth Trujillo
    export
       IsKeyWord
       IsOperator
       IsAlphNum
       IsAlpha
       IsNumber
       IsSeparator
       CollectWord
       CollectNumber
       CollectOperator
       tokenizer:Tokenizer
   
    define

    fun {IsKeyWord Word}
       local Keywords in
	  Keywords = {String.tokens "program void bool int float true false if then else local in end assign call" & }
	  {Member  {Atom.toString Word} Keywords}
	end
    end
    fun{IsOperator Word}
       local Operators in
	  Operators = {String.tokens "= + - * ! / == != > < <= >=" & }
	  if  Word == "!" then false
	  else
	     {Member Word Operators}%change to Collect Operator
	  end
       end
end

fun {IsAlphNum X}
   if (( X > '@' andthen X <'[') orelse (X >'`' andthen X < '{')) orelse  ( X > '/' andthen X <':')  then
      true
   else
      false
   end
end
fun {IsAlpha X}
   if ( X > '@' andthen X <'[') orelse (X >'`' andthen X < '{') then
      true
   else
      false
   end
  
end
fun {IsNumber X NextChar}
   if X == '-' then
       if (NextChar > '/' andthen NextChar <':') then
	  true
       else
	  false
       end
       
   else
      if  X > '/' andthen X <':' then	 
	 true	 
      else	 
	 false	 
      end      
   end
   
 end
 
fun {CollectNumber X}
    local 
      fun {CN Xs Y}
	 case Xs  
	 of nil then
	    local R in
			R = {Reverse Y}			
			if {String.isInt R}			   
			then			   
			   {String.toInt R}#nil			   
			else			   
			   if{String.isFloat R} then			      
			      {String.toFloat R}#nil			      
			   else			      
			      {String.toAtom R}#nil		      
			   end			   
			end			
	    end
	 [] X|Xr then
	    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	       if {Char.toAtom X} == '.' then {CN Xr X|Y}
	       else
		  if  ((X == 32 orelse X == 13) orelse {Char.toAtom X} == &\n )
		     orelse {IsNumber {Char.toAtom X} {Char.toAtom Xr.1}} == false    
		  then
		     local R in
			R = {Reverse Y}			
			if {String.isInt R}			   
			then			   
			   {String.toInt R}#Xs			   
			else			   
			   if{String.isFloat R} then			      
			      {String.toFloat R}#Xs			      
			   else			      
			      {String.toAtom R}#nil	      
			   end			   
			end			
		     end
		  else

		     if{Char.toAtom X} == '-'
			
		     then {CN Xr 126|Y}						 
		     else
			{CN Xr X|Y }			
		     end
		    
		  end
	       end	       	    
	 end	 
      end
   in
      {CN X nil}
   end
end

fun {CollectWord X}
   local
      fun {CW Xs Y}
	 case Xs  
	 of nil then {Reverse Y}#nil   
	 [] X|Xr then  
	    if  ((X == 32 orelse X == 13) orelse {Char.toAtom X} == &\n )
	       orelse {IsAlphNum {Char.toAtom X}}== false then {Reverse Y}#Xs   
	    else   
	      {CW Xr X|Y}	     
	    end
	 end
      end
   in
      {CW X nil}
   end
 end

 fun {IsSeparator Word}
   local Separators in
      Separators = {String.tokens "; , ( ) { }" & }
      {Member {Atom.toString Word} Separators}%change to Collect Separator
   end
end

 fun {CollectOperator X}
   local
      fun {CO Xs Y}
	 case Xs
	 of nil then {Reverse Y}#nil
	 []X|Xr then
	    %if we reach a blank or the next character is not an op or is -
	    if ((X == 32 orelse X == 13) orelse {Char.toAtom X} == &\n )
	       orelse {IsOperator{Atom.toString{Char.toAtom X}}}==false
	    then {Reverse Y}#Xs
	    else
		  {CO Xr X|Y} 	      
	    end
	 end
      end
   in
      {CO X nil}
   end
   
end

fun {Tokenizer InputString OutPut}
   
       case InputString
       of nil then {Reverse OutPut}
       []X|Xr then
	  local Y in
	     if {IsAlpha {Char.toAtom X}}		
	     then		
		Y={CollectWord InputString}
	
		if{IsKeyWord {String.toAtom Y.1}} then		   
		   {Tokenizer Y.2 {String.toAtom Y.1}|OutPut}		   
		else		   
		   {Tokenizer Y.2 {String.toAtom Y.1}|OutPut}		   
		end		
	     else
		if (X == 32 orelse X == 13)orelse X == &\n then {Tokenizer Xr OutPut}
		else
		   if
		     {IsNumber {Char.toAtom X} {Char.toAtom Xr.1}} 		      
		   then
		        Y = {CollectNumber InputString}
		      if {IsAtom Y}then
			 illegalNumberExpression(Y)
			 
		      else	 
			 {Tokenizer Y.2 Y.1|OutPut}
		      end
		      
		   else
		      if  
			 {IsOperator {Atom.toString {Char.toAtom X}} }== true %maybeErro
		      then
			 Y={CollectOperator InputString}
			 if {IsOperator  Y.1}
			 then {Tokenizer Y.2 {String.toAtom Y.1}|OutPut}
			 else
			    illegalOperator({String.toAtom Y.1})
			 end
			 
		      else
			 if{IsSeparator  {Char.toAtom X}}
			 then
			       {Tokenizer Xr {Char.toAtom X}|OutPut}
			       
			 else
			    illegalExpressionFound({Char.toAtom X})
			 end
		      end
		   end  
		end
		
	     end	     	
	  end	  
       end

end
end



