note
	description: "Eros application command options"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-02-16 10:15:06 GMT (Friday 16th February 2024)"
	revision: "6"

class
	EROS_APPLICATION_COMMAND_OPTIONS

inherit
	EL_APPLICATION_COMMAND_OPTIONS
		redefine
			initialize_fields, Help_text
		end

	EROS_REMOTE_CALL_CONSTANTS

create
	make, make_default

feature {NONE} -- Initialization

	initialize_fields
		do
			duration := 5
		end

feature -- Options

	binary: BOOLEAN

	duration: INTEGER
		-- running time in seconds

feature -- Access

	running_time_secs: INTEGER
		do
			Result := duration
		end

	protocol: INTEGER
		do
			if binary then
				Result := Type_binary
			else
				Result := Type_plaintext
			end
		end

feature {NONE} -- Constants

	Help_text: STRING
		once
			Result := joined (Precursor, "[
				binary:
					Use binary transmission protocol
				duration:
					Running time in seconds
			]")
		end
end