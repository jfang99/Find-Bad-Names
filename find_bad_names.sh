#!/bin/bash

duplicate=FALSE # flag for duplicates


if [ "$1" == "-r" ] # test if there's option r
then
    function poornames {
	local input="$2"

        # test the inputs
	if [ -d "$input" ] && [ ! -L "$input" ] && 
{ [[ "$input" =~ ^[^\-].*$ ]] || [ $# -eq 1 ]; } && [ $# -lt 3 ]
	then
	    
       	    while read line; do

		# now files differing only in case:
	   amount=$(ls -a "$input" | grep -i -c -F -x "$line" "-")
        
           if [[ $amount -ge 2 ]] #test if there's duplicate
           then
	       duplicate=TRUE
       	       fi


       if [ $duplicate == "TRUE" ]
       then
              if [ -d "$input/$line" ] && [ ! -L "$input/$line" ]
              then
              echo "$input/$line/"
              else
                  echo "$input/$line"
                  fi

       else
	    if [ "$line" == "." ] || [ "$line" == ".." ] || 
{ [[ "$line" =~ ^[^\-].*$ ]] && [[ "$line" =~ ^[^\.].*$ ]] && 
[[ "$line" =~ ^[a-zA-Z_\.\-]{1,14}$ ]]; } 
            # test if name satisfies conditions
	    then
		: # do nothing
	    else
		if [ -d "$input/$line" ] && [ ! -L "$input/$line" ]
		then
		    echo "$input/$line/"
		else
		    echo "$input/$line"
		fi
	     fi	
	    
       fi
       duplicate=FALSE
       done < <(ls -a "$2")

        # recursion here:
	while read line; do
	  if [ -d "$input/$line" ] && [ ! -L "$input/$line" ] && 
[ "$line" != "." ] && [ "$line" != ".." ]
	       then
	       poornames -r "$input/$line"
	   fi    	 
	      done < <(ls -a "$2")


# errors
	else
	    if [ ! -d "$input" ] || [ -L "$input" ]
	    then
		       >&2 echo "It's not a directory!"
       exit 1
    fi
    	if [[ "$input" =~ ^\-.*$ ]]
         then
             >&2 echo "start with dash!"
             exit 1
	fi
        if [ $# -gt 1 ]
           then
           >&2 echo "more than 1 argument!"
           exit 1
        fi
	fi    

    } # end of function
    


poornames -r "$2"







    else  #without option -r
       if [ -d "$1" ] && [ ! -L "$1" ] && { [[ "$1" =~ ^[^\-].*$ ]] || 
[ $# -eq 0 ]; } && [ $# -lt 2 ]
      then

        while read line; do
	  # now files differing only in case:                          
        amount=$(ls -a "$1" | grep -i -c -F -x "$line" "-")

        if [[ $amount -ge 2 ]]
           then
               duplicate=TRUE
        fi

	
	   if [ $duplicate == TRUE ]
           then
              if [ -d "$1/$line" ] && [ ! -L "$1/$line" ]
              then
              echo "$1/$line/"
              else
                  echo "$1/$line"
              fi

	   else # there are no duplicates	
           if [ "$line" == "." ] || [ "$line" == ".." ] || { [[ "$line" =~ ^[^\-].*$ ]] && [[ "$line" =~ ^[^\.].*$ ]] && 
[[ "$line" =~ ^[a-zA-Z_\.\-]{1,14}$ ]]; }       
           then                                            	     
           : # do nothing
           else
	      if [ -d "$1/$line" ] && [ ! -L "$1/$line" ]
	      then
	      echo "$1/$line/"
	      else
		  echo "$1/$line"
		  fi
	
           fi
       
         fi
       duplicate=FALSE
       done < <(ls -a "$1")

#error
  else
    if [ ! -d "$1" ] || [ -L "$1" ]
       then
       >&2 echo "It's not a directory!"
       exit 1
    fi
    if [[ "$1" =~ ^\-.*$ ]] 
    then
         >&2 echo "start with dash!"
         exit 1
    fi
    if [ $# -gt 1 ]
    then
        >&2 echo "more than 1 argument!"
        exit 1
    fi

   fi
fi
