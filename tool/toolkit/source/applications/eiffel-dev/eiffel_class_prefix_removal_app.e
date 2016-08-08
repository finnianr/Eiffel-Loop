note
	description: "Summary description for {EIFFEL_CLASS_PREFIX_REMOVAL_APP}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-08-04 9:42:55 GMT (Thursday 4th August 2016)"
	revision: "2"

class
	EIFFEL_CLASS_PREFIX_REMOVAL_APP

inherit
	EIFFEL_SOURCE_TREE_EDIT_SUB_APP
		redefine
			Option_name, Installer, normal_initialize, set_defaults
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

	new_editor: EIFFEL_CLASS_PREFIX_REMOVER
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
			create {EL_CONTEXT_MENU_SCRIPT_APPLICATION_INSTALLER_IMP} Result.make ("Eiffel Loop/Development/Remove classname prefixes")
		end

	Log_filter: ARRAY [like Type_logging_filter]
			--
		do
			Result := <<
				[{EIFFEL_CLASS_PREFIX_REMOVAL_APP}, All_routines]
			>>
		end

end
