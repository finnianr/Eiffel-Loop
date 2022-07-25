note
	description: "Expansion of attributes for ECF ''system'' tag"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-07-25 6:03:58 GMT (Monday 25th July 2022)"
	revision: "5"

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

	set_from_line (line: STRING)
		local
			nvp: ECF_NAME_VALUE_PAIR; s: EL_STRING_8_ROUTINES
		do
			if attached shared_name_value_list (line) as nvp_list then
				across nvp_list as list loop
					nvp := list.item
					if nvp.name ~ Name.configuration_ns then
						version.share (nvp.value)
						s.remove_double_quote (version)
					elseif nvp.name ~ Name.name then
						if name_uuid_pair.name.count = 0 then
							name_uuid_pair.name.share (nvp.value)
						else
							name_uuid_pair.name.insert_string (nvp.value, 1)
						end
					elseif nvp.name ~ Name.library_target then
						library_target.put (Var.name, nvp.value)
						if name_uuid_pair.name.count = 0 then
							name_uuid_pair.name.share (library_target.substituted)
						else
							library_target.substitute_to (name_uuid_pair.name)
						end
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
				set_from_pair_list (nvp_list)

				remove_first
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

	set_variables (nvp: ECF_NAME_VALUE_PAIR)
		do
			Precursor (nvp)
			template.put (Var.url, Eiffel_configuration + version)
		end

feature {NONE} -- Internal attributes

	name_uuid_pair: ECF_NAME_VALUE_PAIR

	version: STRING

feature {NONE} -- Constants

	Eiffel_configuration: STRING = "http://www.eiffel.com/developers/xml/configuration-"

	Library_target: EL_TEMPLATE [STRING]
		once
			Result := "[
				; library_target = $NAME
			]"
		end

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