note
	description: "[
		Application to collate a Tango MP3 collection into a directory structure using any
		available ID3 tag information and renaming the file according to the title and a numeric
		id to distinguish duplicates.
		
			<genre>/<artist>/<title>.<id>.mp3
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-01-23 12:01:31 GMT (Sunday 23rd January 2022)"
	revision: "17"

class
	TANGO_MP3_FILE_COLLATOR_APP

inherit
	EL_COMMAND_LINE_SUB_APPLICATION [TANGO_MP3_FILE_COLLATOR]
		redefine
			Option_name
		end

feature {NONE} -- Implementation

	argument_specs: ARRAY [EL_COMMAND_ARGUMENT]
		do
			Result := <<
				required_argument ("directory", "MP3 location", << directory_must_exist >>),
				optional_argument ("dry_run", "Show output without moving any files", No_checks)
			>>
		end

	default_make: PROCEDURE [like command]
		do
			Result := agent {like command}.make ("", False)
		end

feature {NONE} -- Constants

	Option_name: STRING = "mp3_collate"

end