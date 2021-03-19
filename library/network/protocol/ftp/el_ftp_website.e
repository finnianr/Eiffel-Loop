note
	description: "FTP uploader for website"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-03-15 11:32:27 GMT (Monday 15th March 2021)"
	revision: "13"

class
	EL_FTP_WEBSITE

inherit
	EL_FTP_PROTOCOL
		rename
			make as make_ftp
		end

	EL_MODULE_LIO

	EL_MODULE_TRACK

create
	make

feature -- Element change

	make (url: STRING; user_home_directory: EL_DIR_PATH)
		local
			ftp_site: FTP_URL
		do
			create ftp_site.make (url)
			if url.is_empty then
				make_default
			else
				if is_lio_enabled then
					lio.put_string_field ("url", ftp_site.path)
					lio.put_new_line
					lio.put_path_field ("user-home", user_home_directory)
					lio.put_new_line
				end
				make_write (ftp_site)
				set_home_directory (user_home_directory)
			end
		end

feature -- Basic operations

	do_ftp_upload (upload_list: LIST [EL_FTP_UPLOAD_ITEM])
		require
			initialized: is_initialized
			logged_in: is_logged_in
		do
			change_home_dir
			Track.progress (Console_display, upload_list.count, agent upload_list.do_all (agent upload))
			lio.put_line ("DONE")
		end

feature -- Status query

	is_initialized: BOOLEAN
		do
			Result := address /= Default_url
		end

end