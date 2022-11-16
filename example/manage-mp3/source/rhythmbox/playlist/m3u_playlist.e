note
	description: "M3U playlist"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:03 GMT (Tuesday 15th November 2022)"
	revision: "7"

class
	M3U_PLAYLIST

inherit
	EVOLICITY_SERIALIZEABLE

create
	make

feature {NONE} -- Initialization

	make (playlist: RBOX_PLAYLIST; is_windows_format: BOOLEAN; a_output_path: like output_path)
		do
			m3u_entry_list := playlist.m3u_entry_list (is_windows_format, is_nokia_phone)
			make_from_file (a_output_path)
		end

feature {NONE} -- Attributes

 	m3u_entry_list: EL_ZSTRING_LIST

 	is_nokia_phone: BOOLEAN
 		do
 		end

feature {NONE} -- Evolicity fields

	Template: STRING
		once
			Result := "[
				#EXTM3U
				#across $m3u_entry_list as $m3u_entry loop
				$m3u_entry.item
				#end
			]"
		end

	getter_function_table: like getter_functions
			--
		do
			create Result.make (<<
				["m3u_entry_list", 	agent: EL_ZSTRING_LIST do Result := m3u_entry_list end]
			>>)
		end

end