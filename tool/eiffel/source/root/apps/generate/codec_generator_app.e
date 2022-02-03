note
	description: "Command-line interface to [$source CODEC_GENERATOR] command"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-03 13:05:19 GMT (Thursday 3rd February 2022)"
	revision: "19"

class
	CODEC_GENERATOR_APP

inherit
	EL_COMMAND_LINE_SUB_APPLICATION [CODEC_GENERATOR]
		redefine
			Option_name
		end

create
	make

feature {NONE} -- Implementation

	argument_specs: ARRAY [EL_COMMAND_ARGUMENT]
		do
			Result := <<
				required_argument ("c_source", "C source code path", No_checks),
				required_argument ("template", "Eiffel codec template", No_checks)
			>>
		end

	default_make: PROCEDURE [like command]
		do
			Result := agent {like command}.make ("", "")
		end

feature {NONE} -- Constants

	Option_name: STRING = "generate_codecs"

end