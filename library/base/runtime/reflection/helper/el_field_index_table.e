note
	description: "Summary description for {EL_FIELD_INDEX_TABLE}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-12-05 17:15:49 GMT (Tuesday 5th December 2017)"
	revision: "2"

class
	EL_FIELD_INDEX_TABLE

inherit
	HASH_TABLE [INTEGER, STRING]
		rename
			search as search_field,
			make as make_table
		end

	EL_ATTRIBUTE_NAME_TRANSLATEABLE
		undefine
			is_equal, copy
		redefine
			import_name
		end

create
	make

feature {NONE} -- Initialization

	make (n: INTEGER; a_import_name: like import_name)
		do
			make_table (n)
			import_name := a_import_name
			name_argument := [create {STRING}.make_empty, create {STRING}.make_empty]
		end

feature -- Basic operations

	search (name: READABLE_STRING_GENERAL)
		local
			field_name: STRING
		do
			field_name := name_argument.name_in
			field_name.wipe_out
			if attached {ZSTRING} name as z_name then
				z_name.append_to_string_8 (field_name)
			else
				field_name.append (name.to_string_8)
			end
			if import_name /= Default_import_name then
				name_argument.name_out.wipe_out
				import_name.call (name_argument)
				field_name := name_argument.name_out
			end
			search_field (field_name)
		end

feature {NONE} -- Internal attributes

	import_name: PROCEDURE [STRING, STRING]

	name_argument: TUPLE [name_in, name_out: STRING]

end
