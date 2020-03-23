namespace :after_party do
  desc 'Deployment task: import_industries'
  task import_industries: :environment do
    puts "Running deploy task 'import_industries'"

    # Import industries
    filename = "#{Rails.root}/lib/tasks/files/industries.csv"

    CSV.foreach(filename, headers: true) do |row|
      naics_code = row['Major Group'].try(:strip) || row['Minor Group'].try(:strip)
      title = row['Title'].strip

      begin
        industry = Industry.where(
          naics_code: naics_code,
          title: title,
        ).first_or_create!
      rescue Exception => e
        Notify.error("Error in after_party:industries_import CSV import", e)
      end
    end

    Industry.reindex

    # Link occupations to industry
    Occupation.find_each do |occupation|
      next if occupation.onet_code.blank?

      onet_code = occupation.onet_code.gsub(/\.\d{2}$/, '')
      onet_code = onet_code.gsub(/\./, '-')
      onet_code_minor = onet_code.gsub(/\d{3}$/,'000')
      onet_code_major = onet_code.gsub(/\d{4}$/,'0000')

      industry = Industry.find_by(naics_code: onet_code_minor)
      unless industry
        industry = Industry.find_by(naics_code: onet_code_major)
      end
      begin
        occupation.update!(industry: industry) if industry
      rescue Exception => e
        Notify.error("Error in after_party:industries_import assigning industries", e)
      end
    end

    # Update task as completed.  If you remove the line below, the task will
    # run with every deploy (or every time you call after_party:run).
    AfterParty::TaskRecord
      .create version: AfterParty::TaskRecorder.new(__FILE__).timestamp
  end
end
