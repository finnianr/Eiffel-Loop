note
	description: "Ftp website 2"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 19:24:49 GMT (Saturday 19th May 2018)"
	revision: "4"

class
	EL_FTP_WEBSITE_2

inherit
	ANY
	
	EL_MODULE_LIO

	EL_MODULE_USER_INPUT

create
	make, make_from_node

feature -- Element change

	make_from_node (ftp_site_node: EL_XPATH_NODE_CONTEXT)
			--
		do
			make (ftp_site_node.string_at_xpath ("url"), ftp_site_node.string_32_at_xpath ("user-home"))
		end

	make (url: ZSTRING; user_home_directory: EL_DIR_PATH)
		local
			ftp_site: FTP_URL
		do
			create ftp_site.make (url.to_latin_1)
			if url.is_empty then
				ftp := Default_ftp
			else
				lio.put_string_field ("url", ftp_site.path)
				lio.put_new_line
				lio.put_path_field ("user-home", user_home_directory.as_unix)
				lio.put_new_line
				create ftp.make (ftp_site)
				ftp.set_home_directory (user_home_directory.as_unix)
				ftp.set_write_mode
				ftp.set_binary_mode
			end
		end

feature -- Basic operations

	do_ftp_upload (file_and_destination_paths: LIST [like ftp.Type_source_destination])
		require
			initialized: is_initialized
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

feature -- Status query

	is_initialized: BOOLEAN
		do
			Result := ftp /= Default_ftp
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
				lio.put_new_line
				lio.put_line ("ERROR: login failed")
			end
		end

	set_login_detail (prompt: ZSTRING; setter: PROCEDURE; get_detail_action: FUNCTION [STRING])
		local
			detail: ZSTRING
		do
			lio.put_new_line
			detail := User_input.line (prompt)
			if detail.is_empty then
				-- Use previous value
				detail := get_detail_action (ftp.address)
			end
			setter (detail.to_latin_1)
		end

	ftp: EL_FTP_PROTOCOL_2

feature {NONE} -- Constants

	Default_ftp: EL_FTP_PROTOCOL_2
		once ("PROCESS")
			create Result.make_default
		end

end
