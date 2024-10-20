every 5.minutes do
  rake "ride_requests:cleanup"
  rake "drivers_on_duties:cleanup"
end
