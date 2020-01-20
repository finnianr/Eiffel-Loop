note
	description: "Eros application options"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-20 9:26:29 GMT (Monday 20th January 2020)"
	revision: "1"

class
	EROS_APPLICATION_OPTIONS

inherit
	EL_APPLICATION_COMMAND_OPTIONS
		redefine
			initialize_fields, Help_text
		end

create
	make, make_default

feature {NONE} -- Initialization

	initialize_fields
		do
			Precursor
			port := 8000
			max_threads := 8
		end

feature -- Access

	port: INTEGER

	max_threads: INTEGER

feature {NONE} -- Constants

	Help_text: STRING
		once
			Result := joined (Precursor, "[
				port:
					Port number on which to listen for connections
				max_threads:
					Maximum number of threads to use for serving client request
			]")
		end
end
