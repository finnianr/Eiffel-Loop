note
	description: "Shared access to instance of [$source TL_MUSICBRAINZ_ENUM]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-03-27 15:10:04 GMT (Friday 27th March 2020)"
	revision: "1"

deferred class
	TL_SHARED_MUSICBRAINZ_ENUM

inherit
	EL_ANY_SHARED

feature {NONE} -- Constants

	Musicbrainz: TL_MUSICBRAINZ_ENUM
		once
			create Result.make
		end
end
