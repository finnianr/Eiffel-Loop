note
	description: "[
		Auto-generated class from C source file `rhythmdb.c' using [$source GENERATE_RBOX_DATABASE_FIELDS_APP]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-04-07 18:17:51 GMT (Tuesday 7th April 2020)"
	revision: "1"

class
	RBOX_DATABASE_FIELDS

feature {NONE} -- Constants

	Field_type_table: EL_HASH_TABLE [INTEGER, STRING]
		once
			create Result.make (<<
				["title", G_type_string],
				["genre", G_type_string],
				["artist", G_type_string],
				["album", G_type_string],
				["track-number", G_type_ulong],
				["disc-number", G_type_ulong],
				["duration", G_type_ulong],
				["file-size", G_type_uint64],
				["location", G_type_string],
				["mountpoint", G_type_string],
				["mtime", G_type_ulong],
				["first-seen", G_type_ulong],
				["last-seen", G_type_ulong],
				["rating", G_type_double],
				["play-count", G_type_ulong],
				["last-played", G_type_ulong],
				["bitrate", G_type_ulong],
				["date", G_type_ulong],
				["replaygain-track-gain", G_type_double],
				["replaygain-track-peak", G_type_double],
				["replaygain-album-gain", G_type_double],
				["replaygain-album-peak", G_type_double],
				["media-type", G_type_string],
				["title-sort-key", G_type_string],
				["genre-sort-key", G_type_string],
				["artist-sort-key", G_type_string],
				["album-sort-key", G_type_string],
				["title-folded", G_type_string],
				["genre-folded", G_type_string],
				["artist-folded", G_type_string],
				["album-folded", G_type_string],
				["last-played-str", G_type_string],
				["hidden", G_type_boolean],
				["playback-error", G_type_string],
				["first-seen-str", G_type_string],
				["last-seen-str", G_type_string],
				["search-match", G_type_string],
				["year", G_type_ulong],
				["keyword", G_type_string],
				["status", G_type_ulong],
				["description", G_type_string],
				["subtitle", G_type_string],
				["summary", G_type_string],
				["lang", G_type_string],
				["copyright", G_type_string],
				["image", G_type_string],
				["post-time", G_type_ulong],
				["mb-trackid", G_type_string],
				["mb-artistid", G_type_string],
				["mb-albumid", G_type_string],
				["mb-albumartistid", G_type_string],
				["mb-artistsortname", G_type_string],
				["album-sortname", G_type_string],
				["artist-sortname-sort-key", G_type_string],
				["artist-sortname-folded", G_type_string],
				["album-sortname-sort-key", G_type_string],
				["album-sortname-folded", G_type_string],
				["comment", G_type_string],
				["album-artist", G_type_string],
				["album-artist-sort-key", G_type_string],
				["album-artist-folded", G_type_string],
				["album-artist-sortname", G_type_string],
				["album-artist-sortname-sort-key", G_type_string],
				["album-artist-sortname-folded", G_type_string],
				["beats-per-minute", G_type_double],
				["composer", G_type_string],
				["composer-sort-key", G_type_string],
				["composer-folded", G_type_string],
				["composer-sortname", G_type_string],
				["composer-sortname-sort-key", G_type_string],
				["composer-sortname-folded", G_type_string]
			>>)
		end

	G_type_string: INTEGER = 1

	G_type_ulong: INTEGER = 2

	G_type_uint64: INTEGER = 3

	G_type_double: INTEGER = 4

	G_type_boolean: INTEGER = 5

end
