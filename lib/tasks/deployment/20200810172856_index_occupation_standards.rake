namespace :after_party do
  desc 'Deployment task: Indexes Occupation Standards on ElasticSearch'
  task index_occupation_standards: :environment do
    puts "Running deploy task 'index_occupation_standards'"

    OccupationStandard.reindex

    # Update task as completed.  If you remove the line below, the task will
    # run with every deploy (or every time you call after_party:run).
    AfterParty::TaskRecord
      .create version: AfterParty::TaskRecorder.new(__FILE__).timestamp
  end
end