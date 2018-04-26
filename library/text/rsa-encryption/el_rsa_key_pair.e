note
	description: "Summary description for {RANDOM_RSA_KEY_PAIR}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-04-18 13:46:19 GMT (Wednesday 18th April 2018)"
	revision: "3"

class
	EL_RSA_KEY_PAIR

inherit
	RSA_KEY_PAIR
		redefine
			make
		end

create
	make

feature {NONE} -- Initialization

	make (bits: INTEGER)
			--
		local
			seeder: EL_RANDOM_SEED_INTEGER_X
		do
			create seeder
			Precursor (bits)
		end

end
