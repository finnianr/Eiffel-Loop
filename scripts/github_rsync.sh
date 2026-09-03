
# Synchronize Eiffel-Loop development to github directory excluding build files and directories

if [[ "$1" == "live" ]]; then
	DRY_RUN=
else
	DRY_RUN=--dry-run
fi

EIFFEL_LOOP=$EIFFEL/library/Eiffel-Loop

rsync -av --itemize-changes $DRY_RUN --safe-links --delete --delete-excluded \
	--filter=". $EIFFEL_LOOP/rsync-preserve.txt" \
	--exclude-from=$EIFFEL_LOOP/rsync-excludes.txt \
	$EIFFEL_LOOP $HOME/github | sort | grep --invert-match -F ".d..t...... Eif"

if [[ "$1" == "live" ]]; then
	cd $HOME/github/Eiffel-Loop
	
	# Warn if any EIFGENs got copied
	line_count=$(find $HOME/github/Eiffel-Loop -type f -name "editors_1" | wc -l)
	if [ "$line_count" -gt 0 ]; then
		 echo "WARNING: $line_count 'EIFGENs/**/editors_1' file(s) found" >&2
	fi

	line_count=$(find $HOME/github/Eiffel-Loop -type d -name "__pycache__" | wc -l)
	if [ "$line_count" -gt 0 ]; then
		 echo "WARNING: $line_count '__pycache__' folder(s) found" >&2
	fi
fi	

