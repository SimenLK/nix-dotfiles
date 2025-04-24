([
 (line_comment)
 (block_comment_content)
] @injection.content
 (#set! injection.language "comment"))

((line_comment) @injection.content
 (#match? @injection.content "^///")
 (#offset! @injection.content 0 3 0 0)
 (#set! injection.language "xml")
 (#set! injection.combined))

(application_expression
  (infix_expression
    (long_identifier_or_op) @test
    (#eq? @test "Sql.query"))
  (const
    (triple_quoted_string) @injection.content
    (#set! injection.language "sql")))

(application_expression
  (infix_expression
    (long_identifier_or_op
      (long_identifier
        (identifier)
        (identifier) @fun (#eq? @fun "query"))))
  (const
    (triple_quoted_string) @sql)
  (#offset! @sql 0 3 0 -3)
  )

