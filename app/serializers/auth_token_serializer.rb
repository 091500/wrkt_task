class AuthTokenSerializer
  include JSONAPI::Serializer
  set_id { |object| object.token }
  set_type :token
  attributes :token
end
