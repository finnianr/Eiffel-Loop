note
	description: "Command line interface to [$source LIBRARY_MIGRATION_COMMAND]"
	notes: "[
			el_eiffel -library_migration -sources <directory or manifest path> \
				-home <current library home directory> -suffix <basename suffix>
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-06-12 9:20:35 GMT (Sunday 12th June 2022)"
	revision: "30"

class
	LIBRARY_MIGRATION_APP

inherit
	SOURCE_MANIFEST_APPLICATION [LIBRARY_MIGRATION_COMMAND]
		redefine
			argument_list
		end

create
	make

feature {NONE} -- Implementation

	argument_list: EL_ARRAYED_LIST [EL_COMMAND_ARGUMENT]
		do
			Result := Precursor +
				required_argument ("home", "Home directory for library", << directory_must_exist >>) +
				optional_argument ("suffix", "Basename suffix for migrated output", << at_least_n_characters (1) >>)
		end

	default_make: PROCEDURE [like command]
		do
			Result := agent {like command}.make (create {FILE_PATH}, create {DIR_PATH}, "-2")
		end

end