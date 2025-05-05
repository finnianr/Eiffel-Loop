note
	description: "Data directories"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-05-05 12:28:16 GMT (Monday 5th May 2025)"
	revision: "3"

class
	DATA_DIRECTORIES

inherit
	EL_REFLECTIVE_ATTRIBUTE_TABLE [DIR_PATH]
		rename
			attribute_list as directory_list
		redefine
			initialize
		end

	SHARED_EIFFEL_LOOP

create
	make

feature {NONE} -- Initialization

	initialize (field_list: EL_FIELD_LIST)
		do
			across field_list as list loop
				if attached {EL_REFLECTED_PATH} list.item as field
					and then attached {DIR_PATH} field.value (Current) as directory
				then
					directory.set_parent (eiffel_loop_dir #+ "test/data")
				end
			end
		ensure then
			all_exist: across directory_list as list all list.item.exists end
		end

feature -- Test data

	code: DIR_PATH

	csv: DIR_PATH

	currencies: DIR_PATH

	docs: DIR_PATH

	eiffel_loop_com: DIR_PATH

	encryption: DIR_PATH

	evol: DIR_PATH

	id3: DIR_PATH

	network: DIR_PATH

	pyxis: DIR_PATH

	rsa_keys: DIR_PATH

	svg: DIR_PATH

	thunderbird: DIR_PATH

	txt: DIR_PATH

	vtd_xml: DIR_PATH

	wav: DIR_PATH

	xml: DIR_PATH

feature {NONE} -- Implementation

	new_text_table: STRING_8
		-- map eiffel attribute identifier to director name if different
		do
			Result := "[
				eiffel_loop_com:
					eiffel-loop.com
				id3:
					id3$
				thunderbird:
					.thunderbird
				vtd_xml:
					vtd-xml
				xml:
					XML
			]"
		end

end