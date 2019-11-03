note
	description: "Mp3 audio signature reader app"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-09-25 15:24:02 GMT (Wednesday 25th September 2019)"
	revision: "11"

class
	MP3_AUDIO_SIGNATURE_READER_APP

inherit
	EL_LOGGED_COMMAND_LINE_SUB_APPLICATION [MP3_AUDIO_SIGNATURE_READER]
		redefine
			Option_name
		end

create
	make

feature {NONE} -- Implementation

	argument_specs: ARRAY [EL_COMMAND_ARGUMENT]
		do
			Result := <<
				valid_required_argument ("music", "Location of music files", << directory_must_exist >>),
				optional_argument ("clean_up", "Remove duplicates with same name")
			>>
		end

	default_make: PROCEDURE [like command]
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
				[{MP3_AUDIO_SIGNATURE_READER_APP}, All_routines],
				[{MP3_AUDIO_SIGNATURE_READER}, All_routines]
			>>
		end

end
