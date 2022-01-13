note
	description: "Command line interface to [$source REPOSITORY_SOURCE_LINK_EXPANDER] command"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-01-13 12:30:40 GMT (Thursday 13th January 2022)"
	revision: "10"

class
	REPOSITORY_SOURCE_LINK_EXPANDER_APP

inherit
	REPOSITORY_PUBLISHER_SUB_APPLICATION [REPOSITORY_SOURCE_LINK_EXPANDER]
		redefine
			Option_name, argument_specs
		end

	EL_ZSTRING_CONSTANTS

	EL_STRING_8_CONSTANTS

feature {NONE} -- Implementation

	default_make: PROCEDURE [like command]
		do
			Result := agent {like command}.make (Empty_string, Empty_string, Empty_string_8, 0)
		end

	argument_specs: ARRAY [EL_COMMAND_ARGUMENT]
		local
			list: ARRAYED_LIST [EL_COMMAND_ARGUMENT]
		do
			create list.make_from_array (Precursor)
			list.put_front (
				valid_required_argument ("in", "Path to text file to be expanded", << file_must_exist >>)
			)
			Result := list.to_array
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