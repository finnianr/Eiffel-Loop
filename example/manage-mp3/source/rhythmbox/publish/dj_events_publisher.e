note
	description: "Summary description for {DJ_EVENTS_PUBLISHER}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-01-26 11:49:55 GMT (Monday 26th January 2015)"
	revision: "7"

class
	DJ_EVENTS_PUBLISHER

inherit
	EL_MODULE_USER_INPUT

	EL_MODULE_DIRECTORY

	EL_MODULE_LOG

create
	make

feature {NONE} -- Initiliazation

	make (a_config: like config; a_playlists: like playlists)
			--
		do
			config := a_config
			create playlists.make (a_playlists.count)
			across a_playlists as playlist loop
				if playlist.item.is_publishable then
					playlists.extend (playlist.item)
				end
			end
			create file_upload_list.make
		end

feature -- Basic operations

	publish
		local
			index_html_path, playlist_path: EL_FILE_PATH; website: EL_FTP_WEBSITE
			html_index: DJ_EVENTS_HTML_INDEX
			event_page: DJ_EVENT_HTML_PAGE
		do
			index_html_path := config.www_dir + "index.html"
			create html_index.make (playlists.to_array, config.www_dir + config.html_index_template, index_html_path)
			html_index.serialize
			file_upload_list.extend (new_copy_file_arguments (index_html_path, config.ftp_destination_dir))

			across playlists as list loop
				playlist_path := config.www_dir + list.item.html_page_name
				if not playlist_path.exists then
					create event_page.make (list.item, config.www_dir + config.html_template, playlist_path)
					event_page.serialize
					file_upload_list.extend (new_copy_file_arguments (playlist_path, config.ftp_destination_dir))
				end
			end
			if config.upload then
				log_or_io.put_string ("Upload pages (y/n) ")
				if user_input.entered_letter ('y') then
					create website.make (config.ftp_url, config.ftp_user_home)
					website.do_ftp_upload (file_upload_list)
				end
			end
		end

feature {NONE} -- Factory

	new_copy_file_arguments (
		source_path: EL_FILE_PATH; destination_dir: EL_DIR_PATH

	): TUPLE [source_path: EL_FILE_PATH; destination_dir: EL_DIR_PATH]
		do
			Result := [source_path, destination_dir]
		end

feature {NONE} -- Implementation: attributes

	file_upload_list: LINKED_LIST [like new_copy_file_arguments]

	config: DJ_EVENT_PUBLISHER_CONFIG

	playlists: EL_ARRAYED_LIST [DJ_EVENT_PLAYLIST]

end
