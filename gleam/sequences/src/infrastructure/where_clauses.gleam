import gleam/string_builder
import infrastructure/types.{type FieldName, type FieldType, type FieldValue}

pub type WhereClause {
  WhereClause(FieldName, FieldValue, FieldType)
}

pub fn new(
  field: FieldName,
  value: FieldValue,
  field_type f_type: FieldType,
) -> WhereClause {
  WhereClause(field, value, f_type)
}

pub fn field_name(wc: WhereClause) -> FieldName {
  case wc {
    WhereClause(field, ..) -> field
  }
}

pub fn field_value(wc: WhereClause) -> FieldValue {
  case wc {
    WhereClause(_, value, _) -> value
  }
}

pub fn field_type(wc: WhereClause) -> FieldType {
  case wc {
    WhereClause(_, _, field_type) -> field_type
  }
}

pub fn to_string(wc: WhereClause) -> String {
  string_builder.new()
  |> string_builder.append(field_name(wc))
  |> string_builder.append(" = ")
  |> string_builder.append("?")
  |> string_builder.to_string
}
