import gleam/dynamic.{type Dynamic}
import gleam/io
import gleam/json
import gleam/result

pub type Schema {
  SchemaString
  SchemaObject
  SchemaArray(Schema)
  SchemaNullable(Schema)
  SchemaEnum(List(String))
}

pub fn main() {
  io.println("Hello from json_schema_parse!")
}

pub fn decode_string(json: Dynamic) -> Result(Schema, dynamic.DecodeErrors) {
  Ok(SchemaString)
}

pub fn decoder(json: Dynamic) -> Result(Schema, dynamic.DecodeErrors) {
  use type_ <- result.try(dynamic.field("type", dynamic.string)(json))

  case type_ {
    "string" -> decode_string(json)
    _ ->
      Error([
        dynamic.DecodeError(expected: "A valid type", found: type_, path: [
          "type",
        ]),
      ])
  }
}

pub fn parse(json_string: String) {
  json.decode(from: json_string, using: decoder)
}
