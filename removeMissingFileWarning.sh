for missingFile in $(svn status | sed -e '/^!/!d' -e 's/^!//')
do
      echo $missingFile
      svn rm --force $missingFile
done
