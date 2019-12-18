class API::V1::ImportOccupationStandard
  attr_reader :data, :user

  def initialize(data:, user:)
    @data = data
    @user = user
  end

  def call
    occupation_standard = find_or_create_occupation_standard(data.first)

    data.each do |row|
      DataImport.transaction do
        if row["work_process_title"].present?
          work_process = WorkProcess.where(
            title: row["work_process_title"],
            description: row["work_process_description"],
          ).first_or_create!
          oswp = OccupationStandardWorkProcess.where(
            occupation_standard: occupation_standard,
            work_process: work_process,
            hours: row["work_process_hours"],
          ).first_or_create!(sort_order: row["work_process_sort"])
        else
          oswp = nil
        end

        if row["skill"].present?
          skill = Skill.where(
            description: row["skill"],
          ).first_or_create!
          OccupationStandardSkill.where(
            occupation_standard: occupation_standard,
            skill: skill,
            occupation_standard_work_process: oswp,
          ).first_or_create!(sort_order: row["skill_sort"])
        end
      end
    end
    ServiceResponse.new(success: true)
  rescue Exception => e
    error_msg = e.respond_to?(:record) ? "#{e.record.class.name} " : ""
    error_msg += e.message
    ServiceResponse.new(success: false, error: error_msg)
  end

  private

  def find_or_create_occupation_standard(row)
    DataImport.transaction do
      if row["rapids_code"].present?
        occupation = Occupation.find_by(rapids_code: row["rapids_code"])
      elsif row["onet_code"].present?
        occupation = Occupation.find_by(onet_code: row["onet_code"])
      end

      unless occupation
        # Determine Occupation Type
        type = if row["work_process_hours"].present? && row["skill"].present?
                 "HybridOccupation"
               elsif row["work_process_hours"].present?
                 "TimeOccupation"
               elsif row["skill"].present?
                 "CompetencyOccupation"
               else
                 raise "Either work process or skill is required"
               end
        occupation = Occupation.where("LOWER(title) = ?", row["occupation_standard_title"].downcase).first_or_create!(
          title: row["occupation_standard_title"],
          type: type,
        )
      end
      organization = Organization.where(title: row["organization_title"]).first_or_create!
      state = State.find_by(short_name: row["registration_state"])
      occupation_standard = OccupationStandard.where(
        type: "#{row["type"]}Standard",
        organization: organization,
        occupation: occupation,
        title: row["occupation_standard_title"].presence || occupation.try(:title),
      ).first_or_create!(
        creator: user,
        registration_organization_name: row["registration_organization_name"],
        registration_state: state,
        )
    end
  end
end
