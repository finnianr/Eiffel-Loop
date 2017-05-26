note
	description: "Summary description for {AUDIO_UUID_READER_APP}."

	

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-05-22 8:58:37 GMT (Monday 22nd May 2017)"
	revision: "2"

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

	make_action: PROCEDURE [like default_operands]
		do
			Result := agent command.make
		end

	default_operands: TUPLE [music_path: EL_DIR_PATH; clean_up: BOOLEAN]
		do
			create Result
			Result.music_path := ""
			Result.clean_up := False
		end

	argument_specs: ARRAY [like Type_argument_specification]
		do
			Result := <<
				required_existing_path_argument ("music", "Location of music files"),
				optional_argument ("clean_up", "Remove duplicates with same name")
			>>
		end

feature {NONE} -- Constants

	Option_name: STRING = "read_signatures"

	Description: STRING = "Read MP3 audio signatures"

	Log_filter: ARRAY [like Type_logging_filter]
			--
		do
			Result := <<
				[{MP3_AUDIO_SIGNATURE_READER_APP}, "*"],
				[{MP3_AUDIO_SIGNATURE_READER}, "*"]
			>>
		end

end