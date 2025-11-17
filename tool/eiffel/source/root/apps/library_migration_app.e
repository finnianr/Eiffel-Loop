note
	description: "Command line interface to ${LIBRARY_MIGRATION_COMMAND}"
	notes: "[
			el_eiffel -library_migration -sources <directory or manifest path> \
				-alias_map <path to alias mapping>
				-home <current library home directory> -suffix <basename suffix>
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-11-17 17:54:17 GMT (Monday 17th November 2025)"
	revision: "35"

class
	LIBRARY_MIGRATION_APP

inherit
	SOURCE_MANIFEST_APPLICATION [GRADUAL_LIBRARY_COPY_COMMAND]
		redefine
			argument_list
		end

create
	make

feature {NONE} -- Implementation

	argument_list: EL_ARRAYED_LIST [EL_COMMAND_ARGUMENT]
		do
			Result := Precursor +
				optional_argument ("alias_map", "Path to alias mapping", << file_must_exist >>) +
				required_argument ("home", "Home directory for library", << directory_must_exist >>) +
				optional_argument ("suffix", "Basename suffix for migrated output", << at_least_n_characters (1) >>) +
				optional_argument ("dry_run", "List classes without copying", No_checks)
		end

	default_make: PROCEDURE [like command]
		do
			Result := agent {like command}.make (create {FILE_PATH}, create {FILE_PATH}, create {DIR_PATH}, "-2", False)
		end

end