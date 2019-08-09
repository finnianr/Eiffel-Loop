note
	description: "Summary description for {EL_UNIX_SIGNALS}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

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
