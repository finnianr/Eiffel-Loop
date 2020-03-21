note
	description: "Command line interface to [$source ID3_FRAME_CODE_CLASS_GENERATOR]"
	notes: "[
		Usage:
		
			el_eiffel -id3_frame_code_class_generator [-id3v2 <path to specification documents directory>]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-03-21 11:46:16 GMT (Saturday 21st March 2020)"
	revision: "2"

class
	ID3_FRAME_CODE_CLASS_GENERATOR_APP

inherit
	EL_COMMAND_LINE_SUB_APPLICATION [ID3_FRAME_CODE_CLASS_GENERATOR]

	EIFFEL_LOOP_TEST_CONSTANTS

create
	make

feature {NONE} -- Implementation

	argument_specs: ARRAY [EL_COMMAND_ARGUMENT]
		do
			Result := <<
				valid_optional_argument ("id3v2", "Path to id3v2 specifications directory", << file_must_exist >>)
			>>
		end

	default_make: PROCEDURE [like command]
		do
			Result := agent {like command}.make (ID3_v2_dir)
		end

feature {NONE} -- Constants

	ID3_v2_dir: EL_DIR_PATH
		once
			Result := Eiffel_loop_dir.joined_dir_path ("contrib/C++/taglib/include/mpeg/id3v2")
		end

	Description: STRING = "Generate ID3 frame code constant classes for ID3 versions 2.2, 2.3 and 2.4"

end
