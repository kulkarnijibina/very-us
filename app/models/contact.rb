# frozen_string_literal: true

class Contact < ApplicationRecord
  enum status: { 'listed' => 0 }
end
