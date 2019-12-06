class API::V1::ImportOccupationStandard
  attr_reader :data, :user

  def initialize(data:, user:)
    @data = data
    @user = user
  end

  def call
    DataImport.transaction do
      data.each do |row|
        occupation = Occupation.find_by(rapids_code: row["rapids_code"])
        occupation = Occupation.find_by(onet_code: row["onet_code"]) unless occupation
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
          occupation = Occupation.where("LOWER(title) = ?", row["occupation_standard_title"].downcase).first_or_create(
            title: row["occupation_standard_title"],
            type: type,
          )
        end
        organization = Organization.where(title: row["organization_title"]).first_or_create
        occupation_standard = OccupationStandard.where(
          type: "#{row["type"]}Standard",
          organization: organization,
          occupation: occupation,
          title: row["occupation_standard_title"].presence || occupation.try(:title),
        ).first_or_create!(creator: user)
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
    ServiceResponse.new(success: true)
  rescue Exception => e
    ServiceResponse.new(success: false, error: e.message)
  end
end
