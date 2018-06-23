note
	description: "Class prefix removal app"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-06-19 9:22:34 GMT (Tuesday 19th June 2018)"
	revision: "8"

class
	CLASS_PREFIX_REMOVAL_APP

inherit
	SOURCE_TREE_EDIT_SUB_APP
		redefine
			Option_name, normal_initialize, set_defaults
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

	new_editor: CLASS_PREFIX_REMOVER
		do
			create Result.make (prefix_letters)
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
			Result := << 0, 0 >>
		end

	Option_name: STRING = "remove_prefix"

	Description: STRING = "Removes all classname prefixes over a source directory"

	Desktop: EL_DESKTOP_ENVIRONMENT_I
		once
			Result := new_context_menu_desktop ("Eiffel Loop/Development/Remove classname prefixes")
		end

	Log_filter: ARRAY [like CLASS_ROUTINES]
			--
		do
			Result := <<
				[{CLASS_PREFIX_REMOVAL_APP}, All_routines]
			>>
		end

end
