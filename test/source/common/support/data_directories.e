note
	description: "Data directories"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-05-04 21:05:21 GMT (Sunday 4th May 2025)"
	revision: "1"

class
	DATA_DIRECTORIES

inherit
	EL_REFLECTIVE_LOCALE_TEXTS
		redefine
			initialize_fields, value_in_set
		end

	SHARED_DEV_ENVIRON

create
	make_english

feature {NONE} -- Initialization

	initialize_fields
		do
			Precursor
			across new_directory_list as list loop
				list.item.set_parent (eiffel_loop_dir #+ "test/data")
			end
		ensure then
			all_exist: across new_directory_list as list all list.item.exists end
		end

feature -- Access

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

	new_directory_list: EL_ARRAYED_LIST [DIR_PATH]
		do
			create Result.make (field_list.count)
			across field_list as list loop
				if attached {EL_REFLECTED_PATH} list.item as field
					and then attached {DIR_PATH} field.value (Current) as directory
				then
					Result.extend (directory)
				end
			end
		end

	english_table: STRING_8
		-- description of attributes
		do
			Result := "[
				eiffel_loop_com:
					eiffel-loop.com
				id3:
					id3$
				rsa_keys:
					rsa_keys
				thunderbird:
					.thunderbird
				vtd_xml:
					vtd-xml
				xml:
					XML
			]"
		end

	value_in_set (value: ANY; set: like none): BOOLEAN
		do
			Result := True
		end

end