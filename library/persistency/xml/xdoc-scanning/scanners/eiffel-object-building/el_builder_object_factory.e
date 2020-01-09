note
	description: "[
		Create an object from a Pyxis or XML file where the root element name matches a type alias
		(Pyxis is a more readable analog of XML inspired by the syntax of the Python programming language)
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-09 13:32:13 GMT (Thursday 9th January 2020)"
	revision: "5"

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

	instance_from_pyxis (make_from_file: PROCEDURE [G]): G
		require
			path_exists: new_pyxis_path (make_from_file).exists
			make_default_set: attached make_default
		local
			pyxis_path: EL_FILE_PATH
		do
			pyxis_path := new_pyxis_path (make_from_file)
			if pyxis_path.exists then
				last_root_element := Pyxis.root_element (pyxis_path)
				if last_root_element.is_empty then
					if is_lio_enabled then
						lio.put_labeled_substitution ("ERROR", "File %"%S%" is not a valid Pyxis document", [pyxis_path])
						lio.put_new_line
					end

				elseif has_alias (last_root_element) then
					Result := instance_from_alias (last_root_element, make_from_file)
				else
					if is_lio_enabled then
						lio.put_labeled_substitution (
							"ERROR", "No type corresponding to root element %"%S%"", [last_root_element]
						)
						lio.put_new_line
					end
				end
			end
			if not attached Result then
				if attached {PROCEDURE [G]} make_default as l_make_default then
					Result := instance_from_alias (default_alias, l_make_default)
				else
					Result := raw_instance_from_alias (default_alias)
				end
			end
		end

	new_pyxis_path (make_from_file: PROCEDURE [G]): EL_FILE_PATH
		local
			p: EL_PROCEDURE [G]
		do
			p := make_from_file
			if p.closed_count = 1 and then attached {EL_FILE_PATH} p.closed_operands.reference_item (1) as path then
				Result := path
			else
				create Result
			end
		end

feature -- Access attributes

	last_root_element: ZSTRING

	make_default: detachable PROCEDURE [G]

feature -- Element change

	set_make_default (a_make_default: PROCEDURE [G])
		do
			make_default := a_make_default
		end

end
