#!/bin/bash

function install_homebrew {
  if binary_exist brew ; then
    echo "brew installed already"
  else
    echo "installing brew now"
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  fi
}

function install_dependencies {
  for dependency in $@ ; do
    if binary_exist $dependency ; then
      echo "dependency $dependency installed already"
    else
      echo "installing dependency $dependency now"
      brew install $dependency
    fi
  done
}

function install_react_native {
  if binary_exist react-native ; then
    echo "react-native-cli installed already"
  else
    echo "installing react-native-cli now"
    npm install -g react-native-cli
  fi
}

function binary_exist {
  if [ -x "$(command -v $1)" ]; then
    return 0
  else
    return 1
  fi
}

install_homebrew
install_dependencies node watchman
install_react_native
