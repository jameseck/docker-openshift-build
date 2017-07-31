# docker-openshift-build

This will build Openshift Origin RPM's.
Set the environment variable GIT_BRANCH to the branch you require
Mount a volume to /output and the RPM's will be saved here

Example:

docker run -v /home/user/openshift-rpm:/output jameseckersall/openshift-build
