note
	description: "Summary description for {EVOLICITY_CACHEABLE_SERIALIZEABLE}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-01-01 13:10:47 GMT (Thursday 1st January 2015)"
	revision: "5"

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
