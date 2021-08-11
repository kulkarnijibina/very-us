# GetPredictedMatchesService.new.call(couple_profile)
class GetPredictedMatchesService
  def initialize(match_count_for_day = nil, master_bucket_config = nil, buckets = nil)
    @buckets = buckets || Bucket.all
    @master_bucket_config = master_bucket_config || MasterBucketConfig.configuration
    @match_count_for_day = match_count_for_day
    @near_by_location_in_km = BurnOn.configuration.near_by_location_in_km
  end

  def create_matches(couple_profile_1, date, excluded_couple_ids = [])
    predicted_matches = call(couple_profile_1, date, excluded_couple_ids)
    predicted_matches.each(&:save!)
  end

  def call(couple_profile_1, date, excluded_couple_ids = [])
    return [] unless couple_profile_1.get_effective_traits.count > 0

    clean_up_temp_matches(couple_profile_1)
    create_temp_matches(couple_profile_1, excluded_couple_ids)

    forcast_matches = get_forcast_matches(couple_profile_1, date)

    clean_up_temp_matches(couple_profile_1)
    return forcast_matches
  end

  def remove_far_target_matches(target_matches)
    near_by_target_matches = []
    target_matches.each do |target_match|
      target_match.destroy unless check_near_by_location(target_match.source_couple,target_match.target_couple)
    end
  end

  private
  def create_temp_matches(couple_profile_1, excluded_couple_ids)
    excluded_couple_ids = [couple_profile_1.id] + excluded_couple_ids + couple_profile_1.matches.pluck(:target_couple_id) + couple_profile_1.irrelavant_and_reported_relationships.pluck(:target_couple_id)
    other_couple_profiles = CoupleProfile.where.not(id: excluded_couple_ids).with_personality_traits.activated_couples

    other_couple_profiles.each do |couple_profile_2|
      if check_near_by_location(couple_profile_1, couple_profile_2)
        match_percentage = couple_profile_1.get_match_percentage(couple_profile_2)
        couple_profile_1.temp_matches.create(target_couple_id: couple_profile_2.id, percentage: match_percentage) if match_percentage > 0
      end
    end
  end

   def get_forcast_matches(couple_profile_1, date)
    forcast_matches = []
    day = get_day(date)
    total_matches = match_count_for_day(day).to_i
    previous_threshold_percentage = 100
    @buckets.order(threshold_percentage: :desc).each do |bucket|
      match_count = get_match_count_for_day_for_bucket(bucket, day)
      match_count = [match_count, total_matches].min
      temp_matched_couples = couple_profile_1.temp_matches.where(percentage: (bucket.threshold_percentage)..(previous_threshold_percentage)).order(:percentage).limit(match_count)
      temp_matched_couples.each do |match|
        forcast_matches << couple_profile_1.matches.build(match.attributes.merge(bucket_id: bucket.id, date: date).except("id"))
      end
      total_matches -= temp_matched_couples.count
      temp_matched_couples.destroy_all
      previous_threshold_percentage = bucket.threshold_percentage
    end
    forcast_matches
  end

  def get_match_count_for_day_for_bucket(bucket, day)
    (match_count_for_day(day).to_f * (bucket.percentage_for_day[day].to_f / 100)).ceil
  end

  def match_count_for_day(day)
    @match_count_for_day || @master_bucket_config.match_count_for_day[day]
  end

  def clean_up_temp_matches(couple_profile_1)
    couple_profile_1.temp_matches.destroy_all
  end

  def get_day(date)
    date.strftime("%A").downcase
  end

  def check_near_by_location(couple_profile_1, couple_profile_2)
    couple_profile_1.get_distance_with(couple_profile_2) <= @near_by_location_in_km
  end
end
