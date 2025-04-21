note
	description: "Routines related to ${ITERABLE}"
	notes: "Accessible via ${EL_MODULE_ITERABLE}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-21 12:51:46 GMT (Monday 21st April 2025)"
	revision: "10"

class
	EL_ITERABLE_ROUTINES_IMP [G]

feature -- Measurement

	frozen count (iterable: ITERABLE [G]): INTEGER
		do
			if attached {FINITE [G]} iterable as finite then
				Result := finite.count

			elseif attached {READABLE_INDEXABLE [G]} iterable as indexable then
				Result := indexable.upper - indexable.lower + 1

			else
				across iterable as it loop
					Result := Result + 1
				end
			end
		end

	character_count (list: ITERABLE [READABLE_STRING_GENERAL]; separator_count: INTEGER): INTEGER
		do
			across list as ln loop
				if Result > 0 then
					Result := Result + separator_count
				end
				Result := Result + ln.item.count
			end
		end

	max_character_count (strings: ITERABLE [READABLE_STRING_GENERAL]): INTEGER
		-- maximum character count of `strings'
		do
			across strings as str loop
				if str.item.count > Result then
					Result := str.item.count
				end
			end
		end

feature -- Access

	first (iterable: ITERABLE [G]): detachable G
		local
			done: BOOLEAN
		do
			across iterable as it until done loop
				Result := it.item
				done := True
			end
		end
end