module IceCube

  class YearlyRule < MonthlyRule
    
    # Determine whether or not the rule, given a start_date,
    # occurs on a given date.
    # Yearly occurs if we're in a proper interval
    # and either (1) we're on a day of the year, or (2) we're on a month of the year as specified
    # Note: rollover dates don't work, so you can't ask for the 400th day of a year
    # and expect to roll into the next year (this might be a possible direction in the future)
    def occurs_on?(date, start_date)
      #make sure we're in the proper interval
      return false unless (date.year - start_date.year) % @interval == 0
      # if only months of year is specified, it should only return the single day of start_date
      unless @days_of_year || @days_of_month || @days_of_week || @days
        return false unless date.day == start_date.day
      end
      # fall back on making sure that the day falls on this exact day of the year
      unless has_obscure_validations?
        return false unless date.month == start_date.month && date.day == start_date.day
      end
      # otherwise
      true
    end
    
    def to_ical 
      'FREQ=YEARLY' << to_ical_base
    end
    
    def to_s
      to_ical
    end
    
    protected
    
    def default_jump(date)
      Time.utc(date.year + @interval, date.month, date.day, date.hour, date.min, date.sec)
    end
    
    private

    def initialize(interval)
      super(interval)
    end
    
  end
    
end