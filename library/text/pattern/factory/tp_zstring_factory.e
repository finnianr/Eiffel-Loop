note
	description: "Factory to create new instances of text patterns optimized for ${ZSTRING}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:26 GMT (Saturday 20th January 2024)"
	revision: "13"

class
	TP_ZSTRING_FACTORY

inherit
	TP_FACTORY
		rename
			core as Factory_zstring
		end

	TP_SHARED_OPTIMIZED_FACTORY

end