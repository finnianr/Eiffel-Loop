note
	description: "Unix signals"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:04 GMT (Tuesday 15th November 2022)"
	revision: "2"

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

	is_user_defined_1 (code: INTEGER): BOOLEAN
		do
			Result := code = Sigusr1
		end

feature -- Constants

	Termination: ARRAY [INTEGER]
		once
			Result := << Sigint, Sigterm >>
		end

end
