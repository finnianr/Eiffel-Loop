note
	description: "A 'do nothing' default ID3 tag"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-11-11 11:02:41 GMT (Monday 11th November 2019)"
	revision: "4"

class
	TL_DEFAULT_ID3_TAG

inherit
	TL_ID3_TAG
		redefine
			is_default
		end

feature -- Status query

	is_default: BOOLEAN = True

feature -- Fields

	album: ZSTRING
		do
			create Result.make_empty
		end

	artist: ZSTRING
		do
			create Result.make_empty
		end

	comment: ZSTRING
		do
			create Result.make_empty
		end

	title: ZSTRING
		do
			create Result.make_empty
		end

end
