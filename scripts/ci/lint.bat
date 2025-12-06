@echo off
pushd ..\..
npx nx run learning-platform:lint --no-cache
popd
