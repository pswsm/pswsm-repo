import sqlight

pub type TableName =
  String

pub type FieldName =
  String

pub type FieldValue =
  String

pub type QueryableFields =
  List(FieldName)

pub type FieldNameList =
  List(FieldName)

pub type FieldValueList =
  List(FieldValue)

pub type FieldType =
  sqlight.Value
