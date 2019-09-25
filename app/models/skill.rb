class Skill < ApplicationRecord
  belongs_to :work_process
  belongs_to :parent_skill, class_name: 'Skill', optional: true

  def to_s
    description
  end
end
