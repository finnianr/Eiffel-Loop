note
	description: "Caches the substituted output"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-12 18:21:01 GMT (Thursday 12th October 2017)"
	revision: "2"

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
