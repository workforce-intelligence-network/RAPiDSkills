class OccupationStandardPdf < Prawn::Document
  def initialize(os)
    super()

    repeat :all do
      # header
      bounding_box [bounds.left, bounds.top], width: bounds.width do
        text os.title, align: :center, size: 25
        stroke_horizontal_rule
      end

      # footer
      bounding_box [bounds.left, bounds.bottom + 50], width: bounds.width do
        stroke_horizontal_rule
        move_down(5)
        font_size(8) do
          text "Created for #{os.creator_name}"
          text "Last updated #{I18n.l(os.updated_at, format: :mdY)}"
        end
      end
    end

    bounding_box([bounds.left, bounds.top - 50], width: bounds.width, height: bounds.height - 100) do
      text os.organization_title
      text os.occupation_title
      text os.industry_title if os.industry
      move_down 20

      text "Work Processes", size: 16, style: :bold
      os.occupation_standard_work_processes.each do |oswp|
        text oswp.work_process.title
        text "Hours: #{oswp.hours}"
        move_down 5
      end

      move_down 20
      text "Skills", size: 16, style: :bold
      os.occupation_standard_skills.each do |oss|
        text oss.skill.description
        move_down 5
      end
    end
  end
end
