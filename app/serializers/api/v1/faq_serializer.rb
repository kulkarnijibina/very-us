class Api::V1::FaqSerializer < ActiveModel::Serializer
  attributes :id, :question, :answer
end
