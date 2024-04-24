note
	description: "[
		[https://en.wikipedia.org/wiki/List_of_FTP_server_return_codes List of common FTP server return codes]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-04-24 15:54:37 GMT (Wednesday 24th April 2024)"
	revision: "4"

class
	EL_FTP_SERVER_REPLY_ENUM

inherit
	EL_ENUMERATION_NATURAL_16
		rename
			foreign_naming as English
		redefine
			initialize_fields, Description_table
		end

create
	make

feature {NONE} -- Initialization

	initialize_fields
		do
			about_to_open_data_connection := 150
			action_not_taken := 550
			closing_control_connection := 221
			closing_data_connection := 226
			command_not_implemented :=	202
			file_action_ok := 250
			file_status := 213
			service_ready := 220
			success := 200
			user_logged_in := 230
			user_name_okay := 331
			PATHNAME_created := 257
		end

feature -- Access

	about_to_open_data_connection: NATURAL_16

	action_not_taken: NATURAL_16

	closing_control_connection: NATURAL_16

	closing_data_connection: NATURAL_16

	command_not_implemented: NATURAL_16

	file_action_ok: NATURAL_16

	file_status: NATURAL_16

	service_ready: NATURAL_16

	success: NATURAL_16

	PATHNAME_created: NATURAL_16

	user_logged_in: NATURAL_16

	user_name_okay: NATURAL_16

feature {NONE} -- Constants

	Description_table: EL_IMMUTABLE_UTF_8_TABLE
		once
			create Result.make_by_indented ("[
				about_to_open_data_connection:
					File status okay; about to open data connection.
				action_not_taken:
					Requested action not taken. File unavailable (e.g., file not found, no access).
				closing_control_connection:
					Service closing control connection. Logged out if appropriate.
				closing_data_connection:
					Closing data connection. Requested file action successful (for example, file transfer or file abort).
				command_not_implemented:
					Command not implemented, superfluous at this site. 
				file_action_ok:
					Requested file action okay, completed.
				service_ready:
					Service ready for new user.
				success:
					The requested action has been successfully completed.
				user_logged_in:
					User logged in, proceed.
				user_name_okay:
					User name okay, need password.
			]")
		end

	English: EL_ENGLISH_NAME_TRANSLATER
		once
			create Result.make
			Result.set_uppercase_exception_set ("pathname")
		end

end