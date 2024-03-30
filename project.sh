while true; do

    echo "Select an option to run the top statistics project:"
    echo "r) read top output file"
    echo "c) average, minimum, and maximum CPU usage"
    echo "i) average, minimum, and maximum received packets"
    echo "o) average, minimum, and maximum sent packets"
    echo "u) commands with the maximum average CPU"
    echo "a) commands with the maximum average memory usage"
    echo "b) commands with the minimum average memory usage"
    echo "e) exit"
read -p "Enter your choice: " choice

case "$choice" in
   # 'r' option - read top output file
r) 
        echo "Please input the name of the file"
        read FileName
        if [ ! -f "$FileName" ]
        then
            echo "File does not exist"
        else 
            cat "$FileName" 
        fi
        ;;

   #'c' option - average, minimum, and maximum CPU usage
c)
        # Extract CPU usage values from the file
        value=$(grep -oE 'CPU usage: [0-9.]+' "$FileName" | cut -d' ' -f3)
        sum=0
        j=0
        avg=0

        # Calculate the sum of CPU usage values and count the number of values
        for val in $value; do
            sum=$(awk "BEGIN {printf \"%.2f\", $sum + $val}")
            j=$((j + 1))
        done

        # Calculate the average CPU usage
        avg=$(awk "BEGIN {printf \"%.2f\", $sum / $j}")
        echo "Average CPU usage: $avg"

        # Find the minimum and maximum CPU usage values
        min=$(echo "$value" | sort -n | head -n 1)
        max=$(echo "$value" | sort -n | tail -n 1)
        echo "Maximum CPU usage: $min%"
        echo "Minimum CPU usage: $max%"
        ;;

    # 'i' option - average, minimum, and maximum received packets
i)
        # Extract received packet values from the file
        value=$(grep -oE 'Networks: packets: [0-9.]+' $FileName | cut -d' ' -f3)
        sum=0
        j=0
        avg=0

        # Calculate the sum of received packet values and count the number of values
        for val in $value; do
            sum=$(awk "BEGIN {printf \"%.2f\", $sum + $val}")
            j=$((j + 1))
        done

        # Calculate the average received packets
        avg=$(awk "BEGIN {printf \"%.2f\", $sum / $j}")
        echo "Average received packets: $avg"

        # Find the minimum and maximum received packet values
        min=$(echo "$value" | sort -n | head -n 1)
        max=$(echo "$value" | sort -n | tail -n 1)
        echo "Maximum received packets: $min"
        echo "Minimum received packets: $max"
        ;;

   #'o' option - average, minimum, and maximum sent packets
o)
        # Extract sent packet values from the file
        value=$(grep -oE 'in, [0-9.]+' $FileName | cut -d' ' -f2)
        sum=0
        j=0
        avg=0

        # Calculate the sum of sent packet values and count the number of values
        for val in $value; do
            sum=$(awk "BEGIN {printf \"%.2f\", $sum + $val}")
            j=$((j + 1))
        done

        # Calculate the average sent packets
        avg=$(awk "BEGIN {printf \"%.2f\", $sum / $j}")
        echo "Average sent packets: $avg"

        # Find the minimum and maximum sent packet values
        min=$(echo "$value" | sort -n | head -n 1)
        max=$(echo "$value" | sort -n | tail -n 1)
        echo "Maximum sent packets: $min"
        echo "Minimum sent packets: $max"
        ;;


u) 
touch test.txt
touch out.txt
touch out1.txt
touch out2.txt
touch out3.txt
touch F3.txt
touch F4.txt
touch F5.txt
touch F6.txt
> test.txt
> out.txt
> out1.txt
> out2.txt
> out3.txt
> F3.txt
> F4.txt
> F5.txt
> F6.txt
echo "Enter the integer number m:"
read m

if [[ "$m" =~ ^[0-9]+$ ]]; then
 
    sed '/^Processes:/,/^Disks:/d' $FileName > test.txt
    sed 's/[()]//g' test.txt > out.txt
    sed -E 's/([a-zA-Z]) ([a-zA-Z])/\1#\2/g' out.txt > out1.txt
    awk '{print $2, $3}' out1.txt > out2.txt
    sed '/COMMAND/d' out2.txt > out3.txt
    while IFS= read -r line;
    do
          if [[ -z "$line" ]]; then
           continue
          fi
 
         name=$(echo "$line" | cut -d' ' -f1) 
         if  ! grep -q "$name" F3.txt; then 
            echo "$name" >> F3.txt
          value=$(grep -oE  -w "$name [0-9.]+" out3.txt | cut -d' ' -f2)   
            sum=0
            j=0
            avg=0
            for val in $value; do
               sum=$(awk "BEGIN {printf \"%.2f\", $sum + $val}")
               j=$((j + 1))
            done
            avg=$(awk "BEGIN {printf \"%.2f\", $sum / $j}")
            echo "$avg" >> F4.txt
         fi
    done < "out3.txt"  
    paste F3.txt F4.txt > F5.txt
    sort -k2 -r -n -t $'\t' F5.txt > F6.txt

    #sort -k 2 -n -t $'\t' F5.txt > F6.txt
    head -"$m"  F6.txt
       
  
