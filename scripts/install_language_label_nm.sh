#!/usr/bin/env bash

usage() { echo "Usage: $0 -l <language i18n id>" 1>&2; exit 1; }

while getopts "l:" o; do
  case "${o}" in
    l)
      lang=${OPTARG}
      ;;
    *)
      usage
      ;;
  esac
done
shift $((OPTIND-1))

HOME=$(awk -F: '/1000/ {print $6}' /etc/passwd)

label_file_name="labels_${lang}.txt"

unzip -o $HOME/BirdNETx86_64/model/labels_nm.zip $label_file_name \
  -d $HOME/BirdNETx86_64/model \
  && mv -f $HOME/BirdNETx86_64/model/$label_file_name $HOME/BirdNETx86_64/model/labels.txt \
  && logger "[$0] Changed language label file to '$label_file_name'";

label_file_name_flickr="labels_en.txt"

unzip -o $HOME/BirdNETx86_64/model/labels_nm.zip $label_file_name_flickr \
  -d $HOME/BirdNETx86_64/model \
  && mv -f $HOME/BirdNETx86_64/model/$label_file_name_flickr $HOME/BirdNETx86_64/model/labels_flickr.txt \
  && logger "[$0] Set Flickr labels '$label_file_name_flickr'";

exit 0
