note
	description: "Command line interface to [$source REPOSITORY_SOURCE_LINK_EXPANDER] command"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-11-06 16:50:50 GMT (Friday 6th November 2020)"
	revision: "8"

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

	log_filter_list: EL_LOG_FILTER_LIST [
		like Current, EIFFEL_CONFIGURATION_FILE, EIFFEL_CONFIGURATION_INDEX_PAGE
	]
		do
			create Result.make
		end

feature {NONE} -- Constants

	Option_name: STRING = "expand_links"

	Description: STRING = "Expand [$source MY_CLASS] links in text file using repository configuration"

end