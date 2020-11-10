note
	description: "Class prefix removal sub-application"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-11-10 10:07:49 GMT (Tuesday 10th November 2020)"
	revision: "13"

class
	CLASS_PREFIX_REMOVAL_APP

inherit
	SOURCE_TREE_EDITING_SUB_APPLICATION
		rename
			extra_log_filter_set as empty_log_filter_set
		redefine
			Option_name, normal_initialize, set_defaults, test_sources
		end

	EL_INSTALLABLE_SUB_APPLICATION
		rename
			desktop_menu_path as Default_desktop_menu_path,
			desktop_launcher as Default_desktop_launcher
		end

create
	make

feature {NONE} -- Initialization

	normal_initialize
			--
		do
			Precursor
			set_attribute_from_command_opt (prefix_letters, "prefix", "Prefix letters to remove")
		end

feature {NONE} -- Implementation

	new_editor (file_path_list: LIST [EL_FILE_PATH]): CLASS_PREFIX_REMOVER
		do
			create Result.make (prefix_letters, file_path_list)
		end

	test_sources: ARRAY [STRING]
		do
			Result := << "latin1-sources/os-command" >>
		end

	prefix_letters: STRING

	set_defaults
		do
			Precursor
			prefix_letters := "EL"
		end

feature {NONE} -- Constants

	Checksum: ARRAY [NATURAL]
		once
			Result := << 2669768227 >>
		end

	Option_name: STRING = "remove_prefix"

	Description: STRING = "Removes all classname prefixes over a source directory"

	Desktop: EL_DESKTOP_ENVIRONMENT_I
		once
			Result := new_context_menu_desktop ("Eiffel Loop/Development/Remove classname prefixes")
		end

end