note
	description: "Summary description for {EL_WEBSITE_ROUTINES}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-06-24 12:37:05 GMT (Monday 24th June 2013)"
	revision: "3"

class
	EL_WEBSITE_ROUTINES

inherit
	EL_MODULE_LOG

	EL_MODULE_USER_INPUT

feature -- Element change

	set_ftp_site (ftp_site_node: EL_XPATH_NODE_CONTEXT)
			--
		local
			ftp_site: STRING
			user_home_directory: EL_DIR_PATH
		do
			ftp_site := ftp_site_node.string_at_xpath ("url")
			user_home_directory := ftp_site_node.string_32_at_xpath ("user-home")
			user_home_directory.change_to_unix

			if not ftp_site.is_empty then
				log.put_string_field ("url", ftp_site)
				log.put_new_line
				log.put_path_field ("user-home", user_home_directory)
				log.put_new_line
				create ftp.make (create {FTP_URL}.make (ftp_site))
				ftp.set_home_directory (user_home_directory)
				ftp.set_write_mode
				ftp.set_binary_mode
			end
		end

feature -- Basic operations

	do_ftp_upload (file_and_destination_paths: LIST [like ftp.Type_source_destination])
			--
		do
			from until ftp.is_logged_in loop
				ftp.reset_error
				ftp.open
				if ftp.is_open then
					try_login
				end
			end
			ftp.upload (file_and_destination_paths)
			ftp.close
		end

feature {NONE} -- Implementation

	try_login
		require
			is_open: ftp.is_open
		do
			set_login_detail ("Enter FTP access username", agent ftp.set_username, agent {FTP_URL}.username)
			set_login_detail ("Password", agent ftp.set_password, agent {FTP_URL}.password)
			ftp.try_login
			if not ftp.is_logged_in then
				log_or_io.put_new_line
				log_or_io.put_line ("ERROR: login failed")
			end
		end

	set_login_detail (
		prompt: STRING; setter: PROCEDURE [EL_FTP_PROTOCOL, TUPLE]; get_detail_action: FUNCTION [FTP_URL, TUPLE, STRING]
	)
		local
			detail: STRING
		do
			log_or_io.put_new_line
			detail := User_input.line (prompt)
			if detail.is_empty then
				-- Use previous value
				detail := get_detail_action.item ([ftp.address])
			end
			setter.call ([detail])
		end

	ftp: EL_FTP_PROTOCOL

end
