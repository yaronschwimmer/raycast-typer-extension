#!/bin/bash

mkdir -p src
commands="["
 while read -r i; do
    # generate ts file
    key=$(echo "$i" | jq  '.key' | tr -d '"')
    value=$(echo "$i" | jq '.value')
    filename="src/$key.ts"
    valueEscaped=$(echo "$value" | sed -E 's/\//\\\//g')
    sed -E "s/##value##/$valueEscaped/g" template.txt > "$filename"

    # add command to commands
    command="{\"name\": \"$key\",\"title\": \"$key\",\"description\": \"type my $key\",\"mode\": \"no-view\"},"
    commands="$commands $command"
done <<< "$(jq -c '.[]' strings.json)"
commands="$(echo "$commands" | sed -E 's/,$//')]"
jq ".commands = ${commands}" package.json > tmp.json
mv tmp.json package.json