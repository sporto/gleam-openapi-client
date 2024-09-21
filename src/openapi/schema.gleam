import gleam/dict.{type Dict}
import gleam/dynamic.{type Dynamic}
import gleam/json
import gleam/result

pub type Schema {
  SchemaString
  SchemaObject(properties: Dict(String, Schema))
  SchemaArray(Schema)
  SchemaNullable(Schema)
  SchemaEnum(List(String))
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

pub fn parse(json_string: String) {
  json.decode(from: json_string, using: decoder)
}
