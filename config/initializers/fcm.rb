require 'fcm'

key = ENV['FCM_KEY']
FCM_CLIENT = FCM.new(key)
