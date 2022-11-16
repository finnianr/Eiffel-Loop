note
	description: "Shared cyclic redundancy check 32"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "8"

deferred class
	EL_SHARED_CYCLIC_REDUNDANCY_CHECK_32

inherit
	EL_ANY_SHARED

feature -- Factory

	crc_generator: like Once_crc_generator
		do
			Result := Once_crc_generator
			Result.reset
		end

feature {NONE} -- Constants

	Once_crc_generator: EL_CYCLIC_REDUNDANCY_CHECK_32
		once
			create Result.make
		end

end