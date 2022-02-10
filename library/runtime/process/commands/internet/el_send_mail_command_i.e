note
	description: "Send mail command i"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-10 17:33:38 GMT (Thursday 10th February 2022)"
	revision: "11"

deferred class
	EL_SEND_MAIL_COMMAND_I

inherit
	EL_CAPTURED_OS_COMMAND_I
		redefine
			do_with_lines, getter_function_table, execute
		end

	EL_PLAIN_TEXT_LINE_STATE_MACHINE
		rename
			make as make_machine,
			do_with_lines as do_with_machine_lines
		end

feature {NONE} -- Initialization

	make (a_email: like email)
		do
			make_default; make_machine
			email := a_email
			create log_lines.make_empty
		end

feature -- Access

	email: EL_EMAIL

	log_lines: EL_ZSTRING_LIST

feature -- Basic operations

	execute
		do
			email.serialize
			Precursor
		end

feature {NONE} -- Implementation

	do_with_lines (lines: like new_output_lines)
		do
			do_with_machine_lines (agent find_message_accepted, lines)
			if has_error then
				lines.do_all (agent log_lines.extend)
			end
		end

feature {NONE} -- Line states

	find_message_accepted (line: ZSTRING)
		do
			if line.has_substring (Connecting_to_local) then
				has_error := True
				state := final

				-- If it's connecting to local, it's because it failed to send

				--	050 503-Rejecting due to poor sender reputation: 78.19.215.59
				--	050 503 Valid RCPT command must precede DATA
				--	050 >>> RSET
				--	050 250 Reset OK
				--	050 <finnian@localhost.localdomain>... Connecting to local...
				--	050 <finnian@localhost.localdomain>... Sent
				--	250 2.0.0 u7NFs1UU007567 Message accepted for delivery
				--	tanguero@eiffel-loop.com... Sent (u7NFs1UU007567 Message accepted for delivery)
				--	Closing connection to [127.0.0.1]

			elseif line.has_substring (Message_accepted) then
				state := final
			end
		end

feature {NONE} -- Evolicity reflection

	getter_function_table: like getter_functions
			--
		do
			Result := Precursor +
				["email_path", 	agent: ZSTRING do Result := email.email_path.escaped end] +
				["from_address", 	agent: ZSTRING do Result := email.from_address end] +
				["to_address",		agent: ZSTRING do Result := email.to_address end]
		end

feature {NONE} -- Constants

	Connecting_to_local: ZSTRING
		once
			Result := "Connecting to local"
		end

	Message_accepted: ZSTRING
		once
			Result := "Message accepted for delivery"
		end

end