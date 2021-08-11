namespace :refresh_free_save_for_later do
  desc "Refresh Free Save for later count"
  task :update => [:environment] do
    CoupleProfile.all.update(free_save_for_later_count: BurnOn.configuration.daily_free_per_save_for_later)
  end
end
