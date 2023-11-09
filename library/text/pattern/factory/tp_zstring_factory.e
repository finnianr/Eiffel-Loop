note
	description: "Factory to create new instances of text patterns optimized for [$source ZSTRING]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-11-09 13:34:46 GMT (Thursday 9th November 2023)"
	revision: "12"

class
	TP_ZSTRING_FACTORY

inherit
	TP_FACTORY
		rename
			core as Factory_zstring
		end

	TP_SHARED_OPTIMIZED_FACTORY

end