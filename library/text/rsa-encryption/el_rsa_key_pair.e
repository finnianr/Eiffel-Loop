note
	description: "Rsa key pair"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 17:36:22 GMT (Saturday 19th May 2018)"
	revision: "4"

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
