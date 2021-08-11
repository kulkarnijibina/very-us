namespace :reward_karma_score do
  desc "reward couple profile those karma score equal to 5"
  task :create => [:environment] do

    CoupleProfile.all.each do |couple_profile_1|
      AddEarnCoinsService.call(:reward_points_to_karma_score, couple_profile_1) if couple_profile_1.karma_score == 5
    end
  end
end
