note
	description: "Command line interface to ${REPOSITORY_SOURCE_LINK_EXPANDER} command"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-10-17 11:11:21 GMT (Thursday 17th October 2024)"
	revision: "19"

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
			Result [2].set_optional -- make version optional
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