else
    echo "Invalid input"
fi
;;
a) touch test.txt
touch out.txt
touch out1.txt
touch out2.txt
touch out3.txt
touch F3.txt
touch F4.txt
touch F5.txt
touch F6.txt
> test.txt
> out.txt
> out1.txt
> out2.txt
> out3.txt
> F3.txt
> F4.txt
> F5.txt
> F6.txt
echo "Enter the integer number m:"
read m

if [[ "$m" =~ ^[0-9]+$ ]]; then
 
    sed '/^Processes:/,/^Disks:/d' $FileName > test.txt
    sed 's/[()]//g' test.txt > out.txt
    sed -E 's/([a-zA-Z]) ([a-zA-Z])/\1#\2/g' out.txt > out1.txt
    awk '{print $2, $8}' out1.txt > out2.txt
    sed '/COMMAND/d' out2.txt > out3.txt
    while IFS= read -r line;
    do
          if [[ -z "$line" ]]; then
           continue
          fi
 
         name=$(echo "$line" | cut -d' ' -f1)   
         if  ! grep -q "$name" F3.txt; then 
            echo "$name" >> F3.txt
          value=$(grep -oE  -w "$name [0-9.]+[k,M]" out3.txt | cut -d' ' -f2)   
            sum=0
            j=0
            avg=0
            for val in $value; do
               sum=$(awk "BEGIN {printf \"%.2f\", $sum + $val}")
               j=$((j + 1))
            done
            avg=$(awk "BEGIN {printf \"%.2f\", $sum / $j}")
            echo "$avg" >> F4.txt
         fi
    done < "out3.txt"  
    paste F3.txt F4.txt > F5.txt
    sort -k2 -r -n -t $'\t' F5.txt > F6.txt

    #sort -k 2 -n -t $'\t' F5.txt > F6.txt
    head -"$m"  F6.txt
       
  
else
    echo "Invalid input"
fi
;;
b)touch test.txt
touch out.txt
touch out1.txt
touch out2.txt
touch out3.txt
touch F3.txt
touch F4.txt
touch F5.txt
touch F6.txt
> test.txt
> out.txt
> out1.txt
> out2.txt
> out3.txt
> F3.txt
> F4.txt
> F5.txt
> F6.txt
echo "Enter the integer number m:"
read m

if [[ "$m" =~ ^[0-9]+$ ]]; then
 
    sed '/^Processes:/,/^Disks:/d' $FileName > test.txt
    sed 's/[()]//g' test.txt > out.txt
    sed -E 's/([a-zA-Z]) ([a-zA-Z])/\1#\2/g' out.txt > out1.txt
    awk '{print $2, $8}' out1.txt > out2.txt
    sed '/COMMAND/d' out2.txt > out3.txt
    while IFS= read -r line;
    do
          if [[ -z "$line" ]]; then
           continue
          fi
 
         name=$(echo "$line" | cut -d' ' -f1)  
         if  ! grep -q "$name" F3.txt; then 
            echo "$name" >> F3.txt
          value=$(grep -oE  -w "$name [0-9.]+[KM]" out3.txt | cut -d' ' -f2)   
            sum=0
            j=0
            avg=0
            for val in $value; do
               sum=$(awk "BEGIN {printf \"%.2f\", $sum + $val}")
               j=$((j + 1))
            done
            avg=$(awk "BEGIN {printf \"%.2f\", $sum / $j}")
            echo "$avg" >> F4.txt
         fi
    done < "out3.txt"  
    paste F3.txt F4.txt > F5.txt
    sort -k 2 -n -t $'\t' F5.txt > F6.txt
    head -"$m"  F6.txt
       
  
else
    echo "Invalid input"
fi;;
e) echo "Are you sure you want to exit? (yes/no): "
        read answer
            if [ "$answer" = "yes" ]; then
                break
            fi
            ;;

esac
done