note
	description: "Fields from `rhythmdb.c' for Rhythmbox version 3.0.1"
	notes: "[
		Generated from C array by utility [$source GENERATE_RBOX_DATABASE_FIELD_ENUM_APP]
		
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
	date: "2023-07-16 15:44:53 GMT (Sunday 16th July 2023)"
	revision: "13"

class
	RBOX_DATABASE_FIELD_ENUM

inherit
	EL_ENUMERATION_NATURAL_16
		rename
			foreign_naming as kebab_case
		redefine
			initialize_fields, make
		end

create
	make

feature {NONE} -- Initialization

	initialize_fields
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
			create sorted.make_from_array (list.to_array)
			sorted.sort
			create element_cache_table.make (count, agent new_element)
		end

feature -- Fields A

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

feature -- Fields B to G

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

feature -- Fields H to P

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

feature -- Fields R to Z

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

	always_saved_set: ARRAY [NATURAL_16]
		-- Fields that are always saved in XML media item entries even when empty
		once
			Result := << artist, album, date, genre, title >>
		end

	sorted: SORTABLE_ARRAY [NATURAL_16]

	type (field_code: NATURAL_16): NATURAL_16
		do
			Result := field_code & 0xFF
		end

	type_group_table: EL_FUNCTION_GROUP_TABLE [NATURAL_16, NATURAL_16]
		-- fields grouped by `type'
		do
			create Result.make_from_list (agent type, sorted)
		end

	xml_element (field_code: NATURAL_16): XML_TEXT_ELEMENT
		do
			Result := element_cache_table.item (field_code)
		end

feature -- Status query

	is_string_type (field_code: NATURAL_16): BOOLEAN
		do
			Result := type (field_code) = G_type_string
		end

feature {NONE} -- Constants

	G_type_boolean: NATURAL_16 = 0

	G_type_double: NATURAL_16 = 0x1

	G_type_string: NATURAL_16 = 0x2

	G_type_uint64: NATURAL_16 = 0x4

	G_type_ulong: NATURAL_16 = 0x8

feature {NONE} -- Implementation

	numbered_boolean (n: INTEGER): NATURAL_16
		do
			Result := (n.to_natural_16 |<< 8) | G_type_boolean
		end

	numbered_double (n: INTEGER): NATURAL_16
		do
			Result := (n.to_natural_16 |<< 8) | G_type_double
		end

	numbered_string (n: INTEGER): NATURAL_16
		do
			Result := (n.to_natural_16 |<< 8) | G_type_string
		end

	numbered_uint64 (n: INTEGER): NATURAL_16
		do
			Result := (n.to_natural_16 |<< 8) | G_type_uint64
		end

	numbered_ulong (n: INTEGER): NATURAL_16
		do
			Result := (n.to_natural_16 |<< 8) | G_type_ulong
		end

	hi_byte (n: INTEGER): NATURAL_16
		do
			Result := n.to_natural_16 |<< 8
		end

	new_element (field_code: NATURAL_16): XML_TEXT_ELEMENT
		do
			create Result.make_empty (name (field_code))
		end

feature {NONE} -- Internal attributes

	element_cache_table: EL_CACHE_TABLE [XML_TEXT_ELEMENT, NATURAL_16]

end