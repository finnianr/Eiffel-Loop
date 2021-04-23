note
	description: "Winzip software common"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-04-23 13:44:10 GMT (Friday 23rd April 2021)"
	revision: "5"

deferred class
	WINZIP_SOFTWARE_COMMON

inherit
	EL_MODULE_TUPLE

	EL_MODULE_DEFERRED_LOCALE

feature -- Contract Support

	valid_architecture_list	(a_list: STRING): BOOLEAN
		do
			Result := True
			across a_list.split (',') as list until not Result loop
				list.item.left_adjust
				inspect list.item.to_integer
					when 32, 64 then
				else
					Result := False
				end
			end
		end

	valid_target_list	(a_list: STRING): BOOLEAN
		do
			Result := True
			across a_list.split (',') as list until not Result loop
				list.item.left_adjust
				Result := Target_set.has (list.item)
			end
		end

	valid_language_list	(a_list: STRING): BOOLEAN
		do
			Result := True
			across a_list.split (',') as list until not Result loop
				list.item.left_adjust
				Result := Locale.all_languages.has (list.item)
			end
		end

	root_class_exists (a_pecf_path: EL_FILE_PATH): BOOLEAN
		do
			Result := (a_pecf_path.parent + Root_class_path).exists
		end

feature {NONE} -- Constants

	Root_class_path: ZSTRING
		-- path to root class relative to project directory
		once
			Result := "source/application_root.e"
		end

	Target_set: EL_STRING_8_LIST
		once
			create Result.make_from_tuple (Target)
		end

	Target: TUPLE [exe, installer: STRING]
		once
			create Result
			Tuple.fill (Result, "exe, installer")
		end

end