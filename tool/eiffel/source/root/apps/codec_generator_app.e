note
	description: "Command-line interface to [$source CODEC_GENERATOR] command"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-01-06 14:18:21 GMT (Thursday 6th January 2022)"
	revision: "16"

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
				required_argument ("c_source", "C source code path"),
				required_argument ("template", "Eiffel codec template")
			>>
		end

	default_make: PROCEDURE [like command]
		do
			Result := agent {like command}.make ("", "")
		end

feature {NONE} -- Constants

	Option_name: STRING = "generate_codecs"

	Description: STRING = "Generate Eiffel codecs from VTD-XML C source"

end