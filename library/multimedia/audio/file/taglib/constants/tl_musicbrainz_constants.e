note
	description: "Constants associated with [https://musicbrainz.org/ MusicBrainz] supplementary ID3 data"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-03-20 10:29:25 GMT (Friday 20th March 2020)"
	revision: "1"

class
	TL_MUSICBRAINZ_CONSTANTS

feature {NONE} -- Constants

	Http_musicbrainz_org: ZSTRING
		once
			Result := "http://musicbrainz.org"
		end

	Music_brainz_fields: EL_STRING_8_LIST
		once
			create Result.make_with_separator ("artistid, albumid, albumartistid, artistsortname", ',', True)
		end

	Music_brainz_prefix: ZSTRING
		once
			Result := "musicbrainz_"
		end

end
