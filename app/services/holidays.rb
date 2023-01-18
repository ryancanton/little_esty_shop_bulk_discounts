require 'holiday_services.rb'
class Holidays
  def initialize
    @holidays = HolidayService.parsed
  end

  def holiday_names
    @holidays.map do |holiday|
      holiday[:localName]
    end
  end

  def holiday_dates
    @holidays.map do |holiday|
      holiday[:date]
    end
  end
end