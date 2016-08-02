note
	description: "Caches the substituted output"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-07-26 8:17:45 GMT (Tuesday 26th July 2016)"
	revision: "1"

deferred class
	EVOLICITY_CACHEABLE_SERIALIZEABLE

inherit
	EVOLICITY_SERIALIZEABLE
		rename
			as_text as new_text,
			as_utf_8_text as new_utf_8_text
		export
			{NONE} new_text, new_utf_8_text
		redefine
			make_default
		end

	EVOLICITY_CACHEABLE
		redefine
			make_default
		end

feature {NONE} -- Initialization

	make_default
			--
		do
			Precursor {EVOLICITY_CACHEABLE}
			Precursor {EVOLICITY_SERIALIZEABLE}
		end
end
