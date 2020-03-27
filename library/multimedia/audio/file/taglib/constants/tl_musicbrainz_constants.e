note
	description: "Constants associated with [https://musicbrainz.org/ MusicBrainz] supplementary ID3 data"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-03-26 11:56:57 GMT (Thursday 26th March 2020)"
	revision: "3"

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

	MB_field: TUPLE [artistid, albumid, albumartistid, artistsortname, trackid: STRING]
		once
			create Result
			Tuple.fill (Result, "artistid, albumid, albumartistid, artistsortname, trackid")
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
