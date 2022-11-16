note
	description: "Stores a serialized form of VTD-XML navigation location"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "5"

class
	EL_VTD_CONTEXT_IMAGE

inherit
	ARRAY [INTEGER]
		rename
			make as make_range
		export
			{ANY} twin
		redefine
			out
		end

create
	make, make_empty, make_from_other

feature {NONE} -- Initialization

	make (size: INTEGER)
			--
		do
			make_filled (0, 1, size)
		end

	make_from_other (other: EL_VTD_CONTEXT_IMAGE)
			--
		do
			copy (other)
		end

feature -- Element change

	set_from_other (other: EL_VTD_CONTEXT_IMAGE)
			--
		do
			if count = other.count then
				subcopy (other, 1, other.count, 1)
			else
				copy (other)
			end
		end

feature -- Conversion

	out: STRING
			--
		local
			i: INTEGER
		do
			create Result.make_from_string ("{")
			from
				i := 1
			until
				i > count
			loop
				if i > 1 then
					Result.append_character (',')
				end
				Result.append_integer (item (i))
				i := i + 1
			end
			Result.append_string ("} count=")
			Result.append_integer (count)
		end

end -- class VTD_CONTEXT_IMAGE