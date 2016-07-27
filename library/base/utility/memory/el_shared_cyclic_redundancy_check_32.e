note
	description: "Summary description for {EL_SHARED_CYCLIC_REDUNDANCY_CHECK_32}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-07-06 6:47:25 GMT (Wednesday 6th July 2016)"
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