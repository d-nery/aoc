# frozen_string_literal: true

def assert(value, expected)
  return if value == expected

  raise "Expected #{expected} but found #{value}"
end
