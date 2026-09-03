# Create source archive of Eiffel-Loop for AI analysis

#DRY_RUN=--dry-run
DRY_RUN=
SOURCE_DIR=$EIFFEL/library/Eiffel-Loop
DESTINATION_DIR=$HOME/Downloads/tar.gz
rsync -av $DRY_RUN --safe-links --delete --chmod D0755,F0644 --exclude-from=$SOURCE_DIR/rsync-eiffel-source.txt \
	$SOURCE_DIR $DESTINATION_DIR

pushd .

cd $DESTINATION_DIR
tar -czvf Eiffel-Loop-source.tar.gz Eiffel-Loop
rm -r Eiffel-Loop

popd 
