note
	description: "[
		Caches the output of `as_text' for either ${EVC_SERIALIZEABLE_AS_STRING_8} or
		${EVC_SERIALIZEABLE_AS_ZSTRING}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-03-18 7:03:36 GMT (Tuesday 18th March 2025)"
	revision: "10"

deferred class
	EVC_CACHEABLE_SERIALIZEABLE

feature -- Access

	cached_text: like once_medium.text
		do
			if is_static then
				if attached internal_text then
					Result := internal_text
				else
					Result := as_text
					internal_text := Result
				end
			else
				Result := as_text
			end
		end

feature -- Element change

	clear_cache
		-- cause `as_text' to be called on next call to `cached_text'
		do
			internal_text := Void
		end

feature -- Status query

	is_static: BOOLEAN
		-- `True' if value of `as_text' should be cached
		do
			Result := True
		end

feature {NONE} -- Implementation

	once_medium: EL_STRING_IO_MEDIUM
		-- implement as once function
		deferred
		end

	as_text: like once_medium.text
		deferred
		end

feature {NONE} -- Internal attributes

	internal_text: detachable like once_medium.text

end