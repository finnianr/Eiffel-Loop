note
	description: "Eros application command options"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-19 16:23:12 GMT (Sunday 19th January 2020)"
	revision: "3"

class
	EROS_APPLICATION_COMMAND_OPTIONS

inherit
	EL_APPLICATION_COMMAND_OPTIONS
		redefine
			initialize_fields, Help_text
		end

	EROS_REMOTE_CALL_CONSTANTS
		undefine
			is_equal
		end

create
	make

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
			Result := Precursor + New_line + "[
				binary:
					Use binary transmission protocol
				duration:
					Running time in seconds
			]"
		end
end
