import gleeunit
import gleeunit/should
import openapi/schema.{SchemaString}

pub fn parse_string_test() {
  let json = "{\"type\":\"string\"}"
  let parsed = schema.parse(json)
  parsed |> should.equal(Ok(SchemaString))
}
