#!/bin/bash

declare -a phpVersions=("8.2" "8.3")
declare -a defaultPhpVersion="8.3"

#### Functions ###
display_usage() { 
    echo "This script must be run with Docker capable privileges and you should login to your registry before pushing!" 
    echo -e "\nUsage:\n$0 --run [--push]\n" 
    echo -e " --run\t\t\tLets do it!" 
    echo -e " [--push]\t\t\tPush to registry. Omit if you just want to build"
    echo -e "\nExample: $0 --run --push"
} 

# Check params
if [  $# -le 0 ] 
then 
    display_usage
    exit 1
fi 

# Check Docker command executable exit code
docker images > /dev/null 2>&1; rc=$?;
if [[ $rc != 0 ]]; then 
    display_usage
    exit 1
fi

for version in "${phpVersions[@]}"
do
    echo "\nBuilding ${version} for linux/amd64"
    docker buildx build --platform linux/amd64 -t "voyagestudio/silverstripe-web:${version}" "$version" --load

    if [[ $* == *--push* ]]; then
    echo "\nPushing image to Docker hub..."
        docker buildx build --platform linux/amd64 -t "voyagestudio/silverstripe-web:${version}" "$version" --push
    fi
done

echo "\nBuilding latest for linux/amd64"
docker buildx build --platform linux/amd64 -t "voyagestudio/silverstripe-web:latest" "$defaultPhpVersion" --load

if [[ $* == *--push* ]]; then
    echo "\nPushing image to Docker hub..."
    docker buildx build --platform linux/amd64 -t "voyagestudio/silverstripe-web:latest" "$defaultPhpVersion" --push
fi

echo "Done!"
echo "Please remember to update the README file with the latest tag published. Have a nice day!"
exit 0