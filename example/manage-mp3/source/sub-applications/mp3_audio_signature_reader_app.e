note
	description: "Summary description for {AUDIO_UUID_READER_APP}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-15 11:36:03 GMT (Sunday 15th October 2017)"
	revision: "6"

class
	MP3_AUDIO_SIGNATURE_READER_APP

inherit
	EL_COMMAND_LINE_SUB_APPLICATION [MP3_AUDIO_SIGNATURE_READER]
		redefine
			Option_name
		end

create
	make

feature {NONE} -- Implementation

	argument_specs: ARRAY [like specs.item]
		do
			Result := <<
				valid_required_argument ("music", "Location of music files", << directory_must_exist >>),
				optional_argument ("clean_up", "Remove duplicates with same name")
			>>
		end

	default_make: PROCEDURE
		do
			Result := agent {like command}.make ("", False)
		end

feature {NONE} -- Constants

	Option_name: STRING = "read_signatures"

	Description: STRING = "Read MP3 audio signatures"

	Log_filter: ARRAY [like CLASS_ROUTINES]
			--
		do
			Result := <<
				[{MP3_AUDIO_SIGNATURE_READER_APP}, "*"],
				[{MP3_AUDIO_SIGNATURE_READER}, "*"]
			>>
		end

end
