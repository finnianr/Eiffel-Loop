note
	description: "Command line interface to [$source CLASS_DESCENDANTS_COMMAND]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-06-19 11:11:43 GMT (Tuesday 19th June 2018)"
	revision: "3"

class
	CLASS_DESCENDANTS_APP

inherit
	EL_LOGGED_COMMAND_LINE_SUB_APPLICATION [CLASS_DESCENDANTS_COMMAND]
		redefine
			Option_name
		end

	EL_STRING_CONSTANTS

create
	make

feature {NONE} -- Implementation

	argument_specs: ARRAY [like specs.item]
		do
			Result := <<
				valid_optional_argument ("build_dir", "Parent directory of EIFGENs", << file_must_exist >>),
				optional_argument ("out_dir", "Output directory path"),
				valid_required_argument ("class", "Path to Eiffel class", << file_must_exist >>)
			>>
		end

	default_make: PROCEDURE
		local
			build_dir: EL_DIR_PATH
		do
			build_dir := "build/$ISE_PLATFORM"
			build_dir.expand
			Result := agent {like command}.make (build_dir, "doc", Empty_string_8)
		end

feature {NONE} -- Constants

	Option_name: STRING = "descendants"

	Description: STRING = "Output descendants of class to a file with wiki-markup"

	Log_filter: ARRAY [like CLASS_ROUTINES]
			--
		do
			Result := <<
				[{CLASS_DESCENDANTS_APP}, All_routines],
				[{CLASS_DESCENDANTS_COMMAND}, All_routines]
			>>
		end

end
