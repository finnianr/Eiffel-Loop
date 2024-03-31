note
	description: "Command line interface to ${CLASS_DESCENDANTS_COMMAND}"
	notes: "[
		Usage:
		
			el_eiffel -descendants -out_dir doc/descendant -class $path -target $target_name
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-03-31 7:58:14 GMT (Sunday 31st March 2024)"
	revision: "20"

class
	CLASS_DESCENDANTS_APP

inherit
	EL_COMMAND_LINE_APPLICATION [CLASS_DESCENDANTS_COMMAND]
		redefine
			Option_name, visible_types
		end

	EL_STRING_8_CONSTANTS

create
	make

feature {NONE} -- Implementation

	argument_specs: ARRAY [EL_COMMAND_ARGUMENT]
		do
			Result := <<
				optional_argument ("build_dir", "Parent directory of EIFGENs", << file_must_exist >>),
				optional_argument ("out_dir", "Output directory path", No_checks),
				required_argument ("class", "Name of Eiffel class", No_checks),
				optional_argument ("target", "Target name used to identify ecf file", No_checks)
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

	visible_types: TUPLE [EL_OS_COMMAND]
		-- types with lio output visible in console
		-- See: {EL_CONSOLE_MANAGER_I}.show_all
		do
			create Result
		end

feature {NONE} -- Constants

	Option_name: STRING = "descendants"

end