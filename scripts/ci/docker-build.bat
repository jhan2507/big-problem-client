@echo off
pushd ..\..
docker build -t local/learning-platform:ci -f apps/learning-platform/Dockerfile .
popd
