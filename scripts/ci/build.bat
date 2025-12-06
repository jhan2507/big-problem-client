@echo off
pushd ..\..
npx nx run learning-platform:build --no-cache
popd
