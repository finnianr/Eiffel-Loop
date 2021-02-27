note
	description: "Map class name to HTML source path"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-02-27 19:25:17 GMT (Saturday 27th February 2021)"
	revision: "1"

class
	CLASS_SOURCE_TABLE

inherit
	EL_ZSTRING_HASH_TABLE [EL_FILE_PATH]
		redefine
			make_equal
		end

	PUBLISHER_CONSTANTS

create
	make_equal

feature {NONE} -- Initialization

	make_equal (n: INTEGER)
		do
			Precursor (n)
			create last_name.make_empty
		end

feature -- Access

	last_name: ZSTRING

feature -- Element change

	put_class (e_class: EIFFEL_CLASS)
		do
			put (e_class.relative_source_path.with_new_extension (Html), e_class.name)
		end

feature -- Status query

	has_class (text: ZSTRING): BOOLEAN
		local
			pos_bracket: INTEGER; leading: ZSTRING
		do
			pos_bracket := text.index_of ('[', 1)
			if text.is_empty then
				last_name.wipe_out

			elseif pos_bracket > 0 then
				-- remove class parameter
				leading := text.substring (1, pos_bracket - 1)
				leading.right_adjust
				last_name := class_name (leading)
				Result := has_key (last_name)
			else
				last_name := class_name (text)
				Result := has_key (last_name)
			end
		end

feature {NONE} -- Implementation

	class_name (text: ZSTRING): ZSTRING
		local
			done, alpha_found: BOOLEAN
		do
			if text.item (1).is_alpha then
				Result := text
			else
				create Result.make (text.count - 2)
				across text as c until done loop
					if alpha_found then
						inspect c.item
							when '_', 'A' .. 'Z' then
								Result.append_character (c.item)
						else
							done := True
						end
					elseif c.item.is_alpha then
						alpha_found := True
						Result.append_character (c.item)
					end
				end
			end
		end
end