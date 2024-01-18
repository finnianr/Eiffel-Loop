note
	description: "Shared access to instance of ${TL_MUSICBRAINZ_ENUM}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "2"

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