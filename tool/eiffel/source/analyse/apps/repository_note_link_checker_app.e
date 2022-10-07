note
	description: "Command line interface to [$source REPOSITORY_NOTE_LINK_CHECKER] command"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-10-07 10:31:27 GMT (Friday 7th October 2022)"
	revision: "11"

class
	REPOSITORY_NOTE_LINK_CHECKER_APP

inherit
	REPOSITORY_PUBLISHER_APPLICATION [REPOSITORY_NOTE_LINK_CHECKER]
		redefine
			Option_name
		end

feature {NONE} -- Implementation

	default_make: PROCEDURE [like command]
		do
			Result := agent {like command}.make ("", "", 0)
		end

	log_filter_set: EL_LOG_FILTER_SET [
		like Current, EIFFEL_CONFIGURATION_FILE, EIFFEL_CONFIGURATION_INDEX_PAGE
	]
		do
			create Result.make
		end

feature {NONE} -- Constants

	Option_name: STRING = "check_note_links"

end