#!bin/bash

declare -a phpVersions=("7.4" "7.3" "7.1" "5.6")
declare -a defaultPhpVersion="7.4"

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
    echo "\nBuilding ${version}"
    docker build -t "voyagestudio/silverstripe-web:${version}" "$version"

    if [[ $* == *--push* ]]; then
    echo "\nPushing image to Docker hub..." 
        docker push "voyagestudio/silverstripe-web:${version}"
    fi
done

echo "\nBuilding latest"
docker build -t "voyagestudio/silverstripe-web:latest" "$defaultPhpVersion"

if [[ $* == *--push* ]]; then
    echo "\nPushing image to Docker hub..." 
    docker push "voyagestudio/silverstripe-web:latest"
fi

echo "Done!"
exit 0