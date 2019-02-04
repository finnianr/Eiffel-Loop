note
	description: "Duplicity arguments"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-01-31 17:41:30 GMT (Thursday 31st January 2019)"
	revision: "1"

class
	DUPLICITY_ARGUMENTS

inherit
	EL_REFLECTIVELY_SETTABLE
		rename
			make_default as make,
			field_included as is_any_field,
			export_name as export_default,
			import_name as import_default
		end

create
	make

feature -- Access

	exclusions: ZSTRING

	options: ZSTRING

	type: ZSTRING

	target: EL_DIR_PATH

	destination: ZSTRING

	command: EL_OS_COMMAND
		do
			create Result.make (Template)
			Result.put_object (Current)
		end

	captured_command: EL_CAPTURED_OS_COMMAND
		do
			create Result.make (Template)
			Result.put_object (Current)
		end

feature -- Element change

	append_exclusions (list: EL_ZSTRING_LIST)
		do
			across list as exclusion loop
				if not exclusions.is_empty then
					exclusions.append_character (' ')
				end
				exclusions.append_string (Exclude_template #$ [exclusion.item])
			end
		end

feature {NONE} -- Constants

	Exclude_template: ZSTRING
		once
			Result := "[
				--exclude "#"
			]"
		end

	Template: STRING = "[
		duplicity $type $options $exclusions $target "$destination"
	]"

end
