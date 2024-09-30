note
	description: "Convert ${CONTAINER [G]} to type conforming to ${EL_CONTAINER_STRUCTURE [G]}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-30 15:19:19 GMT (Monday 30th September 2024)"
	revision: "1"

class
	EL_CONTAINER_CONVERSION [G]

feature {NONE} -- Implementation

	as_structure (container: CONTAINER [G]): EL_CONTAINER_STRUCTURE [G]
		do
			if attached {EL_CONTAINER_STRUCTURE [G]} container as structure then
				Result := structure
			else
				create {EL_CONTAINER_WRAPPER [G]} Result.make (container)
			end
		end

end