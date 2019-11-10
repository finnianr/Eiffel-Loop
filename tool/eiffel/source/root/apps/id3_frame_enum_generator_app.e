note
	description: "Command line interface to [$source ID3_FRAME_ENUM_GENERATOR]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-11-10 18:29:17 GMT (Sunday 10th November 2019)"
	revision: "1"

class
	ID3_FRAME_ENUM_GENERATOR_APP

inherit
	EL_COMMAND_LINE_SUB_APPLICATION [ID3_FRAME_ENUM_GENERATOR]
		redefine
			Option_name
		end

create
	make

feature {NONE} -- Implementation

	argument_specs: ARRAY [EL_COMMAND_ARGUMENT]
		do
			Result := <<
				required_argument ("text", "Path to specification file")
			>>
		end

	default_make: PROCEDURE [like command]
		do
			Result := agent {like command}.make ("")
		end

feature {NONE} -- Constants

	Option_name: STRING = "generate_id3_codes"

	Description: STRING = "Generate ID3 frame code enumeration source in workarea"

end
