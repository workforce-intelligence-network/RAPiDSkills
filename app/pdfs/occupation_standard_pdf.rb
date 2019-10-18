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
        move_down 5
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
      move_down 3
      os.occupation_standard_work_processes.each.with_index(1) do |oswp, index|
        text "#{index}."

        bounding_box([bounds.left + 18, cursor + 14], width: bounds.width) do
          text oswp.work_process.title
          text "Hours: #{oswp.hours}"

          bounding_box([bounds.left, cursor - 12], width: bounds.width - 20) do
            text "Skills", size: 12, style: :bold
            oswp.skills.each do |skill|
              text skill.description
              move_down 2
            end
          end
        end
        move_down 15
      end
    end
  end
end
