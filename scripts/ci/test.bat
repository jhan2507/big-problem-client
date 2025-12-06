@echo off
pushd ..\..
npx nx run learning-platform:test --codeCoverage --no-cache
popd
