note
	description: "Summary description for {RANDOM_RSA_KEY_PAIR}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:31 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	EL_RSA_KEY_PAIR

inherit
	RSA_KEY_PAIR
		redefine
			make
		end

	EL_MODULE_LOG

create
	make

feature {NONE} -- Initialization

	make (bits: INTEGER)
			--
		local
			seeder: EL_RANDOM_SEED_INTEGER_X
		do
			log.enter_with_args ("make", << bits >>)
			create seeder
			Precursor (bits)
			log.exit
		end

end
