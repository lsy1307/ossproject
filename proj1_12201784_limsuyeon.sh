#!/bin/bash

echo "User Name:LIMSUYEON"
echo "Student Number: 12201784"
echo "[ MENU ]"
echo "1. Get the data of the movie identified by a specific 'movie id' from 'u.item'"
echo "2. Get the data of action genre movies from 'u.item'"
echo "3. Get the average 'rating' of the movie identified by specific 'movie id' from 'u.data'"
echo "4. Delete the 'IMDb URL' from 'u.data'"
echo "5. Get the data about users from 'u.user'"
echo "6. Modify the format of 'release date' in 'u.item'"
echo "7. Get the data of movies rated by a specific 'user id' from 'u.data'"
echo "8. Get the average 'rating' of movies rated by users with 'age' between 20 and 29 and 'occupation' as 'programmer'"
echo "9. Exit"
echo "-------------------------------------------------"

while true; do
    read -p "Enter your choice [ 1-9 ] " choice
    echo "";
    if [[ $choice == 1 ]]; then
        read -p "Please enter the 'movie id' (1~1682):" movieid
        echo "";
        awk -v id=$movieid -F'|' '
        {
            if ($1 == id) 
            {
                print $0;
            }
        }' u.item
    fi
    if [[ $choice == 2 ]]; then
        read -p "Do you want to get the data of 'action' genre movies from 'u.item'?(y/n):" check
        echo "";
        if [[ $check == "y" ]]; then
            awk -F'|' '
            {
                if ($7 == 1) 
                {
                    print $1,$2;
                    count++;
                }
                if (count == 10) 
                {
                    exit;
                }
            }' u.item
        fi
    fi
    if [[ $choice == 3 ]]; then
        read -p "Please enter the 'movie id' (1~1682):" movieid
        echo "";
        awk -v id=$movieid '
    {
        if ($2==id)
        	{
            	total = total + $3; 
            	count++;
            }
    }
        END {
            printf "average rating of %d: %.5f\n",id, total/count;
        }' u.data
    fi
    if [[ $choice == 4 ]]; then
        read -p "Do you want to delete the 'IMDb URL'from 'u.item'?(y/n)" check
        echo "";
        if [[ $check == "y" ]]; then
            sed 's#|\([^|]*http[^|]*|\)#||#' u.item | head -n 10
        fi
    fi
    if [[ $choice == 5 ]]; then
        read -p "Do you want to get the data about users from 'u.user'?(y/n)" check
        echo "";
        if [[ $check == "y" ]]; then
            sed -e 's/F/female/' -e 's/M/male/' u.user | awk -F'|' '
            {
                print "user " $1 " is " $2 " years old " $3 " " $4;
                count++;
                if (count == 10) 
                {
                    exit;
                }
            }'
        fi
    fi
    if [[ $choice == 6 ]]; then
        read -p "Do you want to Modify the format of 'release data' in 'u.item'?(y/n)" check
        echo "";
        if [[ $check == "y" ]]; then
            awk -F'|' 'BEGIN {
                OFS = FS
            }
            {
                split($3, a, "-");
                if(a[2]=="Jan") m="01";
                if(a[2]=="Feb") m="02";
                if(a[2]=="Mar") m="03";
                if(a[2]=="Apr") m="04";
                if(a[2]=="May") m="05";
                if(a[2]=="Jun") m="06";
                if(a[2]=="Jul") m="07";
                if(a[2]=="Aug") m="08";
                if(a[2]=="Sep") m="09";
                if(a[2]=="Oct") m="10";
                if(a[2]=="Nov") m="11";
                if(a[2]=="Dec") m="12";
                $3 = a[3] m a[1];
                if(NR>=1673 && NR<=1682) 
                {
                    print
                }
            }' u.item
        fi
    fi
    if [[ $choice == 7 ]]; then
    		read -p "Please enter the 'user id' (1~943):" userid;
    		echo "";
    		movieids=$(awk -v id=$userid '
    		{
        		if($1==id) 
        		{
            		print $2;
    		  	}
        }' u.data | sort -n)
    		echo "$movieids" | sed ':a;N;$!ba;s/\n/|/g';
    		echo "";
    		array=($movieids)
    		for id in "${array[@]:0:10}"; do
        		awk -v movieid=$id -F '|' '
        		{
            		if($1==movieid)
            		{
                		print $1 "|" $2;
            		}
        		}' u.item
    		done
    fi
    if [[ $choice == 8 ]]; then
        read -p "Do you want to get the average 'rating' of movies rated by users with 'age' between 20 and 29 and 'occupation' as 'programmer'?(y/n)" check
        echo "";
        if [[ $check == "y" ]]; then
            id=$(awk -F'|' '$4=="programmer" && $2>=20 && $2<=29 {print $1}' u.user)
            awk -F'\t' -v id="$id" 'BEGIN {
                split(id, ids, " ")
                } 
                {
                    for (i in ids) 
                        if ($1==ids[i]) 
                        {
                            sum[$2]+=$3; count[$2]+=1;
                        }
                } 
                END {
                    for (i in sum) 
                        printf "%d %.6g\n", i, sum[i]/(count[i]*1.0);
                }' u.data | sort -n
        fi
    fi
    if [[ $choice == 9 ]]; then
        echo "Bye!";
        break
    fi
    echo "";
done
