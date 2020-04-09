note
	description: "Rbox database field enum"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-04-09 10:35:22 GMT (Thursday 9th April 2020)"
	revision: "1"

class
	RBOX_DATABASE_FIELD_ENUM

inherit
	EL_ENUMERATION [NATURAL_16]
		rename
			import_name as from_kebab_case,
			export_name as to_kebab_case
		export
			{NONE} all
			{ANY} value, is_valid_value, name, list
		redefine
			initialize_fields, make
		end

create
	make

feature {NONE} -- Initialization

	initialize_fields
		do
			-- order is the same as in C source file: rhythmdb.c
			title := (1).to_natural_16 |<< 8 | G_type_string
			genre := (2).to_natural_16 |<< 8 | G_type_string
			artist := (3).to_natural_16 |<< 8 | G_type_string
			album := (4).to_natural_16 |<< 8 | G_type_string
			track_number := (5).to_natural_16 |<< 8 | G_type_ulong
			disc_number := (6).to_natural_16 |<< 8 | G_type_ulong
			duration := (7).to_natural_16 |<< 8 | G_type_ulong
			file_size := (8).to_natural_16 |<< 8 | G_type_uint64
			location := (9).to_natural_16 |<< 8 | G_type_string
			mountpoint := (10).to_natural_16 |<< 8 | G_type_string
			mtime := (11).to_natural_16 |<< 8 | G_type_ulong
			first_seen := (12).to_natural_16 |<< 8 | G_type_ulong
			last_seen := (13).to_natural_16 |<< 8 | G_type_ulong
			rating := (14).to_natural_16 |<< 8 | G_type_double
			play_count := (15).to_natural_16 |<< 8 | G_type_ulong
			last_played := (16).to_natural_16 |<< 8 | G_type_ulong
			bitrate := (17).to_natural_16 |<< 8 | G_type_ulong
			date := (18).to_natural_16 |<< 8 | G_type_ulong
			replaygain_track_gain := (19).to_natural_16 |<< 8 | G_type_double
			replaygain_track_peak := (20).to_natural_16 |<< 8 | G_type_double
			replaygain_album_gain := (21).to_natural_16 |<< 8 | G_type_double
			replaygain_album_peak := (22).to_natural_16 |<< 8 | G_type_double
			media_type := (23).to_natural_16 |<< 8 | G_type_string
			title_sort_key := (24).to_natural_16 |<< 8 | G_type_string
			genre_sort_key := (25).to_natural_16 |<< 8 | G_type_string
			artist_sort_key := (26).to_natural_16 |<< 8 | G_type_string
			album_sort_key := (27).to_natural_16 |<< 8 | G_type_string
			title_folded := (28).to_natural_16 |<< 8 | G_type_string
			genre_folded := (29).to_natural_16 |<< 8 | G_type_string
			artist_folded := (30).to_natural_16 |<< 8 | G_type_string
			album_folded := (31).to_natural_16 |<< 8 | G_type_string
			last_played_str := (32).to_natural_16 |<< 8 | G_type_string
			hidden := (33).to_natural_16 |<< 8 | G_type_boolean
			playback_error := (34).to_natural_16 |<< 8 | G_type_string
			first_seen_str := (35).to_natural_16 |<< 8 | G_type_string
			last_seen_str := (36).to_natural_16 |<< 8 | G_type_string
			search_match := (37).to_natural_16 |<< 8 | G_type_string
			year := (38).to_natural_16 |<< 8 | G_type_ulong
			keyword := (39).to_natural_16 |<< 8 | G_type_string
			status := (40).to_natural_16 |<< 8 | G_type_ulong
			description := (41).to_natural_16 |<< 8 | G_type_string
			subtitle := (42).to_natural_16 |<< 8 | G_type_string
			summary := (43).to_natural_16 |<< 8 | G_type_string
			lang := (44).to_natural_16 |<< 8 | G_type_string
			copyright := (45).to_natural_16 |<< 8 | G_type_string
			image := (46).to_natural_16 |<< 8 | G_type_string
			post_time := (47).to_natural_16 |<< 8 | G_type_ulong
			mb_trackid := (48).to_natural_16 |<< 8 | G_type_string
			mb_artistid := (49).to_natural_16 |<< 8 | G_type_string
			mb_albumid := (50).to_natural_16 |<< 8 | G_type_string
			mb_albumartistid := (51).to_natural_16 |<< 8 | G_type_string
			mb_artistsortname := (52).to_natural_16 |<< 8 | G_type_string
			album_sortname := (53).to_natural_16 |<< 8 | G_type_string
			artist_sortname_sort_key := (54).to_natural_16 |<< 8 | G_type_string
			artist_sortname_folded := (55).to_natural_16 |<< 8 | G_type_string
			album_sortname_sort_key := (56).to_natural_16 |<< 8 | G_type_string
			album_sortname_folded := (57).to_natural_16 |<< 8 | G_type_string
			comment := (58).to_natural_16 |<< 8 | G_type_string
			album_artist := (59).to_natural_16 |<< 8 | G_type_string
			album_artist_sort_key := (60).to_natural_16 |<< 8 | G_type_string
			album_artist_folded := (61).to_natural_16 |<< 8 | G_type_string
			album_artist_sortname := (62).to_natural_16 |<< 8 | G_type_string
			album_artist_sortname_sort_key := (63).to_natural_16 |<< 8 | G_type_string
			album_artist_sortname_folded := (64).to_natural_16 |<< 8 | G_type_string
			beats_per_minute := (65).to_natural_16 |<< 8 | G_type_double
			composer := (66).to_natural_16 |<< 8 | G_type_string
			composer_sort_key := (67).to_natural_16 |<< 8 | G_type_string
			composer_folded := (68).to_natural_16 |<< 8 | G_type_string
			composer_sortname := (69).to_natural_16 |<< 8 | G_type_string
			composer_sortname_sort_key := (70).to_natural_16 |<< 8 | G_type_string
			composer_sortname_folded := (71).to_natural_16 |<< 8 | G_type_string
		end

	make
		local
			l_list: EL_SORTABLE_ARRAYED_LIST [NATURAL_16]
		do
			Precursor
			create l_list.make_from_array (name_by_value.current_keys)
			l_list.sort
			sorted := l_list.to_array
			create element_cache_table.make (count, agent new_element)
		end

