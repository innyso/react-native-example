ANDROID_VERSION=25.0.0
ANDROID_HOME=/usr/local/opt/android-sdk

function parse_opts {
  while getopts :v:h opt; do
    case $opt in
      h)
cat <<EOF
usage ./osx_setup.sh [-h|-v <int>|-a <string>]

-h help
-a path to android home. Default to /usr/local/opt/android-sdk
-v android build-tools and sdk version to install. Default to 25.0.0

Purpose of this script is to prepare your OSX system to be use for compiling Android application from the commandline. Tools that will be install include brew, android-sdk, android-studio
EOF
        exit 0
        ;;
      v)
        ANDROID_VERSION=$OPTARG
        ;;
      a)
        ANDROID_HOME=$OPTARG
        ;;
      \?)
        echo "Incorrect argument option -$OPTARG"
        exit 1
        ;;
    esac
  done
}

function install_homebrew { 
  if ! [ -x "$(command -v brew)" ]; then
    echo "installing homebrew"
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  else
    echo "homebrew installed already"
  fi
}

function install_android_sdk_cmd {
  if ! [ -x "$(command -v android)" ]; then
    echo "creating license directory"
    mkdir "$ANDROID_HOME/licenses"
    echo -e "\n8933bad161af4178b1185d1a37fbf41ea5269c55" > "$ANDROID_HOME/licenses/android-sdk-license"

    echo "installing android-sdk using brew"
    brew install android-sdk

    echo "setting ANDROID_HOME. It is recommend that you put this into your bashrc"
    export ANDROID_HOME=/usr/local/opt/android-sdk

  else
    echo "android-sdk cmd installed already"
  fi
}

function install_android_sdk {
  if ! [ -d "$ANDROID_HOME/build-tools/$ANDROID_VERSION" ]; then
    echo "Installing android build tools and sdk $ANDROID_VERSION"
    echo y | android update sdk --no-ui --all --filter build-tools-$ANDROID_VERSION,android-$ANDROID_VERSION,extra-android-m2repository
  else
    echo "android build tools and sdk $ANDROID_VERSION installed already"
  fi
}

function install_android_studio {
  installed=`ls /Applications | grep Android\ Studio.app`
  if  [[ $installed == "" ]]; then
    echo "installing android studio using brew cask"
    brew cask install android-studio
  else
    echo "Android studio installed already"
  fi
}

parse_opts "$@"
install_homebrew
install_android_sdk_cmd
install_android_sdk
install_android_studio

