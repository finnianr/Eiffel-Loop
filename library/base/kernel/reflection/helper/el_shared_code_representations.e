note
	description: "[
		Shared instances of [$source EL_CODE_16_REPRESENTATION], [$source EL_CODE_32_REPRESENTATION]
		and [$source EL_CODE_64_REPRESENTATION]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:04 GMT (Tuesday 15th November 2022)"
	revision: "2"

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