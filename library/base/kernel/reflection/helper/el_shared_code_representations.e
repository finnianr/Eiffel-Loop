note
	description: "[
		Shared instances of ${EL_CODE_16_REPRESENTATION}, ${EL_CODE_32_REPRESENTATION}
		and ${EL_CODE_64_REPRESENTATION}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:24 GMT (Saturday 20th January 2024)"
	revision: "3"

deferred class
	EL_SHARED_CODE_REPRESENTATIONS

inherit
	EL_ANY_SHARED

feature {NONE} -- Constants

	Code_16_representation: EL_CODE_16_REPRESENTATION
		once
			create Result.make
		end

	Code_32_representation: EL_CODE_32_REPRESENTATION
		once
			create Result.make
		end

	Code_64_representation: EL_CODE_64_REPRESENTATION
		once
			create Result.make
		end
end