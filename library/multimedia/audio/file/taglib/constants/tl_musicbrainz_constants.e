note
	description: "Constants associated with [https://musicbrainz.org/ MusicBrainz] supplementary ID3 data"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-03-24 11:57:29 GMT (Tuesday 24th March 2020)"
	revision: "2"

deferred class
	TL_MUSICBRAINZ_CONSTANTS

inherit
	EL_ANY_SHARED

	EL_MODULE_TUPLE

feature {NONE} -- Constants

	Http_musicbrainz_org: ZSTRING
		once
			Result := "http://musicbrainz.org"
		end

	MB_field: TUPLE [artistid, albumid, albumartistid, artistsortname: STRING]
		once
			create Result
			Tuple.fill (Result, "artistid, albumid, albumartistid, artistsortname")
		end

	Musicbrainz_fields: EL_STRING_8_LIST
		once
			create Result.make_from_tuple (MB_field)
		end

	Musicbrainz_prefix: ZSTRING
		once
			Result := "musicbrainz_"
		end

end
