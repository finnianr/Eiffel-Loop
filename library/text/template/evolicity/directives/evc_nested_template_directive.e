note
	description: "Evolicity nested template directive"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-03-18 7:04:25 GMT (Tuesday 18th March 2025)"
	revision: "11"

deferred class
	EVC_NESTED_TEMPLATE_DIRECTIVE

inherit
	EVC_COMPOUND_DIRECTIVE
		undefine
			execute
		redefine
			make
		end

	EVC_SHARED_TEMPLATES

feature -- Initialization

	make
			--
		do
			Precursor
			create tabs.make_empty
			create variable_ref.make_empty
			create template_name.make_empty
		end

feature -- Element change

	set_tab_indent (tab_indent: INTEGER)
			--
		do
			create tabs.make_filled ('%T', tab_indent)
		end

	set_template_name (a_name: ZSTRING)
			--
		do
			template_name := a_name
		end

	set_variable_ref (a_variable_ref: like variable_ref)
			--
		do
			variable_ref := a_variable_ref
		end

feature {NONE} -- Implementation

	absolute_path (context: EVC_CONTEXT; relative_path: FILE_PATH): FILE_PATH
		do
			if attached {EVC_SERIALIZEABLE} context as serializeable
				and then serializeable.template_path.exists
			then
				Result := serializeable.template_path.parent.plus_file (relative_path)
			else
				Result := relative_path
			end
		end

	template_file_path (context: EVC_CONTEXT): detachable FILE_PATH
		local
			template_path: FILE_PATH
		do
			if template_name.count > 0 then
				template_path := template_name
				if template_path.exists then
					Result := template_path

				elseif attached absolute_path (context, template_path) as abs_path and then abs_path.exists then
					Result := abs_path

				elseif template_path.is_expandable then
					template_path.expand
					if template_path.exists then
						Result := template_path
					end
				end
			end
		end

feature {NONE} -- Internal attributes

	tabs: STRING

	template_name: ZSTRING

	variable_ref: EVC_VARIABLE_REFERENCE

end