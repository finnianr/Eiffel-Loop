note
	description: "[
		Evaluates security level of passphrase based on a number of attributes defined in [$source EL_PASSWORD_ATTRIBUTES]
		The passphrase has 1 point for each attribute which are added together to give a score.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-09-01 7:49:21 GMT (Wednesday 1st September 2021)"
	revision: "8"

class
	EL_PASSPHRASE_EVALUATOR

inherit
	HASH_TABLE [BOOLEAN, ZSTRING]
		rename
			make as make_with_count
		export
			{NONE} all
			{ANY} new_cursor
		end

create
	make

feature {NONE} -- Initialization

	make
		do
			create phrase.make
			if attached phrase.text_list as text_list then
				make_with_count (text_list.count)
				across text_list as list loop
					extend (False, list.item)
				end
			end
		end

feature -- Measurement

	score: INTEGER
		do
			across Current as list loop
				Result := Result + list.item.to_integer
			end
		end

feature -- Element change

	reset
		do
			across current_keys as key loop
				force (False, key.item)
			end
		end

	update (passphrase: READABLE_STRING_GENERAL)
		local
			i: INTEGER; c: CHARACTER_32
		do
			reset
			from i := 1 until i > passphrase.count loop
				c := passphrase [i]
				if c.is_digit then
					force (True, phrase.has_numeric)
				elseif c.is_alpha then
					if c.is_upper then
						force (True, phrase.has_upper_case)
					else
						force (True, phrase.has_lower_case)
					end
				else
					force (True, phrase.has_symbolic)
				end
				i := i + 1
			end
			if passphrase.count >= 8 then
				force (True, phrase.has_at_least_8)
				if passphrase.count >= 12 then
					force (True, phrase.has_at_least_12)
				end
			end
		end

feature {NONE} -- Internal attributes

	phrase: EL_PASSPHRASE_ATTRIBUTES

end