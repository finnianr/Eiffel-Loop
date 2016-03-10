note
	description: "Summary description for {EIFFEL_CLASS_PREFIX_REMOVAL_APP}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:34 GMT (Sunday 16th December 2012)"
	revision: "1"

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

	create_file_editor: EIFFEL_CLASS_PREFIX_REMOVER
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

	Checksum: NATURAL = 0

	Option_name: STRING = "remove_prefix"

	Description: STRING = "Removes all classname prefixes over a source directory"

	Installer: EL_CONTEXT_MENU_SCRIPT_APPLICATION_INSTALLER
		once
			create Result.make ("Eiffel Loop/Development/Remove classname prefixes")
		end

	Log_filter: ARRAY [like Type_logging_filter]
			--
		do
			Result := <<
				[{EIFFEL_CLASS_PREFIX_REMOVAL_APP}, "*"],
				[{EIFFEL_SOURCE_TREE_PROCESSOR}, "*"],
				[{EL_TEST_ROUTINES}, "*"]
			>>
		end

end
