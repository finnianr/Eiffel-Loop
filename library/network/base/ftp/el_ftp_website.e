note
	description: "FTP uploader for website"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-08-21 8:07:23 GMT (Monday 21st August 2023)"
	revision: "18"

class
	EL_FTP_WEBSITE

inherit
	EL_FTP_PROTOCOL
		rename
			make as make_protocol
		end

	EL_MODULE_LIO

	EL_MODULE_TRACK

create
	make

feature -- Element change

	make (a_config: EL_FTP_CONFIGURATION)
		do
			make_write (a_config)
			if is_lio_enabled then
				lio.put_string_field ("url", a_config.url.path)
				lio.put_new_line
				lio.put_path_field ("user-home", a_config.user_home_dir)
				lio.put_new_line
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
			Result := config.url.host.count > 0
		end

end