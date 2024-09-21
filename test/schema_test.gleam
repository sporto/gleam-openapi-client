import gleeunit/should
import openapi/schema.{SchemaEnum, SchemaNullable, SchemaString}

pub fn parse_string_test() {
  let json = "{\"type\":\"string\"}"
  let parsed = schema.parse(json)
  parsed |> should.equal(Ok(SchemaString))
}

pub fn parse_string_nullable_test() {
  let json = "{\"type\":\"string\", \"nullable\": true}"
  let parsed = schema.parse(json)
  parsed |> should.equal(Ok(SchemaNullable(SchemaString)))
}

pub fn parse_enum_test() {
  let json = "{\"type\":\"string\", \"enum\": [\"red\", \"blue\"]}"
  let parsed = schema.parse(json)
  parsed |> should.equal(Ok(SchemaEnum(["red", "blue"])))
}
