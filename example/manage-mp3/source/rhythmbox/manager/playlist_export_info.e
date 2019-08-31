note
	description: "Playlist export info"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-08-31 12:39:50 GMT (Saturday 31st August 2019)"
	revision: "1"

class
	PLAYLIST_EXPORT_INFO

inherit
	EL_REFLECTIVE_EIF_OBJ_BUILDER_CONTEXT
		rename
			make_default as make,
			xml_names as export_default,
			element_node_type as	Attribute_node
		redefine
			make
		end

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

	root: ZSTRING

	subdirectory_name: ZSTRING

	m3u_extension: ZSTRING

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
