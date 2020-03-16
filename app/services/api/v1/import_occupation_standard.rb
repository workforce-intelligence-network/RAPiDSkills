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

        if row["category"].present?
          category = Category.where(
            name: row["category"],
            sort_order: row["category_sort"],
            occupation_standard_work_process: oswp,
          ).first_or_create!
        else
          category = nil
        end

        if row["skill"].present?
          skill = Skill.where(
            description: row["skill"],
          ).first_or_create!
          OccupationStandardSkill.where(
            occupation_standard: occupation_standard,
            skill: skill,
            occupation_standard_work_process: oswp,
            category: category,
          ).first_or_create!(sort_order: row["skill_sort"])
        end
      end
    end
    occupation_standard.generate_download_docs
    ServiceResponse.new(success: true)
  rescue Exception => e
    error_msg = e.respond_to?(:record) ? "#{e.record.class.name} " : ""
    error_msg += e.message
    ServiceResponse.new(success: false, error: error_msg)
  end

  private

  def find_or_create_occupation_standard(row)
    occupation = nil
    DataImport.transaction do
      rapids_code = row["rapids_code"].presence.try(:strip)
      onet_code = row["onet_code"].presence.try(:strip)
      standard_title = row["occupation_standard_title"].strip.downcase

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

      # Try matching on rapids, onet, type, title
      if rapids_code && onet_code
        occupation = Occupation.where(
          rapids_code: rapids_code,
          onet_code: onet_code,
          type: type,
        ).where(
          "LOWER(title) = ?", standard_title
        ).first
      end

      # Try matching on rapids, type, title
      unless occupation
        if rapids_code
          occupation = Occupation.where(
            rapids_code: rapids_code,
            type: type,
          ).where(
            "LOWER(title) = ?", standard_title
          ).first
        end
      end

      # Try matching on onet, type, title
      unless occupation
        if onet_code
          occupation = Occupation.where(
            onet_code: onet_code,
            type: type,
          ).where(
            "LOWER(title) = ?", standard_title
          ).first
        end
      end

      # Try matching on rapids, onet, type
      unless occupation
        if rapids_code && onet_code
          occupation = Occupation.where(
            rapids_code: rapids_code,
            onet_code: onet_code,
            type: type,
          ).first
        end
      end

      # Try matching on rapids, type
      unless occupation
        if rapids_code
          occupation = Occupation.where(
            rapids_code: rapids_code,
            type: type,
          ).first
        end
      end

      # Try matching on onet, type
      unless occupation
        if onet_code
          occupation = Occupation.where(
            onet_code: onet_code,
            type: type,
          ).first
        end
      end

      unless occupation
        occupation = Occupation.where(
          title: row["occupation_standard_title"].strip,
          type: type,
          rapids_code: row["rapids_code"],
          onet_code: row["onet_code"],
        ).first_or_create!
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
