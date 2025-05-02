note
	description: "Fields from `rhythmdb.c' for Rhythmbox version 3.0.1"
	notes: "[
		Generated from C array by utility ${GENERATE_RBOX_DATABASE_FIELD_ENUM_APP}
		
		**C array**
			static const RhythmDBPropertyDef rhythmdb_properties[] = {
				PROP_ENTRY(TYPE, G_TYPE_OBJECT, "type"),
				PROP_ENTRY(ENTRY_ID, G_TYPE_ULONG, "entry-id"),
				PROP_ENTRY(TITLE, G_TYPE_STRING, "title"),
				..
			}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-05-01 12:51:52 GMT (Thursday 1st May 2025)"
	revision: "20"

class
	RBOX_DATABASE_FIELD_ENUM

inherit
	EL_ENUMERATION_NATURAL_16
		rename
			new_table_text as Empty_text,
			description as enum_description,
			name_translater as kebab_case
		redefine
			initialize_fields, make
		end

	RBOX_ALBUM_FIELDS_ENUM undefine is_equal end

	RBOX_ARTIST_FIELDS_ENUM undefine is_equal end

	RBOX_COMPOSER_FIELDS_ENUM undefine is_equal end

	RBOX_MUSICBRAINZ_FIELDS_ENUM undefine is_equal end

	RBOX_REPLAYGAIN_FIELDS_ENUM undefine is_equal end

	RBOX_DATABASE_FIELD_TYPES undefine is_equal end
create
	make

feature {NONE} -- Initialization

	initialize_fields (field_list: EL_FIELD_LIST)
		-- number is order in C source file: rhythmdb.c
		do
			album_artist_folded := numbered_string (61)
			album_artist := numbered_string (59)
			album_artist_sort_key := numbered_string (60)
			album_artist_sortname_folded := numbered_string (64)
			album_artist_sortname := numbered_string (62)
			album_artist_sortname_sort_key := numbered_string (63)
			album_folded := numbered_string (31)
			album := numbered_string (4)
			album_sort_key := numbered_string (27)
			album_sortname_folded := numbered_string (57)
			album_sortname := numbered_string (53)
			album_sortname_sort_key := numbered_string (56)
			artist_folded := numbered_string (30)
			artist := numbered_string (3)
			artist_sort_key := numbered_string (26)
			artist_sortname_folded := numbered_string (55)
			artist_sortname_sort_key := numbered_string (54)
			comment := numbered_string (58)
			composer_folded := hi_byte (68)
			composer := hi_byte (66)
			composer_sort_key := hi_byte (67)
			composer_sortname_folded := hi_byte (71)
			composer_sortname := hi_byte (69)
			composer_sortname_sort_key := hi_byte (70)
			copyright := numbered_string (45)
			description := numbered_string (41)
			first_seen_str := numbered_string (35)
			genre_folded := numbered_string (29)
			genre := numbered_string (2)
			genre_sort_key := numbered_string (25)
			image := numbered_string (46)
			keyword := numbered_string (39)
			lang := numbered_string (44)
			last_played_str := numbered_string (32)
			last_seen_str := numbered_string (36)
			location := numbered_string (9)
			mb_albumartistid := numbered_string (51)
			mb_albumid := numbered_string (50)
			mb_artistid := numbered_string (49)
			mb_artistsortname := numbered_string (52)
			mb_trackid := numbered_string (48)
			media_type := numbered_string (23)
			mountpoint := numbered_string (10)
			playback_error := numbered_string (34)
			search_match := numbered_string (37)
			subtitle := numbered_string (42)
			summary := numbered_string (43)
			title_folded := numbered_string (28)
			title := numbered_string (1)
			title_sort_key := numbered_string (24)

			bitrate := numbered_ulong (17)
			date := numbered_ulong (18)
			disc_number := numbered_ulong (6)
			duration := numbered_ulong (7)
			first_seen := numbered_ulong (12)
			last_played := numbered_ulong (16)
			last_seen := numbered_ulong (13)
			mtime := numbered_ulong (11)
			play_count := numbered_ulong (15)
			post_time := numbered_ulong (47)
			status := numbered_ulong (40)
			track_number := numbered_ulong (5)
			year := numbered_ulong (38)

			beats_per_minute := numbered_double (65)
			rating := numbered_double (14)
			replaygain_track_gain := numbered_double (19)
			replaygain_track_peak := numbered_double (20)
			replaygain_album_gain := numbered_double (21)
			replaygain_album_peak := numbered_double (22)

			file_size := numbered_uint64 (8)
			hidden := numbered_boolean (33)
		end

	make
		do
			Precursor
			create sorted.make_from_array (as_list.to_array)
			sorted.sort
			create element_cache_table.make (count, agent new_element)
		end

feature -- Fields B to G

	beats_per_minute: N_16

	bitrate: N_16

	comment: N_16

	copyright: N_16

	date: N_16

	description: N_16

	disc_number: N_16

	duration: N_16

	file_size: N_16

	first_seen: N_16

	first_seen_str: N_16

	genre: N_16

	genre_folded: N_16

	genre_sort_key: N_16

feature -- Fields H to P

	hidden: N_16

	image: N_16

	keyword: N_16

	lang: N_16

	last_played: N_16

	last_played_str: N_16

	last_seen: N_16

	last_seen_str: N_16

	location: N_16

	media_type: N_16

	mountpoint: N_16

	mtime: N_16

	play_count: N_16

	playback_error: N_16

	post_time: N_16

feature -- Fields R

	rating: N_16

feature -- Fields S to Z

	search_match: N_16

	status: N_16

	subtitle: N_16

	summary: N_16

	title: N_16

	title_folded: N_16

	title_sort_key: N_16

	track_number: N_16

	year: N_16

feature -- Access

	always_saved_set: ARRAY [N_16]
		-- Fields that are always saved in XML media item entries even when empty
		once
			Result := << artist, album, date, genre, title >>
		end

	sorted: SORTABLE_ARRAY [N_16]

	type_group_table: EL_FUNCTION_GROUPED_SET_TABLE [N_16, N_16]
		-- fields grouped by `type'
		do
			create Result.make_from_list (agent type, sorted)
		end

	xml_element (field_code: N_16): XML_TEXT_ELEMENT
		do
			Result := element_cache_table.item (field_code)
		end

feature -- Status query

	is_string_type (field_code: N_16): BOOLEAN
		do
			Result := type (field_code) = G_type_string
		end

	all_non_string_fields_in_table (table: EL_FIELD_TABLE): BOOLEAN
		do
			Result := across sorted as field all
				not is_string_type (field.item) implies table.has_immutable (field_name (field.item))
			end
		end

feature {NONE} -- Implementation

	new_element (field_code: N_16): XML_TEXT_ELEMENT
		do
			create Result.make_empty (name (field_code))
		end

feature {NONE} -- Internal attributes

	element_cache_table: EL_AGENT_CACHE_TABLE [XML_TEXT_ELEMENT, N_16]

end