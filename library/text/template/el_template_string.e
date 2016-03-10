note
	description: "Summary description for {EL_TEMPLATE_STRING}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-10-18 11:10:25 GMT (Friday 18th October 2013)"
	revision: "4"

class
	EL_TEMPLATE_STRING

inherit
	EL_ASTRING

create
	make_from_unicode, make_from_latin1, make_from_other

convert
	make_from_unicode ({STRING_32}), make_from_latin1 ({STRING_8}), make_from_other ({EL_ASTRING})

feature -- Transformation

	substituted (inserts: ARRAY [ANY]): EL_ASTRING
		local
			list: EL_DELIMITED_SUBSTRINGS
			size, i: INTEGER
			out_inserts: ARRAY [EL_ASTRING]
			l_insert: EL_ASTRING
		do
			create list.make (Current, "$S")
			create out_inserts.make (1, inserts.count)
			from i := 1 until i > inserts.count loop
				if attached {EL_ASTRING} inserts [i] as el_insert then
					l_insert := el_insert

				elseif attached {READABLE_STRING_GENERAL} inserts [i] as str then
					create l_insert.make_from_unicode (str)

				else
					l_insert := inserts.item (i).out
				end
				out_inserts [i] := l_insert
				size := size + l_insert.count
				i := i + 1
			end
			size := size + count
			create Result.make (size)
			from list.start until list.after loop
				Result.append (list.substring)
				if list.index <= out_inserts.count then
					Result.append (out_inserts [list.index])
				end
				list.forth
			end
		end
end
