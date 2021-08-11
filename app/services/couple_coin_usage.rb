# CoupleCoinUsage.call(start_time, end_time)
# CoupleCoinUsage.call("2021-03-04 06:03:54", "2021-06-09 00:00:53")
module CoupleCoinUsage
  class << self
    def call(start_time, end_time)
      transactions = Transaction.joins(wallet: :couple_profile).where('date(transactions.created_at) BETWEEN ? AND ? ', start_time.to_date, end_time.to_date).
                     group_by{|x| x.wallet.couple_profile_id}
      generate_csv(transactions, start_time, end_time)
    end

    private
    def generate_csv(transactions, start_time, end_time)
      csv = CSV.generate do |csv|
        csv << ["From", start_time.to_date, "", "To", end_time.to_date]
        csv << [ "Couple Id", "Couple Name", "Coins Earned", "Coins Purchased", "Coins Burnt", *burn_feature_headers, *earn_feature_headers]

        transactions.each do |k, v|
          couple_name = v.first.wallet.couple_profile.name
          coins_purchased = v.select{|s| s.transaction_purpose == "wallet_topup"}.sum(&:amount)
          coins_earned = v.select{|transaction| transaction.transaction_type == "credit" }.sum(&:amount) - coins_purchased
          coins_burnt = v.select{|transaction| transaction.transaction_type == "debit" }.sum(&:amount)

          transarry = [k, couple_name, coins_earned, coins_purchased, coins_burnt.abs, *feature_coins_burnt(v), *feature_coins_earned(v)]
          csv << transarry
        end
      end
    end

    def earn_feature_headers
      earned_features.map{|feature| "#{feature}_earned"}
    end

    def burn_feature_headers
      burnt_features.map{|feature| "#{feature}_burnt"}
    end

    def feature_coins_earned(transactions)
      earned_features.map{|feature| sum_feature_amount(transactions, feature)  }
    end

    def feature_coins_burnt(transactions)
      burnt_features.map{|feature| sum_feature_amount(transactions, feature)  }
    end

    def sum_feature_amount(transactions,feature)
      transactions.select{|s| s.transaction_purpose == feature}.sum(&:amount).abs
    end

    def burnt_features
      [
        "refresh_match_list",
        "per_save_for_later",
        "change_preference",
        "change_geography",
        "incognito_mode",
        "spotlight_focus",
        "edit_tags_on_match_list",
      ]
    end

    def earned_features
      [
        "onboarding",
        "partner_app_download",
        "per_accept_chat",
        "initial_response",
        "verification_status",
        "feedback_fill_per_couple_meet",
        "reward_points_to_karma_score",
        "profile_completed_score",
        "social_media_connected",
        "do_for_fun",
        "goals",
        "values_needed",
      ]
    end
  end
end
