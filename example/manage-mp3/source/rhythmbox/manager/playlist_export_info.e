note
	description: "Playlist export info"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-09-10 8:33:33 GMT (Tuesday 10th September 2019)"
	revision: "4"

class
	PLAYLIST_EXPORT_INFO

inherit
	EL_REFLECTIVE_EIF_OBJ_BUILDER_CONTEXT
		rename
			make_default as make,
			xml_names as export_default,
			element_node_type as	Attribute_node
		redefine
			make, on_context_exit
		end

	M3U_PLAY_LIST_CONSTANTS

	EL_MODULE_ZSTRING

create
	make

feature {NONE} -- Initialization

	make
		do
			Precursor
			subdirectory_name := Default_playlists_subdirectory_name
			m3u_extension := Default_m3u_extension
		end

feature -- Access

	m3u_extension: ZSTRING

	root: ZSTRING

	subdirectory_name: ZSTRING

feature -- Status query

	is_windows_path: BOOLEAN
		do
			Result := Zstring.starts_with_drive (root)
		end

feature -- Event handling

	on_context_exit
		do
			M3U.play_list_root := root
		end

feature {NONE} -- Constants

	Default_m3u_extension: ZSTRING
		once
			Result := "m3u"
		end

	Default_playlists_subdirectory_name: ZSTRING
		once
			Result := "playlists"
		end
end
