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
	date: "2025-05-05 9:29:04 GMT (Monday 5th May 2025)"
	revision: "13"

class
	ID3_FRAME_CODE_CLASS_GENERATOR_APP

inherit
	EL_COMMAND_LINE_APPLICATION [ID3_FRAME_CODE_CLASS_GENERATOR]

	SHARED_EIFFEL_LOOP

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
			Result := eiffel_loop_dir #+ "contrib/C++/taglib/include/mpeg/id3v2"
		end

end