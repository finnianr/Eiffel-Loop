note
	description: "[
		Top level class for Evolicity accessible though [$source EL_MODULE_EVOLICITY_TEMPLATES]

		The templating substitution language was named `Evolicity' as a portmanteau of "Evolve" and "Felicity" 
		which is also a partial anagram of "Velocity" the Apache project which inspired it. 
		It also bows to an established tradition of naming Eiffel orientated projects starting with the letter 'E'.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-02-19 14:23:57 GMT (Wednesday 19th February 2020)"
	revision: "12"

class
	EVOLICITY_TEMPLATES

inherit
	EL_THREAD_ACCESS

	EL_MODULE_EXCEPTION

	EL_ZSTRING_CONSTANTS

create
	make

feature {NONE} -- Initialization

	make
			--
		do
			create stack_table.make_equal (19)
			set_nice_indentation
		end

feature -- Status query

	has (a_name: EL_FILE_PATH): BOOLEAN
 		do
			restrict_access (Compilers)
				Result := Compilers.item.has (a_name)
			end_restriction (Compilers)
		end

	is_nested_output_indented: BOOLEAN
		-- is the indenting feature that nicely indents nested XML, active?
		-- Active by default.

feature -- Status change

	set_horrible_indentation
			-- Turn off the indenting feature that nicely indents nested XML
			-- This will make application performance better
		do
			is_nested_output_indented := False
		end

	set_nice_indentation
			-- Turn on the indenting feature that nicely indents nested XML
		do
			is_nested_output_indented := True
		end

feature -- Element change

	clear_all
			-- Clear all parsed templates
		do
			restrict_access (Compilers)
				Compilers.item.wipe_out
			end_restriction (Compilers)
		end

	put_source (a_name: EL_FILE_PATH; template_source: READABLE_STRING_GENERAL)
		local
			source: ZSTRING
		do
			if attached {ZSTRING} template_source as zstring then
				source := zstring
			else
				create source.make_from_general (template_source)
			end
			put (a_name, source, Default_encoding)
		end

	put_file (file_path: EL_FILE_PATH; encoding: EL_ENCODING_BASE)
			--
		require
			file_exists: file_path.exists
		do
			put (file_path, Empty_string, encoding)
		end

feature -- Removal

	remove (a_name: EL_FILE_PATH)
			-- remove template
		do
			restrict_access (Compilers)
				Compilers.item.remove (a_name)
			end_restriction (Compilers)
		end

feature -- Basic operations

	merge (a_name: EL_FILE_PATH; context: EVOLICITY_CONTEXT; output: EL_OUTPUT_MEDIUM)
			--
		require
			output_writeable: output.is_open_write and output.is_writable
		local
			template: EVOLICITY_COMPILED_TEMPLATE; stack: like stack_table.stack
			found: BOOLEAN
		do
			if stack_table.has_key (a_name) then
				stack := stack_table.found_stack
			else
				-- using a stack enables use of recursive templates
				create stack.make (5)
				stack_table.extend (stack, a_name)
			end
			if stack.is_empty then
				if attached {like Compilers.item} restricted_access (Compilers) as compiler_table then
					if compiler_table.has_key (a_name) then
						-- Changed 23 Nov 2013
						-- Before it used to make a deep_twin of an existing compiled template
						template := compiler_table.found_item.compiled_template
--						log.put_string_field ("Compiled template", a_name.to_string)
--						log.put_new_line
						stack.put (template)
						found := True
					else
						Exception.raise_developer ("Template [%S] not found", [a_name])
					end
					end_restriction (Compilers)
				end
			else
				template := stack_table.found_stack.item
				found := True
			end
			if found then
				if template.has_file_source and then a_name.modification_date_time > template.modification_time then
					-- File was modified
					stack_table.remove (a_name)
					put_file (a_name, template.encoding)
					-- Try again
					merge (a_name, context, output)
				else
					stack.remove
					if attached {EL_STRING_IO_MEDIUM} output as text_output then
						text_output.grow (template.minimum_buffer_length)
					end
					template.execute (context, output)
					stack.put (template)
				end
			end
		end

	merge_to_file (a_name: EL_FILE_PATH; context: EVOLICITY_CONTEXT; text_file: EL_PLAIN_TEXT_FILE)
			--
		require
			writeable: text_file.is_open_write
		do
			merge (a_name, context, text_file)
			text_file.close
		end

	merged (a_name: EL_FILE_PATH; context: EVOLICITY_CONTEXT): ZSTRING
			--
		local
			text_medium: EL_ZSTRING_IO_MEDIUM
		do
			create text_medium.make_open_write (1024)
			merge (a_name, context, text_medium)
			text_medium.close
			Result := text_medium.text
		end

	merged_utf_8 (a_name: EL_FILE_PATH; context: EVOLICITY_CONTEXT): STRING
			--
		local
			utf8_text_medium: EL_STRING_8_IO_MEDIUM
		do
			create utf8_text_medium.make_open_write (1024)
			merge (a_name, context, utf8_text_medium)
			utf8_text_medium.close
			Result := utf8_text_medium.text
		end

feature {NONE} -- Implementation

	put (key_path: EL_FILE_PATH; template_source: ZSTRING; file_encoding: EL_ENCODING_BASE)
			-- if `file_encoding /= Default_encoding' then compile template stored in
			-- file path `key_path' and add to global template table
			-- or recompile existing template if file modified date is newer

			-- if `file_encoding = Default_encoding' then compile `template_source' and store
			-- with key `key_path'
		local
			compiler: EVOLICITY_COMPILER; compiler_table: like Compilers.item
			is_file_path: BOOLEAN
 		do
 			is_file_path := file_encoding /= Default_encoding
			restrict_access (Compilers)
				compiler_table := Compilers.item
				if not compiler_table.has_key (key_path)
					or else is_file_path and then key_path.modification_date_time > compiler_table.found_item.modification_time
				then
					create compiler.make
					if is_file_path then
						compiler.set_encoding_from_other (file_encoding)
						compiler.set_source_text_from_file (key_path)
					else
						compiler.set_source_text (template_source)
					end
					compiler.parse
					if compiler.parse_succeeded then
						compiler_table [key_path] := compiler
--						log.put_string_field ("Parsed template", key_path.to_string)
--						log.put_new_line
					else
						Exception.raise_developer ("Evolicity compilation failed %S", [key_path])
					end
				end
			end_restriction (Compilers)
		end

feature {NONE} -- Internal attributes

	stack_table: EVOLICITY_TEMPLATE_STACK_TABLE
		-- stacks of compiled templates
		-- This design enables use of recursive templates

feature {NONE} -- Global attributes

	Compilers: EL_MUTEX_REFERENCE [HASH_TABLE [EVOLICITY_COMPILER, EL_FILE_PATH]]
			-- Global template compilers table
		once ("PROCESS")
			create Result.make (create {like Compilers.item}.make (11))
		end

	Default_encoding: EL_ENCODEABLE_AS_TEXT
		once ("PROCESS")
			create Result.make_utf_8
		end

end
