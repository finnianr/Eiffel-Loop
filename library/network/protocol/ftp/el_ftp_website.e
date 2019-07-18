note
	description: "Ftp website"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-07-01 9:47:18 GMT (Monday 1st July 2019)"
	revision: "6"

class
	EL_FTP_WEBSITE

inherit
	EL_FTP_PROTOCOL
		rename
			make as make_ftp
		end

	EL_MODULE_LIO

create
	make, make_from_node

feature -- Element change

	make (url: ZSTRING; user_home_directory: EL_DIR_PATH)
		local
			ftp_site: FTP_URL
		do
			create ftp_site.make (url.to_latin_1)
			if url.is_empty then
				make_default
			else
				if is_lio_enabled then
					lio.put_string_field ("url", ftp_site.path)
					lio.put_new_line
					lio.put_path_field ("user-home", user_home_directory.as_unix)
					lio.put_new_line
				end
				make_write (ftp_site)
				set_home_directory (user_home_directory)
			end
		end

	make_from_node (ftp_site_node: EL_XPATH_NODE_CONTEXT)
			--
		do
			make (ftp_site_node.string_at_xpath ("url"), ftp_site_node.string_32_at_xpath ("user-home"))
		end

feature -- Basic operations

	do_ftp_upload (upload_list: LIST [EL_FTP_UPLOAD_ITEM])
		require
			initialized: is_initialized
			logged_in: is_logged_in
		do
			change_home_dir
			upload_list.do_all (agent upload)
		end

feature -- Status query

	is_initialized: BOOLEAN
		do
			Result := address = Default_url
		end

end
