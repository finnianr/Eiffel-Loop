note
	description: "[
		Create an object from a Pyxis or XML file where the root element name matches a type alias
		(Pyxis is a more readable analog of XML inspired by the syntax of the Python programming language)
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-09-02 10:24:18 GMT (Monday 2nd September 2019)"
	revision: "1"

class
	EL_BUILDER_OBJECT_FACTORY [G -> EL_BUILDABLE_FROM_NODE_SCAN]

inherit
	EL_OBJECT_FACTORY [G]
		redefine
			default_create
		end

	EL_MODULE_PYXIS

	EL_MODULE_LIO

create
	make, make_words_lower, make_words_upper, make_from_table, default_create

feature {NONE} -- Initialization

	default_create
		do
			Precursor
			create last_root_element.make_empty
		end

feature -- Access

	last_root_element: ZSTRING

	instance_from_pyxis (pyxis_path: EL_FILE_PATH; make_default: PROCEDURE [G]): G
		require
			path_exists: pyxis_path.exists
		do
			if pyxis_path.exists then
				last_root_element := Pyxis.root_element (pyxis_path)
				if last_root_element.is_empty then
					Result := instance_from_alias (default_alias, make_default)
					if is_lio_enabled then
						lio.put_labeled_substitution ("ERROR", "File %"%S%" is not a valid Pyxis document", [pyxis_path])
						lio.put_new_line
					end

				elseif has_alias (last_root_element) then
					Result := instance_from_alias (last_root_element, make_default)
					Result.build_from_file (pyxis_path)
				else
					Result := instance_from_alias (default_alias, make_default)
					if is_lio_enabled then
						lio.put_labeled_substitution ("ERROR", "No type for root element %"%S%"", [last_root_element])
						lio.put_new_line
					end
				end
			else
				Result := instance_from_alias (default_alias, make_default)
			end
		end
end
