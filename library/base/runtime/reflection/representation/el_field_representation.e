note
	description: "A field value `G' that represents an item of type `H'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-05-24 11:50:11 GMT (Monday 24th May 2021)"
	revision: "1"

deferred class
	EL_FIELD_REPRESENTATION [G, H]

feature -- Access

	item: H
		-- instance of type `H' that `value' represents

	value_type: TYPE [ANY]
		do
			Result := {G}
		end

feature -- Basic operations

	append_comment (field_definition: STRING)
		-- append comment to meta data `field_definition'
		deferred
		end

	write_crc (crc: EL_CYCLIC_REDUNDANCY_CHECK_32)
		do
			crc.add_string_8 (item.generator)
		end

end