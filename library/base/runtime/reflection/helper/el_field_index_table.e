note
	description: "Summary description for {EL_FIELD_INDEX_TABLE}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-11-27 10:35:40 GMT (Monday 27th November 2017)"
	revision: "1"

class
	EL_FIELD_INDEX_TABLE

inherit
	HASH_TABLE [INTEGER, STRING]
		rename
			search as search_field,
			make as make_table
		end

	EL_ATTRIBUTE_NAME_ROUTINES
		undefine
			is_equal, copy
		end

create
	make

feature {NONE} -- Initialization

	make (n: INTEGER; a_adapt_name: like adapt_name)
		do
			make_table (n)
			adapt_name := a_adapt_name
			adapt_tuple := [create {STRING}.make_empty, create {STRING}.make_empty]
		end

feature -- Basic operations

	search (name: READABLE_STRING_GENERAL)
		local
			field_name: STRING
		do
			field_name := adapt_tuple.name_in
			field_name.wipe_out
			if attached {ZSTRING} name as z_name then
				z_name.append_to_string_8 (field_name)
			else
				field_name.append (name.to_string_8)
			end
			if adapt_name /= Standard_eiffel then
				adapt_tuple.name_out.wipe_out
				adapt_name.call (adapt_tuple)
				field_name := adapt_tuple.name_out
			end
			search_field (field_name)
		end

feature {NONE} -- Internal attributes

	adapt_name: PROCEDURE [STRING, STRING]

	adapt_tuple: TUPLE [name_in, name_out: STRING]

end
