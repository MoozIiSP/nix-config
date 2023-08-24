#!/bin/bash

cd workspace
nix build ./workspace/.#nixosConfigurations.wsl.config.system.build.installer --extra-experimental-features nix-command --extra-experimental-features flakes
cd -
