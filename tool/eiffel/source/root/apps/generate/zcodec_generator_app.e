note
	description: "Command-line interface to ${ZCODEC_GENERATOR} command"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-04-29 8:55:38 GMT (Saturday 29th April 2023)"
	revision: "26"

class
	ZCODEC_GENERATOR_APP

inherit
	EL_COMMAND_LINE_APPLICATION [ZCODEC_GENERATOR]

	SHARED_DEV_ENVIRON

create
	make

feature {NONE} -- Implementation

	argument_specs: ARRAY [EL_COMMAND_ARGUMENT]
		do
			Result := <<
				optional_argument ("c_source", "C source code path", << file_must_exist >>),
				optional_argument ("template", "Eiffel codec template", << file_must_exist >>)
			>>
		end

	default_make: PROCEDURE [like command]
		do
			Result := agent {like command}.make (default_decoder_c_path, "doc/zcodec/template.evol")
		end

	default_decoder_c_path: FILE_PATH
		do
			Result := Dev_environ.Eiffel_loop_dir + "contrib/C/VTD-XML-2.7/source/decoder.c"
		end

end