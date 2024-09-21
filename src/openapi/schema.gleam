import gleam/dict.{type Dict}
import gleam/dynamic.{type Dynamic}
import gleam/json
import gleam/result

pub type Schema {
  SchemaBoolean
  SchemaArray(Schema)
  SchemaEnum(List(String))
  SchemaInteger
  SchemaNullable(Schema)
  SchemaNumber
  SchemaObject(properties: Dict(String, Schema))
  SchemaString
}

pub fn decode_array(json: Dynamic) -> Result(Schema, dynamic.DecodeErrors) {
  dynamic.decode1(SchemaArray, dynamic.field("items", decoder))(json)
}

pub fn decode_boolean(_json: Dynamic) -> Result(Schema, dynamic.DecodeErrors) {
  Ok(SchemaBoolean)
}

pub fn decode_integer(_json: Dynamic) -> Result(Schema, dynamic.DecodeErrors) {
  Ok(SchemaInteger)
}

pub fn decode_number(_json: Dynamic) -> Result(Schema, dynamic.DecodeErrors) {
  Ok(SchemaNumber)
}

pub fn decode_object(json: Dynamic) -> Result(Schema, dynamic.DecodeErrors) {
  dynamic.decode1(
    SchemaObject,
    dynamic.field("properties", dynamic.dict(dynamic.string, decoder)),
  )(json)
}

pub fn decode_string(json: Dynamic) -> Result(Schema, dynamic.DecodeErrors) {
  let enum_result = dynamic.field("enum", dynamic.list(dynamic.string))(json)

  case enum_result {
    Ok(enum) -> Ok(SchemaEnum(enum))
    Error(_) -> Ok(SchemaString)
  }
}

pub fn decoder_non_nullable(
  json: Dynamic,
) -> Result(Schema, dynamic.DecodeErrors) {
  use type_ <- result.try(dynamic.field("type", dynamic.string)(json))

  case type_ {
    "array" -> decode_array(json)
    "boolean" -> decode_boolean(json)
    "integer" -> decode_integer(json)
    "number" -> decode_number(json)
    "object" -> decode_object(json)
    "string" -> decode_string(json)
    _ ->
      Error([
        dynamic.DecodeError(expected: "A valid type", found: type_, path: [
          "type",
        ]),
      ])
  }
}

pub fn decoder(json: Dynamic) -> Result(Schema, dynamic.DecodeErrors) {
  // OpenAPI 3.0 uses nullable
  let nullable_result = dynamic.field("nullable", dynamic.bool)(json)

  case nullable_result {
    Ok(True) -> decoder_non_nullable(json) |> result.map(SchemaNullable)
    _ -> decoder_non_nullable(json)
  }
}

pub fn decode(json_string: String) {
  json.decode(from: json_string, using: decoder)
}
