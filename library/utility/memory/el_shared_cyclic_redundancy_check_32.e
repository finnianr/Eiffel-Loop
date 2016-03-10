note
	description: "Summary description for {EL_SHARED_CYCLIC_REDUNDANCY_CHECK_32}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-09-27 12:38:50 GMT (Sunday 27th September 2015)"
	revision: "5"

class
	EL_SHARED_CYCLIC_REDUNDANCY_CHECK_32

feature -- Factory

	new_crc_generator: like Once_crc_generator
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
