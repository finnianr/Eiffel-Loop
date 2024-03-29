note
	description: "Command line interface to ${ID3_FRAME_CODE_CLASS_GENERATOR}"
	notes: "[
		Usage:
		
			el_eiffel -id3_frame_code_class_generator [-id3v2 <path to specification documents directory>]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:27 GMT (Saturday 20th January 2024)"
	revision: "12"

class
	ID3_FRAME_CODE_CLASS_GENERATOR_APP

inherit
	EL_COMMAND_LINE_APPLICATION [ID3_FRAME_CODE_CLASS_GENERATOR]

	SHARED_DEV_ENVIRON

create
	make

feature {NONE} -- Implementation

	argument_specs: ARRAY [EL_COMMAND_ARGUMENT]
		do
			Result := <<
				optional_argument ("id3v2", "Path to id3v2 specifications directory", << file_must_exist >>)
			>>
		end

	default_make: PROCEDURE [like command]
		do
			Result := agent {like command}.make (ID3_v2_dir)
		end

feature {NONE} -- Constants

	ID3_v2_dir: DIR_PATH
		once
			Result := Dev_environ.Eiffel_loop_dir #+ "contrib/C++/taglib/include/mpeg/id3v2"
		end

end