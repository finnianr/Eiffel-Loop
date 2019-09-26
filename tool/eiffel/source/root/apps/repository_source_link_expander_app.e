note
	description: "Command line interface to [$source REPOSITORY_SOURCE_LINK_EXPANDER] command"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-09-25 15:25:40 GMT (Wednesday   25th   September   2019)"
	revision: "7"

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

feature {NONE} -- Constants

	Option_name: STRING = "expand_links"

	Description: STRING = "Expand [$source MY_CLASS] links in text file using repository configuration"

	Log_filter: ARRAY [like CLASS_ROUTINES]
			--
		do
			Result := <<
				[{REPOSITORY_SOURCE_LINK_EXPANDER_APP}, All_routines],
				[{EIFFEL_CONFIGURATION_FILE}, All_routines],
				[{EIFFEL_CONFIGURATION_INDEX_PAGE}, All_routines]
			>>
		end

end
