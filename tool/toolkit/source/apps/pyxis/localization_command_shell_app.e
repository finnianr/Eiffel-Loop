note
	description: "[
		Command shell to perform queries and edits on tree of Pyxis localization files

		**Usage**
		
			el_toolkit -localization_shell -source <source tree directory>
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-15 11:39:58 GMT (Sunday 15th October 2017)"
	revision: "8"

class
	LOCALIZATION_COMMAND_SHELL_APP

inherit
	EL_COMMAND_LINE_SUB_APPLICATION [LOCALIZATION_COMMAND_SHELL]
		redefine
			Option_name, initialize
		end

create
	make

feature {NONE} -- Initialization

	initialize
		do
			Console.show_all (<< {EL_FTP_PROTOCOL} >>)
			Precursor
		end

feature {NONE} -- Implementation

	argument_specs: ARRAY [like specs.item]
		do
			Result := <<
				valid_required_argument ("source", "Localization directory tree path", << directory_must_exist >>)
			>>
		end

	default_make: PROCEDURE
		do
			Result := agent {like command}.make ("")
		end

feature {NONE} -- Constants

	Option_name: STRING = "localization_shell"

	Description: STRING = "Command shell to perform queries and edits on tree of Pyxis localization files"

	Log_filter: ARRAY [like CLASS_ROUTINES]
			--
		do
			Result := <<
				[{LOCALIZATION_COMMAND_SHELL_APP}, All_routines],
				[{LOCALIZATION_COMMAND_SHELL_TEST_SET}, All_routines]
			>>
		end

end
