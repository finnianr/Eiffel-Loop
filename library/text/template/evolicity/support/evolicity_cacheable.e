note
	description: "Facility to cache conversion text"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-12 18:21:01 GMT (Thursday 12th October 2017)"
	revision: "2"

deferred class
	EVOLICITY_CACHEABLE

feature {NONE} -- Initialization

	make_default
		do
			create cached_text.make (agent new_text)
			create cached_utf_8_text.make (agent new_utf_8_text)
		end

feature -- Conversion

	as_text: ZSTRING
			--
		do
			Result := cached_text.item
		end

	as_utf_8_text: STRING
			--
		do
			Result := cached_utf_8_text.item
		end

feature -- Status change

	clear_cache
		do
			across cache_strings as string loop
				string.item.clear
			end
		end

	disable_caching
		do
			across cache_strings as string loop
				string.item.disable
			end
		end

	enable_caching
		do
			across cache_strings as string loop
				string.item.enable
			end
		end

feature {NONE} -- Implementation

	cache_strings: ARRAY [EL_CACHED_STRING [READABLE_STRING_GENERAL]]
		do
			Result := << cached_text, cached_utf_8_text >>
		end

	cached_text: EL_CACHED_STRING [ZSTRING]

	cached_utf_8_text: EL_CACHED_STRING [STRING]

	new_text: ZSTRING
			--
		deferred
		end

	new_utf_8_text: STRING
			--
		deferred
		end

end