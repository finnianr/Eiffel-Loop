note
	description: "Routines related to `ITERABLE'"
	notes: "Accessible via [$source EL_MODULE_ITERABLE]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-25 12:45:12 GMT (Saturday 25th January 2020)"
	revision: "1"

expanded class
	EL_ITERABLE_ROUTINES

feature -- Measurement

	frozen count (iterable: ITERABLE [ANY]): INTEGER
		do
			if attached {FINITE [ANY]} iterable as finite then
				Result := finite.count
			else
				across iterable as it loop
					Result := Result + 1
				end
			end
		end
end
