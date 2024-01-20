note
	description: "Command line interface to ${REPOSITORY_SOURCE_LINK_EXPANDER} command"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:27 GMT (Saturday 20th January 2024)"
	revision: "18"

class
	REPOSITORY_SOURCE_LINK_EXPANDER_APP

inherit
	REPOSITORY_PUBLISHER_APPLICATION [REPOSITORY_SOURCE_LINK_EXPANDER]
		redefine
			default_make, Option_name, argument_list
		end

	EL_ZSTRING_CONSTANTS

	EL_STRING_8_CONSTANTS

feature {NONE} -- Implementation

	default_make: PROCEDURE [like command]
		do
			Result := agent {like command}.make (create {FILE_PATH}, create {FILE_PATH}, Empty_string_8, 0)
		end

	argument_list: EL_ARRAYED_LIST [EL_COMMAND_ARGUMENT]
		do
			Result := Precursor
			Result.put_front (
				required_argument ("in", "Path to text file to be expanded", << file_must_exist >>)
			)
		end

	log_filter_set: EL_LOG_FILTER_SET [
		like Current, EIFFEL_CONFIGURATION_FILE, EIFFEL_CONFIGURATION_INDEX_PAGE
	]
		do
			create Result.make
		end

feature {NONE} -- Constants

	Option_name: STRING = "expand_links"

end