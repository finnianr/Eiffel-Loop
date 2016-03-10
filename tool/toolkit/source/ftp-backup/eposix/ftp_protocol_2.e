note
	description: "Summary description for {FTP_PROTOCOL_2}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:34 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	FTP_PROTOCOL_2

obsolete "[
	Use EL_FTP_PROTOCOL. Works only if remote directory already exists.
]"

inherit
	EPX_FTP_CLIENT

	EL_TRANSFER_COMMAND_CONSTANTS
		undefine
			is_equal
		end

	EL_LOGGING
		undefine
			is_equal
		end

	EL_FILE_ROUTINES
		rename
			put as put_environment
		undefine
			is_equal, sleep, change_working_directory
		end

create
	make

feature -- Access

	home_directory: STRING

feature -- Element change

	set_home_directory (a_home_directory: like home_directory)
			-- Set user home eg. /public/www
		do
			home_directory := a_home_directory
		ensure
			home_directory_assigned: home_directory = a_home_directory
		end

feature -- Basic operations

	upload_file (a_file_path: FILE_NAME; destination_directory: STRING)
			-- Upload a file to destination relative to user home directory
		require
			is_open: is_open
			file_to_upload_exists: file_exists (a_file_path)
		local
			destination_file_path: STRING
		do
			log.enter_with_args ("upload_file", << a_file_path, destination_directory >>)
			create destination_file_path.make_from_string (home_directory)
			destination_file_path.append_character ('/')
			destination_file_path.append (destination_directory)
			destination_file_path.append_character ('/')
			destination_file_path.append (file_name (a_file_path))

			store (destination_file_path)
			transfer_file_data (a_file_path)
			log.exit
		end

feature {NONE} -- Implementation

	transfer_file_data (a_file_path: FILE_NAME)
			--
		local
			file: RAW_FILE
			packet: MANAGED_POINTER
			l_count: INTEGER
		do
			log.enter_with_args ("transfer_file_data", << a_file_path >>)
			create packet.make (2048)
			create file.make_open_read (a_file_path)
			from until file.after loop
				if l_count \\ 60 = 0 then
					log.put_new_line
					log.put_string ("Uploading .")
				else
					log.put_character ('.')
				end
				file.read_to_managed_pointer (packet, 0, packet.count)
				if file.bytes_read > 0 then
					data_connection.write (packet.item, 0, file.bytes_read)
				end
				l_count := l_count + 1
			end
			file.close
			data_connection.close
			read_reply

			log.put_new_line
			log.put_string_field ("Server replied", last_reply)

			log.exit
		end

end
