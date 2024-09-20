import gleeunit
import gleeunit/should
import openapi.{SchemaString}

pub fn main() {
  gleeunit.main()
}

// gleeunit test functions end in `_test`
pub fn hello_world_test() {
  1
  |> should.equal(1)
}

pub fn parse_string_test() {
  let json = "{\"type\":\"string\"}"
  let parsed = openapi.parse(json)
  parsed |> should.equal(Ok(SchemaString))
}
