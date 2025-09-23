#source this file to remove all the XrdSec env vars

for var in $(env | grep XrdSec | cut -d '=' -f 1); do
    unset "$var"
done

env | grep Xrd