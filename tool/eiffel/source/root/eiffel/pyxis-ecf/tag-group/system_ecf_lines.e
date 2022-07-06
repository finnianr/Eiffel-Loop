note
	description: "Expansion of attributes for ECF ''system'' tag"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-07-06 15:37:41 GMT (Wednesday 6th July 2022)"
	revision: "1"

class
	SYSTEM_ECF_LINES

inherit
	GROUPED_ECF_LINES
		redefine
			make, exit, set_variables, set_from_line, Template
		end

create
	make

feature {NONE} -- Initialization

	make
		do
			Precursor
			create version.make_empty
			create name_uuid_pair.make_empty
		end

feature -- Access

	tag_name: STRING
		do
			Result := Name.system
		end

feature -- Element change

	set_from_line (line: STRING; tab_count: INTEGER)
		local
			nvp: EL_NAME_VALUE_PAIR [STRING]; s: EL_STRING_8_ROUTINES
		do
			if attached shared_name_value_list (line) as nvp_list then
				across nvp_list as list loop
					nvp := list.item
					if nvp.name ~ Name.configuration_ns then
						version.share (nvp.value)
						s.remove_double_quote (version)
					elseif nvp.name ~ Name.name then
						name_uuid_pair.name.share (nvp.value)
					elseif nvp.name ~ Name.uuid then
						name_uuid_pair.value.share (nvp.value)
					end
				end
			end
			if across data_list as str all str.item.count > 0 end
				and then attached Once_name_value_list as nvp_list
			then
				nvp_list.wipe_out
				nvp_list.extend (name_uuid_pair)
				set_from_pair_list (nvp_list, tab_count)

				start; remove
			end
		end

feature {NONE} -- Implementation

	data_list: ARRAY [STRING]
		do
			Result := << version, name_uuid_pair.name, name_uuid_pair.value >>
		end

	exit
		do
			version.wipe_out
			name_uuid_pair.wipe_out
		end

	set_variables (nvp: EL_NAME_VALUE_PAIR [STRING])
		do
			Precursor (nvp)
			template.put (Var.url, Eiffel_configuration + version)
		end

feature {NONE} -- Internal attributes

	name_uuid_pair: EL_NAME_VALUE_PAIR [STRING]

	version: STRING

feature {NONE} -- Constants

	Eiffel_configuration: STRING = "http://www.eiffel.com/developers/xml/configuration-"

	Template: EL_TEMPLATE [STRING]
		once
			Result := "[
				$ELEMENT:
					name = $NAME; uuid = $VALUE
					xmlns = "$URL"; xmlns.xsi = "http://www.w3.org/2001/XMLSchema-instance"
					xsi.schemaLocation = "$URL $URL.xsd"
			]"
		end

end