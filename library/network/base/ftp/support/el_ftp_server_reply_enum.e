note
	description: "[
		[https://en.wikipedia.org/wiki/List_of_FTP_server_return_codes List of common FTP server return codes]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-30 14:48:41 GMT (Wednesday 30th April 2025)"
	revision: "12"

class
	EL_FTP_SERVER_REPLY_ENUM

inherit
	EL_TABLE_ENUMERATION_INTEGER_16
		rename
			name_translater as English
		redefine
			initialize, values_in_text
		end

create
	make

feature {NONE} -- Initialization

	initialize
		do
			valid_enter_passive_mode :=  << entering_passive_mode >>
			valid_file_action := << success, file_action_ok >>
			valid_username := << user_logged_in, user_name_okay >>
			valid_password := << command_not_implemented, user_logged_in >>
			valid_response := << success >>
		end

feature -- Valid server responses

	valid_enter_passive_mode: ARRAY [INTEGER_16]

	valid_file_action: ARRAY [INTEGER_16]

	valid_password: ARRAY [INTEGER_16]

	valid_response: ARRAY [INTEGER_16]
		-- generic response

	valid_username: ARRAY [INTEGER_16]

feature -- Status query

	values_in_text: BOOLEAN = True
		-- `True' if enumeration values are found in the `new_table_text' as the first
		-- word of each description.

feature -- Access

	PATHNAME_created: INTEGER_16

	about_to_open_data_connection: INTEGER_16

	action_not_taken: INTEGER_16

	closing_control_connection: INTEGER_16

	closing_data_connection: INTEGER_16

	command_not_implemented: INTEGER_16

	entering_passive_mode: INTEGER_16

	file_action_ok: INTEGER_16

	file_status: INTEGER_16

	service_ready: INTEGER_16

	success: INTEGER_16

	user_logged_in: INTEGER_16

	user_name_okay: INTEGER_16

feature {NONE} -- Implementation

	new_table_text: STRING
		do
			Result := "[
				about_to_open_data_connection:
					150 File status okay; about to open data connection.
				action_not_taken:
					550 Requested action not taken. File unavailable (e.g., file not found, no access).
				closing_control_connection:
					221 Service closing control connection. Logged out if appropriate.
				closing_data_connection:
					226 Closing data connection. Requested file action successful
					(for example, file transfer or file abort).
				command_not_implemented:
					202 Command not implemented, superfluous at this site.
				entering_passive_mode:
					227 Entering passive mode.
				file_action_ok:
					250 Requested file action okay, completed.
				file_status:
					213 File status.
				pathname_created:
					257 PATHNAME created.
				service_ready:
					220 Service ready for new user.
				success:
					200 The requested action has been successfully completed.
				user_logged_in:
					230 User logged in, proceed.
				user_name_okay:
					331 User name okay, need password.
			]"
		end

feature {NONE} -- Constants

	English: EL_ENGLISH_NAME_TRANSLATER
		once
			create Result.make
			Result.set_uppercase_exception_set ("pathname")
		end

end