namespace :occupations do
  task import: :environment do
    filename = "#{Rails.root}/lib/tasks/files/occupations.csv"

    CSV.foreach(filename, headers: true) do |row|
      title = row['occupational_title'].strip
      if m = /(.*)\([Alt|Ex].*: (.*)\)/.match(title)
        title = m[1].strip
        title_alias = m[2].strip
      end

      term_length = row['term_length'].gsub('+','')
      if row['term_length'] == '*CB'
        term_length_min = nil
        term_length_max = nil
      elsif m = /(.*)-(.*)/.match(row['term_length'])
        term_length_min = m[1].to_f.ceil
        term_length_max = m[2].to_f.ceil
      else
        term_length_min = term_length_max = term_length.to_f.ceil
      end

      type = case row['type'].strip
             when 'TB'
               'TimeOccupation'
             when 'CB'
               'CompetencyOccupation'
             when 'HY'
               'HybridOccupation'
             else
               raise_error "Unknown type: #{row['type']}"
             end
      
      occupation = Occupation.where(
        rapids_code: row['rapids_code']
      ).first_or_create(
        type: type,
        title: title,
        onet_code: row['onet_code'],
        term_length_min: term_length_min,
        term_length_max: term_length_max,
        title_aliases: [title_alias].compact,
      )
    end
  end
end
