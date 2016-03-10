note
	description: "Summary description for {DETECT_RHYTHMBOX_COMMAND}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	DETECT_RHYTHMBOX_COMMAND

inherit
	EL_LINE_PROCESSED_OS_COMMAND
		rename
			make as make_general_command
		end

create
	make

feature {NONE} -- Initialization

	make
			--
		do
			make_general_command ("ps -C rhythmbox")
		end

feature -- Status query

	is_launched: BOOLEAN
		do
			Result := not has_error
		end

feature {NONE} -- Implementation

	reset
		do
		end
end
