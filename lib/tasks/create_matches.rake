namespace :matches_reset do
  desc "Create matches"
  task :create => [:environment] do
    RefreshMatchlistJob.perform_later
  end
end
