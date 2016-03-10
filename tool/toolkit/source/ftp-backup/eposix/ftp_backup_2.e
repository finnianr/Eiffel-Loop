note
	description: "EPOSIX version of FTP_BACKUP"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:34 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	FTP_BACKUP_2

obsolete "[
	Use FTP_BACKUP. Works only if remote directory already exists.
]"

inherit
	FTP_BACKUP
		redefine
			ftp_files
		end

create
	make

feature {NONE} -- Implementation: routines

	ftp_files (server_name, user_name, user_home_directory, user_password: STRING)
			--
		local
			ftp: FTP_PROTOCOL_2
		do
			create ftp.make (server_name, user_name, user_password)
			ftp.set_home_directory (user_home_directory)
			ftp.open
			if ftp.is_positive_completion_reply then
				ftp.type_binary
				from upload_list.start until upload_list.after loop
					(agent ftp.upload_file).call (upload_list.item)
					upload_list.forth
				end
				ftp.quit
				ftp.close
			else
				log.put_line ("Could not open site")
			end

		end

end
