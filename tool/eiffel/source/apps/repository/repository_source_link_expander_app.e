note
	description: "Command line interface to [$source REPOSITORY_SOURCE_LINK_EXPANDER] command"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-04-29 10:32:55 GMT (Sunday 29th April 2018)"
	revision: "1"

class
	REPOSITORY_SOURCE_LINK_EXPANDER_APP

inherit
	REPOSITORY_PUBLISHER_SUB_APPLICATION [REPOSITORY_SOURCE_LINK_EXPANDER]
		redefine
			Option_name, argument_specs
		end

	EL_STRING_CONSTANTS

feature {NONE} -- Implementation

	default_make: PROCEDURE
		do
			Result := agent {like command}.make (Empty_string, Empty_string, Empty_string_8, 0)
		end

	argument_specs: ARRAY [like specs.item]
		local
			list: ARRAYED_LIST [like specs.item]
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
				[{REPOSITORY_SOURCE_TREE}, All_routines],
				[{REPOSITORY_SOURCE_TREE_PAGE}, All_routines]
			>>
		end

end