feature -- Fields

	album: NATURAL_16

	album_artist: NATURAL_16

	album_artist_folded: NATURAL_16

	album_artist_sort_key: NATURAL_16

	album_artist_sortname: NATURAL_16

	album_artist_sortname_folded: NATURAL_16

	album_artist_sortname_sort_key: NATURAL_16

	album_folded: NATURAL_16

	album_sort_key: NATURAL_16

	album_sortname: NATURAL_16

	album_sortname_folded: NATURAL_16

	album_sortname_sort_key: NATURAL_16

	artist: NATURAL_16

	artist_folded: NATURAL_16

	artist_sort_key: NATURAL_16

	artist_sortname_folded: NATURAL_16

	artist_sortname_sort_key: NATURAL_16

	beats_per_minute: NATURAL_16

	bitrate: NATURAL_16

	comment: NATURAL_16

	composer: NATURAL_16

	composer_folded: NATURAL_16

	composer_sort_key: NATURAL_16

	composer_sortname: NATURAL_16

	composer_sortname_folded: NATURAL_16

	composer_sortname_sort_key: NATURAL_16

	copyright: NATURAL_16

	date: NATURAL_16

	description: NATURAL_16

	disc_number: NATURAL_16

	duration: NATURAL_16

	file_size: NATURAL_16

	first_seen: NATURAL_16

	first_seen_str: NATURAL_16

	genre: NATURAL_16

	genre_folded: NATURAL_16

	genre_sort_key: NATURAL_16

	hidden: NATURAL_16

	image: NATURAL_16

	keyword: NATURAL_16

	lang: NATURAL_16

	last_played: NATURAL_16

	last_played_str: NATURAL_16

	last_seen: NATURAL_16

	last_seen_str: NATURAL_16

	location: NATURAL_16

	mb_albumartistid: NATURAL_16

	mb_albumid: NATURAL_16

	mb_artistid: NATURAL_16

	mb_artistsortname: NATURAL_16

	mb_trackid: NATURAL_16

	media_type: NATURAL_16

	mountpoint: NATURAL_16

	mtime: NATURAL_16

	play_count: NATURAL_16

	playback_error: NATURAL_16

	post_time: NATURAL_16

	rating: NATURAL_16

	replaygain_album_gain: NATURAL_16

	replaygain_album_peak: NATURAL_16

	replaygain_track_gain: NATURAL_16

	replaygain_track_peak: NATURAL_16

	search_match: NATURAL_16

	status: NATURAL_16

	subtitle: NATURAL_16

	summary: NATURAL_16

	title: NATURAL_16

	title_folded: NATURAL_16

	title_sort_key: NATURAL_16

	track_number: NATURAL_16

	year: NATURAL_16

feature -- Access

	sorted: ARRAY [NATURAL_16]

	type (field_code: NATURAL_16): NATURAL_16
		do
			Result := field_code & 0xFF
		end

	xml_element (field_code: NATURAL_16): EL_XML_TEXT_ELEMENT
		do
			Result := element_cache_table.item (field_code)
		end

feature -- Constants

	G_type_boolean: NATURAL_16 = 0

	G_type_double: NATURAL_16 = 0x1

	G_type_string: NATURAL_16 = 0x2

	G_type_uint64: NATURAL_16 = 0x4

	G_type_ulong: NATURAL_16 = 0x8

feature {NONE} -- Implementation

	new_element (field_code: NATURAL_16): EL_XML_TEXT_ELEMENT
		do
			create Result.make_empty (Name (field_code))
		end

feature {NONE} -- Internal attributes

	element_cache_table: EL_CACHE_TABLE [EL_XML_TEXT_ELEMENT, NATURAL_16]
end
