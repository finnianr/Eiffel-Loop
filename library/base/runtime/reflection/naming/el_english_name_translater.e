note
	description: "English name translater"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-06-16 18:38:13 GMT (Thursday 16th June 2022)"
	revision: "2"

class
	EL_ENGLISH_NAME_TRANSLATER

inherit
	EL_NAME_TRANSLATER
		redefine
			default_create
		end

create
	make, make_lower, make_upper, make_title

feature {NONE} -- Initialization

	default_create
		do
			uppercase_exception_set := empty_word_set
		end

feature -- Conversion

	exported (eiffel_name: STRING): STRING
		-- `eiffel_name' exported to a foreign naming convention
		local
			s: EL_STRING_8_ROUTINES
		do
			create Result.make (eiffel_name.count)
			to_english (eiffel_name, Result, uppercase_exception_set)
			inspect foreign_case
				when Case_lower then
					Result.to_lower

				when Case_title then
					if attached Split_list as list then
						list.set_target (Result, ' ', 0)
						from list.start until list.after loop
							s.set_upper (Result, list.item_start_index)
							list.forth
						end
					end

				when Case_upper then
					Result.to_upper
			else
			end
		end

	imported (foreign_name: STRING): STRING
		-- `foreign_name' translated to Eiffel attribute-naming convention
		local
			s: EL_STRING_8_ROUTINES
		do
			create Result.make (foreign_name.count)
			if attached Name_buffer.copied (foreign_name) as name then
				s.replace_character (name, ' ', '-')
				from_kebab_case (name, Result)
			end
		end

feature -- Element change

	set_uppercase_exception_set (word_set: EL_HASH_SET [STRING])
		do
			uppercase_exception_set := word_set
		end

feature {NONE} -- Implementation

	uppercase_exception_set: EL_HASH_SET [STRING]

feature {NONE} -- Constants

	Split_list: EL_SPLIT_STRING_8_LIST
		once
			create Result.make_empty
		end

end