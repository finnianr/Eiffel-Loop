note
	description: "Compiles a set of all unique xpaths for document"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-13 19:13:28 GMT (Friday 13th September 2024)"
	revision: "3"

class
	EL_XPATH_SET_SCAN_SOURCE

inherit
	EL_DOCUMENT_NODE_SCAN_SOURCE
		redefine
			make_default, seed_object
		end

create
	make

feature {NONE}  -- Initialisation

	make_default
		do
			create context.make
			create xpath_set.make_equal (0)
			Precursor
		end

feature {NONE} -- Parsing events

	on_comment
			--
		do
			extend_xpath (last_node)
		end

	on_content (node: EL_DOCUMENT_NODE_STRING)
			--
		do
			extend_xpath (last_node)
		end

	on_end_document
			--
		do
		end

	on_end_tag
			--
		do
			context.remove_xpath_step
		end

	on_processing_instruction
			--
		do
		end

	on_start_document
			--
		do
		end

	on_start_tag
			--
		local
			i: INTEGER
		do
			context.set_node (last_node)
			context.extend_xpath (last_node)
			xpath_set.put_copy (context.xpath)

			if attached attribute_list.area as area and then area.count > 0 then
				from until i = area.count loop
					extend_xpath (area [i])
					i := i + 1
				end
			end
		end

feature -- Element change

	set_xpath_set (a_xpath_set: like xpath_set)
		do
			xpath_set := a_xpath_set
		end

feature {NONE} -- Implementation

	extend_xpath (node: EL_DOCUMENT_NODE_STRING)
			--
		do
			context.set_node (node)
			context.extend_xpath (node)
			xpath_set.put_copy (context.xpath)
			context.remove_xpath_step
		end

feature {NONE} -- Internal attributes

	context: EL_XPATH_CONTEXT

	seed_object: EL_XPATH_SET_COMPILER

	xpath_set: EL_HASH_SET [STRING]

end