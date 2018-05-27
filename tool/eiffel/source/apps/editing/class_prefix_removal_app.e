note
	description: "Class prefix removal app"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-27 17:43:46 GMT (Sunday 27th May 2018)"
	revision: "6"

class
	CLASS_PREFIX_REMOVAL_APP

inherit
	SOURCE_TREE_EDIT_SUB_APP
		redefine
			Option_name, normal_initialize, set_defaults
		end

	EL_INSTALLABLE_SUB_APPLICATION

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

	Installer: EL_CONTEXT_MENU_SCRIPT_APPLICATION_INSTALLER_I
		once
			create {EL_CONTEXT_MENU_SCRIPT_APPLICATION_INSTALLER_IMP} Result.make (
				"Eiffel Loop/Development/Remove classname prefixes"
			)
		end

	Log_filter: ARRAY [like CLASS_ROUTINES]
			--
		do
			Result := <<
				[{CLASS_PREFIX_REMOVAL_APP}, All_routines]
			>>
		end

end
