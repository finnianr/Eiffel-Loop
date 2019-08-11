note
	description: "Unix signals"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-08-09 12:18:36 GMT (Friday 9th August 2019)"
	revision: "1"

class
	EL_UNIX_SIGNALS

inherit
	UNIX_SIGNALS

feature -- Access

	broken_pipe: INTEGER
		do
			Result := Sigpipe
		end

	broken_pipe_message: STRING
		do
			Result := meaning (broken_pipe)
		end

feature -- Status query

	is_termination (code: INTEGER): BOOLEAN
		do
			Result := Termination.has (code)
		end

feature -- Constants

	Termination: ARRAY [INTEGER]
		once
			Result := << Sigint, Sigterm >>
		end

end
