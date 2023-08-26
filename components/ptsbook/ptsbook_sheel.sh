#!/bin/bash

contlang=( 'ta-IN'  
 'ar'  
 'bg-BG'  
 'bn-IN'  
 'bs-BA'  
 'ca-ES'  
 'cs-CZ'  
 'cy-GB'  
 'da-DK'  
 'de-DE'  
 'el-GR'  
 'en-GB'  
 'en-IN'  
 'en-US'  
 'es-ES'  
 'et-EE'  
 'fi-FI'  
 'fil-PH'  
 'fr-FR'  
 'gu-IN'  
 'he-IL'  
 'hi-IN'  
 'hr-HR'  
 'hu-HU'  
 'id-ID'  
 'is-IS'  
 'it-IT'  
 'ja-JP'  
 'jv-ID'  
 'km-KH'  
 'kn-IN'  
 'ko-KR'  
 'lv-LV'  
 'lt-LT'  
 'ml-IN'  
 'mr-IN'  
 'ms-MY'  
 'nb-NO'  
 'ne-NP'  
 'nl-NL'  
 'pt-BR'  
 'pt-PT'  
 'pl-PL'  
 'pa-IN'  
 'ro-RO'  
 'ru-RU'  
 'si-LK'  
 'sk-SK'  
 'sq-AL'  
 'sr'  
 'su-ID'  
 'sv-SE'  
 'sw-KE'  
 'te-IN'  
 'th-TH'  
 'tr-TR'  
 'uk-UA'  
 'ur-PK'  
 'vi-VN'  
 'zh-CN'  )

read -p "Enter the number of episodes (integer): " no_of_epi

# Create a folder for each language
for lang in "${contlang[@]}"; do
    lang_folder="$lang"
    mkdir -p "$lang_folder"

    # Create text files in the language folder
    for ((i = 1; i <= no_of_epi; i++)); do
        touch "$lang_folder/$i.txt"
    done
done

echo "Folders and text files created successfully."

