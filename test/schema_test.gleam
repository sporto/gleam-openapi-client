import gleam/dict
import gleeunit/should
import openapi/schema.{SchemaEnum, SchemaNullable, SchemaObject, SchemaString}

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

pub fn parse_object_test() {
  let json =
    "{
    \"type\":\"object\",
    \"properties\": {
      \"name\": {
        \"type\": \"string\"
      }
    }
  }"

  let parsed = schema.parse(json)
  let props = [#("name", SchemaString)] |> dict.from_list
  parsed |> should.equal(Ok(SchemaObject(props)))
}
