note
	description: "Routines related to [$source ITERABLE]"
	notes: "Accessible via [$source EL_MODULE_ITERABLE]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:04 GMT (Tuesday 15th November 2022)"
	revision: "6"

class
	EL_ITERABLE_ROUTINES

feature -- Measurement

	frozen count (iterable: ITERABLE [ANY]): INTEGER
		do
			if attached {FINITE [ANY]} iterable as finite then
				Result := finite.count

			elseif attached {READABLE_INDEXABLE [ANY]} iterable as indexable then
				Result := indexable.upper - indexable.lower + 1

			else
				across iterable as it loop
					Result := Result + 1
				end
			end
		end
end