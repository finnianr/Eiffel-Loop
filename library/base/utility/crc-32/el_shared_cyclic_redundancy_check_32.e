note
	description: "Shared cyclic redundancy check 32"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:13 GMT (Thursday 20th September 2018)"
	revision: "5"

class
	EL_SHARED_CYCLIC_REDUNDANCY_CHECK_32

feature -- Factory

	crc_generator: like Once_crc_generator
		do
			Result := Once_crc_generator
			Result.reset
		end

feature {NONE} -- Constants

	Once_crc_generator: EL_CYCLIC_REDUNDANCY_CHECK_32
		once
			create Result
		end

end