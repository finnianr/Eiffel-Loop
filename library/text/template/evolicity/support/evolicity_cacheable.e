note
	description: "Facility to cache conversion text"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	EVOLICITY_CACHEABLE

feature {NONE} -- Initialization

	make_default
		do
			create cached_text.make (agent new_text)
			create cached_utf_8_text.make (agent new_utf_8_text)
		end

feature -- Conversion

	as_text: ASTRING
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

	cached_text: EL_CACHED_STRING [ASTRING]

	cached_utf_8_text: EL_CACHED_STRING [STRING]

	new_text: ASTRING
			--
		deferred
		end

	new_utf_8_text: STRING
			--
		deferred
		end

end
