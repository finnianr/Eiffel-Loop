note
	description: "Object to time seed random state"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:07 GMT (Tuesday 15th November 2022)"
	revision: "4"

class
	EL_RANDOM_SEED_INTEGER_X

inherit
	INTEGER_X
		export
			{NONE} all
		redefine
			default_create
		end

create
	default_create

feature {NONE} -- Initialization

	default_create
			--
		local
			time: TIME
			seed: NATURAL_64
		do
			Precursor
			create time.make_now_utc
			seed := time.compact_time.to_natural_64 |<< 10
			seed := 0xBAECD515DAF0B49D + (seed | time.milli_second.to_natural_64)

			if attached {LINEAR_CONGRUENTIAL_RNG} random_state as l_random_state then
				l_random_state.randinit_lc_2exp (create {INTEGER_X}.make_from_natural_64 (seed), 1, 64)
			end
		end

end