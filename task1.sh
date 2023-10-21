#!/bin/bash
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <path_to_accounts.csv>"
    exit 1
fi

# Input file (accounts.csv)
accounts_new="accounts_new.csv"
accountsfile="$1"
IFS=','
is_number() {
    re='^[+-]?[0-9]+([.][0-9]+)?$'
    if [[ $1 =~ $re ]]; then
        return 0  # It's a number
    else
        return 1  # It's not a number
    fi
}

# Create an empty accounts_new.csv file or clear its content if it already exists
> "$accounts_new"

while read -r field1 field2 field3 field4; do
    echo "Field 1: $field1"
    echo "Field 2: $field2"
    echo "Field 3: $field3"
    echo "Field 4: $field4"
    if is_number "$field1" && [[ "$field4" == *,, ]]; then
        IFS=' ' read -ra names <<< "$field3"
        first_letter="${names[0]:0:1}"
        last_first="${names[1]:0:1}"
        rest="${names[1]}"
        first_rest="${names[0]:1}"
        last_rest="${names[1]:1}"
        result="${first_letter}${rest}"
        result_lowercase=$(echo "$result" | tr '[:upper:]' '[:lower:]')
        email="${result_lowercase}$field2@abc.com"
        length=${#field4}
        original_string=${field4:0:length-1}
        field4="${original_string}${email},"
        firstnamesf=$(echo "$first_letter" | tr '[:lower:]' '[:upper:]')
        lastnamesf=$(echo "$last_first" | tr '[:lower:]' '[:upper:]')
        firstnamesl=$(echo "$first_rest" | tr '[:upper:]' '[:lower:]')
        lastnamesl=$(echo "$last_rest" | tr '[:upper:]' '[:lower:]')
        field3="${firstnamesf}${firstnamesl} ${lastnamesf}${lastnamesl}"
    fi
    concatenated_line="$field1,$field2,$field3,$field4"
    echo "$concatenated_line" >> "$accounts_new"
done < "$accountsfile"

echo "Processing complete. Data saved to $accounts_new."
