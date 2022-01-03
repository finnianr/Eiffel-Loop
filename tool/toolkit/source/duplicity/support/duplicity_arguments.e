note
	description: "Duplicity arguments"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-01-03 15:51:51 GMT (Monday 3rd January 2022)"
	revision: "5"

class
	DUPLICITY_ARGUMENTS

inherit
	EL_REFLECTIVELY_SETTABLE
		rename
			field_included as is_any_field,
			export_name as export_default,
			import_name as import_default
		end

create
	make

feature {NONE} -- Initialization

	make (backup: DUPLICITY_BACKUP; destination_dir: EL_DIR_URI_PATH; is_dry_run: BOOLEAN)
		local
			option_list: EL_ZSTRING_LIST
		do
			make_default
			type := backup.type
			create option_list.make (5)
			if is_dry_run then
				option_list.extend ("--dry-run")
			end
			option_list.extend ("--verbosity")
			option_list.extend (backup.verbosity_level)
			if backup.encryption_key.is_empty then
				option_list.extend ("--no-encryption")
			else
				option_list.extend ("--encrypt-key")
				option_list.extend (backup.encryption_key)
			end
			options := option_list.joined_words

			append_exclusions (backup.exclude_any_list)
			append_exclusions (backup.exclude_files_list)
			target.set_base (backup.target_dir.base)
			destination := destination_dir.to_string
		end

feature -- Access

	destination: ZSTRING

	exclusions: ZSTRING

	options: ZSTRING

	target: DIR_PATH

	type: ZSTRING

feature {NONE} -- Implementation

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

end
