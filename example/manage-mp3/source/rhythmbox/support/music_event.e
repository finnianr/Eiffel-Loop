note
	description: "Summary description for {MUSIC_EVENT}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-01-03 20:47:42 GMT (Thursday 3rd January 2013)"
	revision: "2"

class
	MUSIC_EVENT

inherit
	EVOLICITY_EIFFEL_CONTEXT
		redefine
			getter_function_table
		end

	EL_MODULE_STRING

	EL_MODULE_URL

	EL_MODULE_DATE
		rename
			Date as Mod_date
		end

create
	make

feature {NONE} -- Implementation

	make (event_node: EL_XPATH_NODE_CONTEXT)
			--
		do
			make_eiffel_context
			disk_jockey_name := event_node.string_at_xpath ("disk-jockey-name/text()")
			title := event_node.string_at_xpath ("title/text()")
			venue := event_node.string_at_xpath ("venue/text()")
			create date.make_from_string (event_node.string_at_xpath ("date/text()"), "dd/mm/yyyy")
			create start_time.make_from_string (event_node.string_at_xpath ("time/text()"), "hh:[0]mi")
			create playlist_names.make
			playlist_names.compare_objects
			create omitted_indices_table.make (3)
			omitted_indices_table.compare_objects

			event_node.context_list (".//playlist").do_all (agent add_playlist)
		end

feature -- Access

	disk_jockey_name: STRING

	date: DATE

	start_time: TIME

	title: STRING

	venue: STRING

	url_encoded_spell_date: STRING
			--
		do
			Result := Url.encoded_path (spell_date, True)
		end

	spell_date: STRING
			--
		do
			Result := Mod_date.spelling_long (date, True)
		end

	html_file_name: STRING
			--
		do
			create Result.make_empty
			Result.append (date.formatted_out ("yyyy-[0]mm-[0]dd"))
			Result.append (".html")
		end

	playlist_names: LINKED_LIST [STRING]

	omitted_indices (playlist: RBOX_PLAYLIST): ARRAYED_LIST [INTEGER_INTERVAL]
			--
		local
			subtraction_expressions: LIST [STRING]
		do
			subtraction_expressions := omitted_indices_table [playlist.name]
			create Result.make (subtraction_expressions.count)
			from subtraction_expressions.start until subtraction_expressions.after loop
				Result.extend (evaluate (subtraction_expressions.item, playlist.count))
				subtraction_expressions.forth
			end
		end

	omitted_indices_table: HASH_TABLE [LIST [STRING], STRING]

feature {NONE} -- Implementation

	evaluate (index_expression: STRING; count: INTEGER): INTEGER_INTERVAL
			--
		local
			expression_operands, sub_expressions: LIST [STRING]
			left_operand, right_operand, difference: INTEGER
		do
			if index_expression.occurrences (':') = 1 then
				sub_expressions := index_expression.split (':')
				create Result.make (
					evaluate (sub_expressions.first, count).lower,
					evaluate (sub_expressions.last, count).lower
				)
			else
				expression_operands := String.separated_list (index_expression, '-')
				if expression_operands.first ~ "count" then
					left_operand := count

				elseif expression_operands.first.is_integer then

					left_operand := expression_operands.first.to_integer
				end
				if expression_operands.count = 2 then
					expression_operands.go_i_th (2)
					if expression_operands.item.is_integer then
						right_operand := expression_operands.item.to_integer
					end
				end
				difference := left_operand - right_operand
				create Result.make (difference, difference)
			end
		end

	add_playlist (playlist_node: EL_XPATH_NODE_CONTEXT)
			--
		local
			subtraction_expressions: ARRAYED_LIST [STRING]
		do
			playlist_names.extend (playlist_node.attributes ["name"])
			create subtraction_expressions.make (playlist_node.context_list (".//omit").count)
			omitted_indices_table [playlist_names.last] := subtraction_expressions

			across playlist_node.context_list (".//omit") as omit loop
				subtraction_expressions.extend (omit.node.normalized_string_value)
			end
		end

feature {NONE} -- Evolicity fields

	get_disk_jockey_name: STRING
			--
		do
			Result := disk_jockey_name
		end

	get_title: STRING
			--
		do
			Result := title
		end

	get_playlist_names: STRING
			--
		do
			Result := String.joined (playlist_names, ", ")
			Result.prepend ("%"")
			Result.append ("%"")
		end

	getter_function_table: like getter_functions
			--
		do
			create Result.make (<<
				["disk_jockey_name", agent get_disk_jockey_name],
				["title", agent get_title],
				["spell_date", agent spell_date],
				["html_file_name", agent html_file_name],
				["url_encoded_spell_date", agent url_encoded_spell_date],
				["playlist_names", agent get_playlist_names]
			>>)
		end
end
