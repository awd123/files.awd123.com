#!/bin/sh
shopt -s nullglob
DIR="$( dirname "$SCRIPT_NAME" )"
FILEROOT="$CONTEXT_DOCUMENT_ROOT"
FULLPATH="$FILEROOT/$DIR"
if [[ -d "$FULLPATH" ]]; then
  ALBUM="$( basename "$DIR" )"
  echo "Content-type: application/zip"
  echo "Content-disposition: attachment; filename=\"$ALBUM.zip\""
  echo ""
  cd "$FULLPATH"
  FILES=*
  /usr/bin/zip - $FILES
else
  echo "Content-type: text/html"
  echo ""
  echo "<p>sorry, directory $DIR does not exist on this server.</p>"
fi
