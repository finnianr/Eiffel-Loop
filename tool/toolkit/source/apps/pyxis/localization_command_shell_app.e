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
	date: "2022-01-13 11:57:11 GMT (Thursday 13th January 2022)"
	revision: "15"

class
	LOCALIZATION_COMMAND_SHELL_APP

inherit
	EL_LOGGED_COMMAND_LINE_SUB_APPLICATION [LOCALIZATION_COMMAND_SHELL]
		redefine
			Option_name, visible_types
		end

create
	make

feature {NONE} -- Implementation

	argument_specs: ARRAY [EL_COMMAND_ARGUMENT]
		do
			Result := <<
				valid_required_argument ("source", "Localization directory tree path", << directory_must_exist >>)
			>>
		end

	default_make: PROCEDURE [like command]
		do
			Result := agent {like command}.make ("")
		end

	log_filter_set: EL_LOG_FILTER_SET [
		like Current, LOCALIZATION_COMMAND_SHELL_TEST_SET
	]
			--
		do
			create Result.make
		end

	visible_types: TUPLE [EL_FTP_PROTOCOL]
		do
			create Result
		end

feature {NONE} -- Constants

	Option_name: STRING = "localization_shell"

end