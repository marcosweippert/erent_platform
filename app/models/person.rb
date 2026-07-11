class Person < ApplicationRecord
    enum status: { available: 0, unavailable: 1 }
    enum person_type: { tenant: 0, owner: 1 }
    has_many_attached :documents
end