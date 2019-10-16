class GenerateMasterSkillPdfJob < ApplicationJob
  queue_as :default

  def perform(occupation_standard_id)
    os = OccupationStandard.find(occupation_standard_id)
    pdf = ::MasterSkill.new(os)
    os.pdf.attach(io: StringIO.new(pdf.render), filename: "master_skill_#{os.id}.pdf")
  end
end
