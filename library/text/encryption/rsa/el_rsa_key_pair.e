note
	description: "Summary description for {RANDOM_RSA_KEY_PAIR}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-12 18:21:01 GMT (Thursday 12th October 2017)"
	revision: "2"

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