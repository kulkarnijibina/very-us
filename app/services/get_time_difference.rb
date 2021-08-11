module GetTimeDifference
  class << self
    def call(expiration_time)
      current_time = Time.current
      time_diff_hash = time_diff(current_time,expiration_time)
      humanize(time_diff_hash)
    end
    private
    def time_diff(start_time, end_time)
      TimeDifference.between(start_time,end_time).in_general
    end
    def humanize(time_diff_hash)
      diff_parts = []
      time_diff_hash.each do |part,quantity|
        next if quantity <= 0
        initial = part.to_s.first
        diff_parts << "#{quantity}#{initial}"
        break if diff_parts.size > 0
      end
      diff_parts.join(', ')
    end
  end
end