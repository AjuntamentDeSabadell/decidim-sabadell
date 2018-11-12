CONFIG_FILE=$1
DOCKER_COMPOSE_FILE=$2
IFS="="
while read -r name value
do
  echo "Content of $name is ${value//\"/}"
  sed -i '' "s/$name/$value/g" "$DOCKER_COMPOSE_FILE"

done < $CONFIG_FILE
