import gleam/list
import gleam/option
import gleam/string_builder
import infra/types.{
  type FieldNameList, type FieldValueList, type QueryableFields, type TableName,
}
import infra/where_clauses.{type WhereClause}
import sqlight
import utils

pub type QueryOperationType {
  Select(QueryableFields)
  Insert(TableName, FieldNameList, FieldValueList)
  Update(TableName, FieldNameList, FieldValueList)
  Delete(TableName, FieldNameList, FieldValueList)
}

pub opaque type Query {
  Query(QueryOperationType, TableName, List(WhereClause))
}

pub fn new_query(
  operation: QueryOperationType,
  table_name: TableName,
  where_clauses: List(WhereClause),
) -> Query {
  Query(operation, table_name, where_clauses)
}

// README:
// Should return something like:
// { string: SELECT whatever FROM table WHERE field /[>=<]/ ?, replacements: [{value: pepe, type: sqlight.Value}], where_clause] }
pub fn build(q: Query) -> #(String, List(types.FieldType)) {
  case q {
    Query(operation, table_name, wc) -> {
      case operation {
        Select(fields) -> {
          #(
            string_builder.new()
              |> string_builder.append("SELECT ")
              |> string_builder.append({
                case list.length(fields) {
                  0 -> "*"
                  _ -> fields |> utils.implode(option.Some(", "))
                }
              })
              |> string_builder.append(" FROM ")
              |> string_builder.append(table_name)
              |> string_builder.append(" WHERE ")
              |> fn(builder) {
                case list.length(wc) {
                  0 -> builder
                  _ ->
                    string_builder.append(
                      builder,
                      wc
                        |> list.map(fn(c) { c |> where_clauses.to_string() })
                        |> utils.implode(option.Some(" AND ")),
                    )
                }
              }
              |> string_builder.to_string,
            wc |> list.map(fn(c) { c |> where_clauses.field_type }),
          )
        }
        _ -> #("TODO: implement other operations", [sqlight.null()])
      }
    }
  }
}
