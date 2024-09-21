import gleam/dict
import gleeunit/should
import openapi/schema.{
  SchemaArray, SchemaBoolean, SchemaEnum, SchemaInteger, SchemaNullable,
  SchemaNumber, SchemaObject, SchemaString,
}

pub fn decode_boolean_test() {
  let json = "{\"type\":\"boolean\"}"
  let decoded = schema.decode(json)
  decoded |> should.equal(Ok(SchemaBoolean))
}

pub fn decode_integer_test() {
  let json =
    "{
    \"type\":\"integer\"
    }"

  let decoded = schema.decode(json)
  decoded |> should.equal(Ok(SchemaInteger))
}

pub fn decode_number_test() {
  let json =
    "{
    \"type\":\"number\"
    }"

  let decoded = schema.decode(json)
  decoded |> should.equal(Ok(SchemaNumber))
}

pub fn decode_string_test() {
  let json = "{\"type\":\"string\"}"
  let decoded = schema.decode(json)
  decoded |> should.equal(Ok(SchemaString))
}

pub fn decode_nullable_string_test() {
  let json = "{\"type\":\"string\", \"nullable\": true}"
  let decoded = schema.decode(json)
  decoded |> should.equal(Ok(SchemaNullable(SchemaString)))
}

pub fn decode_string_array_test() {
  let json =
    "{
    \"type\":\"array\",
    \"items\": {
      \"type\":\"string\"
    }
  }"

  let decoded = schema.decode(json)
  decoded |> should.equal(Ok(SchemaArray(SchemaString)))
}

pub fn decode_nullable_string_array_test() {
  let json =
    "{
    \"type\":\"array\",
    \"nullable\": true,
    \"items\": {
      \"type\":\"string\"
    }
  }"

  let decoded = schema.decode(json)
  decoded |> should.equal(Ok(SchemaNullable(SchemaArray(SchemaString))))
}

pub fn decode_enum_test() {
  let json = "{\"type\":\"string\", \"enum\": [\"red\", \"blue\"]}"
  let decoded = schema.decode(json)
  decoded |> should.equal(Ok(SchemaEnum(["red", "blue"])))
}

pub fn decode_object_test() {
  let json =
    "{
    \"type\":\"object\",
    \"properties\": {
      \"name\": {
        \"type\": \"string\"
      }
    }
  }"

  let decoded = schema.decode(json)
  let props = [#("name", SchemaString)] |> dict.from_list
  decoded |> should.equal(Ok(SchemaObject(props)))
}
