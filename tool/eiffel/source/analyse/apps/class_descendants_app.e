note
	description: "Command line interface to [$source CLASS_DESCENDANTS_COMMAND]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-01-13 12:28:19 GMT (Thursday 13th January 2022)"
	revision: "12"

class
	CLASS_DESCENDANTS_APP

inherit
	EL_LOGGED_COMMAND_LINE_SUB_APPLICATION [CLASS_DESCENDANTS_COMMAND]
		redefine
			Option_name
		end

	EL_STRING_8_CONSTANTS

create
	make

feature {NONE} -- Implementation

	argument_specs: ARRAY [EL_COMMAND_ARGUMENT]
		do
			Result := <<
				valid_optional_argument ("build_dir", "Parent directory of EIFGENs", << file_must_exist >>),
				optional_argument ("out_dir", "Output directory path"),
				valid_required_argument ("class", "Path to Eiffel class", << file_must_exist >>),
				optional_argument ("target", "Target name used to identify ecf file")
			>>
		end

	default_make: PROCEDURE [like command]
		do
			Result := agent {like command}.make (build_ise_platform, "doc", Empty_string_8, "classic")
		end

	build_ise_platform: DIR_PATH
		do
			Result := "build/$ISE_PLATFORM"
			Result.expand
		end

	log_filter_set: EL_LOG_FILTER_SET [like Current, CLASS_DESCENDANTS_COMMAND]
		do
			create Result.make
		end

feature {NONE} -- Constants

	Option_name: STRING = "descendants"

end