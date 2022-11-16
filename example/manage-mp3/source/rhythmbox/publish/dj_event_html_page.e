note
	description: "Dj event html page"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:03 GMT (Tuesday 15th November 2022)"
	revision: "8"

class
	DJ_EVENT_HTML_PAGE

inherit
	EL_ARRAYED_LIST [HTML_SONG]
		rename
			make as make_list
		end

	EVOLICITY_SERIALIZEABLE
		undefine
			is_equal, copy
		redefine
			make_default, getter_function_table
		end

create
	make

feature {NONE} -- Initialization

	make_default
		do
			make_list (20)
			Precursor
		end

	make (a_DJ_event: like DJ_event; a_template_path, a_output_path: like output_path)
		local
			playlist_duration: TIME_DURATION; tanda_type: ZSTRING
			song: RBOX_SONG; played_list: RBOX_PLAYLIST
		do
			make_from_template_and_output (a_template_path, a_output_path)
			DJ_event := a_DJ_event
			create played_list.make_default
			played_list.append (dj_event.less_unplayed)
			grow (played_list.count)
			tanda_type := once "Tango"
			create playlist_duration.make_by_seconds (0)
			from played_list.start until played_list.after loop
				song := played_list.song
				if song.is_cortina then
					tanda_type := played_list.cortina_tanda_type
				end
				extend (create {HTML_SONG}.make (song, DJ_event.start_time + playlist_duration, tanda_type))
				playlist_duration.second_add (song.duration)
				played_list.forth
			end
		end

feature {NONE} -- Implementation

	DJ_event: DJ_EVENT_PLAYLIST

feature {NONE} -- Evolicity fields

	getter_function_table: like getter_functions
			--
		do
			create Result.make (<<
				["DJ_event", agent: like DJ_event do Result := DJ_event end],
				["DJ_event_playlist", agent: ITERABLE [HTML_SONG] do Result := Current end]
			>>)
		end

feature {NONE} -- Constants

	Template: STRING = ""

end