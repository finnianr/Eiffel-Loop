note
	description: "Localized string dependent on quantity attribute: zero, singluar, plural"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-09-25 8:55:12 GMT (Saturday 25th September 2021)"
	revision: "1"

class
	EL_QUANTITY_TEMPLATE

inherit
	ARRAY [EL_TEMPLATE [ZSTRING]]
		rename
			make as make_array,
			item as template_item
		export
			{NONE} all
			{ANY} valid_index
		end

	EL_LOCALE_CONSTANTS

create
	make

feature {NONE} -- Initialization

	make
		do
			make_filled (Default_template, 0, 2)
		end

feature -- Access

	substituted (quantity: INTEGER): ZSTRING
		do
			Result := substituted_extra (quantity, Empty_substitutions)
		end

	substituted_extra (quantity: INTEGER; substitutions: like Empty_substitutions): ZSTRING
			-- translation with adjustments according to value of `quantity'
		local
			template: like template_item; name: READABLE_STRING_8
		do
			template := template_item (quantity.min (upper))
			if template = Default_template then
				template := template_item (1)
			end
			across substitutions as list loop
				name := list.item.name
				if template.has (name) then
					template.put_general (name, list.item.value)
				end
			end
			if template.has (Var_quantity) then
				template.put_general (Var_quantity, quantity.out)
			end
			Result := template.substituted
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