namespace :after_party do
  desc 'Deployment task: index_occupations'
  task index_occupations: :environment do
    puts "Running deploy task 'index_occupations'"

    Occupation.reindex

    # Update task as completed.  If you remove the line below, the task will
    # run with every deploy (or every time you call after_party:run).
    AfterParty::TaskRecord
      .create version: AfterParty::TaskRecorder.new(__FILE__).timestamp
  end
end
