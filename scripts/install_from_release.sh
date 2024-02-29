# Script to install scenarios file.  Pass in language code parameter for a particular language, such as it-it for Italian.
set -e

# TODO: make parameters mandatory
LANG="$1"
RELEASE="$2"

# If no release is specified, download the latest release
if [ "$RELEASE" == "" ]; then
  RELEASE="latest"
fi

# Map the language parameter to the corresponding scenarios file
# If no parameter, download the scenarios from IE
MAIN_LANG_PREFIX="$(echo "$LANG" | head -c2 | tr '[:upper:]' '[:lower:]')"
LANG_ARRAY_1=("de" "es" "fr" "it" "nl" "pt")
LANG_ARRAY_2=("cs" "hu" "id" "ja" "ko" "pl" "pt" "ru" "sv" "tr")

if [ "$MAIN_LANG_PREFIX" = "" ] || [ "$MAIN_LANG_PREFIX" = "en" ]; then
  SCENARIOS="https://github.com/Azure/InnovationEngine/releases/download/$RELEASE/scenarios.zip"
elif [ "$MAIN_LANG_PREFIX" = "pt" ]; then
  if [ "$LANG" = 'pt-pt' ]; then
    SCENARIOS="https://github.com/MicrosoftDocs/executable-docs/releases/download/v1.0.1/pt-pt-scenarios.zip"
  elif [ "$LANG" = 'pt-br' ]; then
    SCENARIOS="https://github.com/MicrosoftDocs/executable-docs/releases/download/v1.0.1/pt-br-scenarios.zip"
  fi
elif [ "$MAIN_LANG_PREFIX" = "zh" ]; then
  if [ "$LANG" = "zh-cn" ]; then
    SCENARIOS="https://github.com/MicrosoftDocs/executable-docs/releases/download/v1.0.1/zh-cn-scenarios.zip"
  elif [ "$LANG" = "zh-tw" ]; then 
    SCENARIOS="https://github.com/MicrosoftDocs/executable-docs/releases/download/v1.0.1/zh-tw-scenarios.zip"
  else
    SCENARIOS="https://github.com/MicrosoftDocs/executable-docs/releases/download/v1.0.1/zh-cn-scenarios.zip"
  fi
elif [[ ${LANG_ARRAY_1[@]} =~ $MAIN_LANG_PREFIX ]]; then
  # for any other language that we do not have a specific scenarios file for, we will use the generic one
  SCENARIOS="https://github.com/MicrosoftDocs/executable-docs/releases/download/v1.0.1/$MAIN_LANG_PREFIX-$MAIN_LANG_PREFIX-scenarios.zip"
elif [[ ${LANG_ARRAY_2[@]} =~ $MAIN_LANG_PREFIX ]]; then
  SCENARIOS="https://github.com/MicrosoftDocs/executable-docs/releases/download/v1.0.1/$MAIN_LANG_PREFIX-$MAIN_LANG_PREFIX-scenarios.zip"
  if [ "$MAIN_LANG_PREFIX" = "cs" ]; then
    SCENARIOS="https://github.com/MicrosoftDocs/executable-docs/releases/download/v1.0.1/$MAIN_LANG_PREFIX-cz-scenarios.zip"
  elif [ "$MAIN_LANG_PREFIX" = "ja" ]; then
    SCENARIOS="https://github.com/MicrosoftDocs/executable-docs/releases/download/v1.0.1/$MAIN_LANG_PREFIX-jp-scenarios.zip"
  elif [ "$MAIN_LANG_PREFIX" = "ko" ]; then
    SCENARIOS="https://github.com/MicrosoftDocs/executable-docs/releases/download/v1.0.1/$MAIN_LANG_PREFIX-kr-scenarios.zip"
  elif [ "$MAIN_LANG_PREFIX" = "sv" ]; then
    SCENARIOS="https://github.com/MicrosoftDocs/executable-docs/releases/download/v1.0.1/$MAIN_LANG_PREFIX-se-scenarios.zip"
  fi
else
  SCENARIOS="https://github.com/Azure/InnovationEngine/releases/download/$RELEASE/scenarios.zip"
fi

# Download the binary
echo "Installing IE & scenarios from the $RELEASE release..."
wget -q -O ie https://github.com/Azure/InnovationEngine/releases/download/$RELEASE/ie > /dev/null
wget -q -O scenarios.zip "$SCENARIOS" > /dev/null

# Setup permissions & move to the local bin
chmod +x ie > /dev/null
mkdir -p ~/.local/bin > /dev/null
mv ie ~/.local/bin > /dev/null

# Unzip the scenarios, overwrite if they already exist.
unzip -o scenarios.zip -d ~ > /dev/null
rm scenarios.zip > /dev/null

# Export the path to IE if it's not already available
if [[ !"$PATH" =~ "~/.local/bin" || !"$PATH" =~ "$HOME/.local/bin" ]]; then
  export PATH="$PATH:~/.local/bin"
fi

echo "Done."
