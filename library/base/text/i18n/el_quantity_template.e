note
	description: "Localized string dependent on quantity attribute: zero, singluar, plural"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:04 GMT (Tuesday 15th November 2022)"
	revision: "3"

class
	EL_QUANTITY_TEMPLATE

inherit
	ARRAY [EL_TEMPLATE [ZSTRING]]
		rename
			count as array_count,
			make as make_array
		export
			{NONE} all
			{ANY} valid_index, item
		end

	EL_LOCALE_CONSTANTS

	DEBUG_OUTPUT
		undefine
			copy, is_equal
		end

create
	make

feature {NONE} -- Initialization

	make
		do
			make_filled (Default_template, 0, 2)
		end

feature -- Access

	debug_output: STRING_32
		local
			template: ZSTRING
		do
			if count = 0 then
				Result := "Empty"
			else
				template := "count: %S %"%S%""
				Result := template #$ [count, first.sorted_name_list.joined (',')]
			end
		end

	difference (other: like Current): EL_STRING_8_LIST
		-- `True' if `Current' and `Other' have same number of inserted templates
		-- and the sorted placeholder names match
		local
			break: BOOLEAN; index: INTEGER
		do
			create Result.make_empty
			if count = other.count then
				across Current as template until break loop
					index := @ template.cursor_index - 1
					if attached template.sorted_name_list as list
						and then attached other [index].sorted_name_list as other_list
						and then list /~ other_list
					then
						Result.extend ("index = " + index.out)
						Result.extend (list.as_word_string)
						Result.extend (other_list.as_word_string)
						break := True
					end
				end
			end
		end

	first: like item
		-- first inserted template
		do
			Result := Default_template
			across Current as template until Result /= Default_template loop
				Result := template
			end
		end

	substituted (quantity: INTEGER): ZSTRING
		do
			Result := substituted_extra (quantity, Empty_substitutions)
		end

	substituted_extra (quantity: INTEGER; substitution_list: like Empty_substitutions): ZSTRING
			-- translation with adjustments according to value of `quantity'
		local
			template: like item
		do
			template := item (quantity.min (upper))
			if template = Default_template then
				template := item (1)
			end
			across substitution_list as substitution loop
				if template.has (substitution.name) then
					template.put_general (substitution.name, substitution.value)
				end
			end
			if template.has (Var_quantity) then
				template.put_general (Var_quantity, quantity.out)
			end
			Result := template.substituted
		end

feature -- Measurement

	count: INTEGER
		-- count of inserted templates
		do
			across Current as template loop
				Result := Result + (template /= Default_template).to_integer
			end
		end

feature -- Comparison

	compatible_with (other: like Current): BOOLEAN
		-- `True' if `Current' and `Other' have same number of inserted templates
		-- and the sorted placeholder names match
		do
			if count = other.count then
				Result := across Current as template all
					template.sorted_name_list ~ other [@ template.cursor_index - 1].sorted_name_list
				end
			end
		end

feature -- Element change

	put_template (template: ZSTRING; a_index: INTEGER)
		require
			valid_index: valid_index (a_index)
		do
			put (create {EL_TEMPLATE [ZSTRING]}.make (template), a_index)
		end

feature {NONE} -- Constants

	Default_template: EL_TEMPLATE [ZSTRING]
		once ("PROCESS")
			create Result.make ("")
		end

end
