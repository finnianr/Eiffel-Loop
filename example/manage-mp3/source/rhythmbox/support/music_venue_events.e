note
	description: "Summary description for {MUSIC_VENUE_EVENTS}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-09-30 17:26:29 GMT (Monday 30th September 2013)"
	revision: "5"

class
	MUSIC_VENUE_EVENTS

inherit
	EVOLICITY_EIFFEL_CONTEXT
		redefine
			getter_function_table
		end

	EL_MODULE_LOG

	EL_MODULE_FILE_SYSTEM

	EL_MODULE_PYXIS

	EL_MODULE_EVOLICITY_ENGINE

create
	make

feature {NONE} -- Initialization

	make (a_file_path: EL_FILE_PATH)
			--
		require
			is_pyxis_file: Pyxis.is_pyxis_file (a_file_path)
		do
			log.enter_with_args ("make", << file_path >> )
			make_eiffel_context
			file_path := a_file_path
			create root_xp_ctx.make_from_string (Pyxis.to_xml (a_file_path))
			playlist_template_path := file_path.parent.joined_file_path (
				root_xp_ctx.string_at_xpath ("/music-venue-events/playlist-template/text()")
			)
			index_template_path := file_path.parent.joined_file_path (
				root_xp_ctx.string_at_xpath ("/music-venue-events/index-template/text()")
			)

			create event_list.make (root_xp_ctx.context_list (XPath_music_venue_events).count)
			across root_xp_ctx.context_list (XPath_music_venue_events) as event loop
				event_list.extend (create {MUSIC_EVENT}.make (event.node))
			end
			root_xp_ctx.find_node ("/music-venue-events/ftp-site")
			if root_xp_ctx.node_found then
				ftp_site_node := root_xp_ctx.found_node
			else
				ftp_site_node := root_xp_ctx
			end
			root_xp_ctx.find_node ("/music-venue-events/ftp-destination-path/text()")
			if root_xp_ctx.node_found then
				ftp_destination_path := root_xp_ctx.found_node.normalized_string_value
			else
				create ftp_destination_path
			end
			Evolicity_engine.set_template_from_file (index_template_path)
			log.exit
		end

feature -- Access

	playlist_template_path: EL_FILE_PATH

	index_template_path: EL_FILE_PATH

	event_list: ARRAYED_LIST [MUSIC_EVENT]

	ftp_site_node: EL_XPATH_NODE_CONTEXT

	ftp_destination_path: EL_DIR_PATH

	file_path: EL_FILE_PATH
		-- Path to pyxis config file

feature -- Basic operations

	write_web_page (html_file_path: EL_FILE_PATH)
			--
		do
			Evolicity_engine.merge_to_file (index_template_path, Current, html_file_path)
		end

feature {NONE} -- Implementation: attributes

	root_xp_ctx: EL_XPATH_ROOT_NODE_CONTEXT

feature {NONE} -- Evolicity fields

	get_event_list: ITERABLE [MUSIC_EVENT]
			--
		do
			Result := event_list
		end

	getter_function_table: like getter_functions
			--
		do
			create Result.make (<<
				["event_list", agent get_event_list]
			>>)
		end

feature {NONE} -- Constants

	XPath_music_venue_events: STRING = "//music-venue-events/event"

end
