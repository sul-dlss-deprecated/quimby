# frozen_string_literal: true

# Response class to return when the API connection fails
class NullResponse
  def present?
    false
  end

  def content
    ''
  end

  def map
    ''
  end
end